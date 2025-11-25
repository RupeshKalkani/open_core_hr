// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on AppStoreBase, Store {
  Computed<Color>? _$appColorPrimaryComputed;

  @override
  Color get appColorPrimary => (_$appColorPrimaryComputed ??= Computed<Color>(
          () => super.appColorPrimary,
          name: 'AppStoreBase.appColorPrimary'))
      .value;
  Computed<int>? _$cartCountComputed;

  @override
  int get cartCount => (_$cartCountComputed ??=
          Computed<int>(() => super.cartCount, name: 'AppStoreBase.cartCount'))
      .value;
  Computed<double>? _$cartTotalAmountComputed;

  @override
  double get cartTotalAmount => (_$cartTotalAmountComputed ??= Computed<double>(
          () => super.cartTotalAmount,
          name: 'AppStoreBase.cartTotalAmount'))
      .value;
  Computed<int>? _$cartTotalQuantityComputed;

  @override
  int get cartTotalQuantity => (_$cartTotalQuantityComputed ??= Computed<int>(
          () => super.cartTotalQuantity,
          name: 'AppStoreBase.cartTotalQuantity'))
      .value;
  Computed<StatusResponse?>? _$getCurrentStatusComputed;

  @override
  StatusResponse? get getCurrentStatus => (_$getCurrentStatusComputed ??=
          Computed<StatusResponse?>(() => super.getCurrentStatus,
              name: 'AppStoreBase.getCurrentStatus'))
      .value;

  late final _$isDarkModeOnAtom =
      Atom(name: 'AppStoreBase.isDarkModeOn', context: context);

  @override
  bool get isDarkModeOn {
    _$isDarkModeOnAtom.reportRead();
    return super.isDarkModeOn;
  }

  @override
  set isDarkModeOn(bool value) {
    _$isDarkModeOnAtom.reportWrite(value, super.isDarkModeOn, () {
      super.isDarkModeOn = value;
    });
  }

  late final _$isHoverAtom =
      Atom(name: 'AppStoreBase.isHover', context: context);

  @override
  bool get isHover {
    _$isHoverAtom.reportRead();
    return super.isHover;
  }

  @override
  set isHover(bool value) {
    _$isHoverAtom.reportWrite(value, super.isHover, () {
      super.isHover = value;
    });
  }

  late final _$isDemoModeAtom =
      Atom(name: 'AppStoreBase.isDemoMode', context: context);

  @override
  bool get isDemoMode {
    _$isDemoModeAtom.reportRead();
    return super.isDemoMode;
  }

  @override
  set isDemoMode(bool value) {
    _$isDemoModeAtom.reportWrite(value, super.isDemoMode, () {
      super.isDemoMode = value;
    });
  }

  late final _$isStatusCheckLoadingAtom =
      Atom(name: 'AppStoreBase.isStatusCheckLoading', context: context);

  @override
  bool get isStatusCheckLoading {
    _$isStatusCheckLoadingAtom.reportRead();
    return super.isStatusCheckLoading;
  }

  @override
  set isStatusCheckLoading(bool value) {
    _$isStatusCheckLoadingAtom.reportWrite(value, super.isStatusCheckLoading,
        () {
      super.isStatusCheckLoading = value;
    });
  }

  late final _$currentStatusAtom =
      Atom(name: 'AppStoreBase.currentStatus', context: context);

  @override
  StatusResponse? get currentStatus {
    _$currentStatusAtom.reportRead();
    return super.currentStatus;
  }

  @override
  set currentStatus(StatusResponse? value) {
    _$currentStatusAtom.reportWrite(value, super.currentStatus, () {
      super.currentStatus = value;
    });
  }

  late final _$iconColorAtom =
      Atom(name: 'AppStoreBase.iconColor', context: context);

  @override
  Color? get iconColor {
    _$iconColorAtom.reportRead();
    return super.iconColor;
  }

  @override
  set iconColor(Color? value) {
    _$iconColorAtom.reportWrite(value, super.iconColor, () {
      super.iconColor = value;
    });
  }

  late final _$appPrimaryColorAtom =
      Atom(name: 'AppStoreBase.appPrimaryColor', context: context);

  @override
  Color get appPrimaryColor {
    _$appPrimaryColorAtom.reportRead();
    return super.appPrimaryColor;
  }

  @override
  set appPrimaryColor(Color value) {
    _$appPrimaryColorAtom.reportWrite(value, super.appPrimaryColor, () {
      super.appPrimaryColor = value;
    });
  }

  late final _$backgroundColorAtom =
      Atom(name: 'AppStoreBase.backgroundColor', context: context);

  @override
  Color? get backgroundColor {
    _$backgroundColorAtom.reportRead();
    return super.backgroundColor;
  }

  @override
  set backgroundColor(Color? value) {
    _$backgroundColorAtom.reportWrite(value, super.backgroundColor, () {
      super.backgroundColor = value;
    });
  }

  late final _$appBarColorAtom =
      Atom(name: 'AppStoreBase.appBarColor', context: context);

  @override
  Color? get appBarColor {
    _$appBarColorAtom.reportRead();
    return super.appBarColor;
  }

  @override
  set appBarColor(Color? value) {
    _$appBarColorAtom.reportWrite(value, super.appBarColor, () {
      super.appBarColor = value;
    });
  }

  late final _$scaffoldBackgroundAtom =
      Atom(name: 'AppStoreBase.scaffoldBackground', context: context);

  @override
  Color? get scaffoldBackground {
    _$scaffoldBackgroundAtom.reportRead();
    return super.scaffoldBackground;
  }

  @override
  set scaffoldBackground(Color? value) {
    _$scaffoldBackgroundAtom.reportWrite(value, super.scaffoldBackground, () {
      super.scaffoldBackground = value;
    });
  }

  late final _$backgroundSecondaryColorAtom =
      Atom(name: 'AppStoreBase.backgroundSecondaryColor', context: context);

  @override
  Color? get backgroundSecondaryColor {
    _$backgroundSecondaryColorAtom.reportRead();
    return super.backgroundSecondaryColor;
  }

  @override
  set backgroundSecondaryColor(Color? value) {
    _$backgroundSecondaryColorAtom
        .reportWrite(value, super.backgroundSecondaryColor, () {
      super.backgroundSecondaryColor = value;
    });
  }

  late final _$appColorPrimaryLightColorAtom =
      Atom(name: 'AppStoreBase.appColorPrimaryLightColor', context: context);

  @override
  Color? get appColorPrimaryLightColor {
    _$appColorPrimaryLightColorAtom.reportRead();
    return super.appColorPrimaryLightColor;
  }

  @override
  set appColorPrimaryLightColor(Color? value) {
    _$appColorPrimaryLightColorAtom
        .reportWrite(value, super.appColorPrimaryLightColor, () {
      super.appColorPrimaryLightColor = value;
    });
  }

  late final _$iconSecondaryColorAtom =
      Atom(name: 'AppStoreBase.iconSecondaryColor', context: context);

  @override
  Color? get iconSecondaryColor {
    _$iconSecondaryColorAtom.reportRead();
    return super.iconSecondaryColor;
  }

  @override
  set iconSecondaryColor(Color? value) {
    _$iconSecondaryColorAtom.reportWrite(value, super.iconSecondaryColor, () {
      super.iconSecondaryColor = value;
    });
  }

  late final _$textPrimaryColorAtom =
      Atom(name: 'AppStoreBase.textPrimaryColor', context: context);

  @override
  Color? get textPrimaryColor {
    _$textPrimaryColorAtom.reportRead();
    return super.textPrimaryColor;
  }

  @override
  set textPrimaryColor(Color? value) {
    _$textPrimaryColorAtom.reportWrite(value, super.textPrimaryColor, () {
      super.textPrimaryColor = value;
    });
  }

  late final _$textSecondaryColorAtom =
      Atom(name: 'AppStoreBase.textSecondaryColor', context: context);

  @override
  Color? get textSecondaryColor {
    _$textSecondaryColorAtom.reportRead();
    return super.textSecondaryColor;
  }

  @override
  set textSecondaryColor(Color? value) {
    _$textSecondaryColorAtom.reportWrite(value, super.textSecondaryColor, () {
      super.textSecondaryColor = value;
    });
  }

  late final _$selectedLanguageCodeAtom =
      Atom(name: 'AppStoreBase.selectedLanguageCode', context: context);

  @override
  String get selectedLanguageCode {
    _$selectedLanguageCodeAtom.reportRead();
    return super.selectedLanguageCode;
  }

  @override
  set selectedLanguageCode(String value) {
    _$selectedLanguageCodeAtom.reportWrite(value, super.selectedLanguageCode,
        () {
      super.selectedLanguageCode = value;
    });
  }

  late final _$isOrderCountLoadingAtom =
      Atom(name: 'AppStoreBase.isOrderCountLoading', context: context);

  @override
  bool get isOrderCountLoading {
    _$isOrderCountLoadingAtom.reportRead();
    return super.isOrderCountLoading;
  }

  @override
  set isOrderCountLoading(bool value) {
    _$isOrderCountLoadingAtom.reportWrite(value, super.isOrderCountLoading, () {
      super.isOrderCountLoading = value;
    });
  }

  late final _$cartItemsAtom =
      Atom(name: 'AppStoreBase.cartItems', context: context);

  @override
  ObservableList<CartItemModel> get cartItems {
    _$cartItemsAtom.reportRead();
    return super.cartItems;
  }

  @override
  set cartItems(ObservableList<CartItemModel> value) {
    _$cartItemsAtom.reportWrite(value, super.cartItems, () {
      super.cartItems = value;
    });
  }

  late final _$clientAtom = Atom(name: 'AppStoreBase.client', context: context);

  @override
  ClientModel? get client {
    _$clientAtom.reportRead();
    return super.client;
  }

  @override
  set client(ClientModel? value) {
    _$clientAtom.reportWrite(value, super.client, () {
      super.client = value;
    });
  }

  late final _$remarksAtom =
      Atom(name: 'AppStoreBase.remarks', context: context);

  @override
  String? get remarks {
    _$remarksAtom.reportRead();
    return super.remarks;
  }

  @override
  set remarks(String? value) {
    _$remarksAtom.reportWrite(value, super.remarks, () {
      super.remarks = value;
    });
  }

  late final _$toggleColorThemeAsyncAction =
      AsyncAction('AppStoreBase.toggleColorTheme', context: context);

  @override
  Future<dynamic> toggleColorTheme() {
    return _$toggleColorThemeAsyncAction.run(() => super.toggleColorTheme());
  }

  late final _$changeColorThemeAsyncAction =
      AsyncAction('AppStoreBase.changeColorTheme', context: context);

  @override
  Future<dynamic> changeColorTheme(Color color) {
    return _$changeColorThemeAsyncAction
        .run(() => super.changeColorTheme(color));
  }

  late final _$toggleDarkModeAsyncAction =
      AsyncAction('AppStoreBase.toggleDarkMode', context: context);

  @override
  Future<void> toggleDarkMode({bool? value}) {
    return _$toggleDarkModeAsyncAction
        .run(() => super.toggleDarkMode(value: value));
  }

  late final _$refreshAttendanceStatusAsyncAction =
      AsyncAction('AppStoreBase.refreshAttendanceStatus', context: context);

  @override
  Future refreshAttendanceStatus() {
    return _$refreshAttendanceStatusAsyncAction
        .run(() => super.refreshAttendanceStatus());
  }

  late final _$setLanguageAsyncAction =
      AsyncAction('AppStoreBase.setLanguage', context: context);

  @override
  Future<void> setLanguage(String val, {BuildContext? context}) {
    return _$setLanguageAsyncAction
        .run(() => super.setLanguage(val, context: context));
  }

  late final _$AppStoreBaseActionController =
      ActionController(name: 'AppStoreBase', context: context);

  @override
  void addToCart(ProductModel product) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.addToCart');
    try {
      return super.addToCart(product);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  int selectedProductQuantity(int productId) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.selectedProductQuantity');
    try {
      return super.selectedProductQuantity(productId);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearCart() {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.clearCart');
    try {
      return super.clearCart();
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetCart() {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.resetCart');
    try {
      return super.resetCart();
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeFromCart(int productId) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.removeFromCart');
    try {
      return super.removeFromCart(productId);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void incrementItemInCart(CartItemModel item) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.incrementItemInCart');
    try {
      return super.incrementItemInCart(item);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void decrementItemInCart(CartItemModel item) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.decrementItemInCart');
    try {
      return super.decrementItemInCart(item);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setQuantity(int productId, int quantity) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setQuantity');
    try {
      return super.setQuantity(productId, quantity);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleHover({bool value = false}) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.toggleHover');
    try {
      return super.toggleHover(value: value);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCurrentStatus(StatusResponse status) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.setCurrentStatus');
    try {
      return super.setCurrentStatus(status);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isDarkModeOn: ${isDarkModeOn},
isHover: ${isHover},
isDemoMode: ${isDemoMode},
isStatusCheckLoading: ${isStatusCheckLoading},
currentStatus: ${currentStatus},
iconColor: ${iconColor},
appPrimaryColor: ${appPrimaryColor},
backgroundColor: ${backgroundColor},
appBarColor: ${appBarColor},
scaffoldBackground: ${scaffoldBackground},
backgroundSecondaryColor: ${backgroundSecondaryColor},
appColorPrimaryLightColor: ${appColorPrimaryLightColor},
iconSecondaryColor: ${iconSecondaryColor},
textPrimaryColor: ${textPrimaryColor},
textSecondaryColor: ${textSecondaryColor},
selectedLanguageCode: ${selectedLanguageCode},
isOrderCountLoading: ${isOrderCountLoading},
cartItems: ${cartItems},
client: ${client},
remarks: ${remarks},
appColorPrimary: ${appColorPrimary},
cartCount: ${cartCount},
cartTotalAmount: ${cartTotalAmount},
cartTotalQuantity: ${cartTotalQuantity},
getCurrentStatus: ${getCurrentStatus}
    ''';
  }
}
