import 'dart:developer';

import 'package:batua/di/locator.dart';
import 'package:batua/main.dart';
import 'package:batua/models/token.dart';
import 'package:batua/pages/tokenInfoPage.dart';
import 'package:batua/pages/transactionHistoryPage.dart';
import 'package:batua/pages/transactionPage.dart';
import 'package:batua/services/account_service.dart';
import 'package:batua/services/api_service.dart';
import 'package:batua/ui_helper/homePageUiHelper.dart';
import 'package:batua/utils/utils.dart';
import 'package:batua/utils/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'onboardingPage.dart';

class HomePage extends StatelessWidget {
  static const route = "/homePage";
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // var provider = Provider.of<HomePageUiHelper>(context);
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height * (1 / 3),
            child: const Column(
              children: [
                TopBar(),
                Expanded(child: WalletInfo()),
              ],
            ),
          ),
          const Expanded(
            child: TokensSectionWidget(),
          )
        ],
      ),
    ));
  }
}

class TokensSectionWidget extends StatelessWidget {
  const TokensSectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Token> tokens = context.select<HomePageUiHelper, List<Token>>(
        (value) => value.tokens.values.toList());
    bool loading =
        context.select<HomePageUiHelper, bool>((value) => value.loadingTokens);
    if (loading) {
      return Shimmer.fromColors(
          child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              )),
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.white);
    }

    return Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade200),
        child: tokens.isEmpty
            ? const Center(
                child: Text(
                  "No Tokens",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                itemCount: tokens.length,
                separatorBuilder: (context, index) => Divider(
                  indent: 5,
                  endIndent: 5,
                ),
                itemBuilder: (context, index) {
                  // log(tokens[index].logo.toString());
                  return Container(
                    margin: EdgeInsets.all(6),
                    child: ListTile(
                      onTap: () => Navigator.pushNamed(
                          context, TokenInfoPage.route,
                          arguments: (
                            logo: tokens[index].logo,
                            name: tokens[index].name,
                            symbol: tokens[index].symbol,
                          )),
                      tileColor: Colors.transparent,
                      leading: tokens[index].logo == null
                          ? CircleAvatar(
                              backgroundColor: Colors.white,
                              child: FittedBox(
                                  child: Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Text(
                                  tokens[index].symbol,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  NetworkImage(tokens[index].logo!),
                            ),
                      title: Text(
                        tokens[index].name,
                        style: const TextStyle(
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis),
                      ),
                      subtitle: Text(tokens[index].symbol),
                      trailing: Container(
                        alignment: Alignment.centerRight,
                        width: MediaQuery.sizeOf(context).width * .3,
                        child: Text(
                          tokens[index].amount.toStringAsFixed(4),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ));
  }
}

class WalletInfo extends StatelessWidget {
  const WalletInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String? address =
        context.select<HomePageUiHelper, String?>((value) => value.address);
    String balance =
        context.select<HomePageUiHelper, String>((value) => value.balance);
    String usdtBalance =
        context.select<HomePageUiHelper, String>((value) => value.usdtBalance);
    String symbol = symbols[context.read<HomePageUiHelper>().network];
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: address ?? ""));

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Address copied!',
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.copy,
              size: 15,
            ),
            label: SizedBox(
              width: 100,
              child: Text(
                address ?? "",
                style: const TextStyle(overflow: TextOverflow.ellipsis),
              ),
            ),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: "$balance $symbol",
                style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
                children: [
                  TextSpan(
                    text: "\n\$$usdtBalance USD",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.shade800),
                  )
                ]),
          ),
          IconLabelBtn(
              text: Text(
                "Send",
                style: TextStyle(color: Colors.blue.shade800, fontSize: 16),
              ),
              onPressed: () {
                Navigator.pushNamed(context, TransactionPage.route);
              },
              color: Colors.blue.shade200,
              icon: Icon(
                Icons.send_rounded,
                color: Colors.blue.shade800,
              )),
        ],
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.all(2.0),
          child: Icon(
            Icons.wallet_rounded,
            color: Colors.blue,
            size: 30,
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(2.0),
          child: Text(
            "बटुआ",
            style: TextStyle(
                color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const Spacer(),
        const NetworksButton(),
        IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                TransactionHistoryPage.route,
              );
            },
            icon: Icon(FontAwesomeIcons.fileInvoice,
                color: Colors.blue.shade800)),
        Padding(
          padding: const EdgeInsets.only(right: 8, left: 2),
          child: PopupMenuButton<String>(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            position: PopupMenuPosition.under,
            child: Icon(
              Icons.settings_rounded,
              color: Colors.grey.shade900,
            ),
            onSelected: (String value) {
              switch (value) {
                case "CopyPrivateKey":
                  AccountService.retrievePrivateKey(
                          context.read<HomePageUiHelper>().address!)
                      .then((value) {
                    Clipboard.setData(ClipboardData(text: value ?? ""));

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Private key copied!',
                        ),
                      ),
                    );
                  });

                case "Accounts":
                  // AccountService.deletePrivateKey();
                  Navigator.popAndPushNamed(context, OnboardingPage.route);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                ("Copy Private Key", Icons.security_rounded),
                ("Accounts", Icons.account_circle_rounded)
              ]
                  .map(((String, IconData) v) => PopupMenuItem<String>(
                        value: v.$1.replaceAll(' ', ''),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(8.0),
                              child: Icon(v.$2),
                            ),
                            Text(
                              v.$1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ))
                  .toList();
            },
          ),
        ),
      ],
    );
  }
}

class NetworksButton extends StatelessWidget {
  const NetworksButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color iconColor;
    String text;
    Network network = context.select<HomePageUiHelper, Network>(
      (value) => value.network,
    );
    switch (network) {
      case Network.ethereumMainnet:
        iconColor = Colors.teal;
        text = "ethereum";
      case Network.sepoliaTestnet:
        iconColor = Colors.purple;
        text = "Sepolia";
    }
    return MaterialButton(
      onPressed: () {
        context.read<HomePageUiHelper>().changingNetwork
            ? ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Network change in progress!',
                  ),
                  margin: EdgeInsets.only(bottom: 30),
                ),
              )
            : context.read<HomePageUiHelper>().changeNetwork();
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Icon(
              Icons.circle,
              color: iconColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              text,
              style: TextStyle(color: Colors.grey.shade900, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
