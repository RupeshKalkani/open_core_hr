import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/main.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Utils/app_constants.dart';

class DemoModeBanner extends StatefulWidget {
  const DemoModeBanner({Key? key}) : super(key: key);

  @override
  State<DemoModeBanner> createState() => _DemoModeBannerState();
}

class _DemoModeBannerState extends State<DemoModeBanner>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = true;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 5), () {
      setState(() {
        _isExpanded = false;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: _isExpanded
            ? const EdgeInsets.all(16)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: appStore.appColorPrimary.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: _isExpanded
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.white),
                      8.width,
                      Text(
                        'Demo Mode Active',
                        style: boldTextStyle(color: Colors.white, size: 18),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _isExpanded = false;
                          });
                        },
                      ),
                    ],
                  ),
                  8.height,
                  Text(
                    'Your Email: ${getStringAsync(emailPref)}',
                    style: primaryTextStyle(color: Colors.white, size: 16),
                  ),
                  10.height,
                  Text(
                    'Login in to the admin panel to manage your data.',
                    style: secondaryTextStyle(color: Colors.white),
                  ),
                  10.height,
                  Text(
                    'Login using the tenant login button on the login screen.',
                    style: secondaryTextStyle(color: Colors.white),
                  ),
                  12.height,
                  ElevatedButton.icon(
                    onPressed: () {
                      log(getStringAsync('baseurl'));
                      launchUrl(Uri.parse(getStringAsync('baseurl')),
                          mode: LaunchMode.externalApplication);
                    },
                    icon:
                        const Icon(Icons.open_in_browser, color: Colors.white),
                    label: const Text('Visit Admin Panel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              )
            : GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = true;
                  });
                },
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.white),
                    8.width,
                    Text(
                      'Demo Details',
                      style: boldTextStyle(color: Colors.white, size: 16),
                    ),
                    const Spacer(),
                    const Icon(Icons.expand_more, color: Colors.white),
                  ],
                ),
              ),
      ),
    );
  }
}
