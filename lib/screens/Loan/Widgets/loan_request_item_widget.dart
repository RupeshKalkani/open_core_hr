import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/Utils/app_widgets.dart';
import 'package:open_core_hr/models/Loan/loan_request_model.dart';

import '../../../Utils/app_constants.dart';
import '../../../main.dart';

class LoanRequestItemWidget extends StatelessWidget {
  final int index;
  final LoanRequestModel model;
  final Function(BuildContext) deleteAction;

  const LoanRequestItemWidget({
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailColumn(
                  language.lblAmount,
                  '${getStringAsync(appCurrencySymbolPref)}${model.amount}',
                ),
                Chip(
                  side: BorderSide(color: Colors.transparent),
                  label: Text(
                    model.status!.capitalizeFirstLetter(),
                    style: primaryTextStyle(color: Colors.white, size: 12),
                  ),
                  backgroundColor: _getStatusColor(model.status),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                ),
              ],
            ),
            12.height,

            // Requested On Date
            _buildDetailRow(
              icon: Icons.calendar_today,
              label: language.lblRequestedOn,
              value: model.createdAt.toString(),
            ),

            if (model.status == 'pending')
              Align(
                alignment: Alignment.centerRight,
                child: buildActionButton(
                  icon: Iconsax.forbidden_2,
                  label: language.lblCancel,
                  color: Colors.red,
                  onTap: () {
                    deleteAction(context);
                  },
                ),
              ).paddingRight(8),
          ],
        ),
      ),
    );
  }

  // Build Detail Row with Icon
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: appStore.appPrimaryColor),
        8.width,
        Text(
          '$label:',
          style: secondaryTextStyle(size: 14),
        ),
        8.width,
        Expanded(
          child: Text(
            value,
            style: boldTextStyle(size: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Build Column for Amount Details
  Widget _buildDetailColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: secondaryTextStyle(size: 12, color: Colors.grey),
        ),
        4.height,
        Text(
          value,
          style: boldTextStyle(size: 16, color: appStore.textPrimaryColor),
        ),
      ],
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
}
