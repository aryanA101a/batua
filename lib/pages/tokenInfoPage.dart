import 'dart:developer';

import 'package:batua/models/token_info_model.dart';
import 'package:batua/services/api_service.dart';
import 'package:batua/ui_helper/homePageUiHelper.dart';
import 'package:flutter/material.dart';

class TokenInfoPage extends StatelessWidget {
  static const route = "/tokenInfoPage";
  const TokenInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as tokenInfoPageArgs;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: FutureBuilder<TokenInfoModel?>(
            future: ApiService.getTokenInfo(args.symbol),
            builder: (context, snapshot) {
              var metricName = "";
              var value = "";
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(bottom: 2),
                        child: Text(
                          args.name,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade900,
                              fontSize: 32),
                        ),
                      ),
                      Text(
                        "\$${snapshot.data?.data.quote.usd.price.toStringAsFixed(2) ?? ""}",
                        style: TextStyle(
                            // fontWeight: FontWeight.w500,
                            color: Colors.grey.shade800,
                            fontSize: 28),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(bottom: 16),
                    child: Text(
                      args.symbol,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * .2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.cyan.shade100,
                    ),
                    child: args.logo == null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Text(
                                  args.symbol,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      color: Colors.blue),
                                )),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(args.logo!),
                          ),
                  ),
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData)
                    Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * .2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: MetricBox(
                                    metricName: "Market Capitalization",
                                    value: snapshot
                                            .data?.data.quote.usd.marketCap
                                            .toStringAsFixed(4) ??
                                        "not available"),
                              ),
                              Expanded(
                                  child: MetricBox(
                                      metricName: "Circulating Supply",
                                      value: snapshot
                                              .data?.data.circulatingSupply
                                              .toStringAsFixed(4) ??
                                          "not available")),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * .16,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: MetricBox(
                                metricName: "Rank",
                                value: snapshot.data?.data.cmcRank.toString() ??
                                    "not available",
                              )),
                              Expanded(
                                  child: MetricBox(
                                      metricName: "Max Supply",
                                      value: snapshot
                                                  .data!.data.infiniteSupply &&
                                              snapshot.data?.data.maxSupply ==
                                                  null
                                          ? "infinite"
                                          : "not available")),
                            ],
                          ),
                        ),
                      ],
                    ),
                  if (snapshot.connectionState == ConnectionState.waiting)
                    CircularProgressIndicator()
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class MetricBox extends StatelessWidget {
  const MetricBox({
    super.key,
    required this.metricName,
    required this.value,
  });

  final String metricName;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.sizeOf(context).width * .4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.cyan.shade100,
      ),
      margin: EdgeInsets.only(right: 6, bottom: 16),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            metricName,
            style: TextStyle(
                color: Colors.blue.shade900,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * .04,
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey.shade900,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
