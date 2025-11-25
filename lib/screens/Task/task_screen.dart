import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/Utils/app_widgets.dart';
import 'package:open_core_hr/screens/Task/task_update_screen/task_update_screen.dart';

import '../../main.dart';
import 'components/task_item_component.dart';
import 'task_store.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  bool isTaskSystemEnabled = false;
  final _store = TaskStore();

  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    isTaskSystemEnabled = moduleService.isTaskModuleEnabled();
    if (isTaskSystemEnabled) _store.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    if (!isTaskSystemEnabled) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: Center(child: Text(language.lblTaskSystemIsNotEnabled)),
      );
    }

    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: _buildAppBar(),
      body: Observer(
        builder: (_) => Column(
          children: [
            // Segmented Control Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSegmentButton(1, Iconsax.clock, language.lblUpcoming,
                      _store.pendingTasks.length),
                  _buildSegmentButton(2, Iconsax.stop_circle,
                      language.lblPaused, _store.holdTasks.length),
                  _buildSegmentButton(3, Iconsax.tick_circle,
                      language.lblCompleted, _store.completedTasks.length),
                ],
              ),
            ),
            // Dynamic Task Content
            Expanded(
              child: Observer(
                builder: (_) => _buildTaskContent(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Observer(
        builder: (_) {
          if (_store.hasRunningTasks && !_store.isLoading) {
            return _buildRunningTaskBottom();
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // AppBar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: appStore.scaffoldBackground,
      elevation: 0,
      title: Text(language.lblTasks, style: boldTextStyle(size: 20)),
      actions: [
        Icon(Iconsax.refresh)
            .paddingAll(6)
            .onTap(() => _store.getTasks())
            .withTooltip(msg: language.lblRefresh),
      ],
    );
  }

  // Segment Button with Count
  Widget _buildSegmentButton(
      int index, IconData icon, String label, int count) {
    bool isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? appStore.appPrimaryColor.withOpacity(0.1)
                : Colors.transparent,
            border: Border.all(
                color: isSelected
                    ? appStore.appPrimaryColor
                    : Colors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 20,
                  color: isSelected ? appStore.appPrimaryColor : Colors.grey),
              const SizedBox(height: 4),
              Text(
                "$label ($count)",
                style: primaryTextStyle(
                    size: 12,
                    color: isSelected ? appStore.appPrimaryColor : Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Task List Content
  Widget _buildTaskContent() {
    switch (_selectedIndex) {
      case 1:
        return _buildTaskList(_store.pendingTasks, language.lblNoUpcomingTasks);
      case 2:
        return _buildTaskList(_store.holdTasks, language.lblNoTasksAreOnHold);
      case 3:
        return _buildTaskList(
            _store.completedTasks, language.lblNoCompletedTasks);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTaskList(List tasks, String noTasksMessage) {
    return tasks.isEmpty
        ? Center(child: Text(noTasksMessage, style: secondaryTextStyle()))
        : Observer(
            builder: (_) => _store.isLoading
                ? loadingWidgetMaker()
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: tasks.length,
                    itemBuilder: (_, index) {
                      return TaskItemComponent(
                        task: tasks[index],
                        onStartTask: () async {
                          var result = await _store.startTask(tasks[index].id!);
                          if (result) {
                            toast(language.lblTaskStartedSuccessfully);
                          }
                        },
                        onResumeTask: () async {
                          var result =
                              await _store.resumeTask(tasks[index].id!);
                          if (result) {
                            toast(language.lblTaskResumedSuccessfully);
                          }
                        },
                      );
                    },
                  ),
          );
  }

  Widget _buildRunningTaskBottom() {
    return Stack(
      clipBehavior: Clip.none, // Allow floating elements
      children: [
        // Bottom Container
        Container(
          padding: const EdgeInsets.only(
              top: 40, left: 12, right: 12, bottom: 12), // Extra top padding
          decoration: BoxDecoration(
            color: appStore.appPrimaryColor.withOpacity(0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Task Title Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _store.runningTask?.title ?? '',
                      style: boldTextStyle(size: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
              8.height,
              // Infinite Progress Bar
              LinearProgressIndicator(
                backgroundColor: Colors.grey.shade300,
                valueColor:
                    AlwaysStoppedAnimation<Color>(appStore.appPrimaryColor),
              ),
              8.height,
              // Complete Task Button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => _confirmCompleteTask(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appStore.appPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    language.lblCompleteTask,
                    style: boldTextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Floating Actions
        Positioned(
          top: -20,
          right: 16,
          left: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left-side spacing (optional)
              const SizedBox(),
              // Actions
              Row(
                children: [
                  _buildFloatingAction(Iconsax.pause, language.lblPause, () {
                    _confirmPauseTask(context);
                  }),
                  20.width,
                  _buildFloatingAction(Iconsax.message, language.lblUpdates,
                      () {
                    TaskUpdateScreen(task: _store.runningTask!).launch(context);
                  }),
                  20.width,
                  _buildFloatingAction(Iconsax.more, language.lblMore, () {
                    _showTaskDetailsSheet();
                  }),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Floating Action Buttons
  Widget _buildFloatingAction(
      IconData icon, String tooltip, VoidCallback onTap) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: appStore.appPrimaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: appStore.appPrimaryColor, size: 24),
        ),
      ),
    );
  }

// Confirmation Dialog for Completing Task
  void _confirmCompleteTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(language.lblCompleteTask, style: boldTextStyle(size: 18)),
        content: Text(language.lblAreYouSureYouWantToCompleteThisTask),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(language.lblCancel, style: secondaryTextStyle()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: appStore.appPrimaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              Navigator.pop(context);
              var result = await _store.completeTask();
              if (result) toast(language.lblTaskCompletedSuccessfully);
            },
            child:
                Text(language.lblComplete, style: boldTextStyle(color: white)),
          ),
        ],
      ),
    );
  }

// Confirmation Dialog for Pausing Task
  void _confirmPauseTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(language.lblPause, style: boldTextStyle(size: 18)),
        content: Text(language.lblAreYouSureYouWantToPauseThisTask),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(language.lblCancel, style: secondaryTextStyle()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              Navigator.pop(context);
              var result = await _store.holdTask();
              if (result) toast(language.lblTaskPausedSuccessfully);
            },
            child: Text(language.lblPause, style: boldTextStyle(color: white)),
          ),
        ],
      ),
    );
  }

  void _showTaskDetailsSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_store.runningTask?.title ?? '',
                style: boldTextStyle(size: 18)),
            12.height,
            Text(language.lblDescription, style: secondaryTextStyle(size: 14)),
            8.height,
            Text(_store.runningTask?.description ?? '',
                style: primaryTextStyle(size: 14)),
            16.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [],
            ),
          ],
        ),
      ),
    );
  }
}
