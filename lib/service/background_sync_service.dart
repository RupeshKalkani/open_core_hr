import 'package:hive/hive.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../models/Document/document_type_model.dart';
import '../models/Expense/expense_type_model.dart';
import '../models/leave_type_model.dart';
import '../utils/app_constants.dart';

class BackgroundSyncService {
  Future<void> syncAllMasters() async {
    var leaveTypes = await apiService.getLeaveTypes();

    final Box<LeaveTypeModel> leaveTypeBox =
        Hive.box<LeaveTypeModel>('leaveTypeBox');

    leaveTypeBox.clear();
    for (var leaveType in leaveTypes) {
      leaveTypeBox.add(leaveType);
    }

    var expenseTypes = await apiService.getExpenseTypes();

    final Box<ExpenseTypeModel> expenseTypeBox =
        Hive.box<ExpenseTypeModel>('expenseTypeBox');

    expenseTypeBox.clear();
    for (var expenseType in expenseTypes) {
      expenseTypeBox.add(expenseType);
    }

    var documentTypes = await apiService.getDocumentTypes();

    final Box<DocumentTypeModel> documentTypeBox =
        Hive.box<DocumentTypeModel>('documentTypeBox');

    documentTypeBox.clear();

    for (var documentType in documentTypes) {
      documentTypeBox.add(documentType);
    }

    setValue(lastSyncRunAtPref, DateTime.now().toString());
  }
}
