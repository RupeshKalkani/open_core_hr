import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../models/Chat/chat_list_model.dart';
import '../../models/user.dart';

part 'new_chat_store.g.dart';

class NewChatStore = NewChatStoreBase with _$NewChatStore;

abstract class NewChatStoreBase with Store {
  @observable
  bool isLoading = false;

  @observable
  bool isSearchActive = false;

  final TextEditingController searchController = TextEditingController();
  static const int pageSize = 10;

  late PagingController<int, User> pagingController;

  @observable
  ObservableList<User> searchResults = ObservableList<User>();

  // To track the latest query initiated by the user for search
  String _latestSearchQueryAttempt = "";
  // To track the query for which an API call is currently in flight (if any)
  String _currentApiQuery = "";

  @action
  void setSearchActive(bool isActive) {
    isSearchActive = isActive;
  }

  @action
  Future<List<User>> fetchPaginatedUsers(int skip) async {
    // isLoading = true;
    try {
      final result = await apiService.getPaginatedUsers(skip, pageSize);
      return result;
    } catch (e) {
      toast('Error fetching users');
      return [];
    } finally {
      // isLoading = false;
    }
  }

  Future<void> fetchUsers(int pageKey) async {
    // Only fetch paginated users if search is not active or query is too short
    if (isSearchActive && searchController.text.length > 2) {
      // If search is active with a valid query, PagingController should not fetch.
      // It's good practice to prevent it, though the UI will hide it.
      // Alternatively, ensure PagingController is not even active/listening.
      return;
    }
    try {
      isLoading = true; // Show loading for paginated list
      final result = await fetchPaginatedUsers(pageKey);
      final isLastPage = result.length < pageSize;

      if (isLastPage) {
        pagingController.appendLastPage(result);
      } else {
        pagingController.appendPage(result, pageKey + result.length);
      }
    } catch (error) {
      pagingController.error = error;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> searchUsers(String query) async {
    final trimmedQuery = query.trim();
    _latestSearchQueryAttempt =
        trimmedQuery; // User wants results for this query now

    if (trimmedQuery.length <= 2) {
      // This case should ideally be handled by the UI before calling searchUsers,
      // or by clearSearch if user deletes text.
      // If called directly, ensure searchResults are cleared if we were searching.
      if (isSearchActive) {
        searchResults.clear();
        // Consider if isLoading should be set to false here if a previous search was loading.
        // For safety, if a call for this query was in flight, and now it's too short,
        // setting isLoading = false if _currentApiQuery == trimmedQuery might be good.
        if (_currentApiQuery == trimmedQuery) isLoading = false;
      }
      return;
    }

    // If a search for this exact query is already in flight, don't start another.
    // if (_currentApiQuery == trimmedQuery && isLoading) {
    //   return;
    // }
    // This simple check above might not be enough if you want to cancel/override.
    // The _latestSearchQueryAttempt check after await is usually more effective.

    isLoading = true;
    _currentApiQuery =
        trimmedQuery; // This specific API call is for trimmedQuery

    try {
      final result = await apiService.searchChatUser(trimmedQuery);

      // CRITICAL: Only update if the results are for the LATEST query attempt.
      // This prevents an older, slower API response from overwriting newer results.
      if (trimmedQuery == _latestSearchQueryAttempt) {
        searchResults
            .clear(); // Clear previous results for this specific latest query
        searchResults.addAll(result);
      }
      // If trimmedQuery != _latestSearchQueryAttempt, it means user typed something new
      // while this API call was in flight. So, we discard these stale results.
    } catch (e) {
      // Only show error if it's for the latest query attempt
      if (trimmedQuery == _latestSearchQueryAttempt) {
        toast('Error searching users: $e');
        searchResults.clear(); // Clear results on error for the relevant search
      }
    } finally {
      // Only set isLoading to false if this API call was for the LATEST query attempt.
      // If user typed more, another searchUsers call would have set isLoading to true again.
      if (trimmedQuery == _latestSearchQueryAttempt) {
        isLoading = false;
      }
      // If this was not the latest query, _currentApiQuery might not be _latestSearchQueryAttempt.
      // Reset _currentApiQuery if this specific call is done, to allow a new call for the same query later if needed.
      if (_currentApiQuery == trimmedQuery) {
        _currentApiQuery = "";
      }
    }
  }

  @action
  void clearSearch() {
    searchController.clear();
    searchResults.clear();
    isSearchActive = false;
    _latestSearchQueryAttempt = ""; // Reset tracking
    _currentApiQuery = ""; // Reset tracking
    isLoading = false; // Ensure loading is off
  }

  @action
  Future<Chat> createGroupChat(String groupName, List<int> userIds) async {
    isLoading = true;
    try {
      final chat = await apiService.createGroupChat(
        userIds,
        isGroupChat: true,
        groupName: groupName,
      );
      //chats.insert(0, chat);
      return chat;
    } catch (e) {
      toast('Failed to create group chat');
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<Chat?> initiateChat(int userId) async {
    isLoading = true;
    try {
      final chat = await apiService.createChat([userId]); // Attempt to create
      return chat;
    } catch (e) {
      final errorString = e.toString().toLowerCase();
      // Customize this condition based on the actual error message or type from your API
      if (errorString.contains('chat already exists') ||
          errorString.contains('already exists')) {
        log('Chat already exists. Opening existing one...');
        try {
          // IMPORTANT: You need an API service method to fetch a 1-on-1 chat by the other user's ID.
          // Replace 'apiService.getOneToOneChatByUserId(userId)' with your actual method.
          // If your API doesn't have a direct way, you might need to fetch all user's chats
          // and find the 1-on-1 chat with 'userId' locally, though less efficient.
          final Chat? existingChat = await apiService.getOneToOneChatByUserId(
            userId,
          ); // Example method

          if (existingChat != null) {
            return existingChat;
          } else {
            toast(
              'Could not retrieve the existing chat. It might have been deleted.',
            );
            log(
              'Failed to retrieve existing chat for user $userId after createChat indicated it exists.',
            );
            return null;
          }
        } catch (fetchError) {
          log("Error fetching existing chat for user $userId: $fetchError");
          toast('Error opening existing chat. Please try again.');
          return null;
        }
      } else {
        // For other unexpected errors
        log("Error initiating chat with user $userId: $e");
        toast('Failed to initiate chat. An unexpected error occurred.');
        return null; // Or rethrow if you have a global error handler for critical issues
      }
    } finally {
      isLoading = false;
    }
  }
}
