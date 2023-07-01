import 'dart:developer';

import 'package:batua/di/locator.dart';
import 'package:batua/exceptions/transaction_history_exception.dart';
import 'package:batua/models/transaction.dart';
import 'package:batua/services/transaction_history_service.dart';
import 'package:batua/ui_helper/homePageUiHelper.dart';
import 'package:batua/utils.dart';
import 'package:flutter/material.dart';

class TransactionPageUiHelper extends ChangeNotifier {
  TransactionPageUiHelper() {
    _isLoading = true;
    if (getIt<HomePageUiHelper>().address != null) {
      loadNext().then((value) {
        _isLoading = false;
        notifyListeners();
      });
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !_pageLoading) {
        log("loadMore");
        if (!_end) {
          loadNext().then((value) => notifyListeners());
        }
      }
    });
  }
  final TransactionHistoryService _transactionHistoryService =
      TransactionHistoryService();
  List<Transaction> _allTransactions = [];
  List<Transaction> get allTransactions => _allTransactions;

  TransactionHistoryException? _exception;
  TransactionHistoryException? get exception => _exception;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _pageLoading = false;
  // bool get pageLoading => _pageLoading;
  bool _end = false;

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  Future<void> loadNext() async {
    log("loadNext");
    _pageLoading = true;

    var transactions = await _transactionHistoryService.getAllTransactions(
      "9b130Ce90b9eC6A3D179e251434a7d10CF3aC21A",
      getIt<HomePageUiHelper>().network,
    );
    transactions.fold((l) {
      _allTransactions += l;
      log(l.length.toString());
    }, (r) {
      log(r.message);
      if (r.eType != TransactionHistoryEType.somethingElse) {
        _end = true;
      }
      _exception = r;
    });
    _pageLoading = false;
  }
}
