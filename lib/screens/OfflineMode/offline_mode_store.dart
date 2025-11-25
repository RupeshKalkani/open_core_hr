import 'package:mobx/mobx.dart';

part 'offline_mode_store.g.dart';

class OfflineModeStore = OfflineModeStoreBase with _$OfflineModeStore;

abstract class OfflineModeStoreBase with Store {
  @observable
  bool isOffline = false;
}
