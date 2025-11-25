import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/utils/app_widgets.dart';

import '../../main.dart';
import '../../models/Visit/visit_model.dart';
import '../Visits/visit_screen.dart';
import 'visit_history_store.dart';

class VisitHistoryScreen extends StatefulWidget {
  const VisitHistoryScreen({super.key});

  @override
  State<VisitHistoryScreen> createState() => _VisitHistoryScreenState();
}

class _VisitHistoryScreenState extends State<VisitHistoryScreen> {
  final _store = VisitHistoryStore();

  @override
  void initState() {
    super.initState();
    globalAttendanceStore.refreshVisitsCount();
    _store.pagingController.addPageRequestListener((pageKey) {
      _store.fetchVisits(pageKey);
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
      appBar: appBar(
        context,
        language.lblVisitHistory,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.filter),
            tooltip: language.lblFilterByDate,
            onPressed: () => _showFilterPopup(context),
          ),
        ],
      ),
      body: Observer(
        builder: (_) => Column(
          children: [
            // Visits Count Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildVisitCountCard(
                  title: language.lblTotalVisits,
                  count: globalAttendanceStore.visitCount?.totalVisits
                          .toString() ??
                      '0',
                  isLoading: globalAttendanceStore.isVisitsCountLoading,
                ),
                _buildVisitCountCard(
                  title: language.lblTodayVisits,
                  count: globalAttendanceStore.visitCount?.todaysVisits
                          .toString() ??
                      '0',
                  isLoading: globalAttendanceStore.isVisitsCountLoading,
                ),
              ],
            ).paddingAll(8),
            16.height,
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
                child: PagedListView<int, VisitModel>(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  pagingController: _store.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<VisitModel>(
                    noItemsFoundIndicatorBuilder: (context) =>
                        noDataWidget(message: language.lblNoVisitsAdded),
                    itemBuilder: (context, visit, index) =>
                        _buildVisitCard(visit),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: appStore.appColorPrimary,
        onPressed: () async {
          if (!globalAttendanceStore.isCheckedIn) {
            toast(language.lblPleaseCheckInFirst);
            return;
          }
          await const VisitScreen().launch(context);
          _store.pagingController.refresh();
        },
        icon: const Icon(Icons.add, color: white),
        label: Text(language.lblCreate, style: boldTextStyle(color: white)),
      ),
    );
  }

  // Build Visit Card
  Widget _buildVisitCard(VisitModel visit) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Client Name and Visit Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    visit.clientName ?? 'N/A',
                    style: boldTextStyle(size: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  visit.visitDateTime ?? 'N/A',
                  style: secondaryTextStyle(size: 12),
                ),
              ],
            ),
            8.height,

            // Address Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                8.width,
                Expanded(
                  child: Text(
                    visit.clientAddress ?? 'N/A',
                    style: secondaryTextStyle(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            8.height,

            // View Image Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appStore.appColorPrimary,
                    shape: buildButtonCorner(),
                  ),
                  onPressed: () {
                    if (visit.visitImage != null &&
                        visit.visitImage!.isNotEmpty) {
                      _openImageViewer(context, visit.visitImage!);
                    } else {
                      toast(language.lblNoImageAvailableForThisVisit);
                    }
                  },
                  child: Text(
                    language.lblViewImage,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build Visit Count Card
  Widget _buildVisitCountCard({
    required String title,
    required String count,
    required bool isLoading,
  }) {
    return isLoading
        ? Flexible(
            child: buildShimmer(100, context.width() / 2),
          )
        : Container(
            width: context.width() * 0.45,
            padding: const EdgeInsets.all(16),
            decoration: cardDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(count, style: boldTextStyle(size: 22)),
                8.height,
                Text(title,
                    textAlign: TextAlign.center, style: secondaryTextStyle()),
              ],
            ),
          );
  }

  void _openImageViewer(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: InteractiveViewer(
              panEnabled: true,
              boundaryMargin: EdgeInsets.zero,
              minScale: 0.5,
              maxScale: 3.0,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      language.lblFailedToLoadImage,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
