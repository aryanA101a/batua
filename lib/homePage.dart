import 'dart:ffi';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height * (1 / 3),
            child: Column(
              children: [
                TopBar(),
                Expanded(child: WalletInfo()),
              ],
            ),
          ),
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
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.grey.shade200),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Public Key"),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: "1.5 ETH",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
                children: [
                  TextSpan(
                    text: "\n\$2400 USD",
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
        Row(children: [
          NetworksButton(),
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.history, color: Colors.grey.shade900))
        ]),
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
    return MaterialButton(
      onPressed: () {},
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Icon(
              Icons.circle,
              color: Colors.purple,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              "Sepolia",
              style: TextStyle(color: Colors.grey.shade900, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
