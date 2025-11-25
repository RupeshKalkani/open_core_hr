import 'package:open_core_hr/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

import '../../models/Client/client_model.dart';
import '../../models/Form/form_model.dart';
import '../../models/Form/form_request_model.dart';

part 'forms_store.g.dart';

class FormsStore = FormsStoreBase with _$FormsStore;

abstract class FormsStoreBase with Store {
  @observable
  bool isLoading = true;
  @observable
  bool isBtnLoading = false;

  List<FormModel> forms = [];

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<FormRequestModel> formRequest = [];

  ClientModel? selectedClient;

  TextEditingController clientController = TextEditingController();

  loadForms() async {
    isLoading = true;

    forms = await apiService.getForms();

    isLoading = false;
  }

  void addUpdateEntry(int key, String value) {
    if (formRequest.isNotEmpty) {
      formRequest.removeWhere((element) => element.id == key);
    }

    formRequest.add(FormRequestModel(id: key, value: value));
  }

  Future<bool> submitForm(int formId) async {
    isBtnLoading = true;
    List<Map<String, dynamic>> entries = [];

    for (var element in formRequest) {
      entries.add({'id': element.id, 'value': element.value});
    }
    var response =
        await apiService.submitForm(selectedClient?.id!, formId, entries);
    isBtnLoading = false;
    return response;
  }
}
