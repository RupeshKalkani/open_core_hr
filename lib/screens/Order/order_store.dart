import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobx/mobx.dart';

import '../../main.dart';
import '../../models/Order/order_count_model.dart';
import '../../models/Order/order_model.dart';
import '../../models/Order/product_category_model.dart';
import '../../models/Order/product_model.dart';

part 'order_store.g.dart';

class OrderStore = OrderStoreBase with _$OrderStore;

abstract class OrderStoreBase with Store {
  @observable
  bool isLoading = false;

  @observable
  bool isOrderCountLoading = false;

  @observable
  bool isOrdersHistoryLoading = true;

  @observable
  bool isSalesTargetLoading = false;

  List<ProductCategoryModel> productCategories = [];

  List<ProductModel> products = [];

  OrderCountModel orderCount =
      OrderCountModel(pending: 0, processing: 0, completed: 0, cancelled: 0);

  static const int pageSize = 10;

  final TextEditingController dateFilterController = TextEditingController();

  @observable
  String dateFilter = '';

  @observable
  PagingController<int, OrderModel> pagingController =
      PagingController(firstPageKey: 0);

  @action
  Future getProductCategories() async {
    isLoading = true;
    productCategories = await apiService.getProductCategories();
    isLoading = false;
  }

  @action
  Future getProducts(int categoryId) async {
    isLoading = true;
    products = await apiService.getProducts(categoryId);
    isLoading = false;
  }

  Future getOrders(int pageKey) async {
    try {
      var result = await apiService.getOrdersHistory(
        skip: pageKey,
        take: pageSize,
        date: dateFilterController.text,
      );
      if (result != null) {
        final isLastPage = result.values!.length < pageSize;
        if (isLastPage) {
          pagingController.appendLastPage(result.values!);
        } else {
          final nextPageKey = pageKey + result.values!.length;
          pagingController.appendPage(result.values!, nextPageKey);
        }
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  Future getOrderCounts({String date = ''}) async {
    isOrderCountLoading = true;
    var result = await appStore.getOrderCounts(date: date);
    orderCount = result!;
    isOrderCountLoading = false;
  }
}
