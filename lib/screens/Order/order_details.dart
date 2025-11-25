import 'package:open_core_hr/Utils/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Utils/app_constants.dart';
import '../../main.dart';
import '../../models/Order/order_model.dart';

class OrderDetails extends StatelessWidget {
  final OrderModel order;

  const OrderDetails({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: appBar(context, language.lblOrderDetails),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            12.height,
            _buildStatusAndDate(),
            16.height,
            _buildProductsSection(),
            12.height,
            _buildTotalSection(),
            12.height,
            _buildRemarksSection(),
          ],
        ),
      ),
    );
  }

  // Order Header
  Widget _buildHeader() {
    return Container(
      decoration: cardDecoration(),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: const Icon(Icons.receipt_long, size: 40, color: Colors.blue),
        title: Text(
          '${language.lblOrderId}: #${order.id}',
          style: boldTextStyle(size: 16),
        ),
        subtitle: Text(
          '${language.lblClient}: ${order.clientName}',
          style: secondaryTextStyle(),
        ),
      ),
    );
  }

  // Status and Date Row
  Widget _buildStatusAndDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _infoTile(Icons.calendar_today, '${language.lblOrderDate}:',
            order.createdOn ?? 'N/A'),
        _infoTile(
          Icons.circle,
          '${language.lblStatus}:',
          order.status.capitalizeFirstLetter(),
          iconColor: _statusColor(order.status.toString()),
        ),
      ],
    );
  }

  // Products Section
  Widget _buildProductsSection() {
    return Container(
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              language.lblProducts,
              style: boldTextStyle(size: 16),
            ),
          ),
          Divider(height: 0, color: Colors.grey.withOpacity(0.5)),
          ListView.separated(
            padding: const EdgeInsets.all(8),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.orderLines!.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: Colors.grey.withOpacity(0.2),
            ),
            itemBuilder: (_, index) {
              var product = order.orderLines![index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${index + 1}. ${product!.productName}',
                      style: primaryTextStyle(),
                    ),
                    Text(
                      '${product.quantity} x ${getStringAsync(appCurrencySymbolPref)}${product.price}',
                      style: secondaryTextStyle(),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Total Section
  Widget _buildTotalSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '${language.lblTotal}: ${getStringAsync(appCurrencySymbolPref)}${order.total!.toStringAsFixed(2)}',
          style: boldTextStyle(size: 16),
        ),
      ],
    );
  }

  // Remarks Section
  Widget _buildRemarksSection() {
    return Container(
      decoration: cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.notes, color: Colors.grey, size: 18),
            8.width,
            Expanded(
              child: Text(
                '${language.lblRemarks}: ${order.note ?? 'N/A'}',
                style: primaryTextStyle(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper for Info Tile
  Widget _infoTile(IconData icon, String title, String value,
      {Color? iconColor}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor ?? Colors.blue),
        6.width,
        Text(title, style: secondaryTextStyle(size: 12)),
        4.width,
        Text(value, style: boldTextStyle(size: 12)),
      ],
    );
  }

  // Status Color
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
