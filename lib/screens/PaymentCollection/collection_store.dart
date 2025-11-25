import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobx/mobx.dart';

import '../../main.dart';
import '../../models/Client/client_model.dart';
import '../../models/PaymentCollection/payment_collection_model.dart';

part 'collection_store.g.dart';

class CollectionStore = CollectionStoreBase with _$CollectionStore;

abstract class CollectionStoreBase with Store {
  static const pageSize = 10;

  ClientModel? selectedClient;

  final formKey = GlobalKey<FormState>();

  final clientController = TextEditingController();
  final clientFocusNode = FocusNode();

  final amountController = TextEditingController();
  final amountFocusNode = FocusNode();

  final paymentModeController = TextEditingController();
  final paymentModeFocusNode = FocusNode();

  final remarksController = TextEditingController();
  final remarksFocusNode = FocusNode();

  final paymentModes = ['Cash', 'Cheque', 'Online', 'Other'];

  @observable
  bool isLoading = false;

  @observable
  String dateFilter = '';

  TextEditingController dateFilterController = TextEditingController();

  final PagingController<int, PaymentCollectionModel> pagingController =
      PagingController(firstPageKey: 0);

  @action
  Future<bool> createCollection() async {
    isLoading = true;
    Map req = {
      'clientId': selectedClient!.id.toString(),
      'amount': amountController.text,
      'paymentType': paymentModeController.text,
      'remarks': remarksController.text,
    };

    var result = await apiService.createPaymentCollection(req);

    isLoading = false;
    return result;
  }

  @action
  Future<void> fetchPaymentCollections(int pageKey) async {
    try {
      var result = await apiService.getPaymentCollection(
        skip: pageKey,
        take: pageSize,
        date: dateFilterController.text,
      );

      if (result != null) {
        final isLastPage = result.totalCount! < pageSize;
        if (isLastPage) {
          pagingController.appendLastPage(result.values!);
        } else {
          pagingController.appendPage(
              result.values!, pageKey + result.values!.length);
        }
      }
    } catch (e) {
      pagingController.error = e;
    }
  }
}
