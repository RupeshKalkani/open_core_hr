import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/screens/Leave/LeaveRequestScreen.dart';
import 'package:open_core_hr/screens/Leave/LeaveStore.dart';
import 'package:open_core_hr/screens/Leave/widget/leave_item_widget.dart';
import 'package:open_core_hr/utils/app_widgets.dart';

import '../../main.dart';
import '../../models/leave_request_model.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  final LeaveStore _store = LeaveStore();

  @override
  void initState() {
    super.initState();
    _store.pagingController.addPageRequestListener((pageKey) {
      _store.fetchLeaveRequests(pageKey);
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
              // Status Filter
              Observer(
                builder: (_) => DropdownButtonFormField<String>(
                  value: _store.selectedStatus,
                  decoration: InputDecoration(
                    labelText: language.lblStatus,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  items: _store.statuses
                      .map((status) => DropdownMenuItem<String>(
                            value: status,
                            child: Text(status.capitalizeFirstLetter()),
                          ))
                      .toList(),
                  onChanged: (value) {
                    _store.selectedStatus = value;
                  },
                ),
              ),
              16.height,
              // Buttons
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Reset filters
                      _store.selectedStatus = null;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, language.lblLeaveRequests, actions: [
        IconButton(
          icon: const Icon(Iconsax.filter),
          tooltip: language.lblFilterByDate,
          onPressed: () => _showFilterPopup(context),
        ),
      ]),
      body: Column(
        children: [
          Observer(
            builder: (_) {
              return _store.selectedStatus != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Chip(
                          side: BorderSide(color: Colors.transparent),
                          label: Text(
                            '${language.lblStatus}: ${_store.selectedStatus}',
                            style: primaryTextStyle(color: white),
                          ),
                          backgroundColor: appStore.appColorPrimary,
                          deleteIcon:
                              const Icon(Icons.close, color: Colors.white),
                          onDeleted: () {
                            _store.selectedStatus = null;
                            _store.pagingController.refresh();
                          },
                        ),
                      ),
                    )
                  : const SizedBox();
            },
          ),
          // Leave Requests List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  Future.sync(() => _store.pagingController.refresh()),
              child: PagedListView<int, LeaveRequestModel>(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                pagingController: _store.pagingController,
                builderDelegate: PagedChildBuilderDelegate<LeaveRequestModel>(
                  noItemsFoundIndicatorBuilder: (context) =>
                      noDataWidget(message: language.lblNoRequests),
                  itemBuilder: (context, leaveRequest, index) {
                    return LeaveItemWidget(
                      index: index,
                      model: leaveRequest,
                      deleteAction: (BuildContext context) {
                        _store.id = leaveRequest.id;
                        showConfirmDialogCustom(
                          context,
                          title:
                              language.lblAreYouSureYouWantToCancelThisRequest,
                          dialogType: DialogType.CONFIRMATION,
                          positiveText: language.lblYes,
                          negativeText: language.lblNo,
                          onAccept: (c) async {
                            await _store.cancelLeave();
                            _store.pagingController.refresh();
                          },
                        );
                      },
                    ).paddingBottom(8);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: appStore.appColorPrimary,
        onPressed: () async {
          await const LeaveRequestScreen().launch(context);
          _store.pagingController.refresh();
        },
        label: Row(
          children: [
            Icon(Icons.add, color: white),
            5.width,
            Text(language.lblCreate, style: TextStyle(color: white)),
          ],
        ),
      ),
    );
  }
}
