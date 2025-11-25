import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/models/payslip_model.dart';
import 'package:open_core_hr/screens/Payslip/payslip_store.dart';

import '../../Utils/app_constants.dart';
import '../../Utils/app_widgets.dart';
import '../../Widgets/button_widget.dart';
import '../../main.dart';

class PayslipDetailsScreen extends StatefulWidget {
  final PayslipModel payslip;
  const PayslipDetailsScreen({
    super.key,
    required this.payslip,
  });

  @override
  State<PayslipDetailsScreen> createState() => _PayslipDetailsScreenState();
}

class _PayslipDetailsScreenState extends State<PayslipDetailsScreen> {
  final _store = PayslipStore();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: appBar(
          context, '${widget.payslip.payrollPeriod} ${language.lblPayslip}'),
      body: Observer(
        builder: (_) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              16.height,
              _buildSummaryCards(),
              16.height,
              _buildBreakdownSection(
                title: language.lblEarnings,
                icon: Iconsax.wallet,
                details: widget.payslip.payrollAdjustments!
                    .where((e) => e.type == 'benefit')
                    .toList(),
                color: Colors.green,
              ),
              16.height,
              _buildBreakdownSection(
                title: language.lblDeductions,
                icon: Iconsax.receipt,
                details: widget.payslip.payrollAdjustments!
                    .where((e) => e.type == 'deduction')
                    .toList(),
                color: Colors.red,
              ),
              32.height,
              _store.isLoading
                  ? loadingWidgetMaker()
                  : button(
                      language.lblDownloadPayslip,
                      onTap: () => _store.downloadPayslip(widget.payslip.id!),
                    ).center(),
            ],
          ),
        ),
      ),
    );
  }

  /// Header Section: Month, Year, Net Pay
  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.payslip.payrollPeriod}',
              style: boldTextStyle(size: 20)),
          8.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(language.lblNetPay, style: primaryTextStyle(size: 14)),
              Text(
                '\$${widget.payslip.netSalary!.toStringAsFixed(2)}',
                style: boldTextStyle(size: 18, color: Colors.blueAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Summary Cards: Working Days, Leaves Taken, Total Deductions
  Widget _buildSummaryCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSummaryCard(
          title: language.lblWorkingDays,
          value: '${widget.payslip.totalWorkedDays}',
          icon: Iconsax.calendar,
          color: Colors.orange,
        ),
        _buildSummaryCard(
          title: language.lblLeaveTaken,
          value: '${widget.payslip.totalLeaveDays}',
          icon: Iconsax.profile_tick,
          color: Colors.redAccent,
        ),
        _buildSummaryCard(
          title: language.lblDeductions,
          value: '\$${widget.payslip.totalDeductions!.toStringAsFixed(2)}',
          icon: Iconsax.money,
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: cardDecoration(),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            8.height,
            Text(value, style: boldTextStyle(size: 16)),
            4.height,
            Text(title, style: secondaryTextStyle(size: 12)),
          ],
        ),
      ),
    );
  }

  /// Breakdown Section for Earnings and Deductions
  Widget _buildBreakdownSection({
    required String title,
    required IconData icon,
    required List<PayrollAdjustment?> details,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              8.width,
              Text(title, style: boldTextStyle(size: 16)),
            ],
          ),
          12.height,
          ...details.map((detail) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(detail!.name.toString(), style: primaryTextStyle()),
                  Text(
                    detail.amount != null
                        ? getStringAsync(appCurrencySymbolPref) +
                            detail.amount.toString()
                        : '${detail.percentage}%',
                    style: boldTextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
