class LoginResponseModel {
  final String token;
  final String non_field_errors;

  LoginResponseModel({required this.token, required this.non_field_errors});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'] ?? "",
      non_field_errors: json['non_field_errors'] ?? "",
    );
  }
}

class LoginRequestModel {
  late String username;
  late String password;
  LoginRequestModel({username, password});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'username': username.trim(),
      'password': password.trim()
    };

    return map;
  }
}
