import 'dart:async';
import 'dart:developer';
import 'package:batua/models/mined_transaction_model.dart';
import 'package:batua/models/token.dart';
import 'package:batua/models/tokens_model.dart';
import 'package:batua/services/api_service.dart';
import 'package:batua/utils.dart';
import 'package:batua/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web3dart/crypto.dart';

typedef ContractAddress = String;
typedef tokenInfoPageArgs = ({String? logo, String name, String symbol});

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

  Map<ContractAddress, Token> _tokens = {};
  Map<ContractAddress, Token> get tokens => _tokens;
  String _tokensMessage = "No Tokens!";
  String get tokensMessage => _tokensMessage;

  late Stream<Transaction?> _txnStream;
  late Function _closeTxnStream;
  late Stream<String?> _ethUsdtPriceStream;
  late Function _closeEthUsdtPriceStream;

  Network _network = Network.etheriumMainnet;
  bool _changingNetwork = false;
  bool get changingNetwork => _changingNetwork;
  Network get network => _network;

  Future<void> _updateBalance() async {
    ApiService.getBalance(address, network).then((value) {
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
    _closeTxnStream();
    _startTxnStream();
    Future.wait([
      _updateBalance(),
      _updateTokens("0x692190B4A5d3524b6FEd0465e7400C07D09dB954", network),
    ]).then((value) => _changingNetwork = false);
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
    getTokens("0x692190B4A5d3524b6FEd0465e7400C07D09dB954", network);
    // _retrieveTokens(
    //   "0x692190B4A5d3524b6FEd0465e7400C07D09dB954",
    //   Network.etheriumMainnet,
    // );

    _startEthUsdtPriceStream();
  }

  void _startTxnStream() {
    var (txnStream, closeTxn) =
        ApiService.getTransactionStream(address, _network);

    _txnStream = txnStream;
    _closeTxnStream = closeTxn;
    _txnStream.listen((event) {
      if (event != null) {
        _updateBalance();
        _updateTokens("0x692190B4A5d3524b6FEd0465e7400C07D09dB954", network);
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
    var (priceStream, closeStream) = ApiService.getEthUsdtPriceStream();

    _ethUsdtPriceStream = priceStream;
    _closeEthUsdtPriceStream = closeStream;

    _ethUsdtPriceStream.listen((event) {
      if (event != null && _balance != 0) {
        _usdtBalance = double.parse(event) * _balance;
        notifyListeners();
      }
    });
  }

  Future<void> getTokens(String address, Network network) async {
    List<TokenModel>? tokens =
        await ApiService.getErc20Tokens(address, network);
    tokens?.where((element) => !element.possibleSpam).forEach((element) {
      _tokens[element.tokenAddress] = Token(
          amount: hexAmountToDouble(element.balance, element.decimals),
          logo: element.logo,
          name: element.name,
          symbol: element.symbol,
          usdtBalance: null);
    });
    notifyListeners();
  }

  Future<void> _updateTokens(String address, Network network) async {
    List<TokenModel>? tokens =
        await ApiService.getErc20Tokens(address, network);
    if (changingNetwork) {
      _tokens = {};
    }
    tokens?.where((element) => !element.possibleSpam).forEach((element) {
      _tokens[element.tokenAddress] = Token(
          amount: hexAmountToDouble(element.balance, element.decimals),
          logo: element.logo,
          name: element.name,
          symbol: element.symbol,
          usdtBalance: null);
    });
    notifyListeners();
  }
}
