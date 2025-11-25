import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Utils/app_constants.dart';
import '../../main.dart';
import '../../utils/app_widgets.dart';

class ExpenseInfoComponent extends StatelessWidget {
  final num approved, pending, rejected;
  const ExpenseInfoComponent(
      {super.key,
      required this.approved,
      required this.pending,
      required this.rejected});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: white.withOpacity(0.8),
      shape: buildRoundedCorner(),
      child: SizedBox(
        width: context.width() - 148,
        child: Column(
          children: [
            Text(
              language.lblExpenseStatus,
              style: boldTextStyle(size: 18),
            ),
            itemRowTWidget(language.lblApproved,
                '${getStringAsync(appCurrencySymbolPref)}$approved', black),
            divider().paddingOnly(top: 1, bottom: 1),
            itemRowTWidget(language.lblPending,
                '${getStringAsync(appCurrencySymbolPref)}$pending', black),
            divider().paddingOnly(top: 1, bottom: 1),
            itemRowTWidget(language.lblRejected,
                '${getStringAsync(appCurrencySymbolPref)}$rejected', black),
          ],
        ).paddingAll(8.0),
      ),
    );
  }
}
