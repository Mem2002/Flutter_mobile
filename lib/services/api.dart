import 'dart:convert';
import 'package:flutter_app/models/payslipModel.dart'; // Đổi tên file model cho phù hợp
import 'package:flutter_app/utils/constants.dart';
import 'package:http/http.dart' as http;

class Api {

  static Future<List<Payslip>> getPayslip() async {
  final response = await http.get(Uri.parse('${Constants.baseUrl}createPayslip'));

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    List<Payslip> payslips = body.map((item) => Payslip.fromJson(item)).toList();
    return payslips;
  } else {
    throw Exception('Failed to load payslips');
  }
}

//  static Future<List<Product>> getProduct() async {
//   List<Product> products = [];
//   var url = Uri.parse("${Constants.baseUrl}get_product");

//   try {
//     final res = await http.get(url);

//     // Log status code của phản hồi
//     print('Status code: ${res.statusCode}');

//     // Log nội dung của phản hồi
//     print('Response body: ${res.body}');

//     if (res.statusCode == 200) {
//       var data = jsonDecode(res.body);

//       // Log dữ liệu được decode
//       print('Decoded data: $data');

//       if (data is List) { // Kiểm tra nếu data là danh sách
//         products = data.map<Product>((value) {
//           // Log từng sản phẩm trong danh sách trước khi chuyển đổi
//           print('Processing product: $value');

//           return Product(
//             id: value['_id']?.toString() ?? '', // Đảm bảo giá trị không phải null
//             name: value['pname'] ?? '',
//             desc: value['pdesc'] ?? '',
//             price: value['pprice'] ?? '',
//             pimagePath: value['pimagePath'] ?? '',
//           );
//         }).toList();
//       } else {
//         print("Unexpected data format: $data");
//       }
//     } else {
//       print("Failed to load products. Status code: ${res.statusCode}");
//     }
//   } catch (e) {
//     print("Error occurred: ${e.toString()}");
//   }
//   return products;
// }
}
