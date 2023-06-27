import 'dart:convert';
import 'dart:developer';

import 'package:batua/models/token_info_model.dart';
import 'package:batua/models/tokens_model.dart';
import 'package:http/http.dart' as http;
import 'package:batua/models/balance_model.dart';
import 'package:batua/models/mined_transaction_model.dart';
import 'package:batua/utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ApiService {
  static const String _etheriumHttps = 'https://eth-mainnet.g.alchemy.com/v2/';
  static const String _etheriumWss = 'wss://eth-mainnet.g.alchemy.com/v2/';
  static const String _sepoliaHttps = 'https://eth-sepolia.g.alchemy.com/v2/';
  static const String _sepoliaWss = 'wss://eth-sepolia.g.alchemy.com/v2/';
  static const String _ethUsdtTicker =
      'wss://stream.binance.com:9443/ws/ethusdt@ticker';
  static const String _moralisHttps = "https://deep-index.moralis.io/api/v2/";

  static Future<BalanceModel?> getBalance(
      String address, Network network) async {
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

    final requestData = {
      'id': 1,
      'jsonrpc': '2.0',
      'params': [
        address,
        'latest',
      ],
      'method': 'eth_getBalance',
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(requestData),
    );

    if (response.statusCode == 200) {
      return BalanceModel.fromRawJson(response.body);
    }
    return null;
  }

  static Future<List<TokenModel>?> getErc20Tokens(
      String address, Network network) async {
    String moralisApiKey = dotenv.get("MORALIS_API_KEY");
    String path = "/api/v2/$address/erc20";
    Map<String, String> queryParameters = {};
    switch (network) {
      case Network.etheriumMainnet:
        queryParameters["chain"] = "eth";
      case Network.sepoliaTestnet:
        queryParameters["chain"] = "sepolia";
    }
    final headers = {
      'accept': 'application/json',
      'content-type': 'application/json',
      'X-API-Key': moralisApiKey,
    };

    final response = await http.get(
      Uri.https("deep-index.moralis.io", path, queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var tokensList = json.decode(response.body);
      log(tokensList.toString());
      return tokensList.map<TokenModel>((e) => TokenModel.fromJson(e)).toList();
    }
    return null;
  }

  static Future<TokenInfoModel?> getTokenInfo(String tokenSymbol) async {
    String coinmarketcapApiKey = dotenv.get("COINMARKETCAP_API_KEY");
    String authority = "pro-api.coinmarketcap.com";
    String path = "/v2/cryptocurrency/quotes/latest";
    Map<String, String> queryParameters = {"symbol": tokenSymbol};

    final headers = {
      'accept': 'application/json',
      'content-type': 'application/json',
      'X-CMC_PRO_API_KEY': coinmarketcapApiKey,
    };

    final response = await http.get(
      Uri.https(authority, path, queryParameters),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      log(jsonData.toString());
      return TokenInfoModel.fromJson(jsonData);
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
          return MinedTransactionModel.fromRawJson(event)
              .params
              .result
              .transaction;
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
