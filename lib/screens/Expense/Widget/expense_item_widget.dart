import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/Utils/app_constants.dart';
import 'package:open_core_hr/models/Expense/expense_request_model.dart';

import '../../../main.dart';
import '../../../utils/app_widgets.dart';

class ExpenseItemWidget extends StatelessWidget {
  final int index;
  final ExpenseRequestModel model;
  final Function(BuildContext) deleteAction;

  const ExpenseItemWidget({
    super.key,
    required this.index,
    required this.model,
    required this.deleteAction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        deleteAction(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Row: Type and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  model.type!,
                  style: boldTextStyle(size: 18),
                ),
                statusWidget(model.status.toString()),
              ],
            ),
            8.height,

            // Requested On
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                6.width,
                Text(
                  '${language.lblRequestedOn}: ${model.createdAt!}',
                  style: secondaryTextStyle(size: 14),
                ),
              ],
            ),
            8.height,

            // For Date
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                6.width,
                Text(
                  '${language.lblForDate}: ${model.date!}',
                  style: secondaryTextStyle(size: 14),
                ),
              ],
            ),
            8.height,

            // Amount Row: Claimed & Approved
            Row(
              children: [
                _buildAmountColumn(
                    language.lblClaimed, model.actualAmount!.toString()),
                16.width,
                if (model.status!.toLowerCase() == 'approved')
                  _buildAmountColumn(
                    language.lblApproved,
                    model.approvedAmount != null
                        ? model.approvedAmount.toString()
                        : model.actualAmount.toString(),
                  ),
              ],
            ),
            if (model.status!.toLowerCase() == 'pending')
              if (model.status?.toLowerCase() == 'pending')
                Align(
                  alignment: Alignment.bottomRight,
                  child: buildActionButton(
                    icon: Iconsax.forbidden_2,
                    label: language.lblCancel,
                    color: Colors.red,
                    onTap: () => deleteAction(context),
                  ),
                ).paddingRight(12),
          ],
        ),
      ),
    );
  }

  // Status Color Helper
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return Colors.green.shade500;
      case 'rejected':
        return Colors.red.shade500;
      default:
        return Colors.orange.shade500;
    }
  }

  // Build Amount Column
  Widget _buildAmountColumn(String title, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: secondaryTextStyle(size: 12, color: Colors.grey),
        ),
        4.height,
        Text(
          '${getStringAsync(appCurrencySymbolPref)}$amount',
          style: boldTextStyle(size: 14),
        ),
      ],
    );
  }
}
