import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../models/Task/task_model.dart';

part 'task_store.g.dart';

class TaskStore = TaskStoreBase with _$TaskStore;

abstract class TaskStoreBase with Store {
  @observable
  bool isLoading = false;

  Position? position;

  @observable
  List<TaskModel> tasks = ObservableList<TaskModel>();

  @computed
  TaskModel? get runningTask => tasks.firstWhere(
        (element) => element.status!.toLowerCase() == 'inprogress',
        orElse: () => TaskModel(),
      );

  @computed
  bool get hasRunningTasks =>
      tasks.any((element) => element.status!.toLowerCase() == 'inprogress');

  @computed
  bool get hasPendingTasks =>
      tasks.any((element) => element.status!.toLowerCase() == 'new');

  @computed
  bool get hasHoldTask =>
      tasks.any((element) => element.status!.toLowerCase() == 'hold');

  @computed
  bool get hasCompletedTasks =>
      tasks.any((element) => element.status!.toLowerCase() == 'completed');

  @computed
  List<TaskModel> get holdTasks => tasks
      .where((element) => element.status!.toLowerCase() == 'hold')
      .toList();

  @computed
  List<TaskModel> get completedTasks => tasks
      .where((element) => element.status!.toLowerCase() == 'completed')
      .toList();

  @computed
  List<TaskModel> get pendingTasks =>
      tasks.where((element) => element.status!.toLowerCase() == 'new').toList();

  @action
  Future getTasks() async {
    isLoading = true;
    var result = await apiService.getTasks();
    tasks.clear();
    tasks.addAll(result);
    isLoading = false;
  }

  @action
  Future<bool> startTask(int taskId) async {
    if (!globalAttendanceStore.isCheckedIn) {
      toast(language.lblPleaseCheckInFirst);
      return false;
    }
    isLoading = true;
    //Get location
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (position == null) {
      isLoading = false;
      toast(language.lblUnableToGetLocationPleaseEnableLocationServices);
      return false;
    }
    var result = await apiService.startTask(
        taskId, position!.latitude, position!.longitude);
    isLoading = false;
    getTasks();
    return result;
  }

  @action
  Future<bool> holdTask() async {
    if (!globalAttendanceStore.isCheckedIn) {
      toast(language.lblPleaseCheckInFirst);
      return false;
    }
    isLoading = true;

    //Get location
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (position == null) {
      isLoading = false;
      toast(language.lblUnableToGetLocationPleaseEnableLocationServices);
      return false;
    }

    var result = await apiService.holdTask(
        runningTask!.id!, position!.latitude, position!.longitude);
    isLoading = false;
    getTasks();
    return result;
  }

  @action
  Future<bool> resumeTask(int taskId) async {
    if (!globalAttendanceStore.isCheckedIn) {
      toast(language.lblPleaseCheckInFirst);
      return false;
    }
    isLoading = true;
    //Get location
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (position == null) {
      isLoading = false;
      toast(language.lblUnableToGetLocationPleaseEnableLocationServices);
      return false;
    }

    var result = await apiService.resumeTask(
        taskId, position!.latitude, position!.longitude);
    isLoading = false;
    getTasks();
    return result;
  }

  @action
  Future<bool> completeTask() async {
    if (!globalAttendanceStore.isCheckedIn) {
      toast(language.lblPleaseCheckInFirst);
      return false;
    }
    isLoading = true;
    //Get location
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (position == null) {
      isLoading = false;
      toast(language.lblUnableToGetLocationPleaseEnableLocationServices);
      return false;
    }
    var result = await apiService.completeTask(
        runningTask!.id!, position!.latitude, position!.longitude);
    isLoading = false;
    getTasks();
    return result;
  }
}
