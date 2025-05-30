import 'dart:convert';

import '../models/registration_data.dart';
import '../providers/base_provider.dart';

import '../models/user.dart';

class UserProvider extends BaseProvider<User> {
  final String _endpoint = "User";

  UserProvider() : super("User");

  @override
  User fromJson(data) {
    return User.fromJson(data);
  }

  /// Get user registrations aggregated by days or months
  Future<List<UserRegistrationData>> getUserRegistrations(int days,
      {bool? groupByMonths = false}) async {
    var url =
        "${BaseProvider.baseUrl}$_endpoint/GetUserRegistrations/$days?groupByMonths=$groupByMonths";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      List<UserRegistrationData> result = [];

      for (var item in data) {
        result.add(UserRegistrationData(
            date: DateTime.parse(item["dateJoined"]),
            numberOfUsers: item["numberOfUsers"]));
      }

      return result;
    } else {
      throw Exception("Unknown error");
    }
  }

  /// Change password for a user by userId
  Future<String> changePassword(int userId, dynamic request) async {
    var url = "${BaseProvider.baseUrl}$_endpoint/ChangePassword/$userId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http!.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data.toString();
    } else {
      throw Exception("Unknown error");
    }
  }
  Future<User?> register(Map<String, dynamic> registrationData) async {
    var url = "${BaseProvider.baseUrl}$_endpoint/register";
    print("Register URL: $url");

    var uri = Uri.parse(url);


    var headers = {
      'Content-Type': 'application/json',
    };

    var jsonRequest = jsonEncode(registrationData);
    var response = await http!.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception("Registration failed with status: ${response.statusCode}");
    }
  }



}
