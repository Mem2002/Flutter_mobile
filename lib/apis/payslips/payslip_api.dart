import 'package:flutter_app/apis/payslips/dtos/payslip_response.dart';
import 'package:injectable/injectable.dart';
import '../http_base.dart';

@Injectable()
class PayslipApi {
  IHttpBase http;
  PayslipApi(this.http);
  Future<PayslipResponse?> getPayslip(int month, int year) async {
    try {
      var res = await http.get('/v1/api/users',
          queryParameters: {"month": month.toString(), "year": year.toString()},
          auth: true);
      var body = payslipResponseFromJson(res.body);

      return body;
    } catch (e) {
      return null;
    }
  }
}
