class Transaction {
  Transaction(
      {required this.from,
      required this.timeStamp,
      required this.to,
      this.tokenName,
      this.tokenSymbol,
      required this.value});
  final DateTime timeStamp;
  final String from;
  final String to;
  final double value;
  final String? tokenName;
  final String? tokenSymbol;
}
