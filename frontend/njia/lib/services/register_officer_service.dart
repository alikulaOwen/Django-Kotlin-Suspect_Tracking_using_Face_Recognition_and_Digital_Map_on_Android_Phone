import 'package:http/http.dart' as http;
import 'package:njia/constants/app_constants.dart';
import 'dart:convert';
import 'package:njia/models/register_officer_model.dart';

class RegisterOfficerService {
  Future<RegisterOfficerResponseModel> register(
      RegisterOfficerRequestModel requestsModel) async {
    var url = Uri.parse("$baseUrl/register-officer/");

    final response = await http.post(url, body: requestsModel.toJson());
    if (response.statusCode == 200 || response.statusCode == 400) {
      return RegisterOfficerResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
