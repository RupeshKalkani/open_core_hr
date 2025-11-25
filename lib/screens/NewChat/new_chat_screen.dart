import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../models/Chat/chat_list_model.dart';
import '../../models/user.dart';
import '../../utils/app_widgets.dart';
import 'new_chat_store.dart';

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({super.key});

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final _store = NewChatStore();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    _store.pagingController = PagingController(firstPageKey: 0);
    _store.pagingController.addPageRequestListener((pageKey) {
      // The fetchUsers method in store now internally checks if search is active
      _store.fetchUsers(pageKey);
    });

    // Ensure search is not active initially
    _store.clearSearch(); // This will set isSearchActive to false
  }

  @override
  void dispose() {
    _store.pagingController.dispose();
    _store.searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'New Chat'),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: Observer(
              builder: (_) {
                // Decide which list to show based on isSearchActive and query length
                final bool shouldShowSearchResults =
                    _store.isSearchActive &&
                    _store.searchController.text.length > 2;

                if (shouldShowSearchResults) {
                  if (_store.isLoading && _store.searchResults.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (_store.searchResults.isNotEmpty) {
                    return _buildSearchResults();
                  } else {
                    return Center(
                      child: Text(
                        'No users found for "${_store.searchController.text}"',
                      ),
                    );
                  }
                } else {
                  // Show paginated list
                  return _buildPaginatedUserList();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AppTextField(
        controller: _store.searchController,
        textFieldType: TextFieldType.NAME,
        onChanged: (value) {
          final String trimmedValue = value
              .trim(); // Important to use trimmed value

          if (trimmedValue.length > 2) {
            _store.setSearchActive(true);
            _store.searchUsers(trimmedValue); // Pass the trimmed value
          } else {
            // If search text becomes too short or empty
            if (_store.isSearchActive) {
              // And if we were in search mode
              _store
                  .clearSearch(); // Clears controller, results, flags, and resets latestQuery
              _store.pagingController.refresh(); // Refresh the main list
            }
          }
        },
        decoration: InputDecoration(
          hintText: 'Search users...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Observer(
            builder: (_) {
              // Add a clear button
              if (_store.searchController.text.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _store
                        .clearSearch(); // Clear controller, results, and deactivate search mode
                    _store.pagingController.refresh(); // Refresh the main list
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildPaginatedUserList() {
    return PagedListView<int, User>(
      pagingController: _store.pagingController,
      builderDelegate: PagedChildBuilderDelegate<User>(
        noItemsFoundIndicatorBuilder: (_) =>
            Center(child: noDataWidget(message: 'No users found')),
        itemBuilder: (context, user, index) {
          return _buildUserListItem(user);
        },
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _store.searchResults.length,
      itemBuilder: (context, index) {
        final user = _store.searchResults[index];
        return _buildUserListItem(user);
      },
    );
  }

  Widget _buildUserListItem(User user) {
    return ListTile(
      leading: userProfileWidget(
        user.initials,
        hideStatus: true,
        imageUrl: user.avatar,
      ),
      title: Text(
        '${user.firstName} ${user.lastName}',
        style: primaryTextStyle(),
      ),
      subtitle: Text(user.email!, style: secondaryTextStyle(size: 12)),
      onTap: () async {
        if (!mounted) return; // Check mounted state early

        // initiateChat will now return Chat? (nullable)
        final Chat? chat = await _store.initiateChat(user.id!);

        if (!mounted) return; // Check mounted state again after async operation

        if (chat != null) {
          // Pop NewChatScreen and return the created/fetched chat object.
          Navigator.pop(context, chat);
        } else {
          // Error handling or feedback is managed within _store.initiateChat via toasts.
          // You could add more specific UI feedback here if needed.
          log('Chat could not be initiated or found for user ${user.id}');
        }
      },
    );
  }
}
