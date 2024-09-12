import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../services/application_service.dart';

@injectable
class PaymentController {
  IApplicationService service;

  PaymentController(this.service);

  ValueNotifier<Map<String, dynamic>?> data =
      ValueNotifier<Map<String, dynamic>?>(null);

  Future getPayslip(int month, int year) async {
    var res = await service.getPayslip(month, year);
    if (res == null) {
      return;
    }

    if (res.data == null) {
      data.value = {};
    } else {
      data.value = res.data;
    }
  }

  List<PayslipKey> keys = [
    PayslipKey(key: "Thông tin chung", type: PayslipType.title),
    PayslipKey(key: "muc_luong", type: PayslipType.money),
    PayslipKey(key: "cong_thang", type: PayslipType.number, note: "ngay phep"),
    PayslipKey(key: "phep_nam", type: PayslipType.number, note: "ngay phep"),
    PayslipKey(
        key: "ngay_le_tet_viec_rieng",
        type: PayslipType.number,
        note: "ngay_le_tet_viec_rieng"),
    PayslipKey(
        key: "tong_cong_thang",
        type: PayslipType.number,
        note: "tong_cong_thang"),
    PayslipKey(
        key: "cong_dinh_muc", type: PayslipType.number, note: "cong_dinh_muc"),
    PayslipKey(
        key: "phan_tram_kpi_thoi_gian",
        type: PayslipType.percent,
        note: "kpi thoi gian"),
    PayslipKey(
        key: "phan_tram_kpi_hoan_thanh_cong_viec",
        type: PayslipType.percent,
        note: "kpi cong viec"),
    PayslipKey(key: "thu_viec", type: PayslipType.bool, note: "Thu viec"),
    PayslipKey(
        key: "so_exp_tich_luy",
        type: PayslipType.number,
        note: "so_exp_tich_luy"),
    PayslipKey(
        key: "so_ngay_phep_con_lai",
        type: PayslipType.number,
        note: "Ngay phep chua dung"),
    PayslipKey(
        key: "thuong_trai_phieu_tich_luy",
        type: PayslipType.money,
        note: "thuong_trai_phieu_tich_luy"),
    PayslipKey(
        key: "thoi_diem_trai_phieu_co_hieu_luc",
        type: PayslipType.date,
        note: "thoi_diem_trai_phieu_co_hieu_luc"),
    PayslipKey(key: "Các khoản thu nhập", type: PayslipType.title),
    PayslipKey(key: "thu_nhap_kra", type: PayslipType.money),
    PayslipKey(key: "tang_ca", type: PayslipType.money),
    PayslipKey(key: "phu_cap", type: PayslipType.money),
    PayslipKey(key: "thuong", type: PayslipType.money),
    PayslipKey(key: "thu_nhap_thieu_thang_truoc", type: PayslipType.money),
    PayslipKey(
        key: "tong_cac_khoan_thu_nhap",
        type: PayslipType.money,
        important: true),
    PayslipKey(key: "Các khoản trừ thu nhập", type: PayslipType.title),
    PayslipKey(key: "bhxh_thang", type: PayslipType.money),
    PayslipKey(key: "tam_ung", type: PayslipType.money),
    PayslipKey(key: "khong_du_cong", type: PayslipType.money),
    PayslipKey(key: "phat", type: PayslipType.money),
    PayslipKey(key: "tru_khac", type: PayslipType.money),
    PayslipKey(
        key: "tong_cac_khoan_tru_thu_nhap",
        type: PayslipType.money,
        important: true),
    PayslipKey(
        key: "luong_thuc_nhan", type: PayslipType.money, important: true),
  ];
}

class PayslipKey {
  bool important;
  String key;
  dynamic value;
  PayslipType type;
  String? note;

  PayslipKey(
      {required this.key,
      required this.type,
      this.value,
      this.note,
      this.important = false});
}

enum PayslipType { money, number, string, bool, title, percent, date }
