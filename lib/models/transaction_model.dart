// To parse this JSON data, do
//
//     final transactionModel = transactionModelFromJson(jsonString);

import 'dart:convert';
import 'dart:math';

import 'package:web3dart/crypto.dart';

class TransactionModel {
  final String status;
  final String message;
  final List<TransactionModelResult> result;

  TransactionModel({
    required this.status,
    required this.message,
    required this.result,
  });

  factory TransactionModel.fromRawJson(String str) =>
      TransactionModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        status: json["status"],
        message: json["message"],
        result: List<TransactionModelResult>.from(
            json["result"].map((x) => TransactionModelResult.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class TransactionModelResult {
  final String blockNumber;
  final DateTime timeStamp;
  final String hash;
  final String nonce;
  final String blockHash;
  final String transactionIndex;
  final String from;
  final String to;
  final double value;
  final String gas;
  final String gasPrice;
  final String? isError;
  final String? txreceiptStatus;
  final String contractAddress;
  final String cumulativeGasUsed;
  final String gasUsed;
  final String confirmations;
  final String? methodId;
  final String? tokenName;
  final String? tokenSymbol;
  final String? tokenDecimal;

  TransactionModelResult({
    required this.blockNumber,
    required this.timeStamp,
    required this.hash,
    required this.nonce,
    required this.blockHash,
    required this.transactionIndex,
    required this.from,
    required this.to,
    required this.value,
    required this.gas,
    required this.gasPrice,
    this.isError,
    this.txreceiptStatus,
    required this.contractAddress,
    required this.cumulativeGasUsed,
    required this.gasUsed,
    required this.confirmations,
    this.methodId,
    this.tokenName,
    this.tokenSymbol,
    this.tokenDecimal,
  });

  factory TransactionModelResult.fromRawJson(String str) =>
      TransactionModelResult.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransactionModelResult.fromJson(Map<String, dynamic> json) =>
      TransactionModelResult(
        blockNumber: json["blockNumber"],
        timeStamp: DateTime.fromMillisecondsSinceEpoch(
            int.parse(json["timeStamp"]) * 1000),
        hash: json["hash"],
        nonce: json["nonce"],
        blockHash: json["blockHash"],
        transactionIndex: json["transactionIndex"],
        from:strip0x( json["from"]),
        to: strip0x(json["to"]),
        value: json["tokenDecimal"] == null
            ? BigInt.parse(json["value"]) / BigInt.from(pow(10, 18))
            : BigInt.parse(json["value"]) /
                BigInt.from(pow(10, int.parse(json["tokenDecimal"]))),
        gas: json["gas"],
        gasPrice: json["gasPrice"],
        isError: json["isError"],
        txreceiptStatus: json["txreceipt_status"],
        contractAddress: json["contractAddress"],
        cumulativeGasUsed: json["cumulativeGasUsed"],
        gasUsed: json["gasUsed"],
        confirmations: json["confirmations"],
        methodId: json["methodId"],
        tokenName: json["tokenName"],
        tokenSymbol: json["tokenSymbol"],
        tokenDecimal: json["tokenDecimal"],
      );

  Map<String, dynamic> toJson() => {
        "blockNumber": blockNumber,
        "timeStamp": timeStamp,
        "hash": hash,
        "nonce": nonce,
        "blockHash": blockHash,
        "transactionIndex": transactionIndex,
        "from": from,
        "to": to,
        "value": value,
        "gas": gas,
        "gasPrice": gasPrice,
        "isError": isError,
        "txreceipt_status": txreceiptStatus,
        "contractAddress": contractAddress,
        "cumulativeGasUsed": cumulativeGasUsed,
        "gasUsed": gasUsed,
        "confirmations": confirmations,
        "methodId": methodId,
        "tokenName": tokenName,
        "tokenSymbol": tokenSymbol,
        "tokenDecimal": tokenDecimal,
      };
}
