import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/screens/NewChat/new_chat_store.dart';

import '../../main.dart';
import '../../models/user.dart';
import '../../utils/app_widgets.dart';

class GroupCreationScreen extends StatefulWidget {
  const GroupCreationScreen({super.key});

  @override
  State<GroupCreationScreen> createState() => _GroupCreationScreenState();
}

class _GroupCreationScreenState extends State<GroupCreationScreen> {
  final NewChatStore _chatListStore = NewChatStore();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _groupNameController = TextEditingController();

  List<int> selectedUserIds = []; // Selected user IDs.
  static const int pageSize = 10; // Number of users to fetch per page.

  late PagingController<int, User> _pagingController;

  @override
  void initState() {
    super.initState();

    // Initialize PagingController for infinite scroll.
    _pagingController = PagingController(firstPageKey: 0);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchUsers(pageKey);
    });

    _chatListStore.clearSearch(); // Clear previous search results.
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchUsers(int pageKey) async {
    try {
      final result = await _chatListStore.fetchPaginatedUsers(pageKey);
      final isLastPage = result.length < pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(result);
      } else {
        _pagingController.appendPage(result, pageKey + result.length);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, language.lblCreateGroup),
      body: Column(
        children: [
          _buildGroupNameInput(),
          _buildSearchBar(),
          Expanded(
            child: Observer(
              builder: (_) {
                return _chatListStore.searchResults.isNotEmpty
                    ? _buildSearchResults()
                    : _buildPaginatedUserList();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: appStore.appColorPrimary,
        onPressed: _createGroupChat,
        icon: const Icon(Icons.done, color: Colors.white),
        label: Text(
          language.lblCreateGroup,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildGroupNameInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AppTextField(
        controller: _groupNameController,
        textFieldType: TextFieldType.NAME,
        decoration: InputDecoration(
          hintText: language.lblEnterGroupName,
          prefixIcon: const Icon(Icons.group),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
        onChanged: (value) {
          if (value.length > 2) {
            _chatListStore.searchUsers(value);
          } else {
            _chatListStore.clearSearch();
            _pagingController.refresh();
          }
        },
        decoration: InputDecoration(
          hintText: '${language.lblSearchUsers}...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildPaginatedUserList() {
    return PagedListView<int, User>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<User>(
        itemBuilder: (context, user, index) {
          final isSelected = selectedUserIds.contains(user.id);

          return ListTile(
            leading: userProfileWidget(
              user.initials,
              hideStatus: true,
              imageUrl: user.avatar,
            ),
            title: Text('${user.firstName} ${user.lastName}'),
            subtitle: Text(user.email!),
            trailing: Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? appStore.appColorPrimary : null,
            ),
            onTap: () {
              setState(() {
                isSelected
                    ? selectedUserIds.remove(user.id)
                    : selectedUserIds.add(user.id!);
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _chatListStore.searchResults.length,
      itemBuilder: (context, index) {
        final user = _chatListStore.searchResults[index];
        final isSelected = selectedUserIds.contains(user.id);

        return ListTile(
          leading: userProfileWidget(
            user.initials,
            hideStatus: true,
            imageUrl: user.avatar,
          ),
          title: Text('${user.firstName} ${user.lastName}'),
          subtitle: Text(user.email.toString()),
          trailing: Icon(
            isSelected ? Icons.check_circle : Icons.circle_outlined,
            color: isSelected ? appStore.appColorPrimary : null,
          ),
          onTap: () {
            setState(() {
              isSelected
                  ? selectedUserIds.remove(user.id)
                  : selectedUserIds.add(user.id!);
            });
          },
        );
      },
    );
  }

  Future<void> _createGroupChat() async {
    hideKeyboard(context);
    if (_groupNameController.text.isEmpty || selectedUserIds.isEmpty) {
      toast(language.lblPleaseEnterAGroupNameAndSelectUsers);
      return;
    }

    final groupName = _groupNameController.text;
    final chat = await _chatListStore.createGroupChat(
      groupName,
      selectedUserIds,
    );

    if (!mounted) return;
    Navigator.pop(context, chat);
  }
}
