// To parse this JSON data, do
//
//     final tokenModel = tokenModelFromJson(jsonString);

import 'dart:convert';

class TokenModel {
  final String tokenAddress;
  final String symbol;
  final String name;
  final String? logo;
  final String? thumbnail;
  final int decimals;
  final String balance;
  final bool possibleSpam;

  TokenModel({
    required this.tokenAddress,
    required this.symbol,
    required this.name,
    this.logo,
    this.thumbnail,
    required this.decimals,
    required this.balance,
    required this.possibleSpam,
  });

  factory TokenModel.fromRawJson(String str) =>
      TokenModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
        tokenAddress: json["token_address"],
        symbol: json["symbol"],
        name: json["name"],
        logo: json["logo"],
        thumbnail: json["thumbnail"],
        decimals: json["decimals"],
        balance: json["balance"],
        possibleSpam: json["possible_spam"],
      );

  Map<String, dynamic> toJson() => {
        "token_address": tokenAddress,
        "symbol": symbol,
        "name": name,
        "logo": logo,
        "thumbnail": thumbnail,
        "decimals": decimals,
        "balance": balance,
        "possible_spam": possibleSpam,
      };
}
