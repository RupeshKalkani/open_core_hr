import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/models/my_checklist_item_model.dart'; // Adjust import path

import '../../main.dart'; // For language/appStore access

part 'MyOnboardingStore.g.dart'; // Run build_runner after creating

class MyOnboardingStore = MyOnboardingStoreBase with _$MyOnboardingStore;

abstract class MyOnboardingStoreBase with Store {
  @observable
  ObservableList<MyChecklistItemModel> checklistItems =
      ObservableList<MyChecklistItemModel>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @action
  Future<void> fetchChecklist() async {
    isLoading = true;
    errorMessage = null;
    try {
      checklistItems.clear();
      final items = await apiService.getMyChecklist();
      checklistItems.addAll(items);
    } catch (e) {
      checklistItems.clear();
      log('Error fetching checklist: $e');
      errorMessage = "Failed to load onboarding tasks. Please try again.";
      // Show toast using nb_utils or handle error appropriately
      toast(errorMessage);
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> updateStatus(int checklistItemId, String newStatus,
      {String? employeeNotes}) async {
    isLoading = true; // Indicate loading for this specific action maybe?
    try {
      final success = await apiService.updateMyChecklistItemStatus(
          checklistItemId, newStatus.toLowerCase(),
          employeeNotes: employeeNotes);
      if (success) {
        toast("Task updated successfully.");
        fetchChecklist(); // Refresh the whole list
        return true;
      } else {
        toast("Failed to update task status.");
        return false;
      }
    } catch (e) {
      log('Error updating checklist status: $e');
      // Optional: Revert optimistic update
      // if (index != -1 && oldStatus != null) {
      //    checklistItems[index] = checklistItems[index]..status = oldStatus;
      // }
      toast("An error occurred while updating status.");
      return false;
    }
  }

  @action
  Future<bool> uploadFile(int checklistItemId, String filePath) async {
    isLoading = true; // Consider item-specific loading state later
    try {
      final success =
          await apiService.uploadChecklistFile(checklistItemId, filePath);
      if (success) {
        // Toast handled by ApiService for now
        fetchChecklist(); // Refresh list to show updated status/file info
        return true;
      } else {
        // Toast handled by ApiService
        return false;
      }
    } catch (e) {
      log('Error uploading checklist file: $e');
      toast("An error occurred during file upload.");
      return false;
    } finally {
      isLoading = false;
    }
  }
}
