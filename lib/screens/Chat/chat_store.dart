import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../main.dart';
import '../../models/chat_response.dart';

part 'chat_store.g.dart';

class ChatStore = ChatStoreBase with _$ChatStore;

abstract class ChatStoreBase with Store {
  static const pageSize = 20;

  Timer? _pollingTimer;

  @observable
  bool isLoading = false;

  @observable
  int? userId;

  int? chatId;

  @observable
  PagingController<int, ChatMessage> pagingController =
      PagingController(firstPageKey: 0);

  void startPollingForMessages() {
    _pollingTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await fetchNewMessages();
    });
  }

  @action
  Future<void> fetchMessages(int pageKey, int chatId) async {
    /* try {*/
    isLoading = true;
    final result = await apiService.getChatMessages(
      chatId,
      skip: pageKey,
      take: pageSize,
    );

    if (result != null) {
      final isLastPage = result.values!.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(result.values!);
      } else {
        pagingController.appendPage(
            result.values!, pageKey + result.values!.length);
      }
    } else {
      pagingController.appendLastPage([]);
    }
  }

  @action
  Future<void> sendMessage(int chatId, String content,
      {String type = 'text', bool isForward = false}) async {
    if (isForward) {
      await apiService.sendMessage(chatId, content, type: type);
      return;
    }

    stopPolling();

    // Create a new message object
    var newMessage = ChatMessage(
      id: 0,
      userId: appStore.userId,
      content: content,
      createdAt: dateTimeFormatter.format(DateTime.now()),
      createdAtHuman: timeago.format(DateTime.now()),
      messageType: type,
      userName: 'You',
      time: timeFormat.format(DateTime.now()),
    );

    // Add the new message to the PagingController items
    final currentItems = pagingController.itemList ?? [];
    pagingController.itemList = [newMessage, ...currentItems];
    pagingController.notifyListeners();

    var result = await apiService.sendMessage(chatId, content, type: type);

    if (result != null) {
      // Update the message with the new id
      newMessage.id = result;
      pagingController.itemList = [newMessage, ...currentItems];
      pagingController.notifyListeners();

      log('First item id new ${pagingController.itemList?.first.id}');

      startPollingForMessages();
    } else {
      toast(language.lblFailedToSendMessage);
    }
  }

  @action
  Future<bool> sendAttachment(int chatId, String filePath, String type) async {
    try {
      var messageType = 'file';
      if (['jpg', 'jpeg', 'png'].contains(type)) messageType = 'image';
      if (['mp4', 'mov', 'avi'].contains(type)) messageType = 'video';
      if (['gif'].contains(type)) messageType = 'gif';
      if (['mp3', 'wav', 'm4a'].contains(type)) messageType = 'audio';
      if (['pdf', 'doc', 'docx'].contains(type)) messageType = 'document';
      if (['zip', 'rar'].contains(type)) messageType = 'archive';
      if (['xls', 'xlsx'].contains(type)) messageType = 'spreadsheet';
      if (['ppt', 'pptx'].contains(type)) messageType = 'presentation';
      if (['txt'].contains(type)) messageType = 'txt';
      if (['apk'].contains(type)) messageType = 'apk';

      // Temporary loading message
      var tempMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch,
        userId: appStore.userId,
        content: 'Uploading file please wait...',
        createdAt: dateTimeFormatter.format(DateTime.now()),
        createdAtHuman: timeago.format(DateTime.now()),
        messageType: 'loading',
        userName: 'You',
        time: timeFormat.format(DateTime.now()),
      );

      final currentItems = pagingController.itemList ?? [];
      pagingController.itemList = [tempMessage, ...currentItems];
      pagingController.notifyListeners();

      var result =
          await apiService.sendAttachment(chatId, filePath, messageType);
      pagingController.refresh(); // Refresh to show attachment
      return result;
    } catch (e) {
      toast(language.lblFailedToSendAttachment);
      return false;
    }
  }

  @action
  Future<void> fetchNewMessages() async {
    if (pagingController.itemList == null ||
        pagingController.itemList!.isEmpty ||
        chatId == null) {
      return;
    }
    log('Fetching new messages');
    final result = await apiService.getNewChatMessages(
        chatId!, pagingController.itemList!.first.id);

    log('New messages count: ${result.length}');

    if (result.isNotEmpty) {
      pagingController.itemList = [...result, ...?pagingController.itemList];
      pagingController.notifyListeners();
    }
  }

  @action
  Future forwardFile(int chatId, int messageId) async {
    var result = await apiService.forwardFile(chatId, messageId);
  }

  void stopPolling() {
    _pollingTimer?.cancel();
  }

  Future<String> downloadFile(String url) async {
    final dio = Dio();
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${url.split('/').last}';

    if (!File(filePath).existsSync()) {
      await dio.download(url, filePath);
    }

    return filePath;
  }
}
