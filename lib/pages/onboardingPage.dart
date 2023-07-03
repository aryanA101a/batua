import 'dart:math' as math;
import 'dart:typed_data';

import 'package:batua/services/account_service.dart';
import 'package:batua/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

import 'homePage.dart';

class OnboardingPage extends StatelessWidget {
  static const route = "/";

  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
        height: MediaQuery.sizeOf(context).height * .25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AppLogo(),
            Spacer(),
            Column(
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * .8,
                  height: MediaQuery.sizeOf(context).height * .05,
                  margin: const EdgeInsets.only(bottom: 6.0),
                  child: IconLabelBtn(
                      text: Text(
                        "Create Account",
                        style: TextStyle(
                            color: Colors.grey.shade900, fontSize: 16),
                      ),
                      onPressed: () {
                        AccountService.createAccount().then(
                          (_) => Navigator.popAndPushNamed(
                              context, HomePage.route),
                        );
                      },
                      color: Colors.blue.shade100,
                      icon: Icon(
                        Icons.add_rounded,
                        color: Colors.grey.shade900,
                      )),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 6.0),
              child: ImportAccountBtn(),
            ),
          ],
        ),
      )),
    );
  }
}

class ImportAccountBtn extends StatelessWidget {
  const ImportAccountBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * .8,
      height: MediaQuery.sizeOf(context).height * .05,
      child: OutlinedButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue.shade100),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        ),
        onPressed: null,
        icon: Icon(
          Icons.download_rounded,
          color: Colors.grey.shade900,
        ),
        label: Text(
          "Import Account",
          style: TextStyle(color: Colors.grey.shade900, fontSize: 16),
        ),
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Icon(
            Icons.wallet_rounded,
            color: Colors.blue,
            size: 50,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            "बटुआ",
            style: TextStyle(
                color: Colors.blue, fontSize: 40, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
