import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/models/Client/client_model.dart';
import 'package:open_core_hr/models/Order/order_count_model.dart';
import 'package:open_core_hr/models/Order/product_model.dart';

import '../locale/app_localizations.dart';
import '../locale/languages.dart';
import '../main.dart';
import '../models/Cart/cart_model.dart';
import '../models/status/status_response.dart';
import '../models/user_status.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';

part 'AppStore.g.dart';

class AppStore = AppStoreBase with _$AppStore;

abstract class AppStoreBase with Store {
  final List<String> statuses = [
    'online',
    'offline',
    'busy',
    'away',
    'on_call',
    'do_not_disturb',
    'on_leave',
    'ON_meeting',
    'unknown',
  ];

  int userId = 0;

  String currentUserStatus = 'online';
  String? statusMessage;
  UserStatusModel? userStatusModel;

  @observable
  bool isDarkModeOn = false;

  @observable
  bool isHover = false;

  String centralDomainURL = '';

  @observable
  bool isDemoMode = false;

  @observable
  bool isStatusCheckLoading = true;

  @observable
  StatusResponse? currentStatus = StatusResponse();

  @observable
  Color? iconColor;

  @observable
  Color appPrimaryColor = opPrimaryColor;

  @observable
  Color? backgroundColor;

  @observable
  Color? appBarColor;

  @observable
  Color? scaffoldBackground;

  @observable
  Color? backgroundSecondaryColor;

  @observable
  Color? appColorPrimaryLightColor;

  @observable
  Color? iconSecondaryColor;

  @observable
  Color? textPrimaryColor;

  @observable
  Color? textSecondaryColor;

  @observable
  String selectedLanguageCode = defaultLanguage;

  @observable
  bool isOrderCountLoading = true;

  List<Color> availableThemes = [
    opPrimaryColor,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.cyan,
    Colors.amber,
    Colors.lime,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.blueGrey,
    Colors.brown,
  ];

  @computed
  Color get appColorPrimary => appPrimaryColor;

  Future<OrderCountModel?> getOrderCounts({String date = ''}) async {
    isOrderCountLoading = true;
    var result = await apiService.getOrderCounts(date);
    isOrderCountLoading = false;
    return result;
  }

  @observable
  ObservableList<CartItemModel> cartItems = ObservableList<CartItemModel>();

  @observable
  ClientModel? client;

  @observable
  String? remarks;

  @computed
  int get cartCount => cartItems.length;

  @action
  void addToCart(ProductModel product) {
    var index = cartItems.indexWhere((element) => element.id == product.id);
    if (index != -1) {
      cartItems[index].quantity = cartItems[index].quantity! + 1;
    } else {
      cartItems.add(CartItemModel(
          id: product.id,
          product: product,
          quantity: 1,
          total: product.price ?? product.basePrice));
    }
  }

  bool isItemAddedInCart(int productId) {
    var index = cartItems.indexWhere((element) => element.id == productId);
    if (index != -1) {
      return true;
    } else {
      return false;
    }
  }

  @computed
  double get cartTotalAmount {
    double total = 0;
    cartItems.forEach((element) {
      var price = element.product!.basePrice ?? element.product!.price!;
      total = total + (element.quantity! * price);
    });
    return total;
  }

  @computed
  int get cartTotalQuantity {
    int total = 0;
    cartItems.forEach((element) {
      total = total + (element.quantity!);
    });
    return total;
  }

  @action
  int selectedProductQuantity(int productId) {
    var cart = cartItems.where((element) => element.id == productId).first;
    return cart.quantity!;
  }

  @action
  void clearCart() {
    cartItems.clear();
  }

  @action
  void resetCart() {
    cartItems.clear();
    client = null;
    remarks = null;
  }

  @action
  void removeFromCart(int productId) {
    var index = cartItems.indexWhere((element) => element.id == productId);
    if (index != -1) {
      cartItems.removeAt(index);
    }
  }

  @action
  void incrementItemInCart(CartItemModel item) {
    var index = cartItems.indexWhere((element) => element.id == item.id);
    if (index != -1) {
      cartItems[index] =
          cartItems[index].copyWith(quantity: cartItems[index].quantity! + 1);
      cartItems = ObservableList.of(cartItems); // Force the update
    }
  }

  @action
  void decrementItemInCart(CartItemModel item) {
    var index = cartItems.indexWhere((element) => element.id == item.id);
    if (index != -1 && cartItems[index].quantity! > 1) {
      cartItems[index] =
          cartItems[index].copyWith(quantity: cartItems[index].quantity! - 1);
      cartItems = ObservableList.of(cartItems); // Force the update
    }
  }

  @action
  void setQuantity(int productId, int quantity) {
    var index = cartItems.indexWhere((element) => element.id == productId);
    if (index != -1) {
      cartItems[index] = cartItems[index].copyWith(quantity: quantity);
      cartItems = ObservableList.of(cartItems); // Force the update
    }
  }

  // Fetch Current User Status
  Future<void> fetchUserStatus(int? userId) async {
    var result = await apiService.getUserStatus(userId);
    if (result != null) {
      userStatusModel = result;
      currentUserStatus = userStatusModel!.status;
      statusMessage = userStatusModel!.message;
    } else {
      currentUserStatus = 'unknown';
    }
  }

  // Update User Status
  Future<void> updateUserStatus(String status, {String? message}) async {
    var success = await apiService.updateUserStatus(status, message: message);
    if (success) {
      currentUserStatus = status;
      statusMessage = message;
      toast('Status updated to $status');
    } else {
      toast('Failed to update status');
    }
  }

  @action
  Future toggleColorTheme() async {
    var colorPref = getStringAsync(appColorPrimaryPref);
    if (colorPref.isNotEmpty) {
      appPrimaryColor = Color(int.parse(colorPref, radix: 16));
    } else {
      appPrimaryColor = opPrimaryColor;
    }
    setValue(appColorPrimaryPref, appPrimaryColor.value.toRadixString(16));
  }

  @action
  Future changeColorTheme(Color color) async {
    appPrimaryColor = color;
    setValue(appColorPrimaryPref, appPrimaryColor.value.toRadixString(16));
  }

  @action
  Future<void> toggleDarkMode({bool? value}) async {
    isDarkModeOn = value ?? !isDarkModeOn;

    if (isDarkModeOn) {
      scaffoldBackground = appBackgroundColorDark;

      appBarColor = cardBackgroundBlackDark;
      backgroundColor = Colors.white;
      backgroundSecondaryColor = Colors.white;
      appStore.appColorPrimaryLightColor = cardBackgroundBlackDark;

      iconColor = iconColorPrimary;
      iconSecondaryColor = iconColorSecondary;

      textPrimaryColor = whiteColor;
      textSecondaryColor = Colors.white54;

      textPrimaryColorGlobal = whiteColor;
      textSecondaryColorGlobal = Colors.white54;
      shadowColorGlobal = appShadowColorDark;
    } else {
      scaffoldBackground = scaffoldLightColor;

      appBarColor = Colors.white;
      backgroundColor = Colors.black;
      backgroundSecondaryColor = appSecondaryBackgroundColor;
      appStore.appColorPrimaryLightColor = appColorPrimaryLight;

      iconColor = iconColorPrimaryDark;
      iconSecondaryColor = iconColorSecondaryDark;

      textPrimaryColor = appTextColorPrimary;
      textSecondaryColor = appTextColorSecondary;

      textPrimaryColorGlobal = appTextColorPrimary;
      textSecondaryColorGlobal = appTextColorSecondary;
      shadowColorGlobal = appShadowColor;
    }
    setStatusBarColor(scaffoldBackground!);

    setValue(isDarkModeOnPref, isDarkModeOn);
  }

  @action
  void toggleHover({bool value = false}) => isHover = value;

  @action
  void setCurrentStatus(StatusResponse status) {
    isStatusCheckLoading = true;
    currentStatus = status;
    globalAttendanceStore.setCurrentStatus(status);
    isStatusCheckLoading = false;
  }

  @action
  refreshAttendanceStatus() async {
    //Setting userId from prefs
    var user = getStringAsync(userIdPref);
    try {
      userId = int.parse(user);
    } catch (e) {
      log('Error : $e');
    }
    isStatusCheckLoading = true;
    var statusResult = await apiService.checkAttendanceStatus();
    if (statusResult != null) {
      setCurrentStatus(statusResult);
    }
    isStatusCheckLoading = false;
  }

  @computed
  StatusResponse? get getCurrentStatus => currentStatus;

  @action
  Future<void> setLanguage(String val, {BuildContext? context}) async {
    selectedLanguageCode = val;
    if (context != null) language = BaseLanguage.of(context);
    await setValue(SELECTED_LANGUAGE_CODE, selectedLanguageCode);
    selectedLanguageDataModel = getSelectedLanguageModel();
    language =
        await const AppLocalizations().load(Locale(selectedLanguageCode));
  }
}
