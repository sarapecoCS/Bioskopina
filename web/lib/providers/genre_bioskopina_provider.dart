import '../providers/base_provider.dart';
import '../models/genre_bioskopina.dart';
import 'dart:convert';

class GenreMovieProvider extends BaseProvider<GenreBioskopina> {
  final String _endpoint = "GenreBioskopina"; // Consistent naming

  GenreMovieProvider() : super("GenreBioskopina");

  @override
  GenreBioskopina fromJson(data) {
    return GenreBioskopina.fromJson(data);
  }

  Future<List<GenreBioskopina>> fetchGenresForMovie(int movieId) async {
    var url = "${BaseProvider.baseUrl}$_endpoint/ByMovie/$movieId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      if (data is List) {
        return data.map((e) => GenreBioskopina.fromJson(e)).toList();
      } else if (data['items'] != null) {
        return (data['items'] as List).map((e) => GenreBioskopina.fromJson(e)).toList();
      }
      throw Exception("Unexpected response format");
    } else {
      throw Exception("Failed to load genres for movie");
    }
  }

  Future<bool> updateGenresForMovie(int movieId, List<GenreBioskopina> genres) async {
    var url = "${BaseProvider.baseUrl}$_endpoint/UpdateForMovie/$movieId";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    var jsonRequest = jsonEncode(genres.map((e) => e.toJson()).toList());

    var response = await http!.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      notifyListeners();
      return true;
    } else {
      throw Exception("Failed to update genres");
    }
  }

  Future<List<GenreBioskopina>> fetchAll() async {
    var url = "${BaseProvider.baseUrl}$_endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      if (data['items'] != null) {
        return (data['items'] as List).map((e) => GenreBioskopina.fromJson(e)).toList();
      }
      throw Exception("Response missing 'items' field");
    } else {
      throw Exception("Failed to load genre-movie relationships");
    }
  }
}