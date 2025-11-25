import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../models/Loan/loan_request_model.dart';

part 'loan_store.g.dart';

class LoanStore = LoanStoreBase with _$LoanStore;

abstract class LoanStoreBase with Store {
  static const pageSize = 10;

  @observable
  PagingController<int, LoanRequestModel> pagingController =
      PagingController(firstPageKey: 0);

  String? selectedStatus;

  @observable
  ObservableList<String> statuses = ObservableList.of([
    'pending',
    'approved',
    'rejected',
    'cancelled',
  ]);

  @observable
  bool isLoading = false;

  final TextEditingController amountController = TextEditingController();
  final FocusNode amountFocusNode = FocusNode();

  final TextEditingController remarksController = TextEditingController();
  final FocusNode remarksFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  Future<bool> requestLoan() async {
    isLoading = true;
    Map req = {
      "amount": amountController.text,
      "remarks": remarksController.text,
    };
    var result = await apiService.requestLoan(req);

    isLoading = false;
    return result;
  }

  @action
  Future<void> fetchLoanRequests(int pageKey) async {
    try {
      var result = await apiService.getLoans(
        skip: pageKey,
        take: pageSize,
        status: selectedStatus,
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
      log('Error fetching loan requests: $error');
      pagingController.error = error;
    }
  }

  @action
  Future<void> cancelLoan(int id) async {
    isLoading = true;

    var result = await apiService.cancelLoanRequest(id);

    if (result) {
      toast(language.lblLoanRequestCancelledSuccessfully);
    }

    isLoading = false;
  }
}
