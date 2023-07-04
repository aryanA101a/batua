import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:batua/exceptions/app_exceptions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class AccountService {
  static String privateKeyToAddress(String privateKey) {
    String address;
    try {
      address = bytesToHex(
        publicKeyToAddress(
          privateKeyBytesToPublic(
            hexToBytes(
              privateKey,
            ),
          ),
        ),
      );
    } catch (e) {
      rethrow;
    }
    return address;
  }

  static Future<void> createAccount() async {
    var rng = math.Random.secure();
    EthPrivateKey ethPrivateKey = EthPrivateKey.createRandom(rng);
    String privateKey = bytesToHex(ethPrivateKey.privateKey);
    await _saveAccount(privateKey);
  }

  static Future<void> _saveAccount(String privateKey) async {
    try {
      AndroidOptions _getAndroidOptions() => const AndroidOptions(
            encryptedSharedPreferences: true,
          );
      final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
      String address = privateKeyToAddress(privateKey);
      String? accountsData = await storage.read(key: 'accounts');
      if (accountsData == null) {
        await storage.write(
            key: "accounts", value: json.encode({address: privateKey}));
        return;
      }
      Map accounts = json.decode(accountsData);
      accounts[address] = privateKey;
      Future.wait(
        [
          storage.write(key: "accounts", value: json.encode(accounts)),
          storage.write(key: "currentAccount", value: address),
        ],
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> saveAddress(String myAddress, String address) async {
    var box = await Hive.openBox('savedAddresses');
    List savedAddresses = box.get(myAddress);
    if (!savedAddresses.contains(address)) {
      box.put(myAddress, [address, ...savedAddresses]);
    }

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

  static Future<String?> retrievePrivateKey(String address) async {
    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
    String? accountsData = await storage.read(key: 'accounts');
    if (accountsData != null) {
      Map accounts = json.decode(accountsData);
      return accounts[address];
    }
    return null;
  }

  static Future<bool> isLogged() async {
    String? currentAccount = await retrieveCurrentAccount();
    log((currentAccount == null).toString());
    return currentAccount == null ? false : true;
  }

  static Future<String?> retrieveCurrentAccount() async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    return storage.read(key: "currentAccount");
  }

  static Future<List<String>> retrieveAccounts() async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    String? accountsData = await storage.read(key: 'accounts');
    if (accountsData == null) {
      return [];
    }

    Map accounts = json.decode(accountsData);

    return accounts.keys.toList() as List<String>;
  }

  static Future<AppException?> importAccount(String privateKey) async {
    try {
      await _saveAccount(privateKey);
    } catch (e) {
      log(e.toString());
      return AppException(AppEType.importAccount);
    }
    return null;
  }

  static Future<void> deleteAccount(String address) async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    String? accountsData = await storage.read(key: 'accounts');
    if (accountsData != null) {
      Map accounts = json.decode(accountsData);
      accounts.remove(address);
      await Future.wait([
        storage.write(key: "accounts", value: json.encode(accounts)),
        storage.write(key: "currentAccount", value: null)
      ]);
    }
  }

  static Future<void> switchAccount(String address) async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    await storage.write(key: "currentAccount", value: address);
  }
}
