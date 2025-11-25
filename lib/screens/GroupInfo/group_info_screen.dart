import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/Utils/app_widgets.dart';
import 'package:open_core_hr/models/user.dart';

import '../../main.dart';
import '../../models/Chat/chat_list_model.dart';

class GroupInfoScreen extends StatefulWidget {
  final Chat chat;

  const GroupInfoScreen({super.key, required this.chat});

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  bool isLoading = true;
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    try {
      users = await apiService.getParticipants(widget.chat.id);
    } catch (e) {
      toast(language.lblFailedToLoadParticipants);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, language.lblGroupInfo),
      body: isLoading
          ? loadingWidgetMaker()
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Group Header Section
                  _buildGroupHeader(),

                  16.height,

                  // Members Section
                  _buildMembersSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildGroupHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          userProfileWidget(widget.chat.name, size: 35, hideStatus: true),
          12.height,

          // Group Name
          Text(
            widget.chat.name,
            style: boldTextStyle(size: 20),
            textAlign: TextAlign.center,
          ),
          4.height,

          /* // Group Description (if available)
          Text(
            widget.chat.description ?? 'No description available',
            style: secondaryTextStyle(),
            textAlign: TextAlign.center,
          ),*/
        ],
      ),
    );
  }

  Widget _buildMembersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language.lblGroupMembers, style: boldTextStyle(size: 18))
            .paddingSymmetric(horizontal: 16),
        8.height,
        ListView.builder(
          itemCount: users.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final user = users[index];
            return _buildMemberTile(user);
          },
        )
      ],
    );
  }

  /// 🧑 Individual Member Tile
  Widget _buildMemberTile(User user) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage:
                user.avatar != null ? NetworkImage(user.avatar!) : null,
            child: user.avatar == null
                ? Text(
                    user.initials,
                    style: boldTextStyle(size: 16),
                  )
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getStatusColor(user.status ?? 'unknown'),
                border: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
      title: Text(user.fullName, style: primaryTextStyle()),
      subtitle: Text(
        user.designation ?? language.lblNoDesignation,
        style: secondaryTextStyle(),
      ),
      trailing: user.role == 'admin'
          ? Chip(
              label: Text(language.lblAdmin,
                  style: secondaryTextStyle(color: Colors.white)),
              backgroundColor: Colors.orange,
              visualDensity: VisualDensity.compact,
            )
          : null,
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
