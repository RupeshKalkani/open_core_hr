import 'package:open_core_hr/Utils/app_widgets.dart';
import 'package:open_core_hr/models/Order/order_model.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../Utils/app_constants.dart';
import '../../../main.dart';
import '../order_details.dart';

class OrderListComponent extends StatelessWidget {
  final List<OrderModel> orders;

  const OrderListComponent({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return orderItem(orders[index], context);
          },
        ),
      ],
    );
  }

  Widget orderItem(OrderModel model, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: cardDecoration(),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          OrderDetails(order: model).launch(context);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Order ID and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${model.orderNo}',
                  style: boldTextStyle(size: 16),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(model.status.toString()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    model.status.toString().toUpperCase(),
                    style: boldTextStyle(size: 12, color: Colors.white),
                  ),
                ),
              ],
            ),
            6.height,

            // Order Date and Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoRow(Icons.calendar_today, '${language.lblOrderDate}:',
                    model.createdOn ?? 'N/A'),
                _infoRow(Icons.attach_money, '${language.lblTotal}:',
                    '${getStringAsync(appCurrencySymbolPref)} ${model.total.toString()}'),
              ],
            ),
            6.height,

            // Client and Total Items
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoRow(Icons.person, '${language.lblClient}:',
                    model.clientName ?? 'N/A'),
                _infoRow(Icons.shopping_cart, '${language.lblTotalItems}:',
                    model.totalQuantity.toString()),
              ],
            ),
          ],
        ).paddingAll(12),
      ),
    );
  }

  // Helper for Info Rows
  Widget _infoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: appStore.appColorPrimary),
        4.width,
        Text(
          title,
          style: secondaryTextStyle(size: 12),
        ),
        4.width,
        Text(
          value,
          style: boldTextStyle(size: 12),
        ),
      ],
    );
  }

  // Helper for Status Colors
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.redAccent;
    }
  }
}
