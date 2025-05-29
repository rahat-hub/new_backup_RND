import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';

class StoragePrefs {
  //Get Storage
  final GetStorage _gs = GetStorage();

  Future<void> lsWrite({required String key, dynamic value}) => _gs.write(key, value);

  T? lsRead<T>({required String key}) => _gs.read(key);

  Future<void> lsDelete({required String key}) => _gs.remove(key);

  bool lsHasData({required String key}) => _gs.hasData(key);

  ///--------------------------------------------------------------------------------

  //Flutter Secure Storage
  final FlutterSecureStorage _fss = const FlutterSecureStorage();

  Future<void> ssWrite({required String key, required String? value}) => _fss.write(key: key, value: value);

  Future<String?> ssRead({required String key}) => _fss.read(key: key);

  Future<void> ssDelete({required String key}) => _fss.delete(key: key);

  Future<void> ssDeleteAll() => _fss.deleteAll();

  Future<bool> ssHasData({required String key}) => _fss.containsKey(key: key);
}
