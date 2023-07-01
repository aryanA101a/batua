import 'dart:convert';
import 'dart:developer';

import 'package:batua/exceptions/transaction_history_exception.dart';
import 'package:batua/models/token_info_model.dart';
import 'package:batua/models/tokens_model.dart';
import 'package:batua/models/transaction_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:batua/models/balance_model.dart';
import 'package:batua/models/mined_transaction_model.dart';
import 'package:batua/utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef Error = String;

class ApiService {
  static const String _etheriumAlchemyHttps =
      'https://eth-mainnet.g.alchemy.com/v2/';
  static const String _etheriumAlchemyWss =
      'wss://eth-mainnet.g.alchemy.com/v2/';
  static const String _sepoliaAlchemyHttps =
      'https://eth-sepolia.g.alchemy.com/v2/';
  static const String _sepoliaAlchemyWss =
      'wss://eth-sepolia.g.alchemy.com/v2/';
  static const String _ethUsdtTickerBinanceWss =
      'wss://stream.binance.com:9443/ws/ethusdt@ticker';
  static const String _moralisHttps = "https://deep-index.moralis.io/api/v2/";
  static const String _ethereumEtherscanHttps = 'https://api.etherscan.io/';
  static const String _sepoliaEtherscanHttps =
      'https://api-sepolia.etherscan.io/';

  static String sepoliaApiKey = dotenv.get("ALCHEMY_SEPOLIA_TESTNET_API_KEY");
  static String etheriumApiKey = dotenv.get("ALCHEMY_ETHERIUM_MAINNET_API_KEY");
  static String coinmarketcapApiKey = dotenv.get("COINMARKETCAP_API_KEY");
  static String moralisApiKey = dotenv.get("MORALIS_API_KEY");
  static String etherscanApiKey = dotenv.get("ETHERSCAN_API_KEY");

  static Future<BalanceModel?> getBalance(
      String address, Network network) async {
    String url;
    switch (network) {
      case Network.etheriumMainnet:
        url = "$_etheriumAlchemyHttps$etheriumApiKey";
      case Network.sepoliaTestnet:
        url = "$_sepoliaAlchemyHttps$sepoliaApiKey";
    }
    final headers = {
      'accept': 'application/json',
      'content-type': 'application/json',
    };

    final requestData = {
      'id': 1,
      'jsonrpc': '2.0',
      'params': [
        "0x$address",
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

  static Future<
          Either<List<TransactionModelResult>, TransactionHistoryException>>
      getTransactions(
    String address,
    Network network,
    TransactionType transactionType,
    int page,
    int offset,
  ) async {
    String authority;
    String path = '/api';
    Map<String, dynamic> queryParameters = {
      "module": "account",
      "address": "0x$address",
      "page": page.toString(),
      "offset": offset.toString(),
      "sort": "desc",
      "apiKey": etherscanApiKey
    };
    switch (network) {
      case Network.etheriumMainnet:
        authority = 'api.etherscan.io';
      case Network.sepoliaTestnet:
        authority = 'api-sepolia.etherscan.io';
    }
    switch (transactionType) {
      case TransactionType.native:
        queryParameters["action"] = "txlist";

      case TransactionType.erc20:
        queryParameters["action"] = "tokentx";
      default:
        break;
    }

    final headers = {
      'accept': 'application/json',
      'content-type': 'application/json',
    };
    log(Uri.https(authority, path, queryParameters).toString());
    try {
      final response = await http.get(
        Uri.https(authority, path, queryParameters),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // log(response.body);
        var result = TransactionModel.fromRawJson(response.body).result;
        if (result.isEmpty) {
          if (page == 1) {
            return right(TransactionHistoryException(
                TransactionHistoryEType.noTransactions));
          } else if (page > 1) {
            return right(
                TransactionHistoryException(TransactionHistoryEType.fininshed));
          }
        }
        return left(result);
      }

      throw TransactionHistoryEType.somethingElse;
    } catch (e) {
      log(e.toString());
      return right(
          TransactionHistoryException(TransactionHistoryEType.somethingElse));
    }
  }

  static Future<List<TokenModel>?> getErc20Tokens(
      String address, Network network) async {
    String path = "/api/v2/0x$address/erc20";
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
      var tokensList = json
          .decode(response.body)
          .map<TokenModel>((e) => TokenModel.fromJson(e))
          .toList();
      // log(tokensList.toString());
      return tokensList;
    }
    return null;
  }

  static Future<TokenInfoModel?> getTokenInfo(String tokenSymbol) async {
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
      // log(jsonData.toString());
      return TokenInfoModel.fromJson(jsonData);
    }
    return null;
  }

  static (Stream<MinedTransaction?>, Future<dynamic> Function([int?, String?]))
      getTransactionStream(String address, Network network) {
    WebSocketChannel channel;
    switch (network) {
      case Network.etheriumMainnet:
        channel = WebSocketChannel.connect(
          Uri.parse("$_etheriumAlchemyWss$etheriumApiKey"),
        );
      case Network.sepoliaTestnet:
        channel = WebSocketChannel.connect(
          Uri.parse("$_sepoliaAlchemyWss$sepoliaApiKey"),
        );
    }
    final message = {
      "jsonrpc": "2.0",
      "method": "eth_subscribe",
      "params": [
        "alchemy_minedTransactions",
        {
          "addresses": [
            {"from": "0x$address"},
            {"to": "0x$address"}
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
      Uri.parse(_ethUsdtTickerBinanceWss),
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
