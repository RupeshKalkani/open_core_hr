class VisitCountModel {
  int? totalVisits;
  int? todaysVisits;

  VisitCountModel({this.totalVisits, this.todaysVisits});

  VisitCountModel.fromJson(Map<String, dynamic> json) {
    totalVisits = json['totalVisits'];
    todaysVisits = json['todaysVisits'];
  }
}
