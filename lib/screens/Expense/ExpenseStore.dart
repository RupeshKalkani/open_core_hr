import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../models/Expense/expense_request_model.dart';
import '../../models/Expense/expense_type_model.dart';

part 'ExpenseStore.g.dart';

class ExpenseStore = ExpenseStoreBase with _$ExpenseStore;

abstract class ExpenseStoreBase with Store {
  static const pageSize = 10;

  @observable
  PagingController<int, ExpenseRequestModel> pagingController =
      PagingController(firstPageKey: 0);

  String? selectedStatus;

  String dateFilter = '';

  @observable
  ObservableList<String> statuses = ObservableList.of([
    'pending',
    'approved',
    'rejected',
    'cancelled',
  ]);
  @observable
  TextEditingController dateFilterController = TextEditingController();

  @observable
  bool isLoading = false;

  File? file;
  @observable
  String fileName = '';

  @observable
  String filePath = '';

  @observable
  bool isImgRequired = false;

  final today = DateTime.now();

  @observable
  DateTime selectedDate = DateTime.now();

  @observable
  ObservableList<ExpenseTypeModel> expenseTypes =
      ObservableList<ExpenseTypeModel>();

  @observable
  ExpenseTypeModel? selectedExpenseType;

  final DateFormat formatter = DateFormat('MM/dd/yyyy');

  Future<String?> getFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      file = File(result.files.single.path!);
      fileName = file!.path.split('/').last;
      filePath = file!.path;

      return fileName;
    }

    return null;
  }

  @action
  Future<void> fetchExpenseRequests(int pageKey) async {
    try {
      var result = await apiService.getExpenseRequests(
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
      log('Error: $error');
      pagingController.error = error;
    }
  }

  @action
  Future<void> cancelExpense(int id) async {
    isLoading = true;

    var result = await apiService.cancelExpenseRequest(id);

    if (result) {
      toast(language.lblExpenseRequestCancelledSuccessfully);
    }

    isLoading = false;
  }

  Future<bool> sendExpenseRequest(String amount, String remarks) async {
    isLoading = true;

    Map req = {
      "date": formatter.format(selectedDate),
      "amount": amount,
      "typeId": selectedExpenseType!.id.toString(),
      "comments": remarks
    };
    var result = await apiService.sendExpenseRequest(req);

    if (result && !filePath.isEmptyOrNull) {
      var uploadResult = await apiService.uploadExpenseDocument(filePath);
      if (!uploadResult) {
        toast(language.lblUnableToUploadTheFile);
      }
    }

    isLoading = false;

    return result;
  }

  Future loadExpenseTypes() async {
    isLoading = true;
    var result = await apiService.getExpenseTypes();

    if (result.isNotEmpty) {
      selectedExpenseType = result.first;
      if (result.first.isImgRequired!) {
        isImgRequired = true;
      }
      expenseTypes = ObservableList<ExpenseTypeModel>();
      expenseTypes.addAll(result);
    } else {
      expenseTypes = ObservableList<ExpenseTypeModel>();
    }
    isLoading = false;
  }
}
