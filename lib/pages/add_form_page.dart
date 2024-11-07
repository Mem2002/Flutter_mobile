// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter_app/models/form_model.dart';
// import 'package:flutter_app/services/form_service.dart';
// import 'package:flutter_app/styles/text_styles.dart';
// import 'package:flutter_app/utils/statusbar_utils.dart';
// import 'package:flutter_app/widgets/add_attendance_form.dart';
// import 'package:flutter_app/widgets/change_working_hour_form.dart';
// import 'package:flutter_app/widgets/container_border.dart';
// import 'package:flutter_app/widgets/on_leave_form.dart';
// import 'package:flutter_app/widgets/overtime_form.dart';
// import 'package:flutter_app/widgets/theme_base_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:get_it/get_it.dart';
// import 'package:quickalert/models/quickalert_type.dart';
// import 'package:quickalert/widgets/quickalert_dialog.dart';

// import '../extensions/form_type_extensions.dart';

// class AddFormPage extends StatefulWidget {
//   const AddFormPage({super.key});

//   @override
//   State<StatefulWidget> createState() => AddFormState();
// }

// class AddFormState extends State<AddFormPage> {
//   final IFormService service = GetIt.instance.get<IFormService>();
//   FormType? type = FormType.onLeave;
//   @override
//   Widget build(BuildContext context) {
//     return ThemeBasePage(
//       child: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             centerTitle: false,
//             systemOverlayStyle: StatusBarUtils.statusConfig(),
//             backgroundColor: Colors.transparent,
//             shadowColor: Colors.transparent,
//             collapsedHeight: 56,
//             toolbarHeight: 56,
//             expandedHeight: 56,
//             foregroundColor: Theme.of(context).colorScheme.primary,
//             pinned: true,
//             title: Text(type?.getTitle(context) ?? "",
//                 style: BoldTextStyle(
//                     color: Theme.of(context).colorScheme.primary)),
//           ),
//           SliverToBoxAdapter(
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(left: 24, right: 24, top: 16),
//                     child: Text(AppLocalizations.of(context)!.form_type),
//                   ),
//                   ContainerBorder(
//                     margin: const EdgeInsets.only(
//                         left: 24, right: 24, top: 12, bottom: 12),
//                     child: DropdownButton<FormType>(
//                       padding: const EdgeInsets.only(left: 16, right: 16),
//                       value: type,
//                       icon: Expanded(
//                         child: Container(
//                           alignment: Alignment.centerRight,
//                           child: const Icon(Icons.arrow_drop_down),
//                         ),
//                       ),
//                       elevation: 4,
//                       style: const SmallNormalTextStyle(),
//                       underline: Container(
//                         height: 0,
//                         color: Theme.of(context).colorScheme.primary,
//                       ),
//                       onChanged: (FormType? value) {
//                         setState(() {
//                           type = value;
//                         });
//                       },
//                       items: [
//                         FormType.onLeave,
//                         FormType.addAttendance,
//                         FormType.ot,
//                         FormType.changeShift
//                       ].map<DropdownMenuItem<FormType>>((FormType value) {
//                         return DropdownMenuItem<FormType>(
//                           value: value,
//                           child: Text(value.getTitle(context)),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ]),
//           ),
//           SliverToBoxAdapter(
//             child: getFormByType(type ?? FormType.onLeave, onSubmit),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget getFormByType(FormType formType, onSubmit) {
//     switch (formType) {
//       case FormType.onLeave:
//         return OnLeaveFormView(onSubmit: onSubmit);
//       case FormType.ot:
//         return OverTimeFormView(onSubmit: onSubmit);
//       case FormType.addAttendance:
//         return AddAttendanceFormView(onSubmit: onSubmit);
//       case FormType.changeShift:
//         return ChangeWorkingHourFormView(onSubmit: onSubmit);
//     }
//   }

//   onSubmit(FormModel form) async {
//     EasyLoading.show();
//     var res = await service.createProposeAsync(form);
//     EasyLoading.dismiss();
//     if (res == null || res.error == true) {
//       QuickAlert.show(
//         context: context,
//         type: QuickAlertType.error,
//         title: 'Oops...',
//         text: res?.message ?? "Có lỗi xảy ra",
//       );
//       return;
//     }

//     EasyLoading.showSuccess("Thêm thành công");
//     Navigator.of(context).pop(true);
//   }
// }
