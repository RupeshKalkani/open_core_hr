import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/Utils/app_constants.dart';
import 'package:open_core_hr/Utils/app_widgets.dart';

import '../../main.dart';
import '../../models/Approval/approval_request_model.dart';
import 'approval_details_screen.dart';
import 'approval_store.dart';

class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({super.key});

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApprovalStore _store = ApprovalStore();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Set up paging listeners.
    _store.leavePagingController.addPageRequestListener((pageKey) {
      _store.fetchLeaveRequests(pageKey);
    });
    _store.expensePagingController.addPageRequestListener((pageKey) {
      _store.fetchExpenseRequests(pageKey);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _store.leavePagingController.dispose();
    _store.expensePagingController.dispose();
    super.dispose();
  }

  /// Builds a paged list using the provided PagingController.
  Widget _buildPagedApprovalList(
      PagingController<int, ApprovalRequestModel> controller,
      {bool isLeave = false}) {
    return PagedListView<int, ApprovalRequestModel>(
      padding: const EdgeInsets.all(16),
      pagingController: controller,
      builderDelegate: PagedChildBuilderDelegate<ApprovalRequestModel>(
        itemBuilder: (context, item, index) {
          return GestureDetector(
            onTap: () async {
              await ApprovalDetailsScreen(request: item).launch(context);
              _store.leavePagingController.refresh();
              _store.expensePagingController.refresh();
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.title, style: boldTextStyle(size: 14)),
                      Text(item.type, style: secondaryTextStyle(size: 12)),
                    ],
                  ),
                  8.height,
                  // Details
                  Row(
                    children: [
                      const Icon(Iconsax.user, size: 16, color: Colors.grey),
                      8.width,
                      Text('${language.lblRequestedBy} ${item.requestedBy}',
                          style: secondaryTextStyle(size: 12)),
                    ],
                  ),
                  4.height,
                  Row(
                    children: [
                      const Icon(Iconsax.calendar,
                          size: 16, color: Colors.grey),
                      8.width,
                      if (isLeave)
                        Text('${language.lblFrom}: ${item.fromDate}',
                            style: secondaryTextStyle(size: 12)),
                      4.width,
                      if (isLeave)
                        Text('${language.lblTo}: ${item.toDate}',
                            style: secondaryTextStyle(size: 12)),
                      if (!isLeave)
                        Text('${language.lblDate}: ${item.date}',
                            style: secondaryTextStyle(size: 12)),
                    ],
                  ),
                  4.height,
                  //Amount
                  if (!isLeave)
                    Row(
                      children: [
                        const Icon(Iconsax.wallet,
                            size: 16, color: Colors.grey),
                        8.width,
                        Text(
                            '${language.lblAmount}: ${getStringAsync(appCurrencySymbolPref)}${item.amount}',
                            style: secondaryTextStyle(size: 12)),
                      ],
                    ),
                  Row(
                    children: [
                      const Icon(Iconsax.status, size: 16, color: Colors.grey),
                      8.width,
                      Text('${language.lblStatus}: ${item.status}',
                          style: secondaryTextStyle(size: 12)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        firstPageProgressIndicatorBuilder: (_) =>
            Center(child: loadingWidgetMaker()),
        newPageProgressIndicatorBuilder: (_) => Center(
          child: loadingWidgetMaker(),
        ),
        noItemsFoundIndicatorBuilder: (_) => Center(
          child: Text(
            language.lblNoRequestsFound,
            style: primaryTextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  /// For tabs that do not have paging (Loan, Other), show a static message.
  Widget _buildStaticEmptyView() {
    return Center(
      child: Text(
        language.lblNoRequestsFound,
        style: primaryTextStyle(color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, language.lblApprovals),
      body: Column(
        children: [
          /// TabBar for approval types
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: appStore.appColorPrimary,
              labelColor: appStore.appColorPrimary,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(icon: Icon(Iconsax.calendar), text: language.lblLeave),
                Tab(icon: Icon(Iconsax.wallet), text: language.lblExpense),
                /*     Tab(icon: Icon(Iconsax.bank), text: 'Loan'),
                Tab(icon: Icon(Iconsax.document), text: 'Other'),*/
              ],
            ),
          ),

          /// TabBarView showing different lists
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Observer(
                  builder: (_) => _buildPagedApprovalList(
                      _store.leavePagingController,
                      isLeave: true),
                ),
                Observer(
                  builder: (_) =>
                      _buildPagedApprovalList(_store.expensePagingController),
                ),
                _buildStaticEmptyView(),
                _buildStaticEmptyView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
