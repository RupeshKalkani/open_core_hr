import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/Utils/app_widgets.dart';
import 'package:open_core_hr/screens/Payslip/payslip_details_screen.dart';
import 'package:open_core_hr/screens/Payslip/payslip_store.dart';

import '../../main.dart';
import '../../models/payslip_model.dart';

class PayslipScreen extends StatefulWidget {
  const PayslipScreen({super.key});

  @override
  State<PayslipScreen> createState() => _PayslipScreenState();
}

class _PayslipScreenState extends State<PayslipScreen> {
  String selectedYear = DateTime.now().year.toString();
  String selectedMonth = 'All';
  final _store = PayslipStore();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    _store.getPayslips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: appBar(
        context,
        language.lblPayslips,
        /*      actions: [
          IconButton(
            icon: Icon(Iconsax.filter),
            onPressed: _showFilterDialog,
          ),
        ],*/
      ),
      body: Observer(
        builder: (_) => _store.isLoading
            ? loadingWidgetMaker()
            : Column(
                children: [
                  // Filter Chips
                  if (selectedYear != DateTime.now().year.toString() ||
                      selectedMonth != 'All')
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Chip(
                            backgroundColor:
                                appStore.appColorPrimary.withOpacity(0.1),
                            label: Text(
                              '${language.lblYear}: $selectedYear',
                              style: primaryTextStyle(),
                            ),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () {
                              setState(() {
                                selectedYear = '2024';
                              });
                            },
                          ).paddingRight(8),
                          Chip(
                            backgroundColor:
                                appStore.appColorPrimary.withOpacity(0.1),
                            label: Text(
                              '${language.lblMonth}: $selectedMonth',
                              style: primaryTextStyle(),
                            ),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () {
                              setState(() {
                                selectedMonth = 'All';
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: _store.payslips.isEmpty
                        ? noDataWidget(message: language.lblNoPayslipsFound)
                        : ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: _store.payslips.length,
                            itemBuilder: (context, index) {
                              return _buildPayslipCard(_store.payslips[index]);
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  /// Payslip Card
  Widget _buildPayslipCard(PayslipModel payslip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header Row: Period and Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: appStore.appColorPrimary.withOpacity(0.1),
                    child: Icon(
                      Iconsax.document,
                      color: appStore.appColorPrimary,
                    ),
                  ),
                  12.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${payslip.payrollPeriod}',
                        style: boldTextStyle(size: 16),
                      ),
                      Text(
                        '${language.lblNetPay}: \$${payslip.netSalary!.toStringAsFixed(2)}',
                        style: primaryTextStyle(size: 14, color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(
                Icons.info_outline,
                color: appStore.appColorPrimary,
              ),
            ],
          ),

          12.height,

          /// Action Button
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => PayslipDetailsScreen(
                payslip: payslip,
              ).launch(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: appStore.appColorPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Iconsax.arrow_right_3,
                  color: Colors.white, size: 18),
              label: Text(
                language.lblViewDetails,
                style: boldTextStyle(size: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
