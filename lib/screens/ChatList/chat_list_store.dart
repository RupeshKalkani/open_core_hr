import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../models/Chat/chat_list_model.dart';
import '../../models/user.dart';

part 'chat_list_store.g.dart';

class ChatListStore = ChatListStoreBase with _$ChatListStore;

abstract class ChatListStoreBase with Store {
  @observable
  bool isLoading = false;

  @observable
  ObservableList<Chat> chats = ObservableList<Chat>();

  final Box<Chat> _chatBox = Hive.box<Chat>('chatBox');

  @action
  Future<List<User>> fetchPaginatedUsers(int skip, int take) async {
    isLoading = true;
    try {
      final result = await apiService.getPaginatedUsers(skip, take);
      return result;
    } catch (e) {
      toast('Error fetching users');
      return [];
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> fetchChats() async {
    isLoading = true;
    // Load from Hive (Local storage)
    if (_chatBox.isNotEmpty) {
      chats.clear();
      chats.addAll(_chatBox.values);
      isLoading = false;
    }
    // Fetch from API for latest updates
    try {
      final apiChats = await apiService.getChats();
      await _chatBox.clear(); // Clear old data
      await _chatBox.addAll(apiChats); // Save new data locally
      chats.clear();
      chats.addAll(apiChats);
    } catch (e) {
      log('Failed to fetch chats: $e');
    }
    isLoading = false;
  }

  /// Search chats locally
  @action
  void searchChats(String query) {
    final filteredChats = _chatBox.values
        .where((chat) => chat.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    chats.clear();
    chats.addAll(filteredChats);
  }

  /// Add new chat to Hive
  @action
  Future<void> addChat(Chat chat) async {
    await _chatBox.add(chat);
    chats.add(chat);
  }
}
