class RegisterOfficerResponseModel {
  final String token;
  final String response;
  final String email;
  final String username;
  final String national_id;
  final String employee_id;
  final String phone_number;
  final String department;

  RegisterOfficerResponseModel(
      {required this.token,
      required this.response,
      required this.email,
      required this.username,
      required this.national_id,
      required this.employee_id,
      required this.phone_number,
      required this.department});

  factory RegisterOfficerResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterOfficerResponseModel(
      token: json['token'] ?? "",
      response: json['non_field_errors'] ?? "",
      email: json['email'] ?? "",
      username: json['username'] ?? "",
      employee_id: json['employee_id'] ?? "",
      phone_number: json['phone_number'] ?? "",
      department: json['department'] ?? "",
      national_id: json['national_id'] ?? "",
    );
  }
}

class RegisterOfficerRequestModel {
  late String email;
  late String username;
  late String password;
  late String password2;
  late String national_id;
  late String employee_id;
  late String phone_number;
  late String department;

  RegisterOfficerRequestModel(
      {email,
      username,
      password,
      password2,
      national_id,
      employee_id,
      phone_number,
      department});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'email': email.trim(),
      'username': username.trim(),
      'password': password.trim(),
      'password2': password2.trim(),
      'national_id': national_id.trim(),
      'employee_id': employee_id.trim(),
      'phone_number': phone_number.trim(),
      'department': department.trim(),
    };

    return map;
  }
}
