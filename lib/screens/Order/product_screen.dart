import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Utils/app_constants.dart';
import '../../Utils/app_widgets.dart';
import '../../main.dart';
import 'order_store.dart';

class ProductScreen extends StatefulWidget {
  final int categoryId;
  const ProductScreen({super.key, required this.categoryId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _store = OrderStore();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    _store.getProducts(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: cartAppBar(context, language.lblChooseProducts),
      body: Observer(
        builder: (_) => _store.isLoading
            ? loadingWidgetMaker()
            : _store.products.isEmpty
                ? Center(
                    child: Text(language.lblNoData, style: boldTextStyle()),
                  )
                : ListView.builder(
                    itemCount: _store.products.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = _store.products[index];

                      return Container(
                        decoration: cardDecoration(),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Product Info Section
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name!,
                                      style: boldTextStyle(size: 16),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    6.height,
                                    Text(
                                      '${language.lblCode}: ${item.productCode}',
                                      style: secondaryTextStyle(size: 12),
                                    ),
                                  ],
                                ),
                              ),

                              // Price and Action Section
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${getStringAsync(appCurrencySymbolPref)}${item.basePrice ?? item.price}',
                                      style: boldTextStyle(
                                          size: 16, color: Colors.green),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    8.height,

                                    // Add to Cart or Remove
                                    Observer(
                                      builder: (_) {
                                        bool isInCart = appStore
                                            .isItemAddedInCart(item.id!);
                                        return GestureDetector(
                                          onTap: () {
                                            if (isInCart) {
                                              appStore.removeFromCart(item.id!);
                                              toast(
                                                  language.lblRemovedFromCart);
                                            } else {
                                              appStore.addToCart(item);
                                              toast(language.lblAddedToCart);
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: isInCart
                                                  ? Colors.redAccent
                                                  : appStore.appColorPrimary,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  isInCart
                                                      ? Iconsax.trash
                                                      : Iconsax.shopping_cart,
                                                  color: white,
                                                  size: 18,
                                                ),
                                                4.width,
                                                Flexible(
                                                  child: Text(
                                                    isInCart
                                                        ? language.lblRemove
                                                        : language.lblAddToCart,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: primaryTextStyle(
                                                        color: white, size: 12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ).paddingSymmetric(horizontal: 8, vertical: 4),
      ),
    );
  }
}
