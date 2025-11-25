import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../models/Document/document_request_model.dart';
import '../../../utils/app_widgets.dart';

class DocumentRequestItemWidget extends StatelessWidget {
  final int index;
  final DocumentRequestModel model;
  final Function(BuildContext) cancelAction;
  final Function(BuildContext) downloadAction;

  const DocumentRequestItemWidget({
    super.key,
    required this.index,
    required this.model,
    required this.cancelAction,
    required this.downloadAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: cardDecoration(),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.documentTypeName ?? 'N/A',
                      style: boldTextStyle(size: 16),
                    ),
                    8.height,
                    _buildDetailRow(Iconsax.calendar_1, language.lblRequestedOn,
                        model.createdAt ?? 'N/A'),
                    12.height,
                  ],
                ),
              ),

              // Right Section: Status Chip
              Chip(
                side: BorderSide(color: Colors.transparent),
                label: Text(
                  model.status?.capitalizeFirstLetter() ?? 'Pending',
                  style: boldTextStyle(color: Colors.white, size: 12),
                ),
                backgroundColor: _getStatusColor(model.status),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              ),
            ],
          ),
          // Conditional Action Buttons
          if (model.status?.toLowerCase() == 'pending')
            Align(
              alignment: Alignment.centerRight,
              child: buildActionButton(
                icon: Iconsax.forbidden_2,
                label: language.lblCancel,
                color: Colors.red,
                onTap: () => cancelAction(context),
              ).paddingRight(6),
            ),
          if (model.status?.toLowerCase() == 'generated')
            Align(
              alignment: Alignment.centerRight,
              child: buildActionButton(
                icon: Iconsax.document_download,
                label: language.lblDownloadDocument,
                color: Colors.blue,
                onTap: () => downloadAction(context),
              ).paddingRight(8),
            ),
        ],
      ),
    );
  }

  // Helper to build a detail row
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: appStore.appPrimaryColor),
        6.width,
        Text('$label: ', style: secondaryTextStyle(size: 12)),
        Expanded(
          child: Text(value, style: boldTextStyle(size: 12)),
        ),
      ],
    );
  }

  // Helper to get status color
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return Colors.green.shade500;
      case 'rejected':
        return Colors.red.shade500;
      case 'generated':
        return Colors.blue.shade500;
      default:
        return Colors.orange.shade500;
    }
  }
}
