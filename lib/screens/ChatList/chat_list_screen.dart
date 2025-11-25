import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../models/Chat/chat_list_model.dart';
import '../../utils/app_widgets.dart';
import '../Chat/chat_screen.dart';
import '../NewChat/group_creation_screen.dart';
import '../NewChat/new_chat_screen.dart';
import 'chat_list_store.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final ChatListStore _chatListStore = ChatListStore();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chatListStore.fetchChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, language.lblChats, hideBack: true),
      body: Column(
        children: [
          _buildSearchBar(),
          Observer(
            builder: (_) {
              if (_chatListStore.isLoading) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (_, __) {
                      return buildShimmer(
                        80,
                        context.width(),
                      ).paddingOnly(left: 8, right: 8);
                    },
                  ),
                );
              }
              if (_chatListStore.chats.isEmpty) {
                return Center(
                  child: noDataWidget(message: language.lblNoChatsFound),
                );
              }

              return Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _chatListStore.chats.length,
                  itemBuilder: (context, index) {
                    final chat = _chatListStore.chats[index];
                    return _buildChatListItem(chat);
                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: appStore.appColorPrimary,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => _buildChatTypeSelector(),
          );
        },
        icon: const Icon(Icons.group_add, color: Colors.white),
        label: Text(language.lblNewChat, style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildChatTypeSelector() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.chat_outlined),
              title: Text(language.lblNewChat),
              onTap: () async {
                Navigator.pop(context);
                final dynamic result = await const NewChatScreen().launch(
                  context,
                );
                if (result != null && result is Chat) {
                  // A chat was successfully initiated (either new or existing)
                  await _chatListStore.fetchChats(); // Refresh the chat list
                  if (mounted) {
                    // Ensure widget is still in the tree
                    ChatScreen(
                      chat: result,
                    ).launch(context); // Navigate to the ChatScreen
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_add_outlined),
              title: Text(language.lblNewGroup),
              onTap: () async {
                Navigator.pop(context);
                final dynamic result = await const GroupCreationScreen().launch(
                  context,
                );
                if (result != null && result is Chat) {
                  await _chatListStore.fetchChats(); // Refresh the chat list
                  if (mounted) {
                    ChatScreen(
                      chat: result,
                    ).launch(context); // Navigate to the ChatScreen
                  }
                }
              },
            ),
            20.height,
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AppTextField(
        controller: _searchController,
        textFieldType: TextFieldType.NAME,
        onChanged: (value) => _chatListStore.searchChats(value),
        decoration: newEditTextDecoration(Icons.search, language.lblSearch),
      ),
    );
  }

  Widget _buildChatListItem(Chat chat) {
    return ListTile(
      leading: userProfileWidget(
        chat.name,
        hideStatus: true,
        imageUrl: chat.avatar,
      ),
      title: Text(chat.name, style: primaryTextStyle(size: 16)),
      subtitle: Text(
        chat.lastMessage ?? language.lblNoMessagesYet,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: secondaryTextStyle(size: 12),
      ),
      trailing: Text(chat.updatedAt, style: secondaryTextStyle(size: 10)),
      onTap: () async {
        await ChatScreen(chat: chat).launch(context);
        _chatListStore.fetchChats();
      },
    );
  }
}
