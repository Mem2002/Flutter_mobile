import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'api_base.dart';
import 'header_provider.dart';

//// Định nghĩa interface IHttpBase
abstract class IHttpBase {
  Future<http.Response> get(String path,
      {Map<String, dynamic> queryParameters, bool auth = false});
  Future<http.Response> post(String path, dto,
      {bool formData = false, bool auth = false});
  Future<http.StreamedResponse> multipart(
      String path, List<http.MultipartFile> files, fields,
      {bool auth = false});
  Future<http.Response> put(String path, dto,
      {bool formData = false, bool auth = false});
  Future<http.Response> delete(String path,
      {Map<String, dynamic> queryParameters, bool auth = false});
  // -> // Các phương thức hoặc thuộc tính của IHttpBase
}

//  Khi bạn sử dụng decorator @Injectable, bạn cần chỉ định kiểu của đối tượng bạn muốn inject vào, thông qua thuộc tính as.
//Đánh dấu lớp hiện tại là một đối tượng có thể được inject và được inject như là một đối tượng của kiểu IHttpBase
//->  Điều này có nghĩa là khi bạn yêu cầu một đối tượng có kiểu IHttpBase từ GetIt hoặc một hệ thống dependency injection khác, GetIt sẽ cung cấp một đối tượng của lớp được đánh dấu bằng @Injectable(as: IHttpBase).
@Injectable(as: IHttpBase)
class HttpBase implements IHttpBase {
  IConfigBase url;
  HeaderProvider headerProvider;
  HttpBase(this.url, this.headerProvider);
  @override
  Future<http.Response> get(String path,
      {Map<String, dynamic>? queryParameters, bool auth = false}) async {
    var headers = await getHeaders(auth);
    var res = await http.get(Uri.https(url.serverApi, path, queryParameters),
        headers: headers);
    if (res.statusCode == 401) {
      throw Exception();
    }
    return res;
  }

  @override
  Future<http.Response> post(String path, dynamic dto,
      {bool formData = false, bool auth = false}) async {
    var headers = await getHeaders(auth, formData: formData);

    var res = await http.post(Uri.https(url.serverApi, path),
        headers: headers,
        encoding: Encoding.getByName("utf-8"),
        body: formData ? dto : jsonEncode(dto));
    if (res.statusCode == 401) {
      throw Exception();
    }
    return res;
  }

  @override
  Future<http.Response> put(String path, dynamic dto,
      {bool formData = false, bool auth = false}) async {
    var headers = await getHeaders(auth, formData: formData);
    var res = await http.put(Uri.https(url.serverApi, path),
        headers: headers,
        encoding: Encoding.getByName("utf-8"),
        body: formData ? dto : jsonEncode(dto));
    if (res.statusCode == 401) {
      throw Exception();
    }
    return res;
  }

  @override
  Future<http.Response> delete(String path,
      {Map<String, dynamic>? queryParameters, bool auth = false}) async {
    var headers = await getHeaders(auth);
    var res = await http.delete(Uri.https(url.serverApi, path, queryParameters),
        headers: headers);
    if (res.statusCode == 401) {
      throw Exception();
    }
    return res;
  }

  Future<Map<String, String>> getHeaders(bool auth,
      {bool formData = false}) async {
    if (auth) {
      var header = await headerProvider.getAuthorization();
      String token = header?.token ?? "";
      if (token.isEmpty) {
        throw Exception("not auth");
      }
      return <String, String>{
        'Content-Type': formData
            ? "application/x-www-form-urlencoded; charset=UTF-8" /////?
            : "application/json; charset=UTF-8",
        'Authorization': 'Bearer $token',
        'Cookie': 'auth_tokenparents=$token'
      };
    }
    return <String, String>{
      'Content-Type': formData
          ? "application/x-www-form-urlencoded; charset=UTF-8"
          : 'application/json; charset=UTF-8'
    };
  }

  @override
  Future<http.StreamedResponse> multipart(
      String path, List<http.MultipartFile> files, fields,
      {bool auth = false}) async {
    var headers = await getHeaders(auth, formData: true);
    var request = http.MultipartRequest("POST", Uri.https(url.serverApi, path));
    if (files.isNotEmpty) {
      for (var e in files) {
        request.files.add(e);
      }
    }
    request.fields.addAll(fields);
    request.headers.addAll(headers);
    var res = await request.send();
    if (res.statusCode == 401) {
      throw Exception();
    }
    return res;
  }
}
