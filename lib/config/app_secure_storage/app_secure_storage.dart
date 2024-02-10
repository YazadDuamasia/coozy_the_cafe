import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  // Create storage
  final storage = FlutterSecureStorage(
      aOptions: AndroidOptions.defaultOptions.copyWith(
          encryptedSharedPreferences: true,
          storageCipherAlgorithm: StorageCipherAlgorithm.AES_CBC_PKCS7Padding,
          keyCipherAlgorithm:
              KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding),
      iOptions: IOSOptions.defaultOptions
          .copyWith(accessibility: KeychainAccessibility.first_unlock),
      webOptions: WebOptions.defaultOptions,
      wOptions: WindowsOptions.defaultOptions
          .copyWith(useBackwardCompatibility: true),
      lOptions: LinuxOptions.defaultOptions,
      mOptions: MacOsOptions.defaultOptions);

  final String _keyCommonFirstTime = 'CommonFirstTime';

  Future setUserName(bool commonFirstTime) async {
    await storage.write(
        key: _keyCommonFirstTime, value: commonFirstTime.toString());
  }

  Future<bool?> getUserName() async {
    String? result = await storage.read(key: _keyCommonFirstTime);
    return result?.toLowerCase() == "true" ? true : false;
  }
}
