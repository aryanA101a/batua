import 'package:batua/exceptions/app_exceptions.dart';
import 'package:batua/main.dart';
import 'package:batua/services/account_service.dart';
import 'package:batua/services/api_service.dart';
import 'package:flutter/material.dart';

class OnboardingPageUiHelper extends ChangeNotifier {
  OnboardingPageUiHelper() {
    _retrieveAccounts();
  }

  void _retrieveAccounts() {
    AccountService.retrieveAccounts().then((value) {
      _accounts = value;
      notifyListeners();
    });
  }

  TextEditingController _textEditingController = TextEditingController();
  TextEditingController get textEditingController => _textEditingController;

  List<String> _accounts = [];
  List<String> get accounts => _accounts;

  bool _createAccountLoading = false;
  bool get createAccountLoading => _createAccountLoading;

  bool _importAccountLoading = false;
  bool get importAccountLoading => _importAccountLoading;

  Future<void> deleteAccount(String address) async {
    var accounts = _accounts.toList();
    accounts.remove(address);
    _accounts = accounts.toList();
    notifyListeners();
    AccountService.deleteAccount(address);
  }

  Future<bool> importAccount() async {
    _importAccountLoading = true;
    AppException? res;
    notifyListeners();
    if (textEditingController.text.length == 64) {
      res = await AccountService.importAccount(textEditingController.text);
    } else {
      if (rootScaffoldMessengerKey.currentState != null) {
        rootScaffoldMessengerKey.currentState!.showSnackBar(
          const SnackBar(
            content: Text(
              'Please input a valid private key!',
            ),
          ),
        );
      }
    }

    _importAccountLoading = false;
    textEditingController.clear();
    notifyListeners();
    if (res == null) {
      _retrieveAccounts();
      return true;
    }
    return false;
  }

  Future<void> createAccount() async {
    _createAccountLoading = true;
    notifyListeners();
    await AccountService.createAccount();
    _createAccountLoading = false;
    notifyListeners();
    _retrieveAccounts();
  }

  
}
