import 'package:open_core_hr/utils/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../main.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  String? privacyPolicyUrl = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    var appSettings = await apiService.getAppSettings();
    if (appSettings != null) {
      privacyPolicyUrl = appSettings.privacyPolicyUrl;
      sharedHelper.setAppSettings(appSettings);
    }
  }

  @override
  Widget build(BuildContext context) {
    var controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(privacyPolicyUrl!));
    return Scaffold(
      appBar: appBar(context, language.lblPrivacyPolicy),
      body: WebViewWidget(controller: controller),
    );
  }
}
