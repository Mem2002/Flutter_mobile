import 'dart:convert';

import 'package:flutter_app/apis/proposes/dtos/get_proposes_dto.dart';
import 'package:flutter_app/apis/response_base.dart';
import 'package:flutter_app/models/form_model.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import '../http_base.dart';

@injectable
class ProposeApi {
  IHttpBase http;
  ProposeApi(this.http);
  Future<ProposeDataResponse?> getProposes(
      {DateTime? from, DateTime? to, int page = 1}) async {
    try {
      final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      var res = await http.get('/v1/api/users',
          queryParameters: {
            "page": page.toString(),
            "date_range[]": from != null && to != null
                ? [dateFormat.format(from), dateFormat.format(to)]
                : null
          },
          auth: true);
      var body = getProposesFromJson(res.body);
      return body.data;
    } catch (e) {
      return null;
    }
  }

  Future<ProposeDataResponse?> getPropose(int id) async {
    try {
      var res = await http.get('/employee/propose/$id', auth: true);
      var body = getProposesFromJson(res.body);
      return body.data;
    } catch (e) {
      return null;
    }
  }

  Future<ResponseEmpty?> createPropose() async {
    try {
      var res = await http.post('/employee/propose', {}, auth: true);
      var body = ResponseEmpty.fromJson(jsonDecode(res.body));
      return body;
    } catch (e) {
      return null;
    }
  }

  Future<ResponseEmpty?> createOnLeavePropose(
      DateTime startDate,
      DateTime endDate,
      String reason,
      double generalLeave,
      int startShiftOff,
      String? phone,
      int? typeLeave,
      DateTime timeCheckin,
      DateTime timeCheckout) async {
    try {
      var request = {
        "category": 0,
        "phone": phone,
        "reason": reason,
        "start_date": DateFormat("yyyy-MM-dd").format(startDate),
        "end_date": DateFormat("yyyy-MM-dd").format(endDate),
        "start_shift_off": startShiftOff,
        "general_leave": generalLeave,
        "type_leave": typeLeave
      };
      var res = await http.post('/employee/propose', request, auth: true);
      var body = ResponseEmpty.fromJson(jsonDecode(res.body));
      return body;
    } catch (e) {
      return null;
    }
  }

  Future<ResponseEmpty?> createChangeShiftPropose(
      DateTime startDate, String reason, WorkingHour current) async {
    try {
      var res = await http.post(
          '/employee/propose',
          {
            "category": 2,
            "reason": reason,
            "start_date": DateFormat("yyyy-MM-dd").format(startDate),
            "current_working_change": current.index + 1,
            "current_working_hours": WorkingHour.values
                    .firstWhere((element) => element != current)
                    .index +
                1,
          },
          auth: true);
      var body = ResponseEmpty.fromJson(jsonDecode(res.body));
      return body;
    } catch (e) {
      return null;
    }
  }

  Future<ResponseEmpty?> createOverTimePropose(
    DateTime date,
    String checkIn,
    String checkOut,
    String reason,
    String result,
  ) async {
    try {
      var res = await http.post(
          '/employee/propose',
          {
            "category": 1,
            "start_date": DateFormat("yyyy-MM-dd").format(date),
            "time_checkin": checkIn.toString(),
            "time_checkout": checkOut.toString(),
            "reason": reason,
            "overtime_results": result
          },
          auth: true);
      var body = ResponseEmpty.fromJson(jsonDecode(res.body));
      return body;
    } catch (e) {
      return null;
    }
  }

  Future<ResponseEmpty?> createAddTimePropose(
      DateTime date, String checkIn, String checkOut, String reason) async {
    try {
      var res = await http.post(
          '/employee/propose',
          {
            "category": 3,
            "start_date": DateFormat("yyyy-MM-dd").format(date),
            "reason": reason,
            "time_checkin": checkIn.toString(),
            "time_checkout": checkOut.toString(),
          },
          auth: true);
      var body = ResponseEmpty.fromJson(jsonDecode(res.body));
      return body;
    } catch (e) {
      return null;
    }
  }

  Future<ResponseEmpty?> deletePropose(int id) async {
    try {
      var res = await http.delete('/employee/propose/$id', auth: true);
      var body = ResponseEmpty.fromJson(jsonDecode(res.body));
      return body;
    } catch (e) {
      return null;
    }
  }
}
