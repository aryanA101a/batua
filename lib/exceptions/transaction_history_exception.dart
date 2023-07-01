enum TransactionHistoryEType { noTransactions, fininshed, somethingElse }

class TransactionHistoryException {
  TransactionHistoryException(this.eType) : _message = _setMessage(eType);
  String _message;
  String get message => _message;

  TransactionHistoryEType eType;

  static String _setMessage(TransactionHistoryEType eType) {
    switch (eType) {
      case TransactionHistoryEType.noTransactions:
        return "No transactions!";

      case TransactionHistoryEType.fininshed:
        return "Limit reached!";

      case TransactionHistoryEType.somethingElse:
        return "Something went wrong!";
    }
  }
}
