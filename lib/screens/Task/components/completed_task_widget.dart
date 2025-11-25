import 'package:open_core_hr/models/Task/task_model.dart';
import 'package:open_core_hr/screens/Task/task_update_screen/task_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart';

class CompletedTaskWidget extends StatefulWidget {
  final TaskModel task;
  const CompletedTaskWidget({super.key, required this.task});

  @override
  State<CompletedTaskWidget> createState() => _CompletedTaskWidgetState();
}

class _CompletedTaskWidgetState extends State<CompletedTaskWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        TaskUpdateScreen(task: widget.task).launch(context);
      },
      child: Card(
        color: Colors.grey.shade100,
        child: ListTile(
          title: Text(
            widget.task.title!,
          ),
          subtitle: Text(
            widget.task.description!,
          ),
          trailing: const Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          leading: const Icon(
            Iconsax.task,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
