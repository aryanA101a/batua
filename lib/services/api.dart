import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:batua/models/balance.dart';
import 'package:batua/models/mined_transaction.dart';
import 'package:batua/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Api {
  static const String _etheriumHttps = 'https://eth-mainnet.g.alchemy.com/v2/';
  static const String _etheriumWss = 'wss://eth-mainnet.g.alchemy.com/v2/';
  static const String _sepoliaHttps = 'https://eth-sepolia.g.alchemy.com/v2/';
  static const String _sepoliaWss = 'wss://eth-sepolia.g.alchemy.com/v2/';
  static const String _ethUsdtTicker =
      'wss://stream.binance.com:9443/ws/ethusdt@ticker';

  static Future<Balance?> getBalance(String address, Network network) async {
    String etheriumApiKey = dotenv.get("ALCHEMY_ETHERIUM_MAINNET_API_KEY");
    String sepoliaApiKey = dotenv.get("ALCHEMY_SEPOLIA_TESTNET_API_KEY");
    String url;
    switch (network) {
      case Network.etheriumMainnet:
        url = "$_etheriumHttps$etheriumApiKey";
      case Network.sepoliaTestnet:
        url = "$_sepoliaHttps$sepoliaApiKey";
    }
    final headers = {
      'accept': 'application/json',
      'content-type': 'application/json',
    };

    // Request data
    final requestData = {
      'id': 1,
      'jsonrpc': '2.0',
      'params': [
        address,
        'latest',
      ],
      'method': 'eth_getBalance',
    };

    // Perform POST request

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(requestData),
    );

    if (response.statusCode == 200) {
      return Balance.fromRawJson(response.body);
    }
    return null;
  }

  static (Stream<Transaction?>, Future<dynamic> Function([int?, String?]))
      getTransactionStream(String address, Network network) {
    String etheriumApiKey = dotenv.get("ALCHEMY_ETHERIUM_MAINNET_API_KEY");
    String sepoliaApiKey = dotenv.get("ALCHEMY_SEPOLIA_TESTNET_API_KEY");
    WebSocketChannel channel;
    switch (network) {
      case Network.etheriumMainnet:
        channel = WebSocketChannel.connect(
          Uri.parse("$_etheriumWss$etheriumApiKey"),
        );
      case Network.sepoliaTestnet:
        channel = WebSocketChannel.connect(
          Uri.parse("$_sepoliaWss$sepoliaApiKey"),
        );
    }
    final message = {
      "jsonrpc": "2.0",
      "method": "eth_subscribe",
      "params": [
        "alchemy_minedTransactions",
        {
          "addresses": [
            {"from": address},
            {"to": address}
          ],
          "includeRemoved": false,
          "hashesOnly": false
        }
      ],
      "id": 1
    };

    channel.sink.add(json.encode(message));

    return (
      channel.stream.map((event) {
        Map data = json.decode(event);
        if (data.containsKey("method")) {
          return MinedTransaction.fromRawJson(event).params.result.transaction;
        }
        return null;
      }),
      channel.sink.close
    );
  }

  static (Stream<String?>, Future<dynamic> Function([int?, String?]))
      getEthUsdtPriceStream() {
    WebSocketChannel channel = WebSocketChannel.connect(
      Uri.parse(_ethUsdtTicker),
    );

    return (
      channel.stream.map((event) {
        Map data = json.decode(event);
        if (data.containsKey("c")) {
          return data["c"];
        }
        return null;
      }),
      channel.sink.close
    );
  }
}
