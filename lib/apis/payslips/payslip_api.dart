import 'package:flutter_app/apis/payslips/dtos/payslip_response.dart';
import 'package:injectable/injectable.dart';
import '../http_base.dart';

@Injectable()
class PayslipApi {
  IHttpBase http;
  PayslipApi(this.http);
  Future<PayslipResponse?> getPayslip(int month, int year) async {
    try {
      var res = await http.get('/employee/payslip/by-month',
          queryParameters: {"month": month.toString(), "year": year.toString()},
          auth: true);
      // In dữ liệu thô từ HTTP response
      print('Raw response body: ${res.body}');

      // Parse dữ liệu từ JSON
      var body = payslipResponseFromJson(res.body);

      // In dữ liệu sau khi đã parse
      print('Parsed response body: $body');

      return body;
    } catch (e) {
      return null;
    }
  }
}
