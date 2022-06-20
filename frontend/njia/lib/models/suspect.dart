// To parse this JSON data, do
//
//     final suspect = suspectFromJson(jsonString);

import 'dart:convert';

List<Suspect> suspectFromJson(String str) =>
    List<Suspect>.from(json.decode(str).map((x) => Suspect.fromJson(x)));

String suspectToJson(List<Suspect> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Suspect {
  Suspect({
    required this.url,
    required this.name,
    required this.mugshot,
    required this.faceEncoding,
    required this.charges,
    required this.sex,
    required this.nationalId,
    required this.phoneNumber,
    required this.isSeen,
    required this.physicalAttributes,
    required this.birthDate,
    required this.datePosted,
    required this.dateModified,
    required this.filedBy,
  });

  final String url;
  final String name;
  final String mugshot;
  final String faceEncoding;
  final String charges;
  final String sex;
  final int nationalId;
  final int phoneNumber;
  final bool isSeen;
  final String physicalAttributes;
  final DateTime birthDate;
  final DateTime datePosted;
  final DateTime dateModified;
  final FiledBy filedBy;

  factory Suspect.fromJson(Map<String, dynamic> json) => Suspect(
        url: json["url"],
        name: json["name"],
        mugshot: json["mugshot"],
        faceEncoding: json["face_encoding"],
        charges: json["charges"],
        sex: json["sex"],
        nationalId: json["national_id"],
        phoneNumber: json["phone_number"],
        isSeen: json["is_seen"],
        physicalAttributes: json["physical_attributes"],
        birthDate: DateTime.parse(json["birth_date"]),
        datePosted: DateTime.parse(json["date_posted"]),
        dateModified: DateTime.parse(json["date_modified"]),
        filedBy: FiledBy.fromJson(json["filed_by"]),
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "name": name,
        "mugshot": mugshot,
        "face_encoding": faceEncoding,
        "charges": charges,
        "sex": sex,
        "national_id": nationalId,
        "phone_number": phoneNumber,
        "is_seen": isSeen,
        "physical_attributes": physicalAttributes,
        "birth_date":
            "${birthDate.year.toString().padLeft(4, '0')}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}",
        "date_posted": datePosted.toIso8601String(),
        "date_modified": dateModified.toIso8601String(),
        "filed_by": filedBy.toJson(),
      };
}

class FiledBy {
  FiledBy({
    required this.url,
    required this.password,
    required this.email,
    required this.nationalId,
    required this.employeeId,
    required this.username,
    required this.phoneNumber,
    required this.department,
    required this.dateJoined,
    required this.lastLogin,
    required this.isAdmin,
    required this.isActive,
    required this.isStaff,
    required this.isSuperuser,
  });

  final String url;
  final String password;
  final String email;
  final int nationalId;
  final String employeeId;
  final String username;
  final int phoneNumber;
  final String department;
  final DateTime dateJoined;
  final DateTime lastLogin;
  final bool isAdmin;
  final bool isActive;
  final bool isStaff;
  final bool isSuperuser;

  factory FiledBy.fromJson(Map<String, dynamic> json) => FiledBy(
        url: json["url"],
        password: json["password"],
        email: json["email"],
        nationalId: json["national_id"],
        employeeId: json["employee_id"],
        username: json["username"],
        phoneNumber: json["phone_number"],
        department: json["department"],
        dateJoined: DateTime.parse(json["date_joined"]),
        lastLogin: DateTime.parse(json["last_login"]),
        isAdmin: json["is_admin"],
        isActive: json["is_active"],
        isStaff: json["is_staff"],
        isSuperuser: json["is_superuser"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "password": password,
        "email": email,
        "national_id": nationalId,
        "employee_id": employeeId,
        "username": username,
        "phone_number": phoneNumber,
        "department": department,
        "date_joined": dateJoined.toIso8601String(),
        "last_login": lastLogin.toIso8601String(),
        "is_admin": isAdmin,
        "is_active": isActive,
        "is_staff": isStaff,
        "is_superuser": isSuperuser,
      };
}
