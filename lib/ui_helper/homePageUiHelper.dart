import 'dart:async';
import 'dart:developer';
import 'package:batua/models/mined_transaction.dart';
import 'package:batua/services/api.dart';
import 'package:batua/utils.dart';
import 'package:batua/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web3dart/crypto.dart';

class HomePageUiHelper extends ChangeNotifier {
  HomePageUiHelper(BuildContext context) : _context = context {
    _init();
  }
  @override
  void dispose() {
    log("dispose");
    _closeTxnStream();
    _closeEthUsdtPriceStream();
    super.dispose();
  }

  BuildContext _context;
  String? _address;
  get address => _address;

  double _balance = 0;
  String get balance => _balance.toStringAsFixed(4);
  double _usdtBalance = 0;
  String get usdtBalance => _usdtBalance.toStringAsFixed(4);

  late Stream<Transaction?> _txnStream;
  late Function _closeTxnStream;
  late Stream<String?> _ethUsdtPriceStream;
  late Function _closeEthUsdtPriceStream;

  Network _network = Network.etheriumMainnet;
  bool _changingNetwork = false;
  bool get changingNetwork => _changingNetwork;
  Network get network => _network;

  Future<void> _updateBalance() async {
    Api.getBalance(address, network).then((value) {
      if (value != null) {
        _balance = hexPriceToDouble(value.result.substring(2));
        if (_balance == 0) {
          _usdtBalance = 0;
        }
        notifyListeners();
      }
    });
  }

  changeNetwork() {
    _changingNetwork = true;

    _network = Network.values[(_network.index + 1) % Network.values.length];
    notifyListeners();
    _updateBalance();
    _closeTxnStream();
    _startTxnStream();
    _changingNetwork = false;
  }

  _init() async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    String? privateKey = await storage.read(key: "privateKey");
    _address = "0x${bytesToHex(
      publicKeyToAddress(
        privateKeyBytesToPublic(
          hexToBytes(
            privateKey!,
          ),
        ),
      ),
    )}";
    _updateBalance();

    notifyListeners();

    _startTxnStream();
    _startEthUsdtPriceStream();
  }

  void _startTxnStream() {
    var (txnStream, closeTxn) = Api.getTransactionStream(address, _network);

    _txnStream = txnStream;
    _closeTxnStream = closeTxn;
    _txnStream.listen((event) {
      if (event != null) {
        _updateBalance();
        String price =
            hexPriceToDouble(event.value.substring(2)).toStringAsFixed(4);
        txnToast(
                from: event.from,
                to: event.to,
                address: address,
                network: network,
                value: price)
            .show(_context);
      }
    });
  }

  void _startEthUsdtPriceStream() {
    var (priceStream, closeStream) = Api.getEthUsdtPriceStream();

    _ethUsdtPriceStream = priceStream;
    _closeEthUsdtPriceStream = closeStream;

    _ethUsdtPriceStream.listen((event) {
      if (event != null && _balance != 0) {
        _usdtBalance = double.parse(event) * _balance;
        notifyListeners();
      }
    });
  }
}

// 