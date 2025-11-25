import 'package:open_core_hr/screens/Task/task_update_screen/task_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../models/Task/task_model.dart';

class HoldTaskComponent extends StatefulWidget {
  final TaskModel task;
  final Function resumeTask;
  const HoldTaskComponent(
      {super.key, required this.task, required this.resumeTask});

  @override
  State<HoldTaskComponent> createState() => _HoldTaskComponentState();
}

class _HoldTaskComponentState extends State<HoldTaskComponent> {
  @override
  void initState() {
    super.initState();
  }

  void resumeTask() {
    var alert = AlertDialog(
      title: Text(language.lblResumeTask),
      content: Text(language.lblAreYouSureYouWantToResumeThisTask),
      actions: [
        TextButton(
          onPressed: () {
            widget.resumeTask();
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
                Text(
                  widget.task.description!.toString(),
                  style: primaryTextStyle(
                    color: white,
                  ),
                ),
              ],
            ),
            10.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /*    button(
                  'Resume',
                  color: Colors.amber,
                  textColor: black,
                  onTap: () {
                    var alert = AlertDialog(
                      title: const Text('Resume Task'),
                      content: const Text(
                          'Are you sure you want to resume this task?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            widget.resumeTask();
                            Navigator.pop(context);
                          },
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('No'),
                        ),
                      ],
                    );

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  },
                ),*/
                ElevatedButton(
                  onPressed: () {
                    resumeTask();
                  },
                  child: Text(
                    language.lblResume,
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
                    language.lblDetails,
                    style: boldTextStyle(),
                  ),
                ),
              ],
            ),
            10.height,
          ],
        ),
      ),
    );
  }
}
