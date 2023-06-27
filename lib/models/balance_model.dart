import 'dart:convert';

class BalanceModel {
  final String jsonrpc;
  final int id;
  final String result;

  BalanceModel({
    required this.jsonrpc,
    required this.id,
    required this.result,
  });

  factory BalanceModel.fromRawJson(String str) =>
      BalanceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BalanceModel.fromJson(Map<String, dynamic> json) => BalanceModel(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result,
      };
}
