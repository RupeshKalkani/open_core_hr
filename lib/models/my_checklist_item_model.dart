class MyChecklistItemModel {
  int? id;
  int? taskId;
  String? title;
  String? description;
  String? taskType; // e.g., 'text', 'file_upload'
  String? status; // e.g., 'PENDING', 'COMPLETED'
  String? dueDate; // YYYY-MM-DD
  String? completedAt; // ISO String or formatted
  String? notes;
  String? uploadedFilePath;
  String? employeeNotes; // <-- Add
  String? uploadedFileName; // <-- Add
  String? uploadedFileUrl; // <-- Add

  MyChecklistItemModel({
    this.id,
    this.taskId,
    this.title,
    this.description,
    this.taskType,
    this.status,
    this.dueDate,
    this.completedAt,
    this.notes,
    this.uploadedFilePath,
    this.employeeNotes,
    this.uploadedFileName,
    this.uploadedFileUrl,
  });

  // Manual fromJson based on API response structure
  factory MyChecklistItemModel.fromJson(Map<String, dynamic> json) {
    return MyChecklistItemModel(
      id: json['id'],
      taskId: json['taskId'],
      title: json['title'],
      description: json['description'],
      taskType: json['taskType'],
      status: json['status'],
      dueDate: json['dueDate'],
      completedAt: json['completedAt'],
      notes: json['notes'],
      uploadedFilePath: json['uploadedFilePath'],
      employeeNotes: json['employeeNotes'], // <-- Add=
      uploadedFileName: json['uploadedFileName'], // <-- Add
      uploadedFileUrl: json['uploadedFileUrl'], // <-- Add
    );
  }

  bool get isFileUploaded =>
      uploadedFilePath != null && uploadedFilePath!.isNotEmpty;
}
