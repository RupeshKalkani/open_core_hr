import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/main.dart';
import 'package:open_core_hr/models/Order/order_count_model.dart';
import 'package:open_core_hr/screens/Home/Component/attendance_component.dart';
import 'package:open_core_hr/screens/Home/Component/demo_mode_banner.dart';
import 'package:open_core_hr/screens/VisitHistory/visit_history_screen.dart';

import '../../../models/Settings/module_settings_model.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/app_widgets.dart';
import '../../Approvals/approval_screen.dart';
import '../../AttendanceHistory/attendance_history_screen.dart';
import '../../Client/client_screen.dart';
import '../../DigitalId/digital_id_card_screen.dart';
import '../../Document/document_request.dart';
import '../../Expense/ExpenseScreen.dart';
import '../../Forms/forms_screen.dart';
import '../../Holidays/holiday_screen.dart';
import '../../Leave/LeaveScreen.dart';
import '../../Loan/loan_screen.dart';
import '../../Order/orders_screen.dart';
import '../../PaymentCollection/payment_collection_screen.dart';
import '../../Payslip/payslip_screen.dart';
import '../../SalesTarget/sales_target_screen.dart';
import '../../Visits/visit_screen.dart';

class WidgetsComponent extends StatefulWidget {
  final OrderCountModel? orderCountModel;
  final bool isOrderCountLoading;

  const WidgetsComponent({
    super.key,
    required this.orderCountModel,
    required this.isOrderCountLoading,
  });

  @override
  State<WidgetsComponent> createState() => _WidgetsComponentState();
}

class _WidgetsComponentState extends State<WidgetsComponent> {
  ModuleSettingsModel? moduleSettings;
  List<Map<String, dynamic>> modules = [];
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    buildModulesList();
    setState(() {});
    if (globalAttendanceStore.isCheckedIn &&
        moduleService.isClientVisitModuleEnabled()) {
      globalAttendanceStore.refreshVisitsCount();
    }

    await sharedHelper.setAppVersionToPref();
  }

  buildModulesList() {
    if (moduleService.isDynamicFormModuleEnabled()) {
      modules.add({
        'title': language.lblForms,
        'icon': Icons.description_outlined,
        'onTap': () => const FormsScreen().launch(context),
      });
    }

    modules.add({
      'title': language.lblClients,
      'icon': Icons.people_outline,
      'onTap': () => const ClientScreen().launch(context),
    });

    if (moduleService.isPaymentCollectionModuleEnabled()) {
      modules.add({
        'title': language.lblPaymentCollections,
        'icon': Icons.payment,
        'onTap': () => const PaymentCollectionScreen().launch(context),
      });
    }

    if (moduleService.isLeaveModuleEnabled()) {
      modules.add({
        'title': language.lblLeaveRequests,
        'icon': Icons.calendar_today,
        'onTap': () => const LeaveScreen().launch(context),
      });
    }

    //Expense Module
    if (moduleService.isExpenseModuleEnabled()) {
      modules.add({
        'title': language.lblExpenseRequests,
        'icon': Icons.attach_money,
        'onTap': () => const ExpenseScreen().launch(context),
      });
    }

    //Loan Module
    if (moduleService.isLoanModuleEnabled()) {
      modules.add({
        'title': language.lblLoanRequests,
        'icon': Iconsax.money,
        'onTap': () => const LoanScreen().launch(context),
      });
    }

    //Documents Module
    if (moduleService.isDocumentModuleEnabled()) {
      modules.add({
        'title': language.lblDocumentRequests,
        'icon': Icons.file_copy_outlined,
        'onTap': () => const DocumentRequestScreen().launch(context),
      });
    }

/*    //My Time Line
    modules.add({
      'title': 'My Time Line',
      'icon': Icons.timeline,
      'onTap': () => MyTimeLineScreen().launch(context),
    });*/

    //Attendance History
    modules.add({
      'title': language.lblAttendanceHistory,
      'icon': Icons.calendar_month_outlined,
      'onTap': () => AttendanceHistoryScreen().launch(context),
    });

    //Digital Id card
    if (moduleService.isDigitalIdCardModuleEnabled()) {
      {
        modules.add({
          'title': language.lblDigitalIDCard,
          'icon': Icons.credit_card,
          'onTap': () => const DigitalIDCardScreen().launch(context),
        });
      }
    }

    //Sales Targets
    if (moduleService.isSalesTargetModuleEnabled()) {
      {
        modules.add({
          'title': language.lblSalesTargets,
          'icon': Icons.stacked_bar_chart_rounded,
          'onTap': () => const SalesTargetScreen().launch(context),
        });
      }

      //Approvals
      if (moduleService.isApprovalModuleEnabled() &&
          getBoolAsync(approverPref)) {
        modules.add({
          'title': language.lblApprovals,
          'icon': Icons.assignment_turned_in_outlined,
          'onTap': () => const ApprovalScreen().launch(context),
        });
      }

      //Payslip
      if (moduleService.isPayrollModuleEnabled()) {
        modules.add({
          'title': language.lblPayslip,
          'icon': Icons.money,
          'onTap': () => const PayslipScreen().launch(context),
        });
      }

      //Holidays
      modules.add({
        'title': language.lblHolidays,
        'icon': Icons.calendar_today,
        'onTap': () => const HolidayScreen().launch(context),
      });
    }

    modules.add({
      'title': language.lblVisitHistory,
      'icon': Icons.history,
      'onTap': () => VisitHistoryScreen().launch(context),
    });
/*    modules.add({
      'title': 'Test',
      'icon': Icons.add,
      'onTap': () => MyOnboardingScreen().launch(context),
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AttendanceComponent(),
            if (getBoolAsync('isDemoCreds')) DemoModeBanner(),
            // Client Visits Section
            if (globalAttendanceStore.isCheckedIn &&
                moduleService.isClientVisitModuleEnabled())
              _buildClientVisitsCard(
                title: language.lblClientVisits,
                imagePath: 'images/3d/business_building.png',
                buttonText: language.lblMarkVisit,
                onButtonTap: () {
                  if (globalAttendanceStore.isOnBreak) {
                    toast(
                        language.lblYouAreOnBreakPleaseEndYourBreakToMarkVisit);
                  } else {
                    const VisitScreen().launch(context);
                  }
                },
                todaysVisitCount: 0,
              ),
            const SizedBox(height: 10),
            // Orders Section
            if (moduleService.isProductModuleEnabled())
              _buildOrderCard(widget.orderCountModel),
            const SizedBox(height: 10),
            Observer(
              builder: (_) => AlignedGridView.count(
                padding: const EdgeInsets.only(top: 0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3, // 4 Columns
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                itemCount: modules.length,
                itemBuilder: (context, index) {
                  final item = modules[index];
                  return GestureDetector(
                    onTap: item['onTap'],
                    child: Container(
                      height: 110,
                      decoration: _buildBoxDecoration(appStore.isDarkModeOn
                          ? Colors.black
                          : Colors.white), // should use appStore observables
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item['icon'],
                            size: 20,
                            color: appStore
                                .appPrimaryColor, // must be an observable property
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item['title'],
                            textAlign: TextAlign.center,
                            style: primaryTextStyle(
                                size:
                                    mediumSize), // ensure this reads from observables if needed
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            100.height,
            FooterSignature(
              textColor: appStore.textPrimaryColor!,
            ),
            55.height,
          ],
        ),
      ),
    );
  }

  // Redesigned Client Visits Card
  Widget _buildClientVisitsCard({
    required String title,
    required String imagePath,
    required String buttonText,
    required int todaysVisitCount,
    required VoidCallback onButtonTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _buildBoxDecoration(appStore.scaffoldBackground!),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Wrap left side in Expanded so it takes available space
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  language.lblTodaysClientVisits,
                  style: boldTextStyle(
                      size: 14, color: appStore.textSecondaryColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Observer(
                  builder: (_) => globalAttendanceStore.isVisitsCountLoading
                      ? buildShimmer(30, 25)
                      : Text(
                          globalAttendanceStore.visitCount!.todaysVisits
                              .toString(),
                          style: boldTextStyle(
                              size: 24, color: appStore.appPrimaryColor),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Button with text wrapped in FittedBox to scale down if necessary
          ElevatedButton(
            onPressed: onButtonTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: appStore.appPrimaryColor,
              foregroundColor: white,
              minimumSize: const Size(100, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                buttonText,
                style: boldTextStyle(size: 14, color: white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Orders Card
  Widget _buildOrderCard(OrderCountModel? orderCount) {
    return Container(
      decoration: _buildBoxDecoration(
          appStore.isDarkModeOn ? Colors.black : Colors.white),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            language.lblOrders,
            style: boldTextStyle(size: mediumSize),
          ),
          const SizedBox(height: 10),

          // Order Counts - Redesigned as Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOrderCountCard(
                icon: Icons.pending_actions,
                label: language.lblPending,
                count:
                    widget.isOrderCountLoading ? 0 : orderCount!.pending ?? 0,
                color: Colors.orangeAccent,
              ),
              _buildOrderCountCard(
                icon: Icons.loop,
                label: language.lblProcessing,
                count: widget.isOrderCountLoading
                    ? 0
                    : orderCount!.processing ?? 0,
                color: Colors.blueAccent,
              ),
              _buildOrderCountCard(
                icon: Icons.check_circle,
                label: language.lblCompleted,
                count:
                    widget.isOrderCountLoading ? 0 : orderCount!.completed ?? 0,
                color: Colors.greenAccent,
              ),
            ],
          ),
        ],
      ),
    ).onTap(() => const OrdersScreen().launch(context));
  }

// Reusable Order Count Card
  Widget _buildOrderCountCard({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
  }) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: appStore.isDarkModeOn ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
        /* boxShadow: [
          BoxShadow(
            color: appStore.backgroundSecondaryColor!.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],*/
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),

          // Label
          Flexible(
            child: Text(
              label,
              style: boldTextStyle(size: 12, color: appStore.textPrimaryColor),
              textAlign: TextAlign.center,
            ),
          ),

          // Count
          const SizedBox(height: 4),
          Text(
            count.toString(),
            style: boldTextStyle(size: 18, color: color),
          ),
        ],
      ),
    );
  }

  // Box Decoration
  BoxDecoration _buildBoxDecoration(Color bgColor) {
    return BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.withOpacity(0.15)),
      /* boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 6,
          offset: const Offset(0, 4),
        ),
      ],*/
    );
  }
}
