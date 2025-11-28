import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/Utils/app_constants.dart';
import 'package:open_core_hr/Utils/app_widgets.dart';
import 'package:open_core_hr/components/support/support_component.dart';
import 'package:open_core_hr/main.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, language.lblSupport),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              SizedBox(width: 150, child: Image.asset('images/app_logo.png')),
              Text(
                mainAppName,
                style: boldTextStyle(size: 32, fontFamily: 'Lufga'),
              ),
              5.height,
              Text(
                language.lblConnectingFacilitiesWithServiceProviders,
                textAlign: TextAlign.center,
                style: secondaryTextStyle(),
              ),
              // Image.asset(
              //   'images/czappstudio_logo.png',
              // ),
              10.height,
              Text(
                language
                    .lblForAnyQueriesCustomizationsInstallationOrFeedbackPleaseContactUsAt,
                style: boldTextStyle(),
                textAlign: TextAlign.center,
              ),
              20.height,
              const SupportComponent(),
            ],
          ).paddingOnly(left: 16, right: 16),
        ],
      ),
    );
  }
}
