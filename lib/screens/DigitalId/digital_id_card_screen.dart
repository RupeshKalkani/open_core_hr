import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/main.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../utils/app_widgets.dart';

class DigitalIDCardScreen extends StatelessWidget {
  const DigitalIDCardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String profileImageUrl = sharedHelper.getProfileImage();
    final String qrData = sharedHelper.getEmployeeCode();
    final String name = sharedHelper.getFullName();
    final String email = sharedHelper.getEmail();
    final String phone = sharedHelper.getPhoneNumber();
    final String designation = sharedHelper.getDesignation();
    final String employeeId = sharedHelper.getEmployeeCode();
    final String companyName = sharedHelper.getCompanyName();
    final String companyAddress = sharedHelper.getCompanyAddress();

    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: appBar(context, language.lblDigitalIDCard),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              50.height,
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.fromLTRB(16, 70, 16, 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile Image

                        16.height,

                        // Employee Name
                        Text(name, style: boldTextStyle(size: 18)),
                        Text(designation, style: secondaryTextStyle(size: 14)),
                        10.height,

                        // Employee Details
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow(Icons.person,
                                language.lblEmployeeCode, employeeId),
                            _buildDetailRow(
                                Icons.email, language.lblEmail, email),
                            _buildDetailRow(
                                Icons.phone, language.lblPhone, phone),
                          ],
                        ),
                        20.height,

                        // QR Code Section
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: appStore.appPrimaryColor, width: 1),
                          ),
                          child: QrImageView(
                            data: qrData,
                            version: QrVersions.auto,
                            size: 120,
                          ),
                        ),
                        /*10.height,
                        Text(
                          'Scan QR Code to Verify',
                          style: secondaryTextStyle(size: 12),
                        ),*/
                        10.height,
                      ],
                    ),
                  ),
                  // Floating Profile Image
                  Positioned(
                    top: -50, // Adjust floating image position
                    child: Hero(
                        tag: 'profile', child: profileImageWidget(size: 60)),
                  ),
                ],
              ),
              Text(companyName),
              2.height,
              Text(
                companyAddress,
                textAlign: TextAlign.center,
                style: secondaryTextStyle(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: appStore.scaffoldBackground!.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon
          CircleAvatar(
            radius: 20,
            backgroundColor: appStore.appPrimaryColor.withOpacity(0.1),
            child: Icon(icon, size: 20, color: appStore.appPrimaryColor),
          ),
          12.width,

          // Title and Value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: boldTextStyle(size: 14, color: Colors.grey),
                ),
                4.height,
                Text(
                  value,
                  style: primaryTextStyle(size: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
