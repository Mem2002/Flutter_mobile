import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/styles/text_styles.dart';
import 'package:flutter_app/styles/themes.dart';
import 'package:flutter_app/utils/statusbar_utils.dart';
import 'package:intl/intl.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';
import '../models/payslipModel.dart';
import '../services/api.dart';
import '../widgets/item_setting.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Future<List<Payslip>> _payslipsFuture;
  DateTime currentTime = DateTime.now();
  ScrollController scrollController = ScrollController();
  double opacity = 0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollChange);
    _initializeDate();
    _payslipsFuture = Api.getPayslip(); // Load initial payslip data
  }

  void _initializeDate() {
    var now = DateTime.now();
    var month = now.month - 1;
    var year = now.year;
    if (now.day < 10) {
      month -= 1;
    }
    if (month <= 0) {
      month += 12;
      year -= 1;
    }
    currentTime = DateTime(year, month, 1);
  }

  void scrollChange() {
    setState(() {
      opacity = (scrollController.offset <= 0)
          ? 0
          : (scrollController.offset >= 56 ? 1 : scrollController.offset / 56);
    });
  }

  double? _parseToDouble(dynamic value) {
    if (value is double) return value;
    if (value is String) return double.tryParse(value);
    return null;
  }

  String _formatMoney(double? amount) {
    if (amount == null || amount.isNaN || amount.isNegative) {
      return 'N/A';
    }
    return NumberFormat.currency(
      customPattern: "#,##0.### đ",
      decimalDigits: 0,
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: MediaQuery.of(context).size.height / 2 + 24,
            child: Image.asset(
              Themes.currentBackground,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _reloadPayslips,
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  _buildSliverAppBar(context),
                  SliverToBoxAdapter(
                    child: FutureBuilder<List<Payslip>>(
                      future: _payslipsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('Chưa có phiếu lương'));
                        }
                        return _buildPayslipList(snapshot.data!);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      systemOverlayStyle: StatusBarUtils.statusConfigWithColor(
        Theme.of(context).colorScheme.primary.withOpacity(opacity),
      ),
      backgroundColor:
          Theme.of(context).colorScheme.primary.withOpacity(opacity),
      shadowColor: Colors.transparent,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      collapsedHeight: 56,
      toolbarHeight: 56,
      expandedHeight: 56,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        title: GestureDetector(
          onTap: selectMonth,
          child: Container(
            margin: EdgeInsets.zero,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat("MMMM yyyy").format(currentTime),
                  style: BoldTextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPayslipList(List<Payslip> payslipData) {
    return Column(
      children: payslipData.map((payslip) {
        return Column(
          children: [
            ItemSettingWidget(
              title: "Basic Salary",
              value: _formatMoney(_parseToDouble(payslip.basicSalary)),
              hasEdit: false,
            ),
            ItemSettingWidget(
              title: "Actual Work",
              value: _formatMoney(_parseToDouble(payslip.actualWork)),
              hasEdit: false,
            ),
            ItemSettingWidget(
              title: "Time KPI",
              value: _formatMoney(_parseToDouble(payslip.timeKPI)),
              hasEdit: false,
            ),
            ItemSettingWidget(
              title: "Job KPI",
              value: _formatMoney(_parseToDouble(payslip.jobKPI)),
              hasEdit: false,
            ),
            ItemSettingWidget(
              title: "KRA Income",
              value: _formatMoney(_parseToDouble(payslip.kraIncome)),
              hasEdit: false,
            ),
            ItemSettingWidget(
              title: "Over Time",
              value: _formatMoney(_parseToDouble(payslip.overtime)),
              hasEdit: false,
            ),
            ItemSettingWidget(
              title: "Bonus",
              value: _formatMoney(_parseToDouble(payslip.bonus)),
              hasEdit: false,
            ),
            ItemSettingWidget(
              title: "Other Penalties",
              value: _formatMoney(_parseToDouble(payslip.otherPenalties)),
              hasEdit: false,
            ),
          ],
        );
      }).toList(),
    );
  }

  Future<void> _reloadPayslips() async {
    setState(() {
      _payslipsFuture = Api.getPayslip();
    });
  }

  Future<void> selectMonth() async {
    final selectedDate = await showMonthPicker(
      context: context,
      initialDate: currentTime,
      firstDate: DateTime(1970),
      lastDate: DateTime(2050),
    );

    if (selectedDate != null) {
      setState(() {
        currentTime = selectedDate;
        _payslipsFuture = Api.getPayslip();
      });
    }
  }
}
