import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/models/attendance_history_model.dart';

import '../../../Utils/app_widgets.dart';
import '../../../main.dart';
import 'attendance_history_store.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  final _store = AttendanceHistoryStore();

  @override
  void initState() {
    super.initState();
    _store.pagingController.addPageRequestListener((pageKey) {
      _store.getAttendanceHistory(pageKey);
    });
  }

  @override
  void dispose() {
    _store.pagingController.dispose();
    super.dispose();
  }

  Future<void> _showFilterPopup(BuildContext context) async {
    DateTimeRange? selectedRange;

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

              // Date Range Picker Section
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: language.lblSelectDateRange,
                        hintText: '${language.lblStart} - ${language.lblEnd}',
                        prefixIcon: const Icon(Icons.date_range),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onTap: () async {
                        final DateTimeRange? range = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2021),
                            lastDate: DateTime.now(),
                            helpText: language.lblSelectDateRange,
                            confirmText: language.lblConfirm);
                        if (range != null) {
                          setState(() {
                            selectedRange = range;
                          });
                          _store.dateRangeController.text =
                              '${_formatDate(range.start)} - ${_formatDate(range.end)}';
                          /*toast(
                            'Selected: ${_formatDate(range.start)} - ${_formatDate(range.end)}',
                          );*/
                        }
                      },
                      controller: _store.dateRangeController,
                    ),
                  ),
                ],
              ),
              16.height,

              // Action Buttons
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      selectedRange = null;
                      _store.startRange = null;
                      _store.endRange = null;
                      _store.dateRangeController.clear();
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
                      if (selectedRange != null) {
                        _store.startRange = _formatDate(selectedRange!.start);
                        _store.endRange = _formatDate(selectedRange!.end);
                      }
                      _store.pagingController.refresh();
                    },
                    child: Text(
                      language.lblApply,
                      style: primaryTextStyle(color: white),
                    ),
                  ).expand(),
                ],
              ),
              20.height,
            ],
          ),
        );
      },
    );
  }

// Helper Function to Format Dates
  String _formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context,
        language.lblAttendanceHistory,
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
              return _store.startRange != null && _store.endRange != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Chip(
                          side: BorderSide(color: Colors.transparent),
                          label: Text(
                            '${language.lblRange}: ${_store.startRange} - ${_store.endRange}',
                            style: primaryTextStyle(color: white),
                          ),
                          backgroundColor: appStore.appColorPrimary,
                          deleteIcon:
                              const Icon(Icons.close, color: Colors.white),
                          onDeleted: () {
                            _store.startRange = _store.endRange = null;
                            _store.dateRangeController.clear();
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
              child: PagedListView<int, AttendanceHistoryModel>(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                pagingController: _store.pagingController,
                builderDelegate:
                    PagedChildBuilderDelegate<AttendanceHistoryModel>(
                  noItemsFoundIndicatorBuilder: (context) =>
                      noDataWidget(message: language.lblNoRequests),
                  itemBuilder: (context, history, index) {
                    return _buildAttendanceCard(history);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Attendance Card Widget
  Widget _buildAttendanceCard(AttendanceHistoryModel data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.date.toString(),
                style: boldTextStyle(size: 16),
              ),
              Text(
                '${data.totalHours}Hrs',
                style: primaryTextStyle(size: 14, color: Colors.green),
              ),
            ],
          ),
          const Divider(height: 20),

          // In-Time and Out-Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoRow(
                  Iconsax.clock, language.lblInTime, data.checkInTime!),
              _buildInfoRow(
                  Iconsax.clock, language.lblOutTime, data.checkOutTime!),
            ],
          ),
          10.height,

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoRow(
                Iconsax.location,
                language.lblVisits,
                data.visitCount.toString(),
              ),
              _buildInfoRow(
                  Iconsax.box, language.lblOrders, data.ordersCount.toString()),
              _buildInfoRow(Iconsax.document, language.lblForms,
                  data.formsSubmissionCount.toString()),
            ],
          ),
          10.height,

          /* // Distance Travelled
          _buildInfoRow(
              Iconsax.map,
              'Distance Travelled',
              data.distanceTravelled.toString() +
                  getStringAsync(appDistanceUnitPref)),*/
        ],
      ),
    );
  }

  // Reusable Row for Info
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: appStore.appPrimaryColor),
        8.width,
        Text('$label: ', style: secondaryTextStyle(size: 14)),
        Text(value, style: boldTextStyle(size: 14)),
      ],
    );
  }
}
