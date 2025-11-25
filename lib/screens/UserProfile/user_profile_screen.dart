import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/app_widgets.dart';
import '../../main.dart';
import '../../models/user.dart';

class UserProfileScreen extends StatefulWidget {
  final int userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  User? user;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    var result = await apiService.getUserInfo(widget.userId);
    if (result != null) {
      user = result;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, language.lblProfile),
      body: isLoading
          ? loadingWidgetMaker()
          : user == null
              ? Center(
                  child: Text(language.lblUnableToGetUserInfo),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Image Section
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: (user!.avatar != null &&
                                    user!.avatar!.isNotEmpty)
                                ? NetworkImage(user!.avatar!)
                                : null,
                            child: user!.avatar == null
                                ? Icon(Icons.person,
                                    size: 60, color: Colors.grey)
                                : null,
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _getStatusColor(user!.status!),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      16.height,

                      // Employee Name and Designation
                      Text(
                        user!.fullName,
                        style: boldTextStyle(size: 20),
                      ),
                      4.height,
                      Text(
                        user!.designation!,
                        style: secondaryTextStyle(size: 14),
                      ),
                      8.height,
                      Divider(thickness: 1, color: Colors.grey[300]),
                      8.height,

                      // Work Information Section
                      _buildInfoTile(
                          Icons.badge, language.lblEmployeeCode, user!.code!),
                      _buildInfoTile(Icons.business, language.lblDesignation,
                          user!.designation!),
                      _buildInfoTile(
                          Icons.email, language.lblEmail, user!.email!),
                      _buildInfoTile(
                          Icons.phone, language.lblPhone, user!.phone!),
                      16.height,

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              launchUrl(Uri.parse('tel:${user!.phone}'));
                            },
                            icon: const Icon(Icons.call),
                            label: Text(language.lblCall),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          16.width,
                          ElevatedButton.icon(
                            onPressed: () {
                              launchUrl(Uri.parse('mailto:${user!.email}'));
                            },
                            icon: const Icon(Icons.email),
                            label: Text(language.lblEmail),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      24.height,
                    ],
                  ).paddingAll(16),
                ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: appStore.appColorPrimary),
      title: Text(label, style: primaryTextStyle()),
      subtitle: Text(value, style: secondaryTextStyle()),
    );
  }

  Color _getStatusColor(String status) {
    final Map<String, Color> statusColors = {
      'online': Colors.green,
      'offline': Colors.grey,
      'busy': Colors.red,
      'away': Colors.orange,
      'on_call': Colors.blueAccent,
      'do_not_disturb': Colors.purple,
      'on_leave': Colors.teal,
      'on_meeting': Colors.cyan,
      'unknown': Colors.grey,
    };
    return statusColors[status] ?? Colors.grey;
  }
}
