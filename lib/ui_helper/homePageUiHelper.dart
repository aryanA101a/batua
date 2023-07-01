import 'dart:async';
import 'dart:developer';
import 'package:batua/di/locator.dart';
import 'package:batua/models/mined_transaction_model.dart';
import 'package:batua/models/token.dart';
import 'package:batua/models/tokens_model.dart';
import 'package:batua/models/transaction.dart';
import 'package:batua/models/transaction_model.dart';
import 'package:batua/services/api_service.dart';
import 'package:batua/utils.dart';
import 'package:batua/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web3dart/crypto.dart';

typedef ContractAddress = String;
typedef tokenInfoPageArgs = ({String? logo, String name, String symbol});

class HomePageUiHelper extends ChangeNotifier {
  HomePageUiHelper() {
    _init();
  }
  @override
  void dispose() {
    log("dispose");
    _closeTxnStream();
    _closeEthUsdtPriceStream();
    getIt.resetLazySingleton<HomePageUiHelper>();
    super.dispose();
  }

  String? _address;
  String? get address => _address;

  double _balance = 0;
  String get balance => _balance.toStringAsFixed(4);
  double _usdtBalance = 0;
  String get usdtBalance => _usdtBalance.toStringAsFixed(4);

  Map<ContractAddress, Token> _tokens = {};
  Map<ContractAddress, Token> get tokens => _tokens;
  String _tokensMessage = "No Tokens!";
  String get tokensMessage => _tokensMessage;

  late Stream<MinedTransaction?> _txnStream;
  late Function _closeTxnStream;
  late Stream<String?> _ethUsdtPriceStream;
  late Function _closeEthUsdtPriceStream;

  Network _network = Network.etheriumMainnet;
  bool _changingNetwork = false;
  bool get changingNetwork => _changingNetwork;
  Network get network => _network;

  Future<void> _updateBalance() async {
    if (_address != null) {
      ApiService.getBalance(_address!, network).then((value) {
        if (value != null) {
          _balance = hexPriceToDouble(value.result.substring(2));
          if (_balance == 0) {
            _usdtBalance = 0;
          }
          notifyListeners();
        }
      });
    }
  }

  changeNetwork() {
    _changingNetwork = true;
    _network = Network.values[(_network.index + 1) % Network.values.length];
    notifyListeners();
    _closeTxnStream();
    _startTxnStream();
    Future.wait([
      _updateBalance(),
      getTokens(),
    ]).then((value) => _changingNetwork = false);
  }

  _init() async {
    await retrieveAddress();

    notifyListeners();
    _updateBalance();
    _startTxnStream();
    getTokens();

    _startEthUsdtPriceStream();
  }

  Future<void> retrieveAddress() async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    String? privateKey = await storage.read(key: "privateKey");
    _address = bytesToHex(
      publicKeyToAddress(
        privateKeyBytesToPublic(
          hexToBytes(
            privateKey!,
          ),
        ),
      ),
    );
  }

  void _startTxnStream() {
    if (_address != null) {
      var (txnStream, closeTxn) =
          ApiService.getTransactionStream(_address!, _network);

      _txnStream = txnStream;
      _closeTxnStream = closeTxn;
      _txnStream.listen((event) {
        if (event != null) {
          _updateBalance();
          _updateTokens();
          double price = hexPriceToDouble(event.value.substring(2));
          txnToast(
              from: event.from,
              to: event.to,
              address: _address!,
              network: network,
              value: price);
        }
      });
    }
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

  Future<void> getTokens() async {
    if (_address != null) {
      List<TokenModel>? tokenModelList =
          await ApiService.getErc20Tokens(_address!, network);
      log("tokens.toString()");
      Map<String, Token> tokens = {};

      tokenModelList
          ?.where((element) =>
              (network == Network.sepoliaTestnet || !element.possibleSpam))
          .forEach((element) {
        log(element.balance + " " + element.decimals.toString());
        tokens[element.tokenAddress] = Token(
            amount: calculateTokenAmount(element.balance, element.decimals),
            logo: element.logo,
            name: element.name,
            symbol: element.symbol,
            usdtBalance: null);
      });
      _tokens = tokens;
      notifyListeners();
    }
  }

  Future<void> _updateTokens() async {
    if (_address != null) {
      List<TokenModel>? tokens =
          await ApiService.getErc20Tokens(_address!, network);
      if (changingNetwork) {
        _tokens = {};
      }
      tokens?.where((element) => !element.possibleSpam).forEach((element) {
        _tokens[element.tokenAddress] = Token(
            amount: calculateTokenAmount(element.balance, element.decimals),
            logo: element.logo,
            name: element.name,
            symbol: element.symbol,
            usdtBalance: null);
      });
      notifyListeners();
    }
  }
}
