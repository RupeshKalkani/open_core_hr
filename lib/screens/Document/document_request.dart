import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/Utils/app_widgets.dart';
import 'package:open_core_hr/screens/Document/create_document_request_screen.dart';

import '../../main.dart';
import '../../models/Document/document_request_model.dart';
import 'document_store.dart';
import 'widget/document_request_item_widget.dart';

class DocumentRequestScreen extends StatefulWidget {
  const DocumentRequestScreen({super.key});

  @override
  State<DocumentRequestScreen> createState() => _DocumentRequestScreenState();
}

class _DocumentRequestScreenState extends State<DocumentRequestScreen> {
  final _store = DocumentStore();

  @override
  void initState() {
    super.initState();
    _store.pagingController.addPageRequestListener((pageKey) {
      _store.fetchDocumentRequests(pageKey);
    });
  }

  @override
  void dispose() {
    _store.pagingController.dispose();
    super.dispose();
  }

  Future<void> _showFilterPopup(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(language.lblFilters, style: boldTextStyle(size: 16)),
              16.height,
              // Date Filter
              TextField(
                controller: _store.dateFilterController,
                decoration: InputDecoration(
                  labelText: language.lblFilterByDate,
                  prefixIcon: const Icon(Iconsax.calendar),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _store.dateFilterController.clear();
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  hideKeyboard(context);
                  var result = await showDatePicker(
                    context: context,
                    confirmText: language.lblOk,
                    initialDate: _store.dateFilterController.text.isEmptyOrNull
                        ? DateTime.now()
                        : formDateFormatter
                            .parse(_store.dateFilterController.text),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (result != null) {
                    _store.dateFilterController.text =
                        formDateFormatter.format(result);
                  }
                },
              ),
              16.height,
              // Status Filter
              Observer(
                builder: (_) => DropdownButtonFormField<String>(
                  value: _store.selectedStatus,
                  decoration: InputDecoration(
                    labelText: language.lblSelectStatus,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  items: _store.statuses
                      .map((status) => DropdownMenuItem<String>(
                            value: status,
                            child: Text(status.capitalizeFirstLetter()),
                          ))
                      .toList(),
                  onChanged: (value) {
                    _store.selectedStatus = value;
                  },
                ),
              ),
              16.height,
              // Buttons
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Clear all filters
                      _store.dateFilterController.clear();
                      Navigator.pop(context);
                      _store.pagingController.refresh();
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: buildButtonCorner(),
                    ),
                    child: Text(language.lblReset,
                        style: primaryTextStyle(color: white)),
                  ).expand(),
                  16.width,
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appStore.appColorPrimary,
                      shape: buildButtonCorner(),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _store.dateFilter = _store.dateFilterController.text;
                      _store.pagingController.refresh();
                      setState(() {});
                    },
                    child: Text(
                      language.lblApply,
                      style: primaryTextStyle(color: white),
                    ),
                  ).expand(),
                ],
              ),
              20.height
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context,
        language.lblDocumentRequests,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.filter),
            tooltip: language.lblFilter,
            onPressed: () => _showFilterPopup(context),
          ),
        ],
      ),
      body: Observer(
        builder: (_) => _store.isDownloadLoading
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(language.lblDownloadingFilePleaseWait),
                    loadingWidgetMaker(),
                  ],
                ),
              )
            : Column(
                children: [
                  Observer(
                    builder: (_) {
                      return (_store.selectedStatus != null ||
                              _store.dateFilter != '')
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    if (_store.selectedStatus != null)
                                      Chip(
                                        side: BorderSide(
                                            color: Colors.transparent),
                                        label: Text(
                                          '${language.lblStatus}: ${_store.selectedStatus}',
                                          style: primaryTextStyle(color: white),
                                        ),
                                        backgroundColor:
                                            appStore.appColorPrimary,
                                        deleteIcon: const Icon(Icons.close,
                                            color: Colors.white),
                                        onDeleted: () {
                                          _store.selectedStatus = null;
                                          _store.pagingController.refresh();
                                          setState(() {});
                                        },
                                      ),
                                    if (_store.selectedStatus != null ||
                                        _store.dateFilter != '')
                                      5.width,
                                    if (_store.dateFilter != '')
                                      Chip(
                                        side: BorderSide(
                                            color: Colors.transparent),
                                        label: Text(
                                          '${language.lblDate}: ${_store.dateFilter}',
                                          style: primaryTextStyle(color: white),
                                        ),
                                        backgroundColor:
                                            appStore.appColorPrimary,
                                        deleteIcon: const Icon(Icons.close,
                                            color: Colors.white),
                                        onDeleted: () {
                                          _store.dateFilterController.clear();
                                          _store.dateFilter = '';
                                          _store.pagingController.refresh();
                                          setState(() {});
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox();
                    },
                  ),
                  // Document Requests List
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () =>
                          Future.sync(() => _store.pagingController.refresh()),
                      child: PagedListView<int, DocumentRequestModel>(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        pagingController: _store.pagingController,
                        builderDelegate:
                            PagedChildBuilderDelegate<DocumentRequestModel>(
                          noItemsFoundIndicatorBuilder: (context) =>
                              noDataWidget(
                                  message: language.lblNoDocumentRequestsFound),
                          itemBuilder: (context, documentRequest, index) {
                            return DocumentRequestItemWidget(
                              index: index,
                              model: documentRequest,
                              cancelAction: (BuildContext context) {
                                showConfirmDialogCustom(
                                  context,
                                  title: language
                                      .lblAreYouSureYouWantToCancelThisRequest,
                                  dialogType: DialogType.CONFIRMATION,
                                  positiveText: language.lblYes,
                                  negativeText: language.lblNo,
                                  onAccept: (c) async {
                                    await _store.cancelDocumentRequest(
                                        documentRequest.id!);
                                    _store.pagingController.refresh();
                                  },
                                );
                              },
                              downloadAction: (BuildContext context) {
                                _store.getDocumentFileUrl(documentRequest.id!);
                              },
                            ).paddingBottom(8);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: appStore.appColorPrimary,
        onPressed: () async {
          await const CreateDocumentRequestScreen().launch(context);
          _store.pagingController.refresh();
        },
        label: Row(
          children: [
            Icon(Icons.add, color: white),
            5.width,
            Text(language.lblCreate, style: TextStyle(color: white)),
          ],
        ),
      ),
    );
  }
}
