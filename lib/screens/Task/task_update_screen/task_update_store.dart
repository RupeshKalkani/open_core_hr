import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/main.dart';

import '../../../models/Task/task_update_model.dart';

part 'task_update_store.g.dart';

class TaskUpdateStore = TaskUpdateStoreBase with _$TaskUpdateStore;

abstract class TaskUpdateStoreBase with Store {
  @observable
  bool isLoading = false;

  int? taskId;

  Position? currentPosition;

  List<TaskUpdateModel> taskUpdates = [];

  final messageController = TextEditingController();

  File? file;
  @observable
  String fileName = '';

  @observable
  String filePath = '';

  Future<String?> pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null) {
      //Check file type
      if (result.files.single.extension != 'pdf') {
        toast(language.lblOnlyPDFFilesAreAllowed);
        return null;
      }

      file = File(result.files.single.path!);
      fileName = file!.path.split('/').last;
      filePath = file!.path;

      return fileName;
    }

    return null;
  }

  Future<String?> takePhoto() async {
    var imagePicker = ImagePicker();

    XFile? result = await imagePicker.pickImage(source: ImageSource.camera);

    if (result != null) {
      file = File(result.path);
      fileName = file!.path.split('/').last;
      filePath = file!.path;

      return fileName;
    }
    return null;
  }

  Future<bool> processFile() async {
    isLoading = true;
    var file = await pickFile();
    if (file == null) {
      toast(language.lblUnableToPickFile);
      isLoading = false;
      return false;
    }
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (currentPosition == null) {
      toast(language.lblUnableToGetCurrentLocation);
      isLoading = false;
      return false;
    }

    var result = await apiService.sendTaskUpdateFile(
      taskId!,
      filePath,
      currentPosition!.latitude,
      currentPosition!.longitude,
    );
    isLoading = false;
    if (result) {
      await getTaskUpdated(taskId!);
    }

    return result;
  }

  Future<bool> processPhoto() async {
    isLoading = true;
    var photo = await takePhoto();
    if (photo == null) {
      toast(language.lblUnableToTakePhoto);
      isLoading = false;
      return false;
    }
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (currentPosition == null) {
      toast(language.lblUnableToGetCurrentLocation);
      isLoading = false;
      return false;
    }

    var result = await apiService.sendTaskUpdateImage(
      taskId!,
      filePath,
      currentPosition!.latitude,
      currentPosition!.longitude,
    );
    isLoading = false;
    if (result) {
      await getTaskUpdated(taskId!);
    }

    return result;
  }

  @action
  Future getTaskUpdated(int taskId) async {
    isLoading = true;
    taskUpdates = await apiService.getTaskUpdates(taskId);
    taskUpdates = taskUpdates.reversed.toList();
    isLoading = false;
  }

  @action
  Future<bool> sendMessage(String message) async {
    isLoading = true;

    if (message.isEmptyOrNull) {
      toast(language.lblMessageCannotBeEmpty);
      isLoading = false;
      return false;
    }

    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (currentPosition == null) {
      toast(language.lblUnableToGetCurrentLocation);
      isLoading = false;
      return false;
    }

    var result = await apiService.sendTaskUpdateMsg(
      taskId!,
      message,
      currentPosition!.latitude,
      currentPosition!.longitude,
    );

    if (result) {
      await getTaskUpdated(taskId!);
      isLoading = false;
      return true;
    }

    isLoading = false;
    return result;
  }

  @action
  Future shareLocation() async {
    isLoading = true;
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (currentPosition == null) {
      toast(language.lblUnableToGetCurrentLocation);
      isLoading = false;
      return;
    }

    var result = await apiService.sendTaskUpdateLocation(
      taskId!,
      currentPosition!.latitude,
      currentPosition!.longitude,
    );
    isLoading = false;
    if (result) {
      await getTaskUpdated(taskId!);
    }
  }
}
