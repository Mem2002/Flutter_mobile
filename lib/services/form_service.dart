import 'package:flutter_app/apis/proposes/propose_api.dart';
import 'package:flutter_app/apis/response_base.dart';
import 'package:flutter_app/models/form_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/services/api.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../extensions/enum_extensions.dart';

abstract class IFormService {
  Future<List<FormModel>> getProposesAsync(
      {DateTime? from, DateTime? to, int page = 1});
  Future<ResponseEmpty?> createProposeAsync(FormModel form);
  //Phản hồi này có thể ở dạng JSON, chứa các thông tin như tình trạng thành công hay thất bại, cùng với các thông điệp liên quan.
  //phản hồi này sẽ được chuyển đổi thành một đối tượng ResponseEmpty (hoặc một đối tượng khác tương ứng) thông qua phương thức fromJson.
  Future<ResponseEmpty?> deleteProposeAsync(int id);
}

@Injectable(as: IFormService)
class FormService extends IFormService { 
  Api api;
  FormService(this.api);
  @override
  Future<List<FormModel>> getProposesAsync(
      {DateTime? from, DateTime? to, int page = 1}) async {
    var res = await Api.getProposes(from: from, to: to, page: page);
    if (res == null) {
      return [];
    }

    return res.data
        .map(
          (e) => FormModel(
              id: e.id,
              type: e.category.toFormType(),
              startTime: e.startDate ?? DateTime.now(),
              reason: e.reason ?? '',
              createdTime: e.createdAt,
              days: e.generalLeave,
              phone: e.phone,
              endTime: e.endDate,
              shiftOff: e.startShiftOff?.toShiftOff(),
              status: e.status.toStatus(),
              workingHour: e.currentWorkingHours?.toWorkingHour(),
              workingHourChanged: e.currentWorkingChange?.toWorkingHour(),
              rejectReason: e.reasonForRefusal,
              overtimeResults: e.overtimeResults,
              typeLeave: e.typeLeave,
              timeCheckin: e.timeCheckin ?? DateTime.now(),
              timeCheckout: e.timeCheckout ?? DateTime.now()),
        )
        .toList();
  }

  @override
  Future<ResponseEmpty?> createProposeAsync(FormModel form) async {
    switch (form.type) {
      case FormType.onLeave:
        var endTime =
            form.startTime.add(Duration(days: (form.days ?? 0.5).ceil()));
        return Api.createOnLeavePropose(
            form.startTime,
            endTime,
            form.reason,
            form.days ?? 0.5,
            (form.shiftOff?.index ?? 0) + 1,
            form.phone ?? "",
            form.typeLeave,
            form.timeCheckin,
            form.timeCheckout);
      case FormType.ot:
        return Api.createOverTimePropose(
            form.startTime,
            DateFormat("HH:mm:ss").format(form.startTime),
            DateFormat("HH:mm:ss").format(form.endTime ?? DateTime.now()),
            form.reason,
            form.overtimeResults ?? "");
      case FormType.addAttendance:
        return Api.createAddTimePropose(
            form.startTime,
            DateFormat("HH:mm:ss").format(form.startTime),
            DateFormat("HH:mm:ss").format(form.endTime ?? DateTime.now()),
            form.reason);
      case FormType.changeShift:
      default:
        return Api.createChangeShiftPropose(form.startTime, form.reason,
            form.workingHour ?? WorkingHour.morningAfternoon);
    }
  }

  @override
  Future<ResponseEmpty?> deleteProposeAsync(int id) async {
    var res = await Api.deletePropose(id);
    return res;
  }
}
