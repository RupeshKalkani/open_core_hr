class OrderCountModel {
  int? pending;
  int? processing;
  int? completed;
  int? cancelled;

  OrderCountModel(
      {this.pending, this.processing, this.completed, this.cancelled});

  OrderCountModel.fromJson(Map<String, dynamic> json) {
    pending = json['pending'];
    processing = json['processing'];
    completed = json['completed'];
    cancelled = json['cancelled'];
  }
}
