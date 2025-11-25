class User {
  int? id;
  String? firstName;
  String? avatar;
  String? lastName;
  String? code;
  String? email;
  String? phone;
  String? status;
  String? designation;
  String? role;
  String? dob;
  String? gender;
  String? dateOfJoining;
  String? createdAt;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.avatar,
      this.code,
      this.email,
      this.phone,
      this.status,
      this.designation,
      this.role,
      this.dob,
      this.gender,
      this.dateOfJoining,
      this.createdAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    avatar = json['avatar'];
    code = json['code'];
    email = json['email'];
    phone = json['phone'];
    status = json['status'];
    designation = json['designation'];
    role = json['role'];
    dob = json['dob'];
    gender = json['gender'];
    dateOfJoining = json['dateOfJoining'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['avatar'] = avatar;
    data['code'] = code;
    data['email'] = email;
    data['phone'] = phone;
    data['status'] = status;
    data['designation'] = designation;
    data['role'] = role;
    data['dob'] = dob;
    data['gender'] = gender;
    data['dateOfJoining'] = dateOfJoining;
    data['createdAt'] = createdAt;
    return data;
  }

  String get fullName => '$firstName $lastName';

  String get initials => '${firstName![0]}${lastName![0]}';
}
