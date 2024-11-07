import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/controllers/payment_controller.dart';
import 'package:flutter_app/styles/text_styles.dart';
import 'package:flutter_app/styles/themes.dart';
import 'package:flutter_app/utils/statusbar_utils.dart';
import 'package:intl/intl.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/payslip_model.dart';
import '../widgets/item_setting.dart';
import 'package:provider/provider.dart'; // Nếu bạn dùng Provider

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late PaymentController paymentController; // Thêm PaymentController
  DateTime currentTime = DateTime.now();
  ScrollController scrollController = ScrollController();
  double opacity = 0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollChange);
    // _initializeDate();
    _loadIncome(); // Gọi phương thức lấy thu nhập
  }

  Future<void> _loadIncome() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken != null) {
      await paymentController.getIncome(accessToken, currentTime.month, currentTime.year);
    }
  }

  // void _initializeDate() {
  //   var now = DateTime.now();
  //   var month = now.month - 0;
  //   var year = now.year;
  //   if (now.day < 10) {
  //     month -= 1;
  //   }
  //   if (month <= 0) {
  //     month += 12;
  //     year -= 1;
  //   }
  //   currentTime = DateTime(year, month, 1);
  // }

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
    paymentController = Provider.of<PaymentController>(context); // Lấy PaymentController từ Provider

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
              onRefresh: _loadIncome,
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  _buildSliverAppBar(context),
                  SliverToBoxAdapter(
                    child: ValueListenableBuilder<int?>(
                      valueListenable: paymentController.income,
                      builder: (context, income, _) {
                        if (income == null) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return _buildIncomeDisplay(income);
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

  Widget _buildIncomeDisplay(int income) {
    return Center(
      child: Text(
        "Thu nhập: ${_formatMoney(income.toDouble())}",
        style: TextStyle(fontSize: 24),
      ),
    );
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
        _loadIncome(); // Tải lại thu nhập với tháng mới
      });
    }
  }
}
