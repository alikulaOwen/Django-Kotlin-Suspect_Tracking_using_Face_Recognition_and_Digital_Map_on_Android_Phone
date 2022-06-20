import 'package:http/http.dart' as http;
import 'package:njia/constants/app_constants.dart';
import 'dart:convert';
import 'package:njia/models/login_model.dart';

class LoginService {
  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    var url = Uri.parse("$baseUrl/login/");

    final response = await http.post(url, body: requestModel.toJson());
    if (response.statusCode == 200 || response.statusCode == 400) {
      return LoginResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
