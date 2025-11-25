import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/screens/PaymentCollection/collect_payment_screen.dart';

import '../../Utils/app_constants.dart';
import '../../main.dart';
import '../../models/PaymentCollection/payment_collection_model.dart';
import '../../utils/app_widgets.dart';
import 'collection_store.dart';

class PaymentCollectionScreen extends StatefulWidget {
  const PaymentCollectionScreen({super.key});

  @override
  State<PaymentCollectionScreen> createState() =>
      _PaymentCollectionScreenState();
}

class _PaymentCollectionScreenState extends State<PaymentCollectionScreen> {
  final _store = CollectionStore();

  @override
  void initState() {
    super.initState();
    _store.pagingController.addPageRequestListener((pageKey) {
      _store.fetchPaymentCollections(pageKey);
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
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: appBar(
        context,
        language.lblPaymentCollections,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.filter),
            tooltip: language.lblFilterByDate,
            onPressed: () => _showFilterPopup(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Observer(
            builder: (_) {
              return _store.dateFilter.isNotEmpty
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
                  : const SizedBox();
            },
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  Future.sync(() => _store.pagingController.refresh()),
              child: PagedListView<int, PaymentCollectionModel>(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                pagingController: _store.pagingController,
                builderDelegate:
                    PagedChildBuilderDelegate<PaymentCollectionModel>(
                  noItemsFoundIndicatorBuilder: (context) =>
                      noDataWidget(message: language.lblNoRecordsFound),
                  itemBuilder: (context, payment, index) =>
                      _buildPaymentCollectionCard(payment),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: appStore.appColorPrimary,
        onPressed: () async {
          await const CollectPaymentScreen().launch(context);
          _store.pagingController.refresh();
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(language.lblCreate, style: boldTextStyle(color: white)),
      ),
    );
  }

  Widget _buildPaymentCollectionCard(PaymentCollectionModel payment) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: cardDecoration(),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: appStore.appColorPrimary.withOpacity(0.1),
          child: Text(
            payment.client!.name![0],
            style: boldTextStyle(color: appStore.appColorPrimary),
          ),
        ),
        title: Text(
          payment.client!.name!,
          style: boldTextStyle(size: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${language.lblAmount}: ${getStringAsync(appCurrencySymbolPref)}${payment.amount!}',
              style: secondaryTextStyle(size: 12),
            ),
            4.height,
            Text(
              '${language.lblDate}: ${payment.createdAt!}',
              style: secondaryTextStyle(size: 12),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: appStore.appColorPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            payment.paymentType!,
            style: boldTextStyle(color: appStore.appColorPrimary, size: 12),
          ),
        ),
      ),
    );
  }
}
