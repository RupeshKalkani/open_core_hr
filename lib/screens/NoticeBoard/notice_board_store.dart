import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../models/notice_model.dart';

part 'notice_board_store.g.dart';

class NoticeBoardStore = NoticeBoardStoreBase with _$NoticeBoardStore;

abstract class NoticeBoardStoreBase with Store {
  @observable
  bool isLoading = false;

  final Box<NoticeModel> _noticeBox = Hive.box<NoticeModel>('noticeBoardBox');

  @observable
  ObservableList<NoticeModel> notices = ObservableList<NoticeModel>();

  @action
  getNoticeBoard() async {
    if (_noticeBox.isNotEmpty) {
      notices.clear();
      notices.addAll(_noticeBox.values);
    }
    updateNoticeBoardInBackground();
  }

  Future<void> updateNoticeBoardInBackground() async {
    try {
      // Fetch the latest notices from the server
      final apiNotices = await apiService.getNotices();

      // Extract IDs of the notices from the server
      final serverNoticeIds = apiNotices.map((notice) => notice.id).toSet();

      // Extract IDs of the notices stored locally
      final localNoticeIds =
          _noticeBox.values.map((notice) => notice.id).toSet();

      // Identify notices to remove: present locally but not on the server
      final noticesToRemove = localNoticeIds.difference(serverNoticeIds);

      // Remove obsolete notices from the local Hive box
      for (var noticeId in noticesToRemove) {
        final key = _noticeBox.keys.firstWhere(
          (k) => _noticeBox.get(k)?.id == noticeId,
          orElse: () => null,
        );
        if (key != null) {
          await _noticeBox.delete(key);
        }
      }

      // Identify new notices to add: present on the server but not locally
      final newNotices = apiNotices
          .where((notice) => !localNoticeIds.contains(notice.id))
          .toList();

      // Add new notices to the local Hive box
      for (var notice in newNotices) {
        await _noticeBox.add(notice);
      }

      // Update the in-memory list to reflect the current state of the Hive box
      notices
        ..clear()
        ..addAll(_noticeBox.values);

      log('${newNotices.length} new notices added, ${noticesToRemove.length} notices removed');
    } catch (e) {
      log('Error updating notices: ${e.toString()}');
      // Handle the error appropriately
    }
  }
}
