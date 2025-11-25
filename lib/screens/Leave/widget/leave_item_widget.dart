import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/models/leave_request_model.dart';

import '../../../main.dart';
import '../../../utils/app_widgets.dart';

class LeaveItemWidget extends StatelessWidget {
  final int index;
  final LeaveRequestModel model;
  final Function(BuildContext) deleteAction;

  const LeaveItemWidget({
    super.key,
    required this.index,
    required this.model,
    required this.deleteAction,
  });

  @override
  Widget build(BuildContext context) {
    Color getStatusColor() {
      switch (model.status?.toLowerCase()) {
        case 'approved':
          return Colors.green.shade400;
        case 'rejected':
          return Colors.red.shade400;
        default:
          return Colors.orange.shade400;
      }
    }

    Color getStatusTextColor() {
      switch (model.status?.toLowerCase()) {
        case 'approved':
          return Colors.green.shade700;
        case 'rejected':
          return Colors.red.shade700;
        default:
          return Colors.orange.shade700;
      }
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: cardDecoration(),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon or Leading Section
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: getStatusColor(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.calendar_today_outlined, color: white),
              ),
              12.width,

              // Main Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.leaveType ?? '',
                      style: boldTextStyle(size: 18),
                    ),
                    4.height,
                    Text(
                      '${language.lblAppliedOn}: ${model.createdOn}',
                      style: secondaryTextStyle(size: 14),
                    ),
                    8.height,
                    Text(
                      '${language.lblDuration}: ${model.fromDate} ${language.lblTo} ${model.toDate}',
                      style: primaryTextStyle(size: 14),
                    ),
                  ],
                ),
              ),

              // Status Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  model.status?.capitalizeFirstLetter() ?? '',
                  style: boldTextStyle(size: 12, color: getStatusTextColor()),
                ),
              ),
            ],
          ),
          // Delete Button
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
    );
  }
}
