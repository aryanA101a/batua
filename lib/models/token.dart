class Token {
  Token({
    required this.amount,
    required this.logo,
    required this.name,
    required this.symbol,
    required this.usdtBalance,
  });
  final String? logo;
  final String name;
  final String symbol;
  final double amount;
  final double? usdtBalance;
}
