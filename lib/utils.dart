import 'dart:developer';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

Future<bool> isLogged() async {
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

  return storage.containsKey(key: "privateKey");
}

double hexPriceToDouble(String hexPrice) {
  int intValue = int.parse(hexPrice, radix: 16);
  debugPrint((intValue / pow(10, 6)).toString());

  return intValue / pow(10, 18);
}
 double hexAmountToDouble(String hexAmount, int decimal) {
    BigInt intValue = BigInt.parse(hexAmount, radix: 16);

    return intValue / BigInt.from(pow(10, decimal));
  }
enum Network { etheriumMainnet, sepoliaTestnet }

Map symbols = {
  Network.etheriumMainnet: "ETH",
  Network.sepoliaTestnet: "SepoliaETH"
};
