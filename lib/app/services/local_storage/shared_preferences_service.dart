import 'local_storage_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'adapters/shared_params.dart';

class SharedPreferencesService implements ILocalStorage {
  @override
  Future<dynamic> getData(String key) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final result = sharedPreferences.get(key);

    if (result != null) {
      return result;
    }

    throw SharedPreferencesException(
        'There is no key ($key) passed as a parameter');
  }

  @override
  Future<bool> setData({required SharedParams params}) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    switch (params.value.runtimeType) {
      case String:
        return await sharedPreferences.setString(params.key, params.value);
      case int:
        return await sharedPreferences.setInt(params.key, params.value);
      case bool:
        return await sharedPreferences.setBool(params.key, params.value);
      case double:
        return await sharedPreferences.setDouble(params.key, params.value);
      case List<String>:
        return await sharedPreferences.setStringList(params.key, params.value);
    }
    return true;
  }

  @override
  Future<bool> removeData(String key) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(key);
  }

  @override
  Future<bool> removeAll() async {
    final preferences = await SharedPreferences.getInstance();
    return await preferences.clear();
  }
}

class SharedPreferencesException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  SharedPreferencesException(
    this.message, {
    this.stackTrace,
  });
}
