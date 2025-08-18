import 'dart:convert';
import '../models/registration_data.dart';
import '../models/user.dart';
import '../providers/base_provider.dart';
import 'package:http/http.dart' as http;

class UserProvider extends BaseProvider<User> {
  final String _endpoint = "User";

  UserProvider() : super("User");

  @override
  User fromJson(data) {
    return User.fromJson(data);
  }

  /// Get user registrations aggregated by days or months
  Future<List<UserRegistrationData>> getUserRegistrations(
      int days, {bool? groupByMonths = false}) async {
    final url =
        "${BaseProvider.baseUrl}$_endpoint/GetUserRegistrations/$days?groupByMonths=$groupByMonths";
    final uri = Uri.parse(url);
    final headers = createHeaders();

    final response = await http.get(uri, headers: headers);

    if (!isValidResponse(response)) {
      throw Exception("Failed to fetch user registrations");
    }

    final data = jsonDecode(response.body) as List;

    return data
        .map((item) => UserRegistrationData(
              date: DateTime.parse(item["dateJoined"]),
              numberOfUsers: item["numberOfUsers"],
            ))
        .toList();
  }

  /// Change password for a user by userId
  Future<String> changePassword(int userId, dynamic request) async {
    final url = "${BaseProvider.baseUrl}$_endpoint/ChangePassword/$userId";
    final uri = Uri.parse(url);
    final headers = createHeaders();
    final jsonRequest = jsonEncode(request);

    final response = await http.post(uri, headers: headers, body: jsonRequest);

    if (!isValidResponse(response)) {
      throw Exception("Failed to change password");
    }

    final data = jsonDecode(response.body);
    return data.toString();
  }

  /// Register a new user
  Future<User?> register(Map<String, dynamic> registrationData) async {
    final url = "${BaseProvider.baseUrl}$_endpoint/register";
    final uri = Uri.parse(url);

    final headers = {'Content-Type': 'application/json'};
    final jsonRequest = jsonEncode(registrationData);

    final response = await http.post(uri, headers: headers, body: jsonRequest);

    if (!isValidResponse(response)) {
      throw Exception(
          "Registration failed with status: ${response.statusCode}");
    }

    final data = jsonDecode(response.body);
    return User.fromJson(data);
  }
}
