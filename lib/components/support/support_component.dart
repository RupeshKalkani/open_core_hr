import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../../utils/app_constants.dart';

class SupportComponent extends StatefulWidget {
  const SupportComponent({super.key});

  @override
  State<SupportComponent> createState() => _SupportComponentState();
}

//TODO: Link not opening issue need to fix
class _SupportComponentState extends State<SupportComponent> {
  String supportEmail = '';
  String supportPhone = '';
  String supportWhatsApp = '';
  String website = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setState(() => isLoading = true);

    supportEmail = getStringAsync(appSupportEmailPref).isNotEmpty
        ? getStringAsync(appSupportEmailPref)
        : "support@wuv.studio";
    supportPhone = getStringAsync(appSupportPhonePref).isNotEmpty
        ? getStringAsync(appSupportPhonePref)
        : "+1 336-310-9644";
    supportWhatsApp = getStringAsync(appSupportWhatsAppPref).isNotEmpty
        ? getStringAsync(appSupportWhatsAppPref)
        : "+1 336-310-9644";
    website = getStringAsync(appWebsiteUrlPref).isNotEmpty
        ? getStringAsync(appWebsiteUrlPref)
        : "www.facilitymate.com";

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(color: appStore.appPrimaryColor),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSupportButton(
                    icon: Icons.call,
                    label: 'Call Support',
                    onTap: () => _makePhoneCall(),
                  ),
                  _buildSupportButton(
                    icon: Icons.email,
                    label: 'Mail Support',
                    onTap: () => _sendEmail(),
                  ),
                  // _buildSupportButton(
                  //   icon: Icons.message,
                  //   label: 'WhatsApp',
                  //   onTap: () => _openWhatsApp(),
                  // ),
                  _buildSupportButton(
                    icon: Icons.web,
                    label: 'Visit Website',
                    onTap: () => _openWebsite(),
                  ),
                ],
              ),
            ],
          );
  }

  // Reusable Support Button
  Widget _buildSupportButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: appStore.appPrimaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: white, size: 24),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: primaryTextStyle(size: 14)),
      ],
    );
  }

  // Open Phone Call
  Future<void> _makePhoneCall() async {
    final Uri url = Uri.parse("tel:$supportPhone");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      toast('Unable to make a phone call');
    }
  }

  // Send Email
  Future<void> _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query: Uri.encodeComponent(
        'subject=I need help from $mainAppName Employee App',
      ),
    );
    try {
      await launchUrl(emailUri);
    } catch (e) {
      toast('Unable to send email');
    }
  }

  // Open WhatsApp
  Future<void> _openWhatsApp() async {
    final Uri url = Uri.parse("https://wa.me/$supportWhatsApp");
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      toast('Unable to open WhatsApp');
    }
  }

  // Open Website
  Future<void> _openWebsite() async {
    final Uri url = Uri.parse(website);
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      toast('Unable to open the website');
    }
  }
}
