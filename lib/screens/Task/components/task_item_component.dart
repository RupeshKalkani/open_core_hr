import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main.dart';
import '../../../models/Task/task_model.dart';
import '../../../service/map_helper.dart';

class TaskItemComponent extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onStartTask;
  final VoidCallback? onResumeTask; // Resume task callback

  const TaskItemComponent({
    super.key,
    required this.task,
    this.onStartTask,
    this.onResumeTask,
  });

  // Task Details Dialog
  void showDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Center(
          child: Text(language.lblDetails, style: boldTextStyle(size: 18)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
                Iconsax.tag, '${language.lblTaskId}:', task.id.toString()),
            _buildDetailRow(
                Iconsax.task_square, '${language.lblTitle}:', task.title!),
            _buildDetailRow(
                Iconsax.calendar_1, '${language.lblTime}:', task.forDate!),
            if (task.client != null)
              _buildDetailRow(Iconsax.profile_2user, '${language.lblClient}:',
                  task.client!.name!),
            _buildDetailRow(Iconsax.info_circle, '${language.lblDescription}:',
                task.description!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(language.lblClose,
                style: boldTextStyle(color: appStore.appColorPrimary)),
          ),
        ],
      ),
    );
  }

  // Resume Task Confirmation
  void confirmResumeTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(language.lblResumeTask, style: boldTextStyle(size: 18)),
        content: Text(language.lblAreYouSureYouWantToResumeThisTask),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(language.lblCancel, style: secondaryTextStyle()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: appStore.appColorPrimary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              onResumeTask?.call();
              Navigator.pop(context);
            },
            child: Text(language.lblResume,
                style: boldTextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Start Task Confirmation
  void confirmStartTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(language.lblStartTask, style: boldTextStyle(size: 18)),
        content: Text(language.lblAreYouSureYouWantToStartThisTask),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(language.lblCancel, style: secondaryTextStyle()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: appStore.appColorPrimary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              onStartTask?.call();
              Navigator.pop(context);
            },
            child: Text(language.lblStart,
                style: boldTextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: appStore.appColorPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                task.title!,
                style:
                    boldTextStyle(size: 16, color: appStore.textPrimaryColor),
                overflow: TextOverflow.ellipsis,
              ),
              Chip(
                side: BorderSide(color: Colors.transparent),
                label: Text(
                  task.status!,
                  style: primaryTextStyle(size: 12, color: Colors.white),
                ),
                backgroundColor: task.status!.toLowerCase() == 'inprogress'
                    ? Colors.orange
                    : task.status!.toLowerCase() == 'completed'
                        ? Colors.green
                        : task.status!.toLowerCase() == 'hold'
                            ? Colors.redAccent
                            : Colors.blue,
              ),
            ],
          ),
          8.height,

          // Date and Client Row
          Row(
            children: [
              _buildIconText(Iconsax.calendar_1, task.forDate!),
              if (task.client != null) 16.width,
              if (task.client != null)
                _buildIconText(Iconsax.profile_2user, task.client!.name!),
            ],
          ),
          12.height,

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildActionButton(Iconsax.map, language.lblMap, () {
                MapHelper helper = MapHelper();
                helper.launchMap(
                    context, task.latitude!, task.longitude!, task.title!);
              }),
              10.width,
              if (task.client != null &&
                  !task.client!.phoneNumber!.isEmptyOrNull)
                _buildActionButton(Iconsax.call, language.lblCall, () {
                  launchUrl(Uri.parse('tel:${task.client!.phoneNumber}'));
                }),
              10.width,
              _buildActionButton(Iconsax.info_circle, language.lblDetails, () {
                showDetails(context);
              }),
            ],
          ),
          8.height,

          // Start or Resume Task Button
          if (task.status!.toLowerCase() == 'new')
            _buildElevatedButton(Iconsax.play, language.lblStartTask, () {
              confirmStartTask(context);
            }),
          if (task.status!.toLowerCase() == 'hold')
            _buildElevatedButton(Iconsax.play, language.lblResumeTask, () {
              confirmResumeTask(context);
            }),
        ],
      ),
    );
  }

  // Reusable Icon Text Row
  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: appStore.appColorPrimary),
        6.width,
        Text(text, style: secondaryTextStyle(size: 14)),
      ],
    );
  }

  // Reusable Action Button
  Widget _buildActionButton(IconData icon, String tooltip, VoidCallback onTap) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: appStore.appColorPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: appStore.appColorPrimary, size: 18),
        ),
      ),
    );
  }

  // Reusable Elevated Button
  Widget _buildElevatedButton(
      IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: appStore.appColorPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: Icon(icon, color: Colors.white, size: 18),
      label: Text(label, style: boldTextStyle(color: Colors.white)),
      onPressed: onPressed,
    );
  }

  // Reusable Detail Row
  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: appStore.appColorPrimary),
          10.width,
          Expanded(
            child: Text(
              '$title $value',
              style: primaryTextStyle(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
