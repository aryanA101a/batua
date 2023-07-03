import 'dart:developer';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class AccountService {
  static Future<String> getAddress() async {
    String? privateKey = await retrievePrivateKey();
    return bytesToHex(
      publicKeyToAddress(
        privateKeyBytesToPublic(
          hexToBytes(
            privateKey!,
          ),
        ),
      ),
    );
  }

  static Future<void> createAccount() async {
    var rng = math.Random.secure();
    EthPrivateKey ethPrivateKey = EthPrivateKey.createRandom(rng);
    Uint8List privateKey = ethPrivateKey.privateKey;
    await _setPrivateKey(privateKey);
  }

  static Future<void> _setPrivateKey(privateKey) async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    await storage.write(key: "privateKey", value: bytesToHex(privateKey));
  }

  static Future<void> saveAddress(String myAddress, String address) async {
    var box = await Hive.openBox('savedAddresses');

    box.put(myAddress, [address, ...box.get(myAddress)]);
    box.close();
  }

  static Future<List<String>> retrieveSavedAddresses(String address) async {
    var box = await Hive.openBox('savedAddresses');

    if (!box.containsKey(address)) {
      box.put(address, []);
      box.close();

      return [];
    }

    List savedAddresses = await box.get(address);
    box.close();
    return savedAddresses.cast<String>();
  }

  static Future<String?> retrievePrivateKey() async {
    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
    String? privateKey = await storage.read(key: "privateKey");
    return privateKey;
  }

  static Future<void> deletePrivateKey() async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    await storage.delete(key: "privateKey");
  }
}
