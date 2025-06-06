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
}
