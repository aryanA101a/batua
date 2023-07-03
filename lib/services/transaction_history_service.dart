import 'dart:developer';

import 'package:batua/exceptions/transaction_history_exception.dart';
import 'package:batua/models/transaction.dart';
import 'package:batua/models/transaction_model.dart';
import 'package:batua/services/api_service.dart';
import 'package:batua/utils/utils.dart';
import 'package:fpdart/fpdart.dart';

class TransactionHistoryService {
  // TransactionType _transactionType = TransactionType.all;
  final int _offset = 10;
  int _page = 1;
  bool _erc20PageEnd = false;
  bool _nativePageEnd = false;
  Future<Either<List<Transaction>, TransactionHistoryException>>
      getAllTransactions(
    String address,
    Network network,
  ) async {
    List<Transaction> transactions = [];
    if (!_nativePageEnd) {
      final nativeData = await ApiService.getTransactions(
          address, network, TransactionType.native, _page, _offset);
      nativeData.fold((l) {
        log("nativeL");
        for (var e in l) {
          transactions.add(Transaction(
            from: e.from,
            timeStamp: e.timeStamp,
            to: e.to,
            value: e.value,
            tokenName: e.tokenName,
            tokenSymbol: e.tokenSymbol,
          ));
        }
      }, (r) {
        log("nativeR");

        if (r.eType == TransactionHistoryEType.fininshed ||
            r.eType == TransactionHistoryEType.noTransactions) {
          _nativePageEnd = true;
        }
      });
    }

    if (!_erc20PageEnd) {
      final erc20Data = await ApiService.getTransactions(
          address, network, TransactionType.erc20, _page, _offset);
      erc20Data.fold((l) {
        log("ercL");
        for (var e in l) {
          transactions.add(Transaction(
            from: e.from,
            timeStamp: e.timeStamp,
            to: e.to,
            value: e.value,
            tokenName: e.tokenName,
            tokenSymbol: e.tokenSymbol,
          ));
        }
      }, (r) {
        log("nativeR");

        if (r.eType == TransactionHistoryEType.fininshed ||
            r.eType == TransactionHistoryEType.noTransactions) {
          _erc20PageEnd = true;
        }
      });
    }
    if (_nativePageEnd && _erc20PageEnd) {
      if (_page == 1) {
        return right(TransactionHistoryException(
            TransactionHistoryEType.noTransactions));
      }
      return right(
          TransactionHistoryException(TransactionHistoryEType.fininshed));
    }
    if (!_nativePageEnd && !_erc20PageEnd) {
      transactions.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
    }

    _page++;
    return left(transactions);
  }
}
