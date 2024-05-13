import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef InvokeAsync<T> = Future<T> Function();

abstract class ICacheService {
  Future<void> setAsync(String key, obj);
  Future<Map<String, dynamic>?> getAsync(String key);
  Future<Map<String, dynamic>?> getOrAddAsync<T>(
      String key, InvokeAsync<T> fun);
}

@Injectable(as: ICacheService)
class CacheService implements ICacheService {
  SharedPreferences? preferences;
  Future ensuredInit() async {
    preferences ??= await SharedPreferences.getInstance();
  }

  @override
  Future<Map<String, dynamic>?> getAsync(String key) async {
    await ensuredInit();
    var str = preferences!.getString(key);
    if (str?.isNotEmpty == true) {
      return jsonDecode(str!);
    }
    return null;
  }

  @override
  Future<void> setAsync(String key, obj) async {
    await ensuredInit();
    if (obj == null) {
      preferences!.remove(key);
      return;
    }
    preferences!.setString(key, jsonEncode(obj));
  }

  @override
  Future<Map<String, dynamic>?> getOrAddAsync<T>(
      String key, InvokeAsync<T> fun) async {
    var obj = await getAsync(key);
    if (obj != null) {
      return obj;
    }
    var value = await fun.call();
    await setAsync(key, value);
    return await getAsync(key);
  }
}
