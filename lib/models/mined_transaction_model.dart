import 'dart:convert';

import 'package:web3dart/crypto.dart';

class MinedTransactionModel {
  final String jsonrpc;
  final String method;
  final Params params;

  MinedTransactionModel({
    required this.jsonrpc,
    required this.method,
    required this.params,
  });

  factory MinedTransactionModel.fromRawJson(String str) =>
      MinedTransactionModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MinedTransactionModel.fromJson(Map<String, dynamic> json) =>
      MinedTransactionModel(
        jsonrpc: json["jsonrpc"],
        method: json["method"],
        params: Params.fromJson(json["params"]),
      );

  Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "method": method,
        "params": params.toJson(),
      };
}

class Params {
  final Result result;
  final String subscription;

  Params({
    required this.result,
    required this.subscription,
  });

  factory Params.fromRawJson(String str) => Params.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Params.fromJson(Map<String, dynamic> json) => Params(
        result: Result.fromJson(json["result"]),
        subscription: json["subscription"],
      );

  Map<String, dynamic> toJson() => {
        "result": result.toJson(),
        "subscription": subscription,
      };
}

class Result {
  final bool removed;
  final MinedTransaction transaction;

  Result({
    required this.removed,
    required this.transaction,
  });

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        removed: json["removed"],
        transaction: MinedTransaction.fromJson(json["transaction"]),
      );

  Map<String, dynamic> toJson() => {
        "removed": removed,
        "transaction": transaction.toJson(),
      };
}

class MinedTransaction {
  final String blockHash;
  final String blockNumber;
  final String from;
  final String gas;
  final String gasPrice;
  final String? maxFeePerGas;
  final String? maxPriorityFeePerGas;
  final String hash;
  final String? input;
  final String nonce;
  final String to;
  final String? transactionIndex;
  final String value;
  final String? type;
  final String chainId;
  final String? v;
  final String? r;
  final String? s;

  MinedTransaction({
    required this.blockHash,
    required this.blockNumber,
    required this.from,
    required this.gas,
    required this.gasPrice,
    this.maxFeePerGas,
    this.maxPriorityFeePerGas,
    required this.hash,
    this.input,
    required this.nonce,
    required this.to,
    this.transactionIndex,
    required this.value,
    this.type,
    required this.chainId,
    this.v,
    this.r,
    this.s,
  });

  factory MinedTransaction.fromRawJson(String str) =>
      MinedTransaction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MinedTransaction.fromJson(Map<String, dynamic> json) =>
      MinedTransaction(
        blockHash: json["blockHash"],
        blockNumber: json["blockNumber"],
        from: strip0x(json["from"]),
        gas: json["gas"],
        gasPrice: json["gasPrice"],
        maxFeePerGas: json["maxFeePerGas"],
        maxPriorityFeePerGas: json["maxPriorityFeePerGas"],
        hash: json["hash"],
        input: json["input"],
        nonce: json["nonce"],
        to: strip0x(json["to"]),
        transactionIndex: json["transactionIndex"],
        value: json["value"],
        type: json["type"],
        chainId: json["chainId"],
        v: json["v"],
        r: json["r"],
        s: json["s"],
      );

  Map<String, dynamic> toJson() => {
        "blockHash": blockHash,
        "blockNumber": blockNumber,
        "from": from,
        "gas": gas,
        "gasPrice": gasPrice,
        "maxFeePerGas": maxFeePerGas,
        "maxPriorityFeePerGas": maxPriorityFeePerGas,
        "hash": hash,
        "input": input,
        "nonce": nonce,
        "to": to,
        "transactionIndex": transactionIndex,
        "value": value,
        "type": type,
        "chainId": chainId,
        "v": v,
        "r": r,
        "s": s,
      };
}
