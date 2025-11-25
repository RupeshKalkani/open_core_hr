import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../Utils/app_widgets.dart';
import '../../../main.dart';
import '../../../models/Task/task_model.dart';
import 'task_update_item.dart';
import 'task_update_store.dart';

class TaskUpdateScreen extends StatefulWidget {
  final TaskModel task;

  const TaskUpdateScreen({super.key, required this.task});

  @override
  State<TaskUpdateScreen> createState() => _TaskUpdateScreenState();
}

class _TaskUpdateScreenState extends State<TaskUpdateScreen> {
  final _store = TaskUpdateStore();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    _store.taskId = widget.task.id;
    _store.getTaskUpdated(widget.task.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context,
        language.lblTaskUpdates,
        actions: [
          IconButton(
            icon: Icon(Iconsax.refresh, color: appStore.iconColor),
            onPressed: () => init(),
          ),
        ],
      ),
      body: SafeArea(
        child: Observer(
          builder: (_) => Stack(
            children: [
              // Task Updates List
              _store.isLoading
                  ? loadingWidgetMaker()
                  : ListView.builder(
                      itemCount: _store.taskUpdates.length,
                      shrinkWrap: true,
                      reverse: true,
                      padding: const EdgeInsets.only(top: 10, bottom: 80),
                      itemBuilder: (context, index) {
                        var update = _store.taskUpdates[index];
                        return TaskUpdateItem(update: update);
                      },
                    ),

              // Bottom Message Input
              if (widget.task.status!.toLowerCase() != 'completed')
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildMessageInput(),
                )
              else
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    language.lblTaskIsCompleted,
                    style: primaryTextStyle(),
                  ).paddingOnly(bottom: 10),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      decoration: BoxDecoration(
        color: appStore.scaffoldBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _store.messageController,
              maxLines: null,
              decoration: InputDecoration(
                hintText: language.lblTypeYourMessage,
                filled: true,
                fillColor: appStore.isDarkModeOn ? cardDarkColor : white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: appStore.appColorPrimary),
                ),
                suffixIcon: _buildAttachActions(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Send Button
          Container(
            decoration: BoxDecoration(
              color: appStore.appColorPrimary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.send, color: white, size: 28)
                .paddingAll(8)
                .onTap(() {
              hideKeyboard(context);
              if (!globalAttendanceStore.isCheckedIn) {
                toast(language.lblPleaseCheckInToSendMessage);
                return;
              }
              if (_store.messageController.text.isEmptyOrNull) {
                toast(language.lblPleaseEnterMessage);
                return;
              }
              var message = _store.messageController.text;
              _store.messageController.clear();
              _store.sendMessage(message);
              setState(() {});
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Iconsax.attach_circle, color: appStore.appColorPrimary),
          onPressed: () => _showAttachmentSheet(),
          tooltip: language.lblAttachFile,
        ),
        IconButton(
          icon: Icon(Iconsax.camera, color: appStore.appColorPrimary),
          onPressed: () {
            if (!globalAttendanceStore.isCheckedIn) {
              toast(language.lblPleaseCheckInToSharePhoto);
              return;
            }
            _store.processPhoto();
          },
          tooltip: language.lblTakePhoto,
        ),
      ],
    );
  }

  void _showAttachmentSheet() {
    hideKeyboard(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: appStore.scaffoldBackground,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(language.lblTaskUpdate, style: boldTextStyle(size: 18)),
            20.height,
            Row(
              children: [
                _buildAttachmentOption(Iconsax.location, language.lblLocation,
                    () {
                  finish(context);
                  _store.shareLocation();
                }),
                16.width,
                _buildAttachmentOption(Iconsax.document, language.lblDocument,
                    () {
                  finish(context);
                  _store.processFile();
                }),
              ],
            ),
            20.height,
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: appStore.appColorPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(language.lblClose,
                  style: boldTextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(
      IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: appStore.appColorPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(icon, size: 32, color: appStore.appColorPrimary),
              8.height,
              Text(label, style: primaryTextStyle(size: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
