import 'dart:convert';

import '../models/preferred_genre.dart';
import '../providers/base_provider.dart';

class PreferredGenreProvider extends BaseProvider<PreferredGenre> {
  final String _endpoint = "PreferredGenre";
  PreferredGenreProvider() : super("PreferredGenre");

  @override
  PreferredGenre fromJson(data) {
    return PreferredGenre.fromJson(data);
  }

  Future<bool> updatePrefGenresForUser(
      int userId, List<PreferredGenre> newPrefGenres) async {
    var url = "${BaseProvider.baseUrl}$_endpoint/UpdatePrefGenres/$userId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(newPrefGenres);
    var response = await http!.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      notifyListeners();
      return true;
    } else {
      throw Exception("Unknown error");
    }
  }
}