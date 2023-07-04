import 'dart:developer';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';



double hexPriceToDouble(String hexPrice) {
  int intValue = int.parse(hexPrice, radix: 16);
  debugPrint((intValue / pow(10, 6)).toString());

  return intValue / pow(10, 18);
}

double calculateTokenAmountFromHex(String hexAmount, int decimal) {
  BigInt intValue = BigInt.parse(hexAmount, radix: 16);

  return intValue / BigInt.from(pow(10, decimal));
}

double calculateTokenAmount(String amount, int decimal) {
  return BigInt.parse(amount) / BigInt.from(pow(10, decimal));
}

enum Network { ethereumMainnet, sepoliaTestnet }

enum TransactionType { native, erc20, all }

Map symbols = {
  Network.ethereumMainnet: "ETH",
  Network.sepoliaTestnet: "SepoliaETH"
};
