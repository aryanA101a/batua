import 'dart:convert';

class MinedTransaction {
    final String jsonrpc;
    final String method;
    final Params params;

    MinedTransaction({
        required this.jsonrpc,
        required this.method,
        required this.params,
    });

    factory MinedTransaction.fromRawJson(String str) => MinedTransaction.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MinedTransaction.fromJson(Map<String, dynamic> json) => MinedTransaction(
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
    final Transaction transaction;

    Result({
        required this.removed,
        required this.transaction,
    });

    factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        removed: json["removed"],
        transaction: Transaction.fromJson(json["transaction"]),
    );

    Map<String, dynamic> toJson() => {
        "removed": removed,
        "transaction": transaction.toJson(),
    };
}

class Transaction {
    final String blockHash;
    final String blockNumber;
    final String from;
    final String gas;
    final String gasPrice;
    final String maxFeePerGas;
    final String maxPriorityFeePerGas;
    final String hash;
    final String input;
    final String nonce;
    final String to;
    final String transactionIndex;
    final String value;
    final String type;
    final List<dynamic> accessList;
    final String chainId;
    final String v;
    final String r;
    final String s;

    Transaction({
        required this.blockHash,
        required this.blockNumber,
        required this.from,
        required this.gas,
        required this.gasPrice,
        required this.maxFeePerGas,
        required this.maxPriorityFeePerGas,
        required this.hash,
        required this.input,
        required this.nonce,
        required this.to,
        required this.transactionIndex,
        required this.value,
        required this.type,
        required this.accessList,
        required this.chainId,
        required this.v,
        required this.r,
        required this.s,
    });

    factory Transaction.fromRawJson(String str) => Transaction.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        blockHash: json["blockHash"],
        blockNumber: json["blockNumber"],
        from: json["from"],
        gas: json["gas"],
        gasPrice: json["gasPrice"],
        maxFeePerGas: json["maxFeePerGas"],
        maxPriorityFeePerGas: json["maxPriorityFeePerGas"],
        hash: json["hash"],
        input: json["input"],
        nonce: json["nonce"],
        to: json["to"],
        transactionIndex: json["transactionIndex"],
        value: json["value"],
        type: json["type"],
        accessList: List<dynamic>.from(json["accessList"].map((x) => x)),
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
        "accessList": List<dynamic>.from(accessList.map((x) => x)),
        "chainId": chainId,
        "v": v,
        "r": r,
        "s": s,
    };
}
