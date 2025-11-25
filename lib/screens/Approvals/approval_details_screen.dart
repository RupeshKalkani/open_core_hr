import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/screens/Approvals/approval_store.dart';

import '../../Utils/app_constants.dart';
import '../../Utils/app_widgets.dart';
import '../../main.dart';
import '../../models/Approval/approval_request_model.dart';

class ApprovalDetailsScreen extends StatefulWidget {
  final ApprovalRequestModel request;
  const ApprovalDetailsScreen({super.key, required this.request});

  @override
  State<ApprovalDetailsScreen> createState() => _ApprovalDetailsScreenState();
}

class _ApprovalDetailsScreenState extends State<ApprovalDetailsScreen> {
  final ApprovalStore _store = ApprovalStore();

  @override
  void initState() {
    super.initState();
  }

  /// Shows a simple confirmation dialog. Returns true if confirmed.
  Future<bool?> _showConfirmationDialog(String action) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm $action"),
        content: Text("Are you sure you want to $action this request?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  /// Shows an input dialog for additional fields.
  ///
  /// For expense requests when approving: displays an Approved Amount field (mandatory) and a Comments field.
  /// For expense requests when rejecting and for leave requests: displays only a Comments field.
  Future<Map<String, dynamic>?> _showActionDialog(
      String category, String action) async {
    final approvedAmountController = TextEditingController();
    final commentsController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    // Only show approved amount if the category is expense and the action is "approved"
    bool showApprovedAmountField =
        (category == 'expense' && action == 'approved');

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            "Confirm ${action.capitalizeFirstLetter()} ${category.capitalizeFirstLetter()} Request"),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showApprovedAmountField) ...[
                TextFormField(
                  controller: approvedAmountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Approved Amount',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Approved amount is required';
                    }
                    return null;
                  },
                ),
                16.height,
              ],
              TextFormField(
                controller: commentsController,
                decoration: const InputDecoration(
                  labelText: 'Comments',
                ),
                maxLines: 3,
                // Comments are optional for leave and for expense rejection.
                // You can add a validator if required for expense approval.
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(context).pop({
                  'approvedAmount': showApprovedAmountField
                      ? approvedAmountController.text
                      : null,
                  'comments': commentsController.text,
                });
              }
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  /// Handles the action (approve/reject) by first confirming then, if needed, collecting extra inputs.
  Future<void> _handleAction(String action) async {
    bool? confirmed = await _showConfirmationDialog(action);
    if (confirmed != true) return;
    String category = widget.request.category.toLowerCase();

    Map<String, dynamic>? extra;
    // For expense requests and leave requests, show extra input dialog.
    // For expense requests, show Approved Amount only when approving.
    if (category == 'expense' || category == 'leave') {
      extra = await _showActionDialog(category, action);
      if (extra == null) return;
    } else {
      extra = {};
    }

    var result = await _store.takeAction(
      category,
      widget.request.id,
      action,
      approvedAmount: extra['approvedAmount'],
      comments: extra['comments'],
    );
    if (result) {
      toast('Request ${action.capitalizeFirstLetter()}d');
      finish(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        backgroundColor: appStore.scaffoldBackground,
        appBar: appBar(context, 'Request Details'),
        body: _store.isLoading
            ? loadingWidgetMaker()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title & Type Card
                    _buildCard(
                      children: [
                        Row(
                          children: [
                            Icon(Iconsax.document,
                                color: appStore.appColorPrimary),
                            8.width,
                            Text(widget.request.title,
                                style: boldTextStyle(size: 20)),
                          ],
                        ),
                        8.height,
                        Row(
                          children: [
                            Icon(Iconsax.tag, size: 18, color: Colors.grey),
                            8.width,
                            Text('Type: ${widget.request.type}',
                                style: secondaryTextStyle()),
                          ],
                        ),
                      ],
                    ),
                    16.height,

                    /// Status Card
                    _buildCard(
                      children: [
                        Row(
                          children: [
                            Icon(Iconsax.status, size: 20, color: Colors.grey),
                            8.width,
                            Text('Status: ${widget.request.status}',
                                style: primaryTextStyle()),
                          ],
                        ),
                      ],
                    ),
                    16.height,

                    /// Requested By & Date Card
                    _buildCard(
                      children: [
                        Row(
                          children: [
                            Icon(Iconsax.user, size: 20, color: Colors.grey),
                            8.width,
                            Text('Requested By: ${widget.request.requestedBy}',
                                style: primaryTextStyle()),
                          ],
                        ),
                        8.height,
                        if (widget.request.category.toLowerCase() ==
                            'leave') ...[
                          Row(
                            children: [
                              Icon(Iconsax.calendar,
                                  size: 20, color: Colors.grey),
                              8.width,
                              Text('From: ${widget.request.fromDate}',
                                  style: primaryTextStyle()),
                            ],
                          ),
                          8.height,
                          Row(
                            children: [
                              Icon(Iconsax.calendar,
                                  size: 20, color: Colors.grey),
                              8.width,
                              Text('To: ${widget.request.toDate}',
                                  style: primaryTextStyle()),
                            ],
                          ),
                        ] else
                          //Amount Field
                          Row(
                            children: [
                              Icon(Iconsax.wallet,
                                  size: 20, color: Colors.grey),
                              8.width,
                              Text(
                                  'Amount: ${getStringAsync(appCurrencySymbolPref)}${widget.request.amount}',
                                  style: primaryTextStyle()),
                            ],
                          ),
                        8.height,
                        Row(
                          children: [
                            Icon(Iconsax.calendar,
                                size: 20, color: Colors.grey),
                            8.width,
                            Text('Date: ${widget.request.date}',
                                style: primaryTextStyle()),
                          ],
                        ),
                      ],
                    ),
                    16.height,

                    /// Description Card
                    _buildCard(
                      children: [
                        Text('Description', style: boldTextStyle(size: 16)),
                        8.height,
                        Text(
                            widget.request.description.isEmptyOrNull
                                ? 'N/A'
                                : widget.request.description,
                            style: primaryTextStyle()),
                      ],
                    ),
                    16.height,

                    /// Attachment Card (if any)
                    _buildCard(
                      children: [
                        Text('Attachment', style: boldTextStyle(size: 16)),
                        8.height,
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[200],
                            image: widget.request.attachmentUrl.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(
                                        widget.request.attachmentUrl),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: widget.request.attachmentUrl.isEmpty
                              ? Center(
                                  child: Icon(Iconsax.image,
                                      size: 48, color: Colors.grey[400]),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
        bottomNavigationBar: _store.isLoading
            ? Container()
            : widget.request.status.toLowerCase() == 'pending'
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border(top: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _handleAction('approved'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: const Icon(Icons.check, color: Colors.white),
                          label: const Text('Approve',
                              style: TextStyle(color: Colors.white)),
                        ).expand(),
                        16.width,
                        ElevatedButton.icon(
                          onPressed: () => _handleAction('rejected'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: const Icon(Icons.close, color: Colors.white),
                          label: const Text('Reject',
                              style: TextStyle(color: Colors.white)),
                        ).expand(),
                      ],
                    ).paddingBottom(10),
                  )
                : null,
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
