import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Utils/app_constants.dart';
import '../../main.dart';
import '../../models/sales_target_model.dart';
import '../../utils/app_widgets.dart';

class SalesTargetCard extends StatefulWidget {
  final SalesTargetModel target;

  const SalesTargetCard({super.key, required this.target});

  @override
  State<SalesTargetCard> createState() => _SalesTargetCardState();
}

class _SalesTargetCardState extends State<SalesTargetCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  late Animation<int> _counterAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _progressAnimation = Tween<double>(
      begin: 0,
      end: widget.target.progress.clamp(0.0, 1.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _counterAnimation = IntTween(
      begin: 0,
      end: (widget.target.progress * 100).toInt(),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Target Type and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.target.targetType!.capitalizeFirstLetter(),
                  style: boldTextStyle(size: 18),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(widget.target.status!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.target.status!.capitalizeFirstLetter(),
                    style: boldTextStyle(
                      size: 12,
                      color: white,
                    ),
                  ),
                ),
              ],
            ),
            8.height,

            // Period
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                4.width,
                Text(
                  '${widget.target.period}',
                  style: secondaryTextStyle(size: 12),
                ),
              ],
            ),
            12.height,

            // Target and Achieved Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAmountTile(
                  title: language.lblTarget,
                  value:
                      "${getStringAsync(appCurrencySymbolPref)}${widget.target.targetAmount?.toStringAsFixed(0) ?? "0"}",
                  icon: Icons.flag,
                ),
                _buildAmountTile(
                  title: language.lblAchieved,
                  value:
                      "${getStringAsync(appCurrencySymbolPref)}${widget.target.achievedAmount?.toStringAsFixed(0) ?? "0"}",
                  icon: Icons.check,
                ),
              ],
            ),
            12.height,

            // Animated Progress Indicator
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  language.lblProgress,
                  style: boldTextStyle(size: 14),
                ),
                8.height,
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Stack(
                      children: [
                        Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        Container(
                          height: 10,
                          width: MediaQuery.of(context).size.width *
                              _progressAnimation.value,
                          decoration: BoxDecoration(
                            color: _getProgressColor(widget.target.progress),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                4.height,
                Align(
                  alignment: Alignment.centerRight,
                  child: AnimatedBuilder(
                    animation: _counterAnimation,
                    builder: (context, child) {
                      return Text(
                        "${_counterAnimation.value}%",
                        style: secondaryTextStyle(size: 12),
                      );
                    },
                  ),
                ),
              ],
            ),
            16.height,

            // Incentive Section
            if (widget.target.incentiveType != 'none') ...[
              Divider(height: 20, color: Colors.grey.shade300),
              Text(
                language.lblIncentiveDetails,
                style: boldTextStyle(size: 14),
              ),
              8.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${language.lblType}:",
                    style: secondaryTextStyle(size: 12),
                  ),
                  Text(
                    widget.target.incentiveType!.capitalizeFirstLetter(),
                    style: primaryTextStyle(size: 12),
                  ),
                ],
              ),
              4.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.target.incentiveType == 'percentage'
                        ? "${language.lblIncentivePercentage}:"
                        : "${language.lblIncentiveAmount}:",
                    style: secondaryTextStyle(size: 12),
                  ),
                  Text(
                    widget.target.incentiveType == 'percentage'
                        ? "${widget.target.incentivePercentage?.toStringAsFixed(0)}%"
                        : "${getStringAsync(appCurrencySymbolPref)}${widget.target.incentiveAmount?.toStringAsFixed(0) ?? "0"}",
                    style: primaryTextStyle(size: 12),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Widget for Target and Achieved Sections
  Widget _buildAmountTile({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: appStore.appColorPrimary, size: 24),
        4.height,
        Text(title, style: secondaryTextStyle(size: 12)),
        4.height,
        Text(value, style: boldTextStyle(size: 14)),
      ],
    );
  }

  /// Get Status Color
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'expired':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  /// Get Progress Color
  Color _getProgressColor(double progress) {
    if (progress >= 1.0) return Colors.green;
    if (progress >= 0.5) return Colors.orange;
    return Colors.red;
  }
}
