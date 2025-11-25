import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../../models/Document/document_request_model.dart';
import '../../models/Document/document_type_model.dart';

part 'document_store.g.dart';

class DocumentStore = DocumentStoreBase with _$DocumentStore;

abstract class DocumentStoreBase with Store {
  static const pageSize = 10;

  @observable
  PagingController<int, DocumentRequestModel> pagingController =
      PagingController(firstPageKey: 0);

  String? selectedStatus;

  String dateFilter = '';

  @observable
  bool isDownloadLoading = false;

  @observable
  ObservableList<String> statuses = ObservableList.of([
    'pending',
    'approved',
    'rejected',
    'cancelled',
    'generated',
  ]);

  @observable
  TextEditingController dateFilterController = TextEditingController();

  @observable
  bool isLoading = false;

  List<DocumentTypeModel> documentTypes = [];

  int? selectedTypeId;

  @observable
  List<DocumentRequestModel> documentRequests = [];

  final formKey = GlobalKey<FormState>();
  final commentsCont = TextEditingController();
  final commentsNode = FocusNode();

  @action
  Future<void> fetchDocumentRequests(int pageKey) async {
    try {
      var result = await apiService.getDocumentRequests(
        skip: pageKey,
        take: pageSize,
        status: selectedStatus,
        date: dateFilterController.text,
      );

      if (result != null) {
        final isLastPage = result.totalCount < pageSize;
        if (isLastPage) {
          pagingController.appendLastPage(result.values);
        } else {
          pagingController.appendPage(
              result.values, pageKey + result.values.length);
        }
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  @action
  Future<bool> sendDocumentRequest() async {
    if (selectedTypeId == null) {
      toast(language.lblPleaseSelectADocumentType);
      return false;
    }
    if (formKey.currentState!.validate()) {
      isLoading = true;
      var result = await apiService.createDocumentRequest(
        typeId: selectedTypeId!,
        comments: commentsCont.text,
      );
      isLoading = false;
      return result;
    }
    return false;
  }

  @action
  Future getDocumentTypes() async {
    isLoading = true;
    documentTypes = await apiService.getDocumentTypes();
    if (documentTypes.isNotEmpty) selectedTypeId = documentTypes.first.id;
    isLoading = false;
  }

  @action
  Future getDocumentFileUrl(int id) async {
    isDownloadLoading = true;
    var url = await apiService.getDocumentFileUrl(id);
    isDownloadLoading = false;
    if (url != null) {
      await _launchUrl(Uri.parse(url));
    }
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      log('Could not launch $url');
    }
  }

  @action
  Future<bool> cancelDocumentRequest(int id) async {
    isLoading = true;
    var result = await apiService.cancelDocumentRequest(id);
    isLoading = false;
    return result;
  }
}
