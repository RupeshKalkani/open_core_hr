import 'package:open_core_hr/screens/Task/task_update_screen/task_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../models/Task/task_model.dart';

class RunningTaskComponent extends StatefulWidget {
  final TaskModel task;
  final Function holdTask;
  final Function completeTask;
  const RunningTaskComponent(
      {super.key,
      required this.task,
      required this.holdTask,
      required this.completeTask});

  @override
  State<RunningTaskComponent> createState() => _RunningTaskComponentState();
}

class _RunningTaskComponentState extends State<RunningTaskComponent> {
  void holdTask() {
    var alert = AlertDialog(
      title: Text(language.lblHoldTask),
      content: Text(language.lblAreYouSureYouWantToHoldThisTask),
      actions: [
        TextButton(
          onPressed: () {
            widget.holdTask();
            Navigator.pop(context);
          },
          child: Text(language.lblYes),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(language.lblNo),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void completeTask() {
    var alert = AlertDialog(
      title: Text(language.lblCompleteTask),
      content: Text(language.lblAreYouSureYouWantToCompleteThisTask),
      actions: [
        TextButton(
          onPressed: () {
            widget.completeTask();
            Navigator.pop(context);
          },
          child: Text(language.lblYes),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(language.lblNo),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: appStore.appColorPrimary,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              color: appStore.appColorPrimary.withOpacity(0.6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${language.lblTaskId}: ${widget.task.id}',
                    style: boldTextStyle(color: white),
                  ),
                  Text(
                    '${language.lblStatus}: ${widget.task.status}',
                    style: boldTextStyle(color: white),
                  ),
                ],
              ).paddingOnly(left: 16, right: 16, top: 16, bottom: 16),
            ),
            10.height,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${language.lblTitle}: ${widget.task.title}',
                  style: boldTextStyle(color: white),
                ),
                Text(
                  '${language.lblStartedOn}: ${widget.task.startDateTime!}',
                  style: boldTextStyle(color: white),
                ),
              ],
            ),
            10.height,
            Text(
              '${language.lblDetails}:',
              style: boldTextStyle(color: white),
            ),
            5.height,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Text(
                    widget.task.description!.toString(),
                    style: primaryTextStyle(
                      color: white,
                    ),
                  ),
                ),
              ],
            ),
            10.height,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    holdTask();
                  },
                  child: Text(
                    language.lblHold,
                    style: boldTextStyle(),
                  ),
                ),
                10.width,
                ElevatedButton(
                  onPressed: () {
                    completeTask();
                  },
                  child: Text(
                    language.lblComplete,
                    style: boldTextStyle(),
                  ),
                ),
                10.width,
                ElevatedButton(
                  onPressed: () {
                    TaskUpdateScreen(
                      task: widget.task,
                    ).launch(context);
                  },
                  child: Text(
                    language.lblUpdates,
                    style: boldTextStyle(),
                  ),
                ),
              ],
            ),
            10.height,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LinearProgressIndicator(
                borderRadius: BorderRadius.circular(10),
                minHeight: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
