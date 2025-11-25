import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/api/result.dart';
import 'package:open_core_hr/models/Client/client_model.dart';
import 'package:open_core_hr/models/Client/client_model_skip_take.dart';
import 'package:open_core_hr/models/Document/document_type_model.dart';
import 'package:open_core_hr/models/Expense/expense_request_model.dart';
import 'package:open_core_hr/models/Expense/expense_type_model.dart';
import 'package:open_core_hr/models/Order/order_count_model.dart';
import 'package:open_core_hr/models/Order/product_model.dart';
import 'package:open_core_hr/models/Settings/app_settings_model.dart';
import 'package:open_core_hr/models/Visit/visit_model.dart';
import 'package:open_core_hr/models/attendance_history_model.dart';
import 'package:open_core_hr/models/chat_response.dart';
import 'package:open_core_hr/models/dashboard_model.dart';
import 'package:open_core_hr/models/notification_model.dart';
import 'package:open_core_hr/models/payslip_model.dart';
import 'package:open_core_hr/models/status/status_response.dart';
import 'package:open_core_hr/models/user_model.dart';
import 'package:open_core_hr/models/user_status.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/Chat/chat_list_model.dart';
import '../models/Document/document_request_model.dart';
import '../models/DomainModel.dart';
import '../models/Form/form_model.dart';
import '../models/Loan/loan_request_model.dart';
import '../models/Order/order_model.dart';
import '../models/Order/product_category_model.dart';
import '../models/PaymentCollection/payment_collection_model.dart';
import '../models/Sales/sales_target.dart';
import '../models/Settings/module_settings_model.dart';
import '../models/Task/task_model.dart';
import '../models/Task/task_update_model.dart';
import '../models/Visit/VisitCountModel.dart';
import '../models/api_response_model.dart';
import '../models/calendar_event_model.dart';
import '../models/holiday_model.dart';
import '../models/leave_request_model.dart';
import '../models/leave_type_model.dart';
import '../models/my_checklist_item_model.dart';
import '../models/notice_model.dart';
import '../models/sales_target_model.dart';
import '../models/schedule_model.dart';
import '../models/user.dart';
import 'api_routes.dart';
import 'network_utils.dart';

class ApiService {
  Future<bool> updateMyChecklistItemStatus(
    int checklistItemId,
    String newStatus, {
    String? employeeNotes,
  }) async {
    String url = APIRoutes.updateMyChecklistItemStatus.replaceFirst(
      '{id}',
      checklistItemId.toString(),
    );
    Map<String, dynamic> payload = {'status': newStatus}; // Use dynamic map
    if (employeeNotes != null && employeeNotes.isNotEmpty) {
      payload['employeeNotes'] = employeeNotes; // Add notes if provided
    }
    var response = await handleResponse(await postRequest(url, payload));
    return checkSuccessCase(response, showError: true);
  }

  Future<bool> uploadChecklistFile(int checklistItemId, String filePath) async {
    String url = APIRoutes.uploadMyChecklistFile.replaceFirst(
      '{id}',
      checklistItemId.toString(),
    );

    var result = await multipartRequest(url, filePath);

    if (result) {
      return true;
    } else {
      toast("Failed to upload file.");
      return false;
    }
  }

  // Helper to launch download URL (use url_launcher package)
  Future<void> launchDownloadUrl(String? url) async {
    if (url == null || url.isEmpty) {
      toast("No file URL available.");
      return;
    }
    var result = await handleResponse(await getRequest(url));

    if (!checkSuccessCase(result)) {
      return;
    }

    if (await canLaunchUrl(result!.data!)) {
      // Might need launchMode: LaunchMode.externalApplication for direct download prompt
      await launchUrl(
        result.data!,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );
    } else {
      toast("Could not launch download URL.");
    }
  }

  Future<List<MyChecklistItemModel>> getMyChecklist() async {
    var response = await handleResponse(
      await getRequest(APIRoutes.getMyOnboardingChecklist),
    );
    if (!checkSuccessCase(response)) return []; // Return empty list on failure

    // API returns a list directly based on controller logic
    Iterable list = response?.data;
    return list.map((m) => MyChecklistItemModel.fromJson(m)).toList();
  }

  Future<List<CalendarEventModel>> getEvents(
    DateTime start,
    DateTime end,
  ) async {
    Map<String, String> query = {
      "start": DateFormat(
        'yyyy-MM-dd',
      ).format(start.toUtc()), // Send UTC dates if backend expects that
      "end": DateFormat('yyyy-MM-dd').format(end.toUtc()),
    };
    final uri = Uri(queryParameters: query).query;
    var response = await handleResponse(
      await getRequestWithQuery(APIRoutes.events, uri),
    );
    if (!checkSuccessCase(response) || response?.data['values'] == null)
      return [];
    Iterable list = response?.data['values'];
    return list.map((m) => CalendarEventModel.fromJson(m)).toList();
  }

  // Create a new event
  Future<CalendarEventModel?> createEvent(Map<String, dynamic> payload) async {
    /*    // Ensure date times are formatted correctly, e.g., ISO8601 or Y-m-d H:i:s
    if (payload['eventStart'] is DateTime) {
      payload['eventStart'] =
          (payload['eventStart'] as DateTime).toIso8601String();
    }
    if (payload['eventEnd'] is DateTime) {
      payload['eventEnd'] = (payload['eventEnd'] as DateTime).toIso8601String();
    } else {
      payload.remove('eventEnd'); // Don't send null if not provided
    }*/

    var response = await handleResponse(
      await postRequest(APIRoutes.events, payload),
    );
    if (!checkSuccessCase(response, showError: true)) return null;
    return CalendarEventModel.fromJson(
      response!.data,
    ); // Assuming API returns created event
  }

  // Update an existing event
  Future<CalendarEventModel?> updateEvent(
    int eventId,
    Map<String, dynamic> payload,
  ) async {
    // Ensure date times are formatted correctly
    if (payload['eventStart'] is DateTime) {
      payload['eventStart'] = (payload['eventStart'] as DateTime)
          .toIso8601String();
    }
    if (payload['eventEnd'] is DateTime) {
      payload['eventEnd'] = (payload['eventEnd'] as DateTime).toIso8601String();
    } else {
      payload.remove('eventEnd'); // Don't send null if not provided
    }

    var response = await handleResponse(
      await postRequest('${APIRoutes.events}/update/$eventId', payload),
    ); // Assuming PUT helper exists
    if (!checkSuccessCase(response, showError: true)) return null;
    return CalendarEventModel.fromJson(
      response!.data,
    ); // Assuming API returns updated event
  }

  // Delete an event
  Future<bool> deleteEvent(int eventId) async {
    var response = await handleResponse(
      await postRequest('${APIRoutes.events}/$eventId', eventId),
    ); // Assuming DELETE helper exists
    return checkSuccessCase(response, showError: true);
  }

  // Method to get Users (similar to your ExpenseStore, adjust if needed)
  Future<List<User>> getUsersForSelection({
    int skip = 0,
    int take = 100,
  }) async {
    // Re-use getPaginatedUsers or create a dedicated method if filter needed
    Map<String, String> query = {
      "skip": skip.toString(),
      "take": take.toString(),
    };
    final response = await handleResponse(
      await getRequestWithQuery(
        APIRoutes.getAllUsers,
        Uri(queryParameters: query).query,
      ),
    );
    if (!checkSuccessCase(response) || response?.data['users'] == null)
      return [];
    Iterable list = response?.data['users'];
    return list
        .map((m) => User.fromJson(m))
        .toList(); // Use your existing User model
  }

  Future downloadPayslip(int payslipId) async {
    Map<String, String> query = {"payslipId": payslipId.toString()};

    var response = await handleResponse(
      await getRequestWithQuery(
        APIRoutes.downloadPayslip,
        Uri(queryParameters: query).query,
      ),
    );

    return response!.data;
  }

  Future<List<PayslipModel>> getPayslips() async {
    //Get list of data from API
    var response = await handleResponse(
      await getRequest(APIRoutes.getPayslipsURL),
    );

    //Check if the response is successful
    if (!checkSuccessCase(response)) return [];

    //Convert the data to a iterable to loop it
    Iterable list = response?.data;

    //Loop through the data and convert it to a list of PayslipModel
    return list.map((m) => PayslipModel.fromJson(m)).toList();
  }

  //Sales targets
  Future<List<SalesTargetModel>> getSalesTargets({int? period}) async {
    Map<String, String> query = {};
    if (period != null) query['period'] = period.toString();

    var response = await handleResponse(
      await getRequestWithQuery(
        APIRoutes.getSalesTargets,
        Uri(queryParameters: query).query,
      ),
    );

    if (!checkSuccessCase(response)) return [];

    Iterable list = response?.data;
    return list.map((item) => SalesTargetModel.fromJson(item)).toList();
  }

  Future<HolidayModelResponse?> getHolidays({
    int skip = 0,
    int take = 10,
    int? year,
  }) async {
    Map<String, dynamic> query = {
      "skip": skip.toString(),
      "take": take.toString(),
    };

    if (year != null) query['year'] = year.toString();

    final uri = Uri(queryParameters: query).query;

    var response = await handleResponse(
      await getRequestWithQuery(APIRoutes.getHolidays, uri),
    );
    if (!checkSuccessCase(response)) return null;

    return HolidayModelResponse.fromJson(response!.data);
  }

  // Fetch current user status
  Future<UserStatusModel?> getUserStatus(int? userId) async {
    Map<String, String> query = {"userId": userId.toString()};

    var response = await handleResponse(
      await getRequestWithQuery(
        APIRoutes.getUserStatus,
        Uri(queryParameters: query).query,
      ),
    );

    if (!checkSuccessCase(response)) {
      return null;
    }

    return UserStatusModel.fromJson(response!.data);
  }

  // Update user status
  Future<bool> updateUserStatus(
    String status, {
    String? message,
    DateTime? expiresAt,
  }) async {
    Map<String, dynamic> payload = {
      'status': status,
      'message': message ?? '',
      'expires_at': expiresAt?.toIso8601String(),
    };

    var response = await handleResponse(
      await postRequest(APIRoutes.updateUserStatus, payload),
    );
    return checkSuccessCase(response, showError: true);
  }

  Future test() async {
    var response = await handleResponse(await getRequest(APIRoutes.test));
    if (!checkSuccessCase(response)) {
      throw Exception('Failed to test');
    }
    return response?.data;
  }

  //New Chat

  Future<List<User>> searchChatUser(String query) async {
    final response = await handleResponse(
      await getRequest('${APIRoutes.searchUser}/$query'),
    );
    if (!checkSuccessCase(response)) return [];
    return (response?.data as List).map((e) => User.fromJson(e)).toList();
  }

  Future<List<User>> getPaginatedUsers(int skip, int take) async {
    Map<String, String> query = {
      "skip": skip.toString(),
      "take": take.toString(),
    };
    final response = await handleResponse(
      await getRequestWithQuery(
        APIRoutes.getAllUsers,
        Uri(queryParameters: query).query,
      ),
    );

    if (!checkSuccessCase(response)) return [];

    Iterable list = response?.data['users'];
    return list.map((m) => User.fromJson(m)).toList();
  }

  Future<User?> getUserInfo(int userId) async {
    final response = await handleResponse(
      await getRequest('${APIRoutes.getUserInfo}/$userId'),
    );
    if (!checkSuccessCase(response)) return null;
    return User.fromJson(response?.data);
  }

  // Search users
  Future<List<User>> searchUsers(String query) async {
    final response = await handleResponse(
      await getRequest('${APIRoutes.searchUsers}/$query'),
    );
    if (!checkSuccessCase(response)) return [];
    return (response?.data as List).map((e) => User.fromJson(e)).toList();
  }

  // Fetch chat messages
  Future<ChatResponse?> getChatMessages(
    int chatId, {
    int skip = 0,
    int take = 10,
  }) async {
    Map<String, String> query = {
      "chatId": chatId.toString(),
      "skip": skip.toString(),
      "take": take.toString(),
    };

    final response = await handleResponse(
      await getRequestWithQuery(
        APIRoutes.getChatMessages,
        Uri(queryParameters: query).query,
      ),
    );

    if (!checkSuccessCase(response)) return null;

    return ChatResponse.fromJson(response!.data);
  }

  // Send message
  Future<int?> sendMessage(
    int chatId,
    String message, {
    String type = 'text',
  }) async {
    final payload = {'message': message, 'messageType': type};
    final response = await handleResponse(
      await postRequest('${APIRoutes.getChats}/$chatId/send', payload),
    );
    if (!checkSuccessCase(response)) return null;

    return response?.data;
  }

  Future<List<User>> getParticipants(int chatId) async {
    final response = await handleResponse(
      await getRequest('${APIRoutes.getChats}/$chatId/participants'),
    );
    if (!checkSuccessCase(response)) return [];
    return (response?.data as List).map((e) => User.fromJson(e)).toList();
  }

  Future<bool> sendAttachment(int chatId, String filePath, String type) async {
    Map<String, String> data = {'type': type};
    final response = await multipartRequestWithData(
      '${APIRoutes.getChats}/$chatId/sendFile',
      filePath,
      data,
    );
    return response.statusCode == 200;
  }

  Future<bool> forwardFile(int chatId, int fileId) async {
    Map<String, String> data = {'messageId': fileId.toString()};
    final response = await handleResponse(
      await postRequest('${APIRoutes.getChats}/$chatId/forwardFile', data),
    );
    return checkSuccessCase(response);
  }

  // Fetch chats
  Future<List<Chat>> getChats() async {
    final response = await handleResponse(await getRequest(APIRoutes.getChats));
    if (!checkSuccessCase(response)) return [];
    return (response?.data as List).map((e) => Chat.fromJson(e)).toList();
  }

  Future<List<ChatMessage>> getNewChatMessages(
    int chatId,
    int lastMessageId,
  ) async {
    Map<String, String> query = {
      "chatId": chatId.toString(),
      "lastMessageId": lastMessageId.toString(),
    };

    final response = await handleResponse(
      await getRequestWithQuery(
        APIRoutes.getNewChatMessages,
        Uri(queryParameters: query).query,
      ),
    );

    if (!checkSuccessCase(response)) return [];

    return (response?.data as List)
        .map((e) => ChatMessage.fromJson(e))
        .toList();
  }

  // Start a new chat
  Future<Chat> createChat(List<int> userId) async {
    final payload = {'isGroupChat': false, 'participants': userId};
    final response = await handleResponse(
      await postRequest('${APIRoutes.getChats}/create', payload),
    );
    if (!checkSuccessCase(response)) throw Exception(response!.data.toString());
    return Chat.fromJson(response?.data);
  }

  Future<Chat> getOneToOneChatByUserId(int userId) async {
    final response = await handleResponse(
      await getRequest('${APIRoutes.getChats}/oneToOne/$userId'),
    );
    return Chat.fromJson(response?.data);
  }

  Future<Chat> createGroupChat(
    List<int> userIds, {
    bool isGroupChat = false,
    String? groupName,
  }) async {
    Map<String, dynamic> payload = {
      'isGroupChat': isGroupChat,
      'participants': userIds,
    };

    if (isGroupChat) payload['name'] = groupName;

    var response = await handleResponse(
      await postRequest('${APIRoutes.getChats}/create', payload),
    );

    if (!checkSuccessCase(response)) throw Exception('Failed to create chat');
    return Chat.fromJson(response?.data);
  }

  //SOS
  Future<bool> sendSoS(Map req) async {
    var result = await handleResponse(
      await postRequest(APIRoutes.sendSOSURL, req),
    );
    return checkSuccessCase(result);
  }

  //Loan
  Future<LoanRequestResponse?> getLoans({
    int skip = 0,
    int take = 10,
    String? status,
  }) async {
    Map<String, dynamic> query = {
      "skip": skip.toString(),
      "take": take.toString(),
    };

    if (status != null && status.isNotEmpty) {
      query['status'] = status;
    }

    final uri = Uri(queryParameters: query).query;

    var response = await handleResponse(
      await getRequestWithQuery(APIRoutes.getLoans, uri),
    );

    if (!checkSuccessCase(response)) return null;

    return LoanRequestResponse.fromJson(response!.data);
  }

  Future<bool> cancelLoanRequest(int id) async {
    Map req = {"id": id};
    var result = await handleResponse(
      await postRequest(APIRoutes.cancelLoanRequest, req),
    );
    return checkSuccessCase(result, showError: true);
  }

  Future<bool> requestLoan(Map req) async {
    var result = await handleResponse(
      await postRequest(APIRoutes.requestLoan, req),
    );
    return checkSuccessCase(result, showError: true);
  }

  //Payment Collection
  Future<PaymentCollectionModelResponse?> getPaymentCollection({
    int skip = 0,
    int take = 10,
    String? date,
  }) async {
    Map<String, dynamic> query = {
      "skip": skip.toString(),
      "take": take.toString(),
    };

    if (date != null) query['date'] = date.toString();

    final uri = Uri(queryParameters: query).query;

    var result = await handleResponse(
      await getRequestWithQuery(APIRoutes.getPaymentCollection, uri),
    );
    if (!checkSuccessCase(result)) return null;

    return PaymentCollectionModelResponse.fromJson(result!.data);
  }

  Future<bool> createPaymentCollection(Map req) async {
    var result = await handleResponse(
      await postRequest(APIRoutes.createPaymentCollection, req),
    );
    return checkSuccessCase(result, showError: true);
  }

  //Task
  Future<bool> sendTaskUpdateMsg(
    int taskId,
    String message,
    double latitude,
    double longitude,
  ) async {
    Map<String, String> req = {
      "taskId": taskId.toString(),
      "comment": message,
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "taskUpdateType": "Comment",
    };

    var result = await handleResponse(
      await postRequest(APIRoutes.taskStatusUpdate, req),
    );

    return checkSuccessCase(result, showError: true);
  }

  Future<bool> sendTaskUpdateLocation(
    int taskId,
    double latitude,
    double longitude,
  ) async {
    Map<String, String> req = {
      "taskId": taskId.toString(),
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "taskUpdateType": "Location",
    };

    var result = await handleResponse(
      await postRequest(APIRoutes.taskStatusUpdate, req),
    );

    return checkSuccessCase(result, showError: true);
  }

  Future<bool> sendTaskUpdateImage(
    int taskId,
    String filePath,
    double latitude,
    double longitude,
  ) async {
    Map<String, String> req = {
      "taskId": taskId.toString(),
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "taskUpdateType": "Image",
    };

    var result = await multipartRequestWithData(
      APIRoutes.taskStatusUpdateFile,
      filePath,
      req,
    );

    return result.statusCode == 200;
  }

  Future<bool> sendTaskUpdateFile(
    int taskId,
    String filePath,
    double latitude,
    double longitude,
  ) async {
    Map<String, String> req = {
      "taskId": taskId.toString(),
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "taskUpdateType": "Document",
    };

    var result = await multipartRequestWithData(
      APIRoutes.taskStatusUpdateFile,
      filePath,
      req,
    );

    return result.statusCode == 200;
  }

  Future<List<TaskUpdateModel>> getTaskUpdates(int taskId) async {
    Map<String, String> req = {"taskId": taskId.toString()};

    var query = Uri(queryParameters: req).query;

    var result = await handleResponse(
      await getRequestWithQuery(APIRoutes.getTaskUpdates, query),
    );

    if (!checkSuccessCase(result)) return [];

    Iterable list = result?.data;

    return list.map((m) => TaskUpdateModel.fromJson(m)).toList();
  }

  Future<bool> startTask(int taskId, double latitude, double longitude) async {
    Map<String, String> req = {
      "taskId": taskId.toString(),
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
    };

    var result = await handleResponse(
      await postRequest(APIRoutes.startTask, req),
    );

    return checkSuccessCase(result, showError: true);
  }

  Future<bool> holdTask(int taskId, double latitude, double longitude) async {
    Map<String, String> req = {
      "taskId": taskId.toString(),
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
    };

    var result = await handleResponse(
      await postRequest(APIRoutes.holdTask, req),
    );

    return checkSuccessCase(result, showError: true);
  }

  Future<bool> resumeTask(int taskId, double latitude, double longitude) async {
    Map<String, String> req = {
      "taskId": taskId.toString(),
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
    };
    var result = await handleResponse(
      await postRequest(APIRoutes.resumeTask, req),
    );

    return checkSuccessCase(result, showError: true);
  }

  Future<bool> completeTask(
    int taskId,
    double latitude,
    double longitude,
  ) async {
    Map<String, String> req = {
      "taskId": taskId.toString(),
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
    };

    var result = await handleResponse(
      await postRequest(APIRoutes.completeTask, req),
    );

    return checkSuccessCase(result, showError: true);
  }

  Future<List<TaskModel>> getTasks() async {
    var result = await handleResponse(await getRequest(APIRoutes.getTasks));
    if (!checkSuccessCase(result)) {
      return [];
    }

    Iterable list = result?.data;

    return list.map((m) => TaskModel.fromJson(m)).toList();
  }

  //Notice
  Future<List<NoticeModel>> getNotices() async {
    var result = await handleResponse(await getRequest(APIRoutes.getNotices));
    if (!checkSuccessCase(result)) {
      return [];
    }

    Iterable list = result?.data;

    return list.map((m) => NoticeModel.fromJson(m)).toList();
  }

  Future<List<SalesTarget>> getSalesTargetHistory({String data = ''}) async {
    Map<String, String> fQuery = {"date": data};
    var param = Uri(queryParameters: fQuery).query;
    var result = await handleResponse(
      await getRequestWithQuery(APIRoutes.getSalesTargetHistory, param),
    );
    if (!checkSuccessCase(result)) {
      return [];
    }

    Iterable list = result?.data;

    return list.map((m) => SalesTarget.fromJson(m)).toList();
  }

  //Order
  Future<bool> placeOrder(Map req) async {
    var result = await handleResponse(
      await postRequest(APIRoutes.placeOrderURL, req),
    );
    return checkSuccessCase(result, showError: true);
  }

  Future<OrderResponse?> getOrdersHistory({
    int skip = 0,
    int take = 10,
    String? date,
  }) async {
    Map<String, String> fQuery = {
      "skip": skip.toString(),
      "take": take.toString(),
    };

    if (date != null && date.isNotEmpty) {
      fQuery['date'] = date;
    }

    var param = Uri(queryParameters: fQuery).query;
    var result = await handleResponse(
      await getRequestWithQuery(APIRoutes.getOrdersHistoryURL, param),
    );
    if (!checkSuccessCase(result)) return null;

    return OrderResponse.fromJson(result!.data);
  }

  Future<OrderCountModel?> getOrderCounts(String data) async {
    Map<String, String> fQuery = {"date": data};
    var param = Uri(queryParameters: fQuery).query;
    var result = await handleResponse(
      await getRequestWithQuery(APIRoutes.getOrderCounts, param),
    );
    if (!checkSuccessCase(result)) {
      return null;
    }

    return OrderCountModel.fromJson(result!.data);
  }

  //Product

  Future<List<ProductModel>> getProducts(int categoryId) async {
    Map<String, String> fQuery = {"categoryId": categoryId.toString()};
    var param = Uri(queryParameters: fQuery).query;
    var result = await handleResponse(
      await getRequestWithQuery(APIRoutes.getProductsByCategoryURL, param),
    );
    if (!checkSuccessCase(result)) {
      return [];
    }

    Iterable list = result?.data;

    return list.map((m) => ProductModel.fromJson(m)).toList();
  }

  Future<List<ProductCategoryModel>> getProductCategories() async {
    var result = await handleResponse(
      await getRequest(APIRoutes.getProductCategoriesURL),
    );
    if (!checkSuccessCase(result)) {
      return [];
    }

    Iterable list = result?.data;

    return list.map((m) => ProductCategoryModel.fromJson(m)).toList();
  }

  //Document
  Future<String?> getDocumentFileUrl(int id) async {
    Map<String, dynamic> req = {"id": id.toString()};

    var param = Uri(queryParameters: req).query;

    var result = await handleResponse(
      await getRequestWithQuery(APIRoutes.getDocumentFileUrl, param),
    );
    if (!checkSuccessCase(result)) {
      return null;
    }

    return result!.data;
  }

  Future<List<DocumentTypeModel>> getDocumentTypes() async {
    var result = await handleResponse(
      await getRequest(APIRoutes.getDocumentTypesURL),
    );
    if (!checkSuccessCase(result)) {
      return [];
    }

    Iterable list = result?.data;

    return list.map((m) => DocumentTypeModel.fromJson(m)).toList();
  }

  Future<DocumentRequestResponse?> getDocumentRequests({
    int skip = 0,
    int take = 10,
    String? status,
    String? date,
  }) async {
    Map<String, dynamic> query = {
      "skip": skip.toString(),
      "take": take.toString(),
    };

    if (status != null && status.isNotEmpty) {
      query['status'] = status;
    }

    if (date != null && date.isNotEmpty) {
      query['date'] = date;
    }

    final uri = Uri(queryParameters: query).query;

    var response = await handleResponse(
      await getRequestWithQuery(APIRoutes.getDocumentRequestsURL, uri),
    );

    if (!checkSuccessCase(response)) return null;

    return DocumentRequestResponse.fromJson(response!.data);
  }

  Future<bool> cancelDocumentRequest(int id) async {
    Map req = {"id": id};
    var result = await handleResponse(
      await postRequest(APIRoutes.cancelDocumentRequestURL, req),
    );
    return checkSuccessCase(result);
  }

  Future<bool> createDocumentRequest({
    required int typeId,
    String? comments,
  }) async {
    Map req = {"typeId": typeId, "comments": comments ?? ""};
    var result = await handleResponse(
      await postRequest(APIRoutes.createDocumentRequestURL, req),
    );
    return checkSuccessCase(result, showError: true);
  }

  //Forms
  Future<List<FormModel>> getForms() async {
    var result = await handleResponse(await getRequest(APIRoutes.getForms));
    if (!checkSuccessCase(result)) {
      return [];
    }

    Iterable list = result?.data;

    return list.map((m) => FormModel.fromJson(m)).toList();
  }

  Future<bool> submitForm(
    int? clientId,
    int formId,
    List<Map<String, dynamic>> entries,
  ) async {
    Map req = {"clientId": clientId, "formId": formId, "formLines": entries};
    var result = await handleResponse(
      await postRequest(APIRoutes.submitForm, req),
    );
    return checkSuccessCase(result);
  }

  //Visits

  Future<VisitCountModel?> getVisitsCount() async {
    var result = await handleResponse(
      await getRequest(APIRoutes.getVisitsCount),
    );
    if (!checkSuccessCase(result)) {
      return null;
    }

    return VisitCountModel.fromJson(result!.data);
  }

  Future<bool> createVisit(Map<String, String> req, String filePath) async {
    var result = await multipartRequestWithData(
      APIRoutes.createVisitURL,
      filePath,
      req,
    );
    if (result.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<VisitResponse?> getVisitsHistory({
    int skip = 0,
    int take = 10,
    String? date,
  }) async {
    Map<String, String> fQuery = {
      "skip": skip.toString(),
      "take": take.toString(),
    };

    if (date != null && date.isNotEmpty) {
      fQuery['date'] = date;
    }

    var param = Uri(queryParameters: fQuery).query;
    var result = await handleResponse(
      await getRequestWithQuery(APIRoutes.getVisitsHistoryURL, param),
    );

    if (!checkSuccessCase(result)) return null;

    return VisitResponse.fromJson(result!.data);
  }

  //Settings
  Future<ModuleSettingsModel?> getModuleSettings() async {
    var result = await handleResponse(
      await getRequest(APIRoutes.getModuleSettings),
    );
    if (!checkSuccessCase(result)) return null;

    return ModuleSettingsModel.fromJson(result!.data);
  }

  Future<AppSettingsModel?> getAppSettings() async {
    var result = await handleResponse(
      await getRequest(APIRoutes.getAppSettings),
    );
    if (!checkSuccessCase(result)) return null;
    return AppSettingsModel.fromJson(result!.data!);
  }

  //SignBoard
  Future<bool> sendSignBoardRequest(Map req) async {
    var result = await handleResponse(
      await postRequest(APIRoutes.addSignBoardRequest, req),
    );
    return checkSuccessCase(result);
  }

  //Clients
  Future<List<ClientModel>> getClients() async {
    var response = await handleResponse(await getRequest(APIRoutes.getClients));
    if (!checkSuccessCase(response)) return [];

    Iterable list = response?.data;

    return list.map((m) => ClientModel.fromJson(m)).toList();
  }

  Future<ClientModelSkipTake?> getClientsWithSkipTake({
    int? skip,
    int? take,
    String? query,
  }) async {
    Map<String, String> fQuery;

    if (skip != null && take != null) {
      fQuery = {"skip": skip.toString(), "take": take.toString()};
    } else {
      fQuery = {};
    }

    if (query != null && query.isNotEmpty) {
      fQuery['search'] = query;
    }

    var param = Uri(queryParameters: fQuery).query;
    var response = await handleResponse(
      await getRequestWithQuery(APIRoutes.getClients, param),
    );
    if (!checkSuccessCase(response)) return null;

    return ClientModelSkipTake.fromJson(response!.data);
  }

  Future<List<ClientModel>> searchClients(String query) async {
    Map<String, String> fQuery = {"query": query.trim()};
    var param = Uri(queryParameters: fQuery).query;
    var response = await handleResponse(
      await getRequestWithQuery(APIRoutes.clientsSearch, param),
    );
    if (!checkSuccessCase(response)) return [];

    Iterable list = response?.data;
    return list.map((m) => ClientModel.fromJson(m)).toList();
  }

  Future<bool> createClient(Map req) async {
    var response = await handleResponse(
      await postRequest(APIRoutes.addClient, req),
    );
    return checkSuccessCase(response, showError: true);
  }

  //TeamChat
  Future<bool> postChat(String message) async {
    var response = await handleResponse(
      await postRequest(APIRoutes.postChat, message),
    );
    return checkSuccessCase(response, showError: true);
  }

  Future<ChatResponse?> getChatsBak() async {
    var response = await handleResponse(await getRequest(APIRoutes.getChats));
    if (!checkSuccessCase(response)) {
      return null;
    }
    return ChatResponse.fromJson(response!.data);
  }

  Future<bool> postChatImage(String filePath) async {
    var response = await multipartRequest(APIRoutes.postChatImage, filePath);
    return response;
  }

  //Attendance
  Future<AttendanceHistoryResponse?> getAttendanceHistory({
    int skip = 0,
    int take = 10,
    String? startDate,
    String? endDate,
  }) async {
    Map<String, dynamic> query = {
      "skip": skip.toString(),
      "take": take.toString(),
    };

    if (startDate != null && startDate.isNotEmpty) {
      query['startDate'] = startDate;
    }

    if (endDate != null && endDate.isNotEmpty) {
      query['endDate'] = endDate;
    }

    final uri = Uri(queryParameters: query).query;

    var response = await handleResponse(
      await getRequestWithQuery(APIRoutes.getAttendanceHistory, uri),
    );

    if (!checkSuccessCase(response)) return null;

    return AttendanceHistoryResponse.fromJson(response!.data);
  }

  Future<bool> verifyDynamicQr(String code) async {
    Map req = {"code": code};
    var response = await handleResponse(
      await postRequest(APIRoutes.verifyDynamicQr, req),
    );
    return checkSuccessCase(response, showError: true);
  }

  Future<bool> verifyQr(String code) async {
    var response = await handleResponse(
      await postRequest(APIRoutes.verifyQr, code),
    );
    return checkSuccessCase(response, showError: true);
  }

  Future<bool> setEarlyCheckoutReason(String reason) async {
    var response = await handleResponse(
      await postRequest(APIRoutes.setEarlyCheckoutReason, reason),
    );
    return checkSuccessCase(response);
  }

  Future<bool> canCheckOut() async {
    var response = await handleResponse(
      await getRequest(APIRoutes.canCheckOut),
    );

    return checkSuccessCase(response);
  }

  Future<bool> validateGeofence(double lat, double long) async {
    Map<String, String> req = {
      "latitude": lat.toString(),
      "longitude": long.toString(),
    };

    var query = Uri(queryParameters: req).query;

    var result = await handleResponse(
      await getRequestWithQuery(APIRoutes.validateGeoLocation, query),
    );
    return checkSuccessCase(result);
  }

  Future<bool> validateIpAddress(String ip) async {
    Map<String, String> req = {"ipAddress": ip};

    var query = Uri(queryParameters: req).query;

    var result = await handleResponse(
      await getRequestWithQuery(APIRoutes.validateIpAddress, query),
    );
    return checkSuccessCase(result);
  }

  Future<bool> startStopBreak() async {
    var response = await handleResponse(
      await postRequest(APIRoutes.startStopBreak, ""),
    );
    return checkSuccessCase(response, showError: true);
  }

  Future<Result> checkInOut(Map req) async {
    Result res = Result();
    var result = await handleResponse(
      await postRequest(APIRoutes.checkInOut, req),
    );
    if (!checkSuccessCase(result)) {
      res.message = result!.data;
      return res;
    }
    res.isSuccess = true;
    return res;
  }

  //Expense
  Future<List<ExpenseTypeModel>> getExpenseTypes() async {
    var response = await handleResponse(
      await getRequest(APIRoutes.getExpenseTypes),
    );
    if (!checkSuccessCase(response)) return [];

    Iterable list = response?.data;
    return list.map((m) => ExpenseTypeModel.fromJson(m)).toList();
  }

  Future<ExpenseRequestResponse?> getExpenseRequests({
    int skip = 0,
    int take = 10,
    String? status,
    String? date,
  }) async {
    Map<String, dynamic> query = {
      "skip": skip.toString(),
      "take": take.toString(),
    };

    if (status != null && status.isNotEmpty) {
      query['status'] = status;
    }

    if (date != null && date.isNotEmpty) {
      query['date'] = date;
    }

    final uri = Uri(queryParameters: query).query;

    var response = await handleResponse(
      await getRequestWithQuery(APIRoutes.getExpenseRequests, uri),
    );

    if (!checkSuccessCase(response)) return null;

    return ExpenseRequestResponse.fromJson(response!.data);
  }

  Future<ExpenseRequestResponse?> getExpenseRequestsForApprovals({
    int skip = 0,
    int take = 10,
    String? status,
    String? date,
  }) async {
    Map<String, dynamic> query = {
      "skip": skip.toString(),
      "take": take.toString(),
    };

    if (status != null && status.isNotEmpty) {
      query['status'] = status;
    }

    if (date != null && date.isNotEmpty) {
      query['date'] = date;
    }

    final uri = Uri(queryParameters: query).query;

    var response = await handleResponse(
      await getRequestWithQuery(APIRoutes.getApprovalExpenseRequests, uri),
    );

    if (!checkSuccessCase(response)) return null;

    return ExpenseRequestResponse.fromJson(response!.data);
  }

  Future<bool> takeLeaveActionForApproval(Map req) async {
    var result = await handleResponse(
      await postRequest(APIRoutes.takeLeaveActionForApproval, req),
    );
    return checkSuccessCase(result);
  }

  Future<bool> takeExpenseActionForApproval(Map req) async {
    var result = await handleResponse(
      await postRequest(APIRoutes.takeExpenseActionForApproval, req),
    );
    return checkSuccessCase(result);
  }

  Future<bool> sendExpenseRequest(Map req) async {
    var result = await handleResponse(
      await postRequest(APIRoutes.addExpenseRequest, req),
    );
    return checkSuccessCase(result);
  }

  Future<bool> uploadExpenseDocument(String filePath) async {
    var result = await multipartRequest(
      APIRoutes.uploadExpenseDocument,
      filePath,
    );
    return result;
  }

  Future<bool> cancelExpenseRequest(int id) async {
    Map req = {"id": id};
    var result = await handleResponse(
      await postRequest(APIRoutes.cancelExpenseRequest, req),
    );
    return checkSuccessCase(result);
  }

  //Leave
  Future<List<LeaveTypeModel>> getLeaveTypes() async {
    var result = await handleResponse(
      await getRequest(APIRoutes.getLeaveTypesURL),
    );
    if (!checkSuccessCase(result)) {
      return [];
    }
    Iterable list = result?.data;

    return list.map((model) => LeaveTypeModel.fromJson(model)).toList();
  }

  Future<bool> sendLeaveRequest(Map req) async {
    var result = await handleResponse(
      await postRequest(APIRoutes.addLeaveRequest, req),
    );
    return checkSuccessCase(result, showError: true);
  }

  Future<bool> uploadLeaveDocument(String filePath) async {
    var result = await multipartRequest(
      APIRoutes.uploadLeaveDocument,
      filePath,
    );
    return result;
  }

  Future<LeaveRequestResponse?> getLeaveRequests({
    int skip = 0,
    int take = 10,
    String? status,
  }) async {
    Map<String, dynamic> query = {
      "skip": skip.toString(),
      "take": take.toString(),
    };

    if (status != null && status.isNotEmpty) {
      query['status'] = status;
    }

    final uri = Uri(queryParameters: query).query;

    var response = await handleResponse(
      await getRequestWithQuery(APIRoutes.getLeaveRequests, uri),
    );

    if (!checkSuccessCase(response)) return null;

    return LeaveRequestResponse.fromJson(response!.data);
  }

  Future<LeaveRequestResponse?> getLeaveRequestsForApprovals({
    int skip = 0,
    int take = 10,
    String? status,
    String? date,
  }) async {
    Map<String, dynamic> query = {
      "skip": skip.toString(),
      "take": take.toString(),
      "date": date,
    };

    if (status != null && status.isNotEmpty) {
      query['status'] = status;
    }

    final uri = Uri(queryParameters: query).query;

    var response = await handleResponse(
      await getRequestWithQuery(APIRoutes.getApprovalLeaveRequests, uri),
    );

    if (!checkSuccessCase(response)) return null;

    return LeaveRequestResponse.fromJson(response!.data);
  }

  Future<bool> cancelLeaveRequest(int id) async {
    var result = await handleResponse(
      await postRequest(APIRoutes.cancelLeaveRequest, id),
    );
    return checkSuccessCase(result, showError: true);
  }

  Future<DashboardModel?> getDashboardInfo() async {
    var result = await handleResponse(
      await getRequest(APIRoutes.getDashboardData),
    );
    if (!checkSuccessCase(result)) {
      return null;
    }
    return DashboardModel.fromJson(result!.data);
  }

  //Device
  Future<bool> checkDeviceUid(String deviceUid) async {
    Map<String, String> req = {"uid": deviceUid};

    var query = Uri(queryParameters: req).query;

    var result = await handleResponse(
      await getRequestWithQuery(APIRoutes.checkDeviceUid, query),
    );
    return checkSuccessCase(result);
  }

  Future updateDeviceStatus(Map req) async {
    await handleResponse(await postRequest(APIRoutes.updateDeviceStatus, req));
  }

  Future updateAttendanceStatus(Map req) async {
    await handleResponse(
      await postRequest(APIRoutes.updateAttendanceStatus, req),
    );
  }

  Future<StatusResponse?> checkAttendanceStatus() async {
    var response = await handleResponse(
      await getRequest(APIRoutes.checkAttendanceStatus),
    );
    if (!checkSuccessCase(response)) return null;

    var status = StatusResponse.fromJson(response?.data);
    return status;
  }

  Future<bool> registerDevice(Map req) async {
    var result = await handleResponse(
      await postRequest(APIRoutes.registerDevice, req),
    );
    return checkSuccessCase(result);
  }

  Future<bool> resetPassword(Map req) async {
    var result = await handleResponse(
      await postRequest(APIRoutes.resetPasswordURL, req),
    );
    return checkSuccessCase(result);
  }

  Future<String?> checkDevice(String deviceType, String deviceId) async {
    Map<String, String> query = {
      'deviceType': deviceType,
      'deviceId': deviceId,
    };
    var param = Uri(queryParameters: query).query;

    var result = await handleResponse(
      await getRequestWithQuery(APIRoutes.checkDevice, param),
    );
    if (result == null) {
      return null;
    }
    return result.data.toString();
  }

  Future<bool> validateDevice(String deviceType, String deviceId) async {
    Map<String, String> query = {
      'deviceType': deviceType,
      'deviceId': deviceId,
    };
    var param = Uri(queryParameters: query).query;

    var result = await handleResponse(
      await getRequestWithQuery(APIRoutes.validateDevice, param),
    );

    return checkSuccessCase(result);
  }

  Future<bool> forgotPassword(String number) async {
    var result = await handleResponse(
      await postRequest(APIRoutes.forgotPasswordURL, number),
    );
    return checkSuccessCase(result);
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    var payload = {"oldPassword": oldPassword, "newPassword": newPassword};
    var response = await handleResponse(
      await postRequest(APIRoutes.changePasswordURL, payload),
    );
    return checkSuccessCase(response, showError: true);
  }

  Future<bool> checkValidPhoneNumber(String phoneNumber) async {
    var response = await handleResponse(
      await postRequest(APIRoutes.phoneNumberCheckURL, phoneNumber),
    );

    return checkSuccessCase(response);
  }

  Future<bool> checkValidEmployeeId(String employeeId) async {
    var response = await handleResponse(
      await postRequest(APIRoutes.userNameCheckURL, employeeId),
    );

    return checkSuccessCase(response);
  }

  Future<UserModel?> loginWIthUid(String uid) async {
    var response = await handleResponse(
      await postRequest(APIRoutes.loginWithUidURL, uid),
    );

    if (!checkSuccessCase(response)) {
      return null;
    }
    var user = UserModel.fromJSON(response?.data);
    return user;
  }

  Future<bool> verifyOTP(String phoneNumber, String otp) async {
    var payload = {"PhoneNumber": phoneNumber, "OTP": otp};
    var response = await handleResponse(
      await postRequest(APIRoutes.verifyOTPURL, payload),
    );
    return checkSuccessCase(response);
  }

  Future<ScheduleModel?> getSchedules() async {
    var response = await handleResponse(
      await getRequest(APIRoutes.getScheduleURL),
    );

    if (!checkSuccessCase(response)) {
      return null;
    }
    var schedule = ScheduleModel.fromJson(response?.data);
    return schedule;
  }

  Future addFirebaseToken(String deviceType, String token) async {
    var payload = {"DeviceType": deviceType, "Token": token};

    var response = await handleResponse(
      await postRequest(APIRoutes.addMessagingTokenURL, payload),
    );

    if (!checkSuccessCase(response)) {
      toast("Unable to send firebase token to server");
    }
  }

  Future<List<TenantModel>> getDomains() async {
    var response = await handleResponse(await getRequest(APIRoutes.domains));
    if (!checkSuccessCase(response)) {
      return [];
    }
    Iterable list = response?.data;
    return list.map((m) => TenantModel.fromJson(m)).toList();
  }

  Future<bool> checkDemoMode() async {
    var response = await handleResponse(
      await getRequest(APIRoutes.demoModeCheck),
    );
    return checkSuccessCase(response);
  }

  Future<UserModel?> me() async {
    var response = await handleResponse(await getRequest(APIRoutes.meURL));
    if (!checkSuccessCase(response)) {
      return null;
    }
    return UserModel.fromJSON(response?.data);
  }

  Future<NotificationResponse?> getNotifications({
    int skip = 0,
    int take = 10,
  }) async {
    Map<String, String> query = {
      "skip": skip.toString(),
      "take": take.toString(),
    };

    final uri = Uri(queryParameters: query).query;

    var response = await handleResponse(
      await getRequestWithQuery(APIRoutes.getNotifications, uri),
    );

    if (!checkSuccessCase(response)) return null;

    return NotificationResponse.fromJson(response!.data);
  }

  Future<UserModel?> createDemoUser() async {
    var response = await handleResponse(
      await postRequest(APIRoutes.createDemoUser, ''),
    );
    if (!checkSuccessCase(response)) return null;

    return UserModel.fromJSON(response?.data);
  }

  Future<bool> bulkDeviceStatusUpdate(List<String> data) async {
    Map req = {'items': data};
    var response = await handleResponse(
      await postRequest(APIRoutes.bulkDeviceStatusUpdateURL, req),
    );
    return checkSuccessCase(response);
  }

  Future<bool> bulkActivityStatusUpdate(List<String> data) async {
    Map req = {'items': data};
    var response = await handleResponse(
      await postRequest(APIRoutes.bulkActivityStatusUpdateURL, req),
    );
    return checkSuccessCase(response);
  }

  Future<String?> getFaceDataImageUrl() async {
    var response = await handleResponse(
      await getRequest(APIRoutes.getFaceDataImageUrl),
    );
    if (!checkSuccessCase(response)) {
      return null;
    }
    return response!.data;
  }

  Future<bool> enrollFace(String filePath, String landmarks) async {
    var response = await multipartRequestWithData(
      APIRoutes.addOrUpdateFaceData,
      filePath,
      {"landmarks": landmarks},
    );

    return response.statusCode == 200;
  }

  Future<dynamic> getFaceData() async {
    var response = await handleResponse(
      await getRequest(APIRoutes.getFaceData),
    );
    if (!checkSuccessCase(response)) {
      return null;
    }
    return response!.data;
  }

  Future<bool> isFaceDataAdded() async {
    var response = await handleResponse(
      await getRequest(APIRoutes.isFaceDataAdded),
    );
    return checkSuccessCase(response);
  }

  bool checkSuccessCase(ApiResponseModel? response, {bool showError = false}) {
    if (!showError) {
      return response != null &&
          response.statusCode == 200 &&
          response.status?.toLowerCase() == 'success';
    } else {
      if (response == null) return false;
      if (response.statusCode == 400 && showError) {
        toast(response.data.toString());
        return false;
      } else {
        return response.statusCode == 200 &&
            response.status?.toLowerCase() == 'success';
      }
    }
  }
}
