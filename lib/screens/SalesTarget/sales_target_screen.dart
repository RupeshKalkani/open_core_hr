import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/main.dart';
import 'package:open_core_hr/screens/SalesTarget/sales_target_card.dart';
import 'package:open_core_hr/screens/SalesTarget/sales_target_store.dart';

import '../../utils/app_widgets.dart';

class SalesTargetScreen extends StatefulWidget {
  const SalesTargetScreen({super.key});

  @override
  State<SalesTargetScreen> createState() => _SalesTargetScreenState();
}

class _SalesTargetScreenState extends State<SalesTargetScreen>
    with SingleTickerProviderStateMixin {
  final _store = SalesTargetStore();

  DateTimeRange? selectedRange;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    _store.getSalesTargets();
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
                      _store.getSalesTargets();
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
        language.lblSalesTargets,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.filter),
            tooltip: language.lblFilterByDate,
            onPressed: () => _showFilterPopup(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Column(
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
                              _store.getSalesTargets();
                            },
                          ),
                        ),
                      )
                    : const SizedBox();
              },
            ),
            Observer(
              builder: (_) => _store.isLoading
                  ? loadingWidgetMaker().center()
                  : _store.targets.isEmpty
                      ? noDataWidget(message: language.lblNoTargetsFound)
                      : Expanded(
                          child: ListView.builder(
                            itemCount: _store.targets.length,
                            itemBuilder: (context, index) {
                              final target = _store.targets[index];
                              return SalesTargetCard(target: target);
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
