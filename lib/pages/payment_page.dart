import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/controllers/payment_controller.dart';
import 'package:flutter_app/styles/text_styles.dart';
import 'package:flutter_app/styles/themes.dart';
import 'package:flutter_app/utils/statusbar_utils.dart';
import 'package:intl/intl.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';
import '../models/payslip_model.dart';
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
    _loadPayslips();
  }

  Future<void> _loadPayslips() async {
    setState(() {
      _payslipsFuture = Api.getPayslipWithStoredToken();
    });
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

  String _formatMoney(double? amount) {
    if (amount == null || amount.isNaN || amount.isNegative) {
      return 'N/A';
    }
    return NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
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
              onRefresh: _loadPayslips,
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  _buildSliverAppBar(context),
                  SliverToBoxAdapter(
                    child: FutureBuilder<List<Payslip>>(
                      future: _payslipsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('Chưa có phiếu lương'));
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
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(opacity),
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
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Card(
            elevation: 2,
            child: Column(
              children: _buildPayslipDetails(payslip),
            ),
          ),
        );
      }).toList(),
    );
  }

  List<Widget> _buildPayslipDetails(Payslip payslip) {
    List<Widget> details = [];
    
    // Example of using your PayslipKey structure
    List<PayslipKey> keys = [
      PayslipKey(key: "Mức lương cơ bản", value: payslip.basicSalary, type: PayslipType.money),
      PayslipKey(key: "Thời gian làm việc thực tế", value: payslip.actualWork, type: PayslipType.money),
      PayslipKey(key: "KPI thời gian", value: payslip.timeKPI, type: PayslipType.money),
      PayslipKey(key: "KPI công việc", value: payslip.jobKPI, type: PayslipType.money),
      PayslipKey(key: "Thu nhập KRA", value: payslip.kraIncome, type: PayslipType.money),
      PayslipKey(key: "Làm thêm", value: payslip.overtime, type: PayslipType.money),
      PayslipKey(key: "Thưởng", value: payslip.bonus, type: PayslipType.money),
      PayslipKey(key: "Phạt khác", value: payslip.otherPenalties, type: PayslipType.money),
    ];

    for (var key in keys) {
      details.add(
        ItemSettingWidget(
          title: key.key,
          value: _formatMoney(_parseToDouble(key.value)),
          hasEdit: false,
        ),
      );
    }
    return details;
  }

  double? _parseToDouble(dynamic value) {
    if (value is double) return value;
    if (value is String) return double.tryParse(value);
    return null;
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
        _loadPayslips();
      });
    }
  }
}
