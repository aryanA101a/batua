// To parse this JSON data, do
//
//     final ethPriceModel = ethPriceModelFromJson(jsonString);

import 'dart:convert';

class EthPriceModel {
    final String status;
    final String message;
    final EthPriceResult result;

    EthPriceModel({
        required this.status,
        required this.message,
        required this.result,
    });

    factory EthPriceModel.fromRawJson(String str) => EthPriceModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory EthPriceModel.fromJson(Map<String, dynamic> json) => EthPriceModel(
        status: json["status"],
        message: json["message"],
        result: EthPriceResult.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result.toJson(),
    };
}

class EthPriceResult {
    final String ethbtc;
    final String ethbtcTimestamp;
    final String ethusd;
    final String ethusdTimestamp;

    EthPriceResult({
        required this.ethbtc,
        required this.ethbtcTimestamp,
        required this.ethusd,
        required this.ethusdTimestamp,
    });

    factory EthPriceResult.fromRawJson(String str) => EthPriceResult.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory EthPriceResult.fromJson(Map<String, dynamic> json) => EthPriceResult(
        ethbtc: json["ethbtc"],
        ethbtcTimestamp: json["ethbtc_timestamp"],
        ethusd: json["ethusd"],
        ethusdTimestamp: json["ethusd_timestamp"],
    );

    Map<String, dynamic> toJson() => {
        "ethbtc": ethbtc,
        "ethbtc_timestamp": ethbtcTimestamp,
        "ethusd": ethusd,
        "ethusd_timestamp": ethusdTimestamp,
    };
}
