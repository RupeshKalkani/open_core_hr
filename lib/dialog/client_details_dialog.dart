import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/main.dart';
import 'package:open_core_hr/utils/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/Client/client_model.dart';
import '../service/map_helper.dart';

class ClientDetails extends StatefulWidget {
  final ClientModel client;

  const ClientDetails({Key? key, required this.client}) : super(key: key);

  @override
  State<ClientDetails> createState() => _ClientDetailsState();
}

class _ClientDetailsState extends State<ClientDetails> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              //Close button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.grey),
                  onPressed: () {
                    finish(context);
                  },
                ),
              ),
              // Profile Avatar
              CircleAvatar(
                radius: 40,
                backgroundColor: appStore.appColorPrimary.withOpacity(0.1),
                child: Text(
                  widget.client.name!.substring(0, 1).toUpperCase(),
                  style:
                      boldTextStyle(size: 28, color: appStore.appColorPrimary),
                ),
              ),
              12.height,

              // Client Name
              Text(widget.client.name!, style: boldTextStyle(size: 20)),
              Text(
                widget.client.contactPerson ?? "",
                style: secondaryTextStyle(size: 14, color: Colors.grey),
              ),

              20.height,

              // Client Details
              _buildDetailRow(Icons.phone, 'Phone Number',
                  '${getStringAsync(appCountryPhoneCodePref)} ${widget.client.phoneNumber}'),
              _buildDetailRow(Icons.email, 'Email', widget.client.email ?? ''),
              _buildDetailRow(
                  Icons.location_city, 'City', widget.client.city.toString()),
              _buildDetailRow(Icons.check_circle_outline, 'Status',
                  widget.client.status.toString()),
              _buildDetailRow(Icons.calendar_today, 'Created On',
                  widget.client.createdAt.toString()),

              20.height,

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Call Now Button
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appStore.appColorPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        launchUrl(Uri(
                          scheme: 'tel',
                          path:
                              '${getStringAsync(appCountryPhoneCodePref)}${widget.client.phoneNumber}',
                        ));
                      },
                      icon: const Icon(Icons.call, color: white),
                      label: Text(
                        'Call Now',
                        style: boldTextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  12.width,

                  // Close Button
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: appStore.appColorPrimary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () async {
                        MapHelper helper = MapHelper();
                        helper.launchMap(context, widget.client.latitude!,
                            widget.client.longitude!, widget.client.name!);
                      },
                      icon: Icon(
                        Icons.directions_rounded,
                        color: appStore.appColorPrimary,
                      ),
                      label: Text(
                        'Direction',
                        style: boldTextStyle(
                          color: appStore.appColorPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: appStore.appColorPrimary),
          12.width,
          Expanded(
            child: Text(
              title,
              style: secondaryTextStyle(size: 14, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: boldTextStyle(size: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
