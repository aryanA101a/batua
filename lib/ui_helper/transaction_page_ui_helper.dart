import 'dart:developer';

import 'package:batua/di/locator.dart';
import 'package:batua/main.dart';
import 'package:batua/services/account_service.dart';
import 'package:batua/services/api_service.dart';
import 'package:batua/ui_helper/homePageUiHelper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

class TransactionPageUiHelper with ChangeNotifier {
  TransactionPageUiHelper() {
    _init();
  }

  Future<void> _init() async {
    AccountService.retrieveSavedAddresses(getIt<HomePageUiHelper>().address!)
        .then(
      (value) {
        _savedAddresses = value;
        notifyListeners();
      },
    );
    ApiService.getEthPrice().then(
      (value) => value.fold(
        (l) {
          _ethUsdPrice = double.parse(l.ethusd);
        },
        (r) {
          if (rootScaffoldMessengerKey.currentState != null) {
            rootScaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
                content: Text("${r.message} ETH price could not be fetched!")));
          }
        },
      ),
    );
    ApiService.getGasInfo(getIt<HomePageUiHelper>().network)
        .then((value) => value.fold((l) {
              _estimatedGas = l.$1.toString();
              _gasPrice = "${l.$2.getValueInUnit(EtherUnit.gwei)} gwei";
              notifyListeners();
            }, (r) => null));
  }

  String _amount = "";
  String get amount => _amount;
  String _usdAmount = "";
  String get usdAmount => _usdAmount;
  TextEditingController _addressFieldValueController = TextEditingController();
  TextEditingController get addressFieldValueController =>
      _addressFieldValueController;
  setAddressFieldValue(String value) {
    _addressFieldValueController.text = value;
    notifyListeners();
  }

  List<String> _savedAddresses = [];
  List<String> get savedAddresses => _savedAddresses;

  double _ethUsdPrice = 0;
  double get ethUsdPrice => _ethUsdPrice;

  String _estimatedGas = "";
  String get estimatedGas => _estimatedGas;

  String _gasPrice = "";
  String get gasPrice => _gasPrice;
  onNumpadKeyPressed(String value) {
    HapticFeedback.lightImpact();
    if (value == '.' && _amount.contains('.')) return;
    if (value == '.' && _amount.isEmpty) {
      _amount += "0$value";
      notifyListeners();
      return;
    }

    _amount += value;
    _usdAmount = (double.parse(_amount) * _ethUsdPrice).toString();
    notifyListeners();
  }

  onBackspaceKeyPressed() {
    HapticFeedback.lightImpact();
    if (_amount.isNotEmpty) {
      _amount = _amount.substring(0, _amount.length - 1);
      if (_amount.isEmpty) {
        _usdAmount = "";
      } else {
        _usdAmount = (double.parse(_amount) * _ethUsdPrice).toString();
      }
    }

    notifyListeners();
  }

  void clearAmount() {
    _amount = "";
    _usdAmount = "";
    notifyListeners();
  }

  bool executeTransaction() {
    if (_amount.isNotEmpty &&
        double.parse(_amount) > 0 &&
        addressFieldValueController.text.isNotEmpty) {
      ApiService.sendTransaction(
        double.parse(_amount),
        getIt<HomePageUiHelper>().address!,
        _addressFieldValueController.text,
        getIt<HomePageUiHelper>().network,
      ).then(
        (value) {
          if (value != null) {
            if (rootScaffoldMessengerKey.currentState != null) {
              rootScaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
                  content: Text(
                      "Something went wrong. Transaction could not be completed!")));
            }
          }
          AccountService.saveAddress(getIt<HomePageUiHelper>().address!,
              addressFieldValueController.text);
        },
      );
      return true;
    } else {
      if (rootScaffoldMessengerKey.currentState != null) {
        rootScaffoldMessengerKey.currentState!.showSnackBar(
            SnackBar(content: Text("Either address or amount is missing!")));
      }
      return false;
    }
  }
}
