import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/utils/date_utils.dart';

import '../../Utils/app_widgets.dart';
import '../../main.dart';
import '../../models/holiday_model.dart';
import 'holiday_store.dart';

class HolidayScreen extends StatefulWidget {
  const HolidayScreen({super.key});

  @override
  State<HolidayScreen> createState() => _HolidayScreenState();
}

class _HolidayScreenState extends State<HolidayScreen> {
  final HolidayStore _store = HolidayStore();

  @override
  void initState() {
    super.initState();
    _store.pagingController.addPageRequestListener((pageKey) {
      _store.fetchHolidays(pageKey);
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
                controller: _store.yearFilterController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelText: language.lblFilterByYear,
                  prefixIcon: const Icon(Iconsax.calendar),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _store.yearFilterController.clear();
                      _store.yearFilter = null;
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  hideKeyboard(context);
                  showYearPicker(
                    context: context,
                    firstDate: DateTime(DateTime.now().year - 10),
                    initialDate: DateTime.now(),
                  ).then((value) {
                    if (value != null) {
                      _store.yearFilterController.text = value.toString();
                    }
                  });
                },
              ),
              16.height,
              // Buttons
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Clear all filters
                      _store.yearFilterController.clear();
                      _store.yearFilter = null;
                      _store.pagingController.refresh();
                      Navigator.pop(context);
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
                      _store.yearFilter =
                          int.parse(_store.yearFilterController.text);
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
        language.lblHolidays,
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
              return _store.yearFilter != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Chip(
                          side: BorderSide(color: Colors.transparent),
                          label: Text(
                            '${language.lblPeriod}: ${_store.yearFilter}',
                            style: primaryTextStyle(color: white),
                          ),
                          backgroundColor: appStore.appColorPrimary,
                          deleteIcon:
                              const Icon(Icons.close, color: Colors.white),
                          onDeleted: () {
                            _store.yearFilterController.clear();
                            _store.yearFilter = null;
                            _store.pagingController.refresh();
                          },
                        ),
                      ),
                    )
                  : const SizedBox();
            },
          ),
          Expanded(
            child: PagedListView<int, HolidayModel>(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              pagingController: _store.pagingController,
              builderDelegate: PagedChildBuilderDelegate<HolidayModel>(
                noItemsFoundIndicatorBuilder: (context) => noDataWidget(
                    message: language.lblNoHolidaysFoundForThisYear),
                itemBuilder: (context, holiday, index) =>
                    _buildHolidayCard(holiday),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Modern Card UI for each holiday
  Widget _buildHolidayCard(HolidayModel holiday) {
    final inputFormat = DateFormat('dd-MM-yyyy');
    final date = inputFormat.parse(holiday.date);
    final day = date.day;
    final month = date.monthName;

    return Container(
      decoration: cardDecoration(),
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Card
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: appStore.appPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$day',
                  style:
                      boldTextStyle(size: 18, color: appStore.appPrimaryColor),
                ),
                Text(
                  month.substring(0, 3).toUpperCase(), // Short month name
                  style: secondaryTextStyle(size: 12),
                ),
              ],
            ),
          ),
          16.width,

          // Holiday Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  holiday.name,
                  style: boldTextStyle(size: 16),
                ),
                4.height,
                Text(
                  '${language.lblFullDate}: ${holiday.date}',
                  style: secondaryTextStyle(size: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
