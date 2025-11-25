import 'dart:async';
import 'dart:io'; // For File type

import 'package:file_picker/file_picker.dart'; // For picking files
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:nb_utils/nb_utils.dart'; // For extensions and utilities
import 'package:open_core_hr/models/my_checklist_item_model.dart'; // Adjust import path
import 'package:open_core_hr/utils/app_widgets.dart'; // For appBar, loadingWidgetMaker, newEditTextDecoration, showConfirmDialogCustom, cardDecoration etc.
import 'package:shimmer/shimmer.dart';

import '../../main.dart';
import 'MyOnboardingStore.dart'; // For appStore access (theme colors etc.)

class MyOnboardingScreen extends StatefulWidget {
  const MyOnboardingScreen({super.key});

  @override
  State<MyOnboardingScreen> createState() => _MyOnboardingScreenState();
}

class _MyOnboardingScreenState extends State<MyOnboardingScreen> {
  // Instantiate the MobX Store
  final MyOnboardingStore _store = MyOnboardingStore();

  // Date formatter for display
  final DateFormat _dateFormatter =
      DateFormat('MMM dd, yyyy'); // e.g., Mar 31, 2025

  // Controller for 'text' type task input
  final TextEditingController _textInputController = TextEditingController();
  // Track which 'text' task's input is currently active (simple state management for this screen)
  int? _currentTextTaskId;

  @override
  void initState() {
    super.initState();
    // Fetch checklist when the screen loads using scheduleMicrotask
    scheduleMicrotask(() => _store.fetchChecklist());
  }

  @override
  void dispose() {
    // Dispose the text controller to prevent memory leaks
    _textInputController.dispose();
    super.dispose();
  }

  // --- Build Shimmer Loading Placeholder ---
  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: 5, // Show 5 shimmer items
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Card(
            margin: EdgeInsets.only(bottom: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shimmer for Title and Status
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: context.width() * 0.5,
                            height: 16.0,
                            color: Colors.white), // Title Placeholder
                        Container(
                            width: 80,
                            height: 20.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    16))) // Status Placeholder
                      ]),
                  10.height,
                  // Shimmer for Description
                  Container(
                      width: double.infinity,
                      height: 14.0,
                      color: Colors.white),
                  6.height,
                  Container(
                      width: context.width() * 0.7,
                      height: 14.0,
                      color: Colors.white),
                  10.height,
                  // Shimmer for Due Date
                  Container(width: 120, height: 12.0, color: Colors.white),
                  12.height,
                  // Shimmer for Action Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                        width: 130,
                        height: 35.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8))),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  // --- End Shimmer ---

  // --- File Picking and Uploading Logic ---
  Future<void> _pickAndUploadFile(int checklistItemId) async {
    // Hide keyboard if open
    hideKeyboard(context);

    // Define allowed extensions based on common document/image types
    List<String> allowedExtensions = [
      'pdf',
      'doc',
      'docx',
      'jpg',
      'jpeg',
      'png'
    ];

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        log("File picked: ${file.path}"); // Log path

        // Optional: Check file size locally before uploading (if desired)
        int fileSize = await file.length();
        if (fileSize > (10 * 1024 * 1024)) {
          // Example: 10MB limit check
          toast("File size exceeds the 10MB limit.");
          return;
        }

        // Call the store action to upload the file
        await _store.uploadFile(checklistItemId, file.path);
        // The store action will handle loading state and refreshing the list
      } else {
        // User canceled the picker or path is null
        log("File selection cancelled.");
        // toast("File selection cancelled."); // Optional feedback
      }
    } catch (e) {
      log("Error picking/uploading file: $e");
      toast("An error occurred while selecting or uploading the file.");
    }
  }
  // --- End File Picking ---

  // --- Helper to build action area based on type and status ---
  Widget _buildActionArea(MyChecklistItemModel item) {
    // Define possible statuses
    const String statusCompleted = 'COMPLETED';
    const String statusNeedsReview = 'NEEDS_REVIEW';
    const String statusInProgress = 'IN_PROGRESS';
    const String statusPending = 'PENDING';

    // --- Terminal States for Employee Interaction ---
    if (item.status == statusCompleted) {
      if (item.completedAt != null) {
        try {
          // Format completion date/time for display
          final completedDateTime = DateTime.parse(item.completedAt!)
              .toLocal(); // Parse and convert to local time
          final formattedCompleted =
              DateFormat('MMM dd, yyyy hh:mm a').format(completedDateTime);
          return Text("Completed on $formattedCompleted",
              style:
                  secondaryTextStyle(color: Colors.green.shade700, size: 12));
        } catch (e) {
          log("Error formatting completed date: ${item.completedAt}");
          return Text('Completed',
              style: secondaryTextStyle(
                  color: Colors.green.shade700, size: 12)); // Fallback
        }
      } else {
        return Text('Completed',
            style: secondaryTextStyle(color: Colors.green.shade700, size: 12));
      }
    }
    // Show file info if submitted and needs review
    if (item.status == statusNeedsReview && item.isFileUploaded) {
      return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text("Submitted, Pending Review",
            style: secondaryTextStyle(color: Colors.purple.shade600, size: 12)),
        4.height,
        Row(
          // Show uploaded file info
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.attach_file_outlined,
                color: Colors.grey.shade700, size: 14),
            4.width,
            Expanded(
                child: Text(
              item.uploadedFileName ?? 'Uploaded File',
              style: secondaryTextStyle(size: 12),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            )),
            // Optional: Add view/download button if URL available and needed for employee
            // if (item.uploadedFileUrl != null) IconButton(icon: Icon(Icons.visibility, size: 16,), padding: EdgeInsets.zero, constraints: BoxConstraints(), onPressed: () => _store.apiService.launchDownloadUrl(item.uploadedFileUrl)),
          ],
        )
      ]);
    }
    // --- End Terminal States ---

    // --- Actionable States (PENDING, IN_PROGRESS) based on Type ---
    String taskTypeLower =
        item.taskType?.toLowerCase() ?? 'task'; // Default to 'task' if null

    // 1. Text/Acknowledgement Task
    if (taskTypeLower == 'text') {
      bool isCurrentTextTask = _currentTextTaskId == item.id;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Show input field only when this specific task's button was clicked first
          if (isCurrentTextTask)
            TextFormField(
              controller: _textInputController,
              decoration: newEditTextDecoration(
                      Icons.abc, // No icon needed usually for multiline
                      "Enter acknowledgement or details here..." // Placeholder text
                      )
                  .copyWith(
                // Customize decoration if needed
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                // Remove focused border color change if desired
              ),
              maxLines: 3,
              style: primaryTextStyle(),
              textCapitalization: TextCapitalization.sentences,
              validator: (s) =>
                  s.isEmptyOrNull ? "This field is required" : null,
            ).paddingBottom(8),

          // Button to activate input or submit
          AppButton(
            text: isCurrentTextTask
                ? "Submit Details"
                : "Acknowledge / Add Details",
            height: 35, // Make buttons slightly smaller/consistent
            color: isCurrentTextTask
                ? Colors.green.shade600
                : appStore.appColorPrimary, // Use theme color
            textColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            textStyle: secondaryTextStyle(color: Colors.white, size: 12),
            shapeBorder: buildButtonCorner(), // Assuming helper exists
            // Disable button while store is processing any action
            onTap: _store.isLoading
                ? null
                : () {
                    if (!isCurrentTextTask) {
                      // First click: Show the input field, populate, and set focus
                      setState(() {
                        _currentTextTaskId = item.id;
                        _textInputController.text =
                            item.employeeNotes ?? ''; // Pre-fill notes
                      });
                      // TODO: Add FocusNode management if needed for auto-focus
                    } else {
                      // Second click: Submit the text input
                      hideKeyboard(context); // Dismiss keyboard
                      final notes = _textInputController.text.trim();
                      if (notes.isEmpty) {
                        toast("Please enter acknowledgement or details.");
                        return; // Simple validation
                      }
                      // Show confirmation before submitting
                      showConfirmDialogCustom(
                        context,
                        title: "Submit Task?",
                        subTitle:
                            "Confirm submission with the entered details.",
                        dialogType: DialogType.CONFIRMATION,
                        positiveText: "Submit",
                        negativeText: "Cancel",
                        onAccept: (c) async {
                          // Call store action with notes
                          bool success = await _store.updateStatus(
                              item.id!, statusCompleted,
                              employeeNotes: notes);
                          if (success && mounted) {
                            // Hide input after successful submit
                            setState(() {
                              _currentTextTaskId = null;
                            });
                          }
                        },
                      );
                    }
                  },
          ),
        ],
      );
    }

    // 2. File Upload Task
    if (taskTypeLower == 'file_upload') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Display uploaded file info if it exists (and status isn't NEEDS_REVIEW yet)
          if (item.isFileUploaded)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.check_circle_outline, color: Colors.green, size: 16),
                4.width,
                Expanded(
                    child: Text(
                  item.uploadedFileName ?? 'File Uploaded',
                  style: secondaryTextStyle(
                      color: Colors.green.shade700, size: 12),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                )),
              ],
            ).paddingBottom(8),

          // Upload/Replace Button
          AppButton(
            text: item.isFileUploaded ? "Replace File" : "Upload File",
            height: 35,
            color: appStore.appColorPrimary, // Use theme color
            textColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            textStyle: secondaryTextStyle(color: Colors.white, size: 12),
            shapeBorder: buildButtonCorner(),
            // Disable button while store is processing
            onTap: _store.isLoading
                ? null
                : () {
                    // Trigger file picker and upload action
                    _pickAndUploadFile(item.id!);
                  },
          ),
        ],
      );
    }

    // 3. Other Simple Task Types (TASK, EXTERNAL_LINK etc.)
    // Assuming these just need a "Mark Complete" button
    List<String> simpleCompleteTypes = [
      'task',
      'external_link',
      'manager_task'
    ]; // Define types handled by simple button
    if (simpleCompleteTypes.contains(taskTypeLower)) {
      return AppButton(
        text: "Mark as Complete",
        height: 35,
        color: appStore.appColorPrimary,
        textColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: secondaryTextStyle(color: Colors.white, size: 12),
        shapeBorder: buildButtonCorner(),
        // Disable button while store is processing
        onTap: _store.isLoading
            ? null
            : () {
                showConfirmDialogCustom(
                  context,
                  title: "Mark Task as Complete?",
                  dialogType: DialogType.CONFIRMATION,
                  positiveText: "Yes",
                  negativeText: "No",
                  onAccept: (c) async {
                    // Call store action without notes
                    await _store.updateStatus(item.id!, statusCompleted);
                  },
                );
              },
      );
    }

    // Default for unknown or unhandled types
    return Text('Action TBD', style: secondaryTextStyle(size: 12));
  }

  // Helper to get status badge background color
  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'PENDING':
        return Colors.orange.shade600;
      case 'COMPLETED':
        return Colors.green.shade600;
      case 'IN_PROGRESS':
        return Colors.blue.shade600;
      case 'NEEDS_REVIEW':
        return Colors.purple.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          appBar(context, "My Onboarding Checklist", hideBack: true, actions: [
        //Logout alert
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            showConfirmDialogCustom(
              context,
              title: "Logout",
              subTitle: "Are you sure you want to logout?",
              positiveText: "Logout",
              negativeText: "Cancel",
              onAccept: (c) {
                // Handle logout logic here
                sharedHelper.logout(context);
              },
            );
          },
        ),
      ]), // Using direct string
      body: Observer(
        // Use Observer to react to MobX state changes
        builder: (_) {
          if (_store.isLoading) {
            return _buildShimmerList();
          }
          // --- Loading State ---
          if (_store.isLoading && _store.checklistItems.isEmpty) {
            return loadingWidgetMaker(); // Show centered loading indicator on initial load
          }
          // --- Error State ---
          if (_store.errorMessage != null && _store.checklistItems.isEmpty) {
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text(_store.errorMessage ?? 'An error occurred.'),
                  16.height,
                  ElevatedButton(
                      onPressed: () => _store.fetchChecklist(),
                      child: Text("Retry"))
                ]));
          }
          // --- Empty State ---
          if (_store.checklistItems.isEmpty && !_store.isLoading) {
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text(
                      "Your onboarding checklist is not available yet.\nPlease check back later.",
                      textAlign: TextAlign.center),
                  16.height,
                  ElevatedButton(
                      onPressed: () => _store.fetchChecklist(),
                      child: Text("Refresh"))
                ]));
          }

          // --- Display Checklist ---
          return RefreshIndicator(
            color: appStore.appColorPrimary, // Use theme color for indicator
            onRefresh: () => Future.sync(
                () => _store.fetchChecklist()), // Allow pull-to-refresh
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _store.checklistItems.length,
              itemBuilder: (context, index) {
                final item = _store.checklistItems[index];
                DateTime? dueDate = item.dueDate != null
                    ? DateTime.tryParse(item.dueDate!)?.toLocal()
                    : null; // Parse and convert to local

                var statusCompleted = 'COMPLETED';

                return Card(
                  // Using Card for each item
                  margin: EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Status Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                item.title ?? 'Task Title',
                                style: boldTextStyle(
                                    size: 15), // Slightly smaller title
                              ),
                            ),
                            8.width, // Spacer
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                  color: _getStatusColor(item.status)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16)),
                              child: Text(
                                item.status
                                        ?.replaceAll('_', ' ')
                                        .capitalizeFirstLetter() ??
                                    'Unknown',
                                style: secondaryTextStyle(
                                    size: 11,
                                    color: _getStatusColor(
                                        item.status)), // Smaller status text
                              ),
                            )
                          ],
                        ),
                        10.height,

                        // Description (if exists)
                        if (item.description != null &&
                            item.description!.isNotEmpty)
                          Text(
                            item.description!,
                            style: secondaryTextStyle(
                                size: 13), // Slightly smaller description
                          ),
                        if (item.description != null &&
                            item.description!.isNotEmpty)
                          10.height,

                        // Meta Row: Due Date
                        if (dueDate != null)
                          Row(
                            children: [
                              Icon(Icons.calendar_today_outlined,
                                  size: 14, color: Colors.grey.shade700),
                              4.width,
                              Text(
                                "Due: ${_dateFormatter.format(dueDate)}",
                                // Highlight if overdue and not completed
                                style: (dueDate.isBefore(DateTime.now()) &&
                                        item.status != statusCompleted)
                                    ? secondaryTextStyle(
                                        size: 12, color: Colors.red.shade600)
                                    : secondaryTextStyle(
                                        size: 12, color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                        if (dueDate != null) 12.height, // Space before actions

                        // Action Area (Right Aligned)
                        Align(
                          alignment: Alignment.centerRight,
                          child: _buildActionArea(item), // Use the helper
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  } // End build method
} // End State Class
