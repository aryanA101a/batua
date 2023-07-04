import 'dart:developer';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:batua/services/account_service.dart';
import 'package:batua/ui_helper/onboarding_page_ui_helper.dart';
import 'package:batua/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

import 'homePage.dart';

class OnboardingPage extends StatelessWidget {
  static const route = "/onboardingPage";

  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 4,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppLogo(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconLabelBtn(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 64),
                          text: Text(
                            "Create Account",
                            style: TextStyle(
                                color: Colors.grey.shade900, fontSize: 16),
                          ),
                          onPressed: () {
                            context
                                .read<OnboardingPageUiHelper>()
                                .createAccount()
                                .then(
                                  (_) => Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      HomePage.route,
                                      (route) => false),
                                );
                          },
                          color: Colors.blue.shade100,
                          icon: context.select<OnboardingPageUiHelper, bool>(
                            (value) => value.createAccountLoading,
                          )
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(),
                                )
                              : Icon(
                                  Icons.add_rounded,
                                  color: Colors.grey.shade900,
                                )),
                    ],
                  ),
                  ImportAccountBtn(),
                ],
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.fromLTRB(0, 16, 0, 32),
              width: MediaQuery.sizeOf(context).width * .65,
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * .2),
              child: Accounts())
        ],
      ),
    );
  }
}

class Accounts extends StatelessWidget {
  const Accounts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final random = math.Random();
    List<String> accounts =
        context.select<OnboardingPageUiHelper, List<String>>(
            (value) => value.accounts);
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              AccountService.switchAccount(accounts[index])
                  .then((value) => Navigator.pushNamedAndRemoveUntil(
                        context,
                        HomePage.route,
                        (route) => false,
                      ));
            },
            // tileColor: Colors.amber,
            leading: CircleAvatar(
              backgroundColor:
                  Colors.primaries[random.nextInt(Colors.primaries.length)],
            ),
            title: Text(
              accounts[index],
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.delete_rounded,
              ),
              onPressed: () {
                context
                    .read<OnboardingPageUiHelper>()
                    .deleteAccount(accounts[index]);
              },
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }
}

class ImportAccountBtn extends StatelessWidget {
  const ImportAccountBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(vertical: 8, horizontal: 64)),
        backgroundColor: MaterialStateProperty.all(Colors.blue.shade100),
        elevation: MaterialStateProperty.all(0),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0.0,
                  child: ImportAccountDialog(),
                ));
      },
      icon: Icon(
        Icons.download_rounded,
        color: Colors.grey.shade900,
      ),
      label: Text(
        "Import Account",
        style: TextStyle(color: Colors.grey.shade900, fontSize: 16),
      ),
    );
  }
}

class ImportAccountDialog extends StatelessWidget {
  const ImportAccountDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Enter Private Key",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 24, 0, 16),
            child: TextFormField(
              controller:
                  context.read<OnboardingPageUiHelper>().textEditingController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.security_rounded),
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Private Key',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 2),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(6)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.red.shade100),
                        elevation: MaterialStateProperty.all(0),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)))),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 2),
                  child: MaterialButton(
                    padding: EdgeInsets.all(6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    color: Colors.blue,
                    onPressed: () {
                      context
                          .read<OnboardingPageUiHelper>()
                          .importAccount()
                          .then((value) {
                        if (value) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              HomePage.route, (route) => false);
                        }
                      });
                    },
                    child: context.select<OnboardingPageUiHelper, bool>(
                      (value) => value.importAccountLoading,
                    )
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.blue.shade100,
                            ),
                          )
                        : Text(
                            "Import",
                            style: TextStyle(
                                color: Colors.blue.shade100,
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                          ),
                  ),
                ),
              )
            ],
          )
        ],
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
