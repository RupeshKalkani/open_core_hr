// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TaskStore on TaskStoreBase, Store {
  Computed<TaskModel?>? _$runningTaskComputed;

  @override
  TaskModel? get runningTask =>
      (_$runningTaskComputed ??= Computed<TaskModel?>(() => super.runningTask,
              name: 'TaskStoreBase.runningTask'))
          .value;
  Computed<bool>? _$hasRunningTasksComputed;

  @override
  bool get hasRunningTasks =>
      (_$hasRunningTasksComputed ??= Computed<bool>(() => super.hasRunningTasks,
              name: 'TaskStoreBase.hasRunningTasks'))
          .value;
  Computed<bool>? _$hasPendingTasksComputed;

  @override
  bool get hasPendingTasks =>
      (_$hasPendingTasksComputed ??= Computed<bool>(() => super.hasPendingTasks,
              name: 'TaskStoreBase.hasPendingTasks'))
          .value;
  Computed<bool>? _$hasHoldTaskComputed;

  @override
  bool get hasHoldTask =>
      (_$hasHoldTaskComputed ??= Computed<bool>(() => super.hasHoldTask,
              name: 'TaskStoreBase.hasHoldTask'))
          .value;
  Computed<bool>? _$hasCompletedTasksComputed;

  @override
  bool get hasCompletedTasks => (_$hasCompletedTasksComputed ??= Computed<bool>(
          () => super.hasCompletedTasks,
          name: 'TaskStoreBase.hasCompletedTasks'))
      .value;
  Computed<List<TaskModel>>? _$holdTasksComputed;

  @override
  List<TaskModel> get holdTasks =>
      (_$holdTasksComputed ??= Computed<List<TaskModel>>(() => super.holdTasks,
              name: 'TaskStoreBase.holdTasks'))
          .value;
  Computed<List<TaskModel>>? _$completedTasksComputed;

  @override
  List<TaskModel> get completedTasks => (_$completedTasksComputed ??=
          Computed<List<TaskModel>>(() => super.completedTasks,
              name: 'TaskStoreBase.completedTasks'))
      .value;
  Computed<List<TaskModel>>? _$pendingTasksComputed;

  @override
  List<TaskModel> get pendingTasks => (_$pendingTasksComputed ??=
          Computed<List<TaskModel>>(() => super.pendingTasks,
              name: 'TaskStoreBase.pendingTasks'))
      .value;

  late final _$isLoadingAtom =
      Atom(name: 'TaskStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$tasksAtom = Atom(name: 'TaskStoreBase.tasks', context: context);

  @override
  List<TaskModel> get tasks {
    _$tasksAtom.reportRead();
    return super.tasks;
  }

  @override
  set tasks(List<TaskModel> value) {
    _$tasksAtom.reportWrite(value, super.tasks, () {
      super.tasks = value;
    });
  }

  late final _$getTasksAsyncAction =
      AsyncAction('TaskStoreBase.getTasks', context: context);

  @override
  Future<dynamic> getTasks() {
    return _$getTasksAsyncAction.run(() => super.getTasks());
  }

  late final _$startTaskAsyncAction =
      AsyncAction('TaskStoreBase.startTask', context: context);

  @override
  Future<bool> startTask(int taskId) {
    return _$startTaskAsyncAction.run(() => super.startTask(taskId));
  }

  late final _$holdTaskAsyncAction =
      AsyncAction('TaskStoreBase.holdTask', context: context);

  @override
  Future<bool> holdTask() {
    return _$holdTaskAsyncAction.run(() => super.holdTask());
  }

  late final _$resumeTaskAsyncAction =
      AsyncAction('TaskStoreBase.resumeTask', context: context);

  @override
  Future<bool> resumeTask(int taskId) {
    return _$resumeTaskAsyncAction.run(() => super.resumeTask(taskId));
  }

  late final _$completeTaskAsyncAction =
      AsyncAction('TaskStoreBase.completeTask', context: context);

  @override
  Future<bool> completeTask() {
    return _$completeTaskAsyncAction.run(() => super.completeTask());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
tasks: ${tasks},
runningTask: ${runningTask},
hasRunningTasks: ${hasRunningTasks},
hasPendingTasks: ${hasPendingTasks},
hasHoldTask: ${hasHoldTask},
hasCompletedTasks: ${hasCompletedTasks},
holdTasks: ${holdTasks},
completedTasks: ${completedTasks},
pendingTasks: ${pendingTasks}
    ''';
  }
}
