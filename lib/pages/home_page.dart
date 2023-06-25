import 'dart:developer';

import 'package:batua/ui_helper/homePageUiHelper.dart';
import 'package:batua/utils.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'onboarding_page.dart';

class HomePage extends StatelessWidget {
  static const route = "/home";
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomePageUiHelper>(context);
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height * (1 / 3),
            child: Column(
              children: [
                TopBar(),
                Expanded(child: WalletInfo()),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade200),
            ),
          )
        ],
      ),
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
      margin: EdgeInsets.all(8),
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
                SnackBar(
                  content: Text(
                    'Address copied!',
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.copy,
              size: 15,
            ),
            label: SizedBox(
              width: 100,
              child: Text(
                address ?? "",
                style: TextStyle(overflow: TextOverflow.ellipsis),
              ),
            ),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: "$balance $symbol",
                style: TextStyle(
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
          MaterialButton(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onPressed: () {},
            child: Text(
              "Send",
              style: TextStyle(color: Colors.grey.shade200),
            ),
            color: Colors.blue.shade400,
          )
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
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Icon(
            Icons.wallet_rounded,
            color: Colors.blue,
            size: 30,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            "बटुआ",
            style: TextStyle(
                color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Spacer(),
        NetworksButton(),
        IconButton(
            onPressed: () {},
            icon: Icon(FontAwesomeIcons.fileInvoice,
                color: Colors.blue.shade800)),
        IconButton(
            onPressed: () async {
              AndroidOptions _getAndroidOptions() => const AndroidOptions(
                    encryptedSharedPreferences: true,
                  );
              final storage =
                  FlutterSecureStorage(aOptions: _getAndroidOptions());
              storage.delete(key: "privateKey");
              Navigator.popAndPushNamed(context, OnboardingPage.route);
            },
            icon: Icon(FontAwesomeIcons.arrowRightFromBracket,
                color: Colors.grey.shade900)),
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
      case Network.etheriumMainnet:
        iconColor = Colors.teal;
        text = "Etherium";
      case Network.sepoliaTestnet:
        iconColor = Colors.purple;
        text = "Sepolia";
    }
    return MaterialButton(
      onPressed: () {
        context.read<HomePageUiHelper>().changingNetwork
            ? ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
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
