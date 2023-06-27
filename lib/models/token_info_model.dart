// To parse this JSON data, do
//
//     final tokenInfoModel = tokenInfoModelFromJson(jsonString);

import 'dart:convert';

class TokenInfoModel {
  final Status status;
  final TokenInfo data;

  TokenInfoModel({
    required this.status,
    required this.data,
  });

  factory TokenInfoModel.fromRawJson(String str) =>
      TokenInfoModel.fromJson(json.decode(str));

  factory TokenInfoModel.fromJson(Map<String, dynamic> json) => TokenInfoModel(
        status: Status.fromJson(json["status"]),
        data: TokenInfo.fromJson(json["data"].entries.first.value.first),
      );
}

class TokenInfo {
  final int id;
  final String name;
  final String symbol;
  final String slug;
  final int numMarketPairs;
  final DateTime dateAdded;
  final List<Tag> tags;
  final int? maxSupply;
  final double circulatingSupply;
  final double totalSupply;
  final int isActive;
  final bool infiniteSupply;
  final Platform? platform;
  final int cmcRank;
  final int isFiat;
  final int? selfReportedCirculatingSupply;
  final double? selfReportedMarketCap;
  final dynamic tvlRatio;
  final DateTime lastUpdated;
  final Quote quote;

  TokenInfo({
    required this.id,
    required this.name,
    required this.symbol,
    required this.slug,
    required this.numMarketPairs,
    required this.dateAdded,
    required this.tags,
    this.maxSupply,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.isActive,
    required this.infiniteSupply,
    this.platform,
    required this.cmcRank,
    required this.isFiat,
    this.selfReportedCirculatingSupply,
    this.selfReportedMarketCap,
    this.tvlRatio,
    required this.lastUpdated,
    required this.quote,
  });

  factory TokenInfo.fromRawJson(String str) =>
      TokenInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TokenInfo.fromJson(Map<String, dynamic> json) => TokenInfo(
        id: json["id"],
        name: json["name"],
        symbol: json["symbol"],
        slug: json["slug"],
        numMarketPairs: json["num_market_pairs"],
        dateAdded: DateTime.parse(json["date_added"]),
        tags: List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
        maxSupply: json["max_supply"],
        circulatingSupply: json["circulating_supply"]?.toDouble(),
        totalSupply: json["total_supply"]?.toDouble(),
        isActive: json["is_active"],
        infiniteSupply: json["infinite_supply"],
        platform: json["platform"] == null
            ? null
            : Platform.fromJson(json["platform"]),
        cmcRank: json["cmc_rank"],
        isFiat: json["is_fiat"],
        selfReportedCirculatingSupply: json["self_reported_circulating_supply"],
        selfReportedMarketCap: json["self_reported_market_cap"]?.toDouble(),
        tvlRatio: json["tvl_ratio"],
        lastUpdated: DateTime.parse(json["last_updated"]),
        quote: Quote.fromJson(json["quote"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "symbol": symbol,
        "slug": slug,
        "num_market_pairs": numMarketPairs,
        "date_added": dateAdded.toIso8601String(),
        "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
        "max_supply": maxSupply,
        "circulating_supply": circulatingSupply,
        "total_supply": totalSupply,
        "is_active": isActive,
        "infinite_supply": infiniteSupply,
        "platform": platform?.toJson(),
        "cmc_rank": cmcRank,
        "is_fiat": isFiat,
        "self_reported_circulating_supply": selfReportedCirculatingSupply,
        "self_reported_market_cap": selfReportedMarketCap,
        "tvl_ratio": tvlRatio,
        "last_updated": lastUpdated.toIso8601String(),
        "quote": quote.toJson(),
      };
}

class Platform {
  final int id;
  final String name;
  final String symbol;
  final String slug;
  final String tokenAddress;

  Platform({
    required this.id,
    required this.name,
    required this.symbol,
    required this.slug,
    required this.tokenAddress,
  });

  factory Platform.fromRawJson(String str) =>
      Platform.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Platform.fromJson(Map<String, dynamic> json) => Platform(
        id: json["id"],
        name: json["name"],
        symbol: json["symbol"],
        slug: json["slug"],
        tokenAddress: json["token_address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "symbol": symbol,
        "slug": slug,
        "token_address": tokenAddress,
      };
}

class Quote {
  final Usd usd;

  Quote({
    required this.usd,
  });

  factory Quote.fromRawJson(String str) => Quote.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        usd: Usd.fromJson(json["USD"]),
      );

  Map<String, dynamic> toJson() => {
        "USD": usd.toJson(),
      };
}

class Usd {
  final double price;
  final double volume24H;
  final double volumeChange24H;
  final double percentChange1H;
  final double percentChange24H;
  final double percentChange7D;
  final double percentChange30D;
  final double percentChange60D;
  final double percentChange90D;
  final double marketCap;
  final double marketCapDominance;
  final double fullyDilutedMarketCap;
  final dynamic tvl;
  final DateTime lastUpdated;

  Usd({
    required this.price,
    required this.volume24H,
    required this.volumeChange24H,
    required this.percentChange1H,
    required this.percentChange24H,
    required this.percentChange7D,
    required this.percentChange30D,
    required this.percentChange60D,
    required this.percentChange90D,
    required this.marketCap,
    required this.marketCapDominance,
    required this.fullyDilutedMarketCap,
    this.tvl,
    required this.lastUpdated,
  });

  factory Usd.fromRawJson(String str) => Usd.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Usd.fromJson(Map<String, dynamic> json) => Usd(
        price: json["price"]?.toDouble(),
        volume24H: json["volume_24h"]?.toDouble(),
        volumeChange24H: json["volume_change_24h"]?.toDouble(),
        percentChange1H: json["percent_change_1h"]?.toDouble(),
        percentChange24H: json["percent_change_24h"]?.toDouble(),
        percentChange7D: json["percent_change_7d"]?.toDouble(),
        percentChange30D: json["percent_change_30d"]?.toDouble(),
        percentChange60D: json["percent_change_60d"]?.toDouble(),
        percentChange90D: json["percent_change_90d"]?.toDouble(),
        marketCap: json["market_cap"]?.toDouble(),
        marketCapDominance: json["market_cap_dominance"]?.toDouble(),
        fullyDilutedMarketCap: json["fully_diluted_market_cap"]?.toDouble(),
        tvl: json["tvl"],
        lastUpdated: DateTime.parse(json["last_updated"]),
      );

  Map<String, dynamic> toJson() => {
        "price": price,
        "volume_24h": volume24H,
        "volume_change_24h": volumeChange24H,
        "percent_change_1h": percentChange1H,
        "percent_change_24h": percentChange24H,
        "percent_change_7d": percentChange7D,
        "percent_change_30d": percentChange30D,
        "percent_change_60d": percentChange60D,
        "percent_change_90d": percentChange90D,
        "market_cap": marketCap,
        "market_cap_dominance": marketCapDominance,
        "fully_diluted_market_cap": fullyDilutedMarketCap,
        "tvl": tvl,
        "last_updated": lastUpdated.toIso8601String(),
      };
}

class Tag {
  final String slug;
  final String name;
  final String category;

  Tag({
    required this.slug,
    required this.name,
    required this.category,
  });

  factory Tag.fromRawJson(String str) => Tag.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        slug: json["slug"],
        name: json["name"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "slug": slug,
        "name": name,
        "category": category,
      };
}

class Status {
  final DateTime timestamp;
  final int errorCode;
  final dynamic errorMessage;
  final int elapsed;
  final int creditCount;
  final dynamic notice;

  Status({
    required this.timestamp,
    required this.errorCode,
    this.errorMessage,
    required this.elapsed,
    required this.creditCount,
    this.notice,
  });

  factory Status.fromRawJson(String str) => Status.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        timestamp: DateTime.parse(json["timestamp"]),
        errorCode: json["error_code"],
        errorMessage: json["error_message"],
        elapsed: json["elapsed"],
        creditCount: json["credit_count"],
        notice: json["notice"],
      );

  Map<String, dynamic> toJson() => {
        "timestamp": timestamp.toIso8601String(),
        "error_code": errorCode,
        "error_message": errorMessage,
        "elapsed": elapsed,
        "credit_count": creditCount,
        "notice": notice,
      };
}
