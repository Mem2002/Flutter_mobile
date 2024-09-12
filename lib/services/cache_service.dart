import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef InvokeAsync<T> = Future<T> Function();

abstract class ICacheService {
  Future<void> setAsync(
      String key, obj); //setAsync lưu trữ dữ liệu một cách không đồng bộ
  // key: Một chuỗi ký tự (String) dùng để xác định đối tượng cần lưu trữ. Nó 
  //đóng vai trò là "khóa" (key) để truy cập đối tượng khi cần.
  // obj: Đối tượng cần được lưu trữ, có thể là bất kỳ loại dữ liệu nào (dynamic type).

  //=> Hàm setAsync(String key, obj) thực hiện thao tác lưu trữ dữ liệu không đồng bộ, trong đó key là
  // khóa để lưu dữ liệu và obj là đối tượng cần lưu
  Future<Map<String, dynamic>?> getAsync(String key);
  Future<Map<String, dynamic>?> getOrAddAsync<T>(
      String key, InvokeAsync<T> fun);
      //check id deviced
}

@Injectable(as: ICacheService)
class CacheService implements ICacheService {
  SharedPreferences? preferences;
  //shared_preferences là một thư viện Flutter phổ biến dùng để lưu trữ dữ liệu đơn
  // giản dưới dạng key-value (cặp khóa-giá trị) trên thiết bị.
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
