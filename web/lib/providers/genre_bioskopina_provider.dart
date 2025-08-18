import '../providers/base_provider.dart';
import '../models/genre_bioskopina.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GenreMovieProvider extends BaseProvider<GenreBioskopina> {
  final String _endpoint = "GenreBioskopina";

  GenreMovieProvider() : super("GenreBioskopina");

  @override
  GenreBioskopina fromJson(data) {
    return GenreBioskopina.fromJson(data);
  }

  /// Fetch genres associated with a specific movie
  Future<List<GenreBioskopina>> fetchGenresForMovie(int movieId) async {
    final url = "${BaseProvider.baseUrl}$_endpoint/ByMovie/$movieId";
    final uri = Uri.parse(url);
    final headers = createHeaders();

    final response = await http.get(uri, headers: headers);

    if (!isValidResponse(response)) {
      throw Exception("Failed to load genres for movie");
    }

    final data = jsonDecode(response.body);

    if (data is List) {
      return data.map((e) => GenreBioskopina.fromJson(e)).toList();
    } else if (data['items'] != null) {
      return (data['items'] as List)
          .map((e) => GenreBioskopina.fromJson(e))
          .toList();
    }

    throw Exception("Unexpected response format");
  }

  /// Update genres for a specific movie
  Future<bool> updateGenresForMovie(
      int movieId, List<GenreBioskopina> genres) async {
    final url = "${BaseProvider.baseUrl}$_endpoint/UpdateForMovie/$movieId";
    final uri = Uri.parse(url);
    final headers = createHeaders();
    final jsonRequest = jsonEncode(genres.map((e) => e.toJson()).toList());

    final response = await http.put(uri, headers: headers, body: jsonRequest);

    if (!isValidResponse(response)) {
      throw Exception("Failed to update genres");
    }

    notifyListeners();
    return true;
  }

  /// Fetch all genre-movie relationships
  Future<List<GenreBioskopina>> fetchAll() async {
    final url = "${BaseProvider.baseUrl}$_endpoint";
    final uri = Uri.parse(url);
    final headers = createHeaders();

    final response = await http.get(uri, headers: headers);

    if (!isValidResponse(response)) {
      throw Exception("Failed to load genre-movie relationships");
    }

    final data = jsonDecode(response.body);

    if (data['items'] != null) {
      return (data['items'] as List)
          .map((e) => GenreBioskopina.fromJson(e))
          .toList();
    }

    throw Exception("Response missing 'items' field");
  }
}
