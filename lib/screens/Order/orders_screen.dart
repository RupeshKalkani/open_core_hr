import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/screens/Order/order_details.dart';
import 'package:open_core_hr/screens/Order/order_store.dart';
import 'package:open_core_hr/screens/Order/product_categories_screen.dart';
import 'package:open_core_hr/screens/navigation_screen.dart';

import '../../main.dart';
import '../../models/Order/order_model.dart';
import '../../utils/app_widgets.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final _store = OrderStore();

  @override
  void initState() {
    super.initState();
    _store.getOrderCounts();
    _store.pagingController.addPageRequestListener((pageKey) {
      _store.getOrders(pageKey);
    });
  }

  @override
  void dispose() {
    _store.pagingController.dispose();
    super.dispose();
  }

  Future<void> _showFilterPopup(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(language.lblFilters, style: boldTextStyle(size: 16)),
              16.height,
              // Date Filter
              TextField(
                controller: _store.dateFilterController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelText: language.lblFilterByDate,
                  prefixIcon: const Icon(Iconsax.calendar),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _store.dateFilterController.clear();
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  hideKeyboard(context);
                  var result = await showDatePicker(
                    context: context,
                    confirmText: language.lblOk,
                    initialDate: _store.dateFilterController.text.isEmptyOrNull
                        ? DateTime.now()
                        : formDateFormatter
                            .parse(_store.dateFilterController.text),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (result != null) {
                    _store.dateFilterController.text =
                        formDateFormatter.format(result);
                  }
                },
              ),
              16.height,
              // Buttons
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Clear all filters
                      _store.dateFilterController.clear();
                      _store.dateFilter = '';
                      Navigator.pop(context);
                      _store.pagingController.refresh();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: buildButtonCorner(),
                    ),
                    child: Text(language.lblReset,
                        style: primaryTextStyle(color: white)),
                  ).expand(),
                  16.width,
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appStore.appColorPrimary,
                      shape: buildButtonCorner(),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _store.dateFilter = _store.dateFilterController.text;
                      _store.pagingController.refresh();
                    },
                    child: Text(
                      language.lblApply,
                      style: primaryTextStyle(color: white),
                    ),
                  ).expand(),
                ],
              ),
              20.height
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        NavigationScreen().launch(context);
      },
      child: Scaffold(
        backgroundColor: appStore.scaffoldBackground,
        appBar: cartAppBar(context, language.lblOrders),
        body: Observer(
          builder: (_) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First Row
                Row(
                  children: [
                    _buildStatusCard(
                      title: language.lblPending,
                      value: _store.isOrderCountLoading
                          ? null
                          : _store.orderCount.pending.toString(),
                      icon: Icons.pending_actions,
                      color: Colors.orange,
                    ).expand(),
                    12.width,
                    _buildStatusCard(
                      title: language.lblProcessing,
                      value: _store.isOrderCountLoading
                          ? null
                          : _store.orderCount.processing.toString(),
                      icon: Icons.sync,
                      color: Colors.blueAccent,
                    ).expand(),
                  ],
                ),
                12.height,
                // Second Row
                Row(
                  children: [
                    _buildStatusCard(
                      title: language.lblCancelled,
                      value: _store.isOrderCountLoading
                          ? null
                          : _store.orderCount.cancelled.toString(),
                      icon: Icons.cancel,
                      color: Colors.red,
                    ).expand(),
                    12.width,
                    _buildStatusCard(
                      title: language.lblCompleted,
                      value: _store.isOrderCountLoading
                          ? null
                          : _store.orderCount.completed.toString(),
                      icon: Icons.check_circle,
                      color: Colors.green,
                    ).expand(),
                  ],
                ),
                20.height,
                // Today’s Orders Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(language.lblOrders, style: boldTextStyle(size: 18)),
                    IconButton(
                      icon: const Icon(Iconsax.filter),
                      tooltip: language.lblFilterByDate,
                      onPressed: () => _showFilterPopup(context),
                    ),
                  ],
                ),
                Divider(height: 10, thickness: 1, color: Colors.grey.shade300),
                10.height,
                Observer(
                  builder: (_) => _store.dateFilter.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Chip(
                              side: BorderSide(color: Colors.transparent),
                              label: Text(
                                '${language.lblDate}: ${_store.dateFilter}',
                                style: primaryTextStyle(color: white),
                              ),
                              backgroundColor: appStore.appColorPrimary,
                              deleteIcon:
                                  const Icon(Icons.close, color: Colors.white),
                              onDeleted: () {
                                _store.dateFilterController.clear();
                                _store.dateFilter = '';
                                _store.pagingController.refresh();
                              },
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () =>
                        Future.sync(() => _store.pagingController.refresh()),
                    child: PagedListView<int, OrderModel>(
                      pagingController: _store.pagingController,
                      builderDelegate: PagedChildBuilderDelegate<OrderModel>(
                        noItemsFoundIndicatorBuilder: (context) =>
                            noDataWidget(message: language.lblNoOrdersFound),
                        itemBuilder: (context, item, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: cardDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Order Header
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${language.lblOrder} #${item.id}',
                                      style: boldTextStyle(size: 18),
                                    ),
                                    statusWidget(item.status.toString()),
                                  ],
                                ),

                                12.height,

                                /// Order Details
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        size: 14, color: Colors.grey),
                                    8.width,
                                    Text(
                                      '${language.lblDate}: ${item.createdOn}',
                                      style: secondaryTextStyle(size: 14),
                                    ),
                                  ],
                                ),

                                8.height,

                                Row(
                                  children: [
                                    const Icon(Icons.attach_money,
                                        size: 14, color: Colors.grey),
                                    8.width,
                                    Text(
                                      '${language.lblTotal}: ${item.total}',
                                      style: secondaryTextStyle(size: 14),
                                    ),
                                  ],
                                ),

                                12.height,

                                /// Actions
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            appStore.appColorPrimary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () {
                                        OrderDetails(order: item)
                                            .launch(context);
                                      },
                                      icon: const Icon(Iconsax.eye,
                                          size: 16, color: Colors.white),
                                      label: Text(
                                        language.lblViewDetails,
                                        style: primaryTextStyle(
                                            color: Colors.white, size: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: appStore.appColorPrimary,
          onPressed: () async {
            await const ProductCategoriesScreen().launch(context);
            _store.pagingController.refresh();
          },
          label: Row(
            children: [
              Icon(Icons.add, color: white),
              5.width,
              Text(language.lblAddOrder, style: TextStyle(color: white)),
            ],
          ),
        ),
      ),
    );
  }

  // Build Modern Status Card
  Widget _buildStatusCard({
    required String title,
    String? value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 36),
          8.height,
          value == null
              ? buildShimmer(30, 50)
              : Text(
                  value,
                  style:
                      boldTextStyle(size: 22, color: appStore.textPrimaryColor),
                ),
          4.height,
          Text(title, style: secondaryTextStyle(size: 14)),
        ],
      ),
    );
  }
}
