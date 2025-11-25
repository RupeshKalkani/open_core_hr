import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:open_core_hr/main.dart';

import '../../models/sales_target_model.dart';

part 'sales_target_store.g.dart';

class SalesTargetStore = SalesTargetStoreBase with _$SalesTargetStore;

abstract class SalesTargetStoreBase with Store {
  @observable
  bool isLoading = false;

  List<SalesTargetModel> targets = [];

  final TextEditingController yearFilterController = TextEditingController();

  @observable
  int? yearFilter;

  @action
  Future getSalesTargets() async {
    isLoading = true;
    targets = await apiService.getSalesTargets(period: yearFilter);
    isLoading = false;
  }
}
