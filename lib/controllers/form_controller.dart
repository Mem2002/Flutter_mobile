import 'package:flutter_app/apis/response_base.dart';
import 'package:flutter_app/models/form_model.dart';
import 'package:flutter_app/services/form_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class FormController {
  IFormService service;
  FormController(this.service);

  Future<List<FormModel>> getProposesAsync(
      {DateTime? from, DateTime? to, int page = 1}) {
    return service.getProposesAsync(page: page, from: from, to: to);
  }

  Future<ResponseEmpty?> deleteAsync(int id) => service.deleteProposeAsync(id);
}
