import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/Widgets/button_widget.dart';
import 'package:open_core_hr/screens/Order/orders_screen.dart';

import '../../Utils/app_constants.dart';
import '../../Utils/app_widgets.dart';
import '../../Widgets/text_widget.dart';
import '../../main.dart';
import '../../models/Client/client_model.dart';
import '../Client/client_search.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = false;
  String clientText = language.lblChooseClient;
  final remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (appStore.client != null) {
      setState(() {
        clientText =
            '${appStore.client!.name.toString()} - ${appStore.client!.phoneNumber} ${language.lblChange}';
      });
    }

    remarksController.text = appStore.remarks ?? '';
  }

  void placeOrder() async {
    if (appStore.client == null) {
      toast(language.lblPleaseSelectAClientToPlaceOrder);
      return;
    }
    setState(() => isLoading = true);

    Map req = {
      'clientId': appStore.client!.id.toString(),
      'remarks': appStore.remarks ?? '',
      'orderItems': appStore.cartItems
          .map((e) => {'productId': e.product!.id, 'quantity': e.quantity})
          .toList(),
    };
    var result = await apiService.placeOrder(req);
    setState(() => isLoading = false);
    if (!mounted) return;
    if (result) {
      appStore.resetCart();
      toast(language.lblOrderPlacedSuccessfully);
      OrdersScreen().launch(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: appBar(context, language.lblCart),
      body: SafeArea(
        child: Observer(
          builder: (_) => appStore.cartItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset('assets/animations/empty-cart.json'),
                      Text(
                        language.lblCartIsEmpty,
                        style: boldTextStyle(size: 16),
                      ),
                    ],
                  ),
                )
              : isLoading
              ? Center(child: loadingWidgetMaker())
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: appStore.cartItems.length,
                        itemBuilder: (_, index) {
                          var item = appStore.cartItems[index];
                          return Observer(
                            builder: (_) => Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 12,
                              ),
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 12,
                                top: 12,
                              ),
                              decoration: cardDecoration(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product Name and Code - Fixed Section
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.product!.name!,
                                              style: boldTextStyle(size: 16),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            4.height,
                                            Text(
                                              '${language.lblCode}: ${item.product!.productCode}',
                                              style: secondaryTextStyle(
                                                size: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Iconsax.trash,
                                        color: Colors.red,
                                      ).onTap(
                                        () => appStore.removeFromCart(item.id!),
                                      ),
                                    ],
                                  ),
                                  8.height,
                                  // Quantity Controls - Fixed Bottom Section
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.remove_circle,
                                            color: Colors.redAccent,
                                          ).onTap(() {
                                            appStore.decrementItemInCart(item);
                                            setState(() {});
                                          }),
                                          10.width,
                                          SizedBox(
                                            width: 50,
                                            height: 35,
                                            child: TextField(
                                              controller: TextEditingController(
                                                text: item.quantity.toString(),
                                              ),
                                              textAlign: TextAlign.center,
                                              style: primaryTextStyle(),
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (value) {
                                                if (value.isNotEmpty) {
                                                  try {
                                                    appStore.setQuantity(
                                                      item.id!,
                                                      int.parse(value),
                                                    );
                                                  } catch (e) {
                                                    toast(
                                                      language.lblInvalidInput,
                                                    );
                                                  }
                                                }
                                              },
                                            ),
                                          ).paddingBottom(17),
                                          10.width,
                                          Icon(
                                            Icons.add_circle,
                                            color: appStore.appPrimaryColor,
                                          ).onTap(() {
                                            appStore.incrementItemInCart(item);
                                            setState(() {});
                                          }),
                                        ],
                                      ),
                                      // Item Total Price
                                      Text(
                                        '${getStringAsync(appCurrencySymbolPref)}${(item.product!.price! * item.quantity!).toStringAsFixed(2)}',
                                        style: boldTextStyle(size: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Observer(
                      builder: (_) => Container(
                        decoration: cardDecoration(
                          color: appStore.scaffoldBackground,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            // Client Selection
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  language.lblOrderingFor,
                                  style: primaryTextStyle(size: 14),
                                ),
                                Flexible(
                                  child: TextButton(
                                    onPressed: () async {
                                      var result = await ClientSearch().launch(
                                        context,
                                      );
                                      if (result != null &&
                                          result is ClientModel) {
                                        setState(() {
                                          var client = result;
                                          appStore.client = client;
                                          setState(
                                            () => clientText =
                                                '${client.name!} - ${client.phoneNumber!}',
                                          );
                                        });
                                      }
                                    },
                                    child: Text(
                                      clientText,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: boldTextStyle(
                                        color: appStore.appPrimaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            10.height,
                            // Remarks Field
                            AppTextField(
                              controller: remarksController,
                              textFieldType: TextFieldType.MULTILINE,
                              maxLines: 2,
                              decoration: newEditTextDecorationNoIcon(
                                language.lblNotes,
                              ),
                              onChanged: (value) => appStore.remarks = value,
                            ),
                            10.height,
                            // Total and Place Order Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Observer(
                                      builder: (_) => Text(
                                        '${language.lblTotal}: ${getStringAsync(appCurrencySymbolPref)}${appStore.cartTotalAmount}',
                                        style: boldTextStyle(size: 16),
                                      ),
                                    ),
                                    Observer(
                                      builder: (_) => Text(
                                        '${language.lblItems}: ${appStore.cartTotalQuantity}',
                                        style: secondaryTextStyle(size: 14),
                                      ),
                                    ),
                                  ],
                                ),
                                button(
                                  language.lblPlaceOrder,
                                  onTap: () {
                                    if (!globalAttendanceStore.isCheckedIn) {
                                      toast(language.lblPleaseCheckInFirst);
                                      return;
                                    }
                                    appStore.client == null
                                        ? toast(
                                            language
                                                .lblPleaseSelectAClientToPlaceOrder,
                                          )
                                        : showConfirmDialogCustom(
                                            context,
                                            title: language
                                                .lblAreYouSureYouWantToPlaceTheOrder,
                                            dialogType: DialogType.CONFIRMATION,
                                            positiveText: language.lblYes,
                                            negativeText: language.lblNo,
                                            onAccept: (c) => placeOrder(),
                                          );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
