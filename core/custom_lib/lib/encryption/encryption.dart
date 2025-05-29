import 'dart:convert';
import 'dart:typed_data';

import 'package:aviation_rnd/shared/constants/constant_storages.dart';
import 'package:aviation_rnd/shared/services/storage_prefs.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class Encryption {
  /// Private Constructor
  Encryption._();

  static final StoragePrefs _dataStore = StoragePrefs();

  static late Encrypter _ei;
  static late IV _iv;

  /// Initialize the Encryption Method with User Provided [encryptionKey]
  /// Or Generate a New Random Encryption Key
  static Future<void> _initializeEncryption({String? encryptionKey}) async {
    if (!(await _dataStore.ssHasData(key: StorageConstants.encryption) && await _dataStore.ssHasData(key: StorageConstants.iv))) {
      final String key = encryptionKey ?? Key.fromSecureRandom(32).base64;
      final String iv = IV.fromLength(16).base64;

      await _dataStore.ssWrite(key: StorageConstants.encryption, value: key);
      await _dataStore.ssWrite(key: StorageConstants.iv, value: iv);
    }

    final EncryptionInitializer encryption = _encryptionInitialization(
      key: await _dataStore.ssRead(key: StorageConstants.encryption) ?? "",
      randomIV: await _dataStore.ssRead(key: StorageConstants.iv) ?? "",
    );

    _ei = encryption.encryption;
    _iv = encryption.iv;
  }

  /// Encrypt the [value] with user provided [key]
  /// and return encrypted value in base64 format
  static Future<String> encrypt({required String value, String? key}) async {
    await _initializeEncryption(encryptionKey: key);

    final Encrypter encryption = _ei;
    final IV iv = _iv;

    return encryption.encrypt(value, iv: iv).base64;
  }

  /// Decrypt the [encryptedValue] with user provided [key]
  /// and return decrypted value in string format
  static Future<String> decrypt({required String encryptedValue, String? key}) async {
    await _initializeEncryption(encryptionKey: key);

    final Encrypter encryption = _ei;
    final IV iv = _iv;

    return encryption.decrypt64(encryptedValue, iv: iv);
  }

  /// Encryption Method Initializer
  static EncryptionInitializer _encryptionInitialization({required String key, required String randomIV}) {
    // hashing key
    final Uint8List bytes = utf8.encode(key);
    final Digest digest = sha256.convert(bytes);
    final Digest fDigest = md5.convert(digest.bytes);
    final Key hashKey = Key.fromUtf8(fDigest.toString());

    // encryption
    final Encrypter encryption = Encrypter(AES(hashKey, mode: AESMode.cfb64));

    // Initial vector
    final IV iv = IV.fromBase64(randomIV);

    return EncryptionInitializer(encryption: encryption, iv: iv);
  }
}

/// Custom Type for Encryptor Method Initializer
class EncryptionInitializer {
  EncryptionInitializer({required this.encryption, required this.iv});

  final Encrypter encryption;
  final IV iv;
}
