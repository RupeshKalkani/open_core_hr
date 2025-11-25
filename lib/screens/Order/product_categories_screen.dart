import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/screens/Order/product_screen.dart';

import '../../main.dart';
import '../../models/Order/product_category_model.dart';
import '../../utils/app_widgets.dart';
import 'order_store.dart';

class ProductCategoriesScreen extends StatefulWidget {
  const ProductCategoriesScreen({super.key});

  @override
  State<ProductCategoriesScreen> createState() =>
      _ProductCategoriesScreenState();
}

class _ProductCategoriesScreenState extends State<ProductCategoriesScreen> {
  final _store = OrderStore();

  @override
  void initState() {
    super.initState();
    _store.getProductCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: cartAppBar(context, language.lblChooseProductCategory),
      body: Observer(
        builder: (_) => _store.isLoading
            ? loadingWidgetMaker()
            : _store.productCategories.isEmpty
                ? Center(child: Text(language.lblNoData))
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two items per row
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 3 / 2.5,
                    ),
                    itemCount: _store.productCategories.length,
                    itemBuilder: (context, index) {
                      var item = _store.productCategories[index];
                      return _buildCategoryCard(item);
                    },
                  ),
      ),
    );
  }

  // Build Category Card
  Widget _buildCategoryCard(ProductCategoryModel item) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        if (item.subCategories!.isEmpty) {
          ProductScreen(categoryId: item.id!).launch(context);
        } else {
          bottomDetailsSheet(item.subCategories!);
        }
      },
      child: Container(
        decoration: cardDecoration(),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.category, color: appStore.appColorPrimary, size: 32),
            8.height,
            Text(item.name ?? '',
                style:
                    boldTextStyle(size: 14, color: appStore.textPrimaryColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            4.height,
            Text('${language.lblId}: ${item.id}',
                style: secondaryTextStyle(size: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

// Bottom Sheet for Subcategories
  bottomDetailsSheet(List<SubCategory?> subCategories) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Allows the bottom sheet to expand fully if needed
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5, // 50% of the screen height initially
          minChildSize: 0.3, // Minimum size is 30%
          maxChildSize: 0.9, // Maximum size is 90%
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(language.lblSubCategories,
                        style: boldTextStyle(size: 18)),
                    12.height,
                    subCategories.isEmpty
                        ? Center(
                            child: Text(language.lblNoData),
                          )
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap:
                                true, // Allows ListView to fit inside Column
                            itemCount: subCategories.length,
                            itemBuilder: (context, index) {
                              var subItem = subCategories[index]!;
                              return ListTile(
                                leading: Icon(
                                  Icons.subdirectory_arrow_right,
                                  color: appStore.appColorPrimary,
                                ),
                                title: Text(
                                  subItem.name.toString(),
                                  style: primaryTextStyle(),
                                ),
                                subtitle: Text(
                                  '${language.lblId}: ${subItem.id}',
                                  style: secondaryTextStyle(size: 12),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                onTap: () {
                                  finish(context);
                                  ProductScreen(categoryId: subItem.id!)
                                      .launch(context);
                                },
                              ).paddingBottom(8);
                            },
                          ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
