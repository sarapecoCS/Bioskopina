import 'dart:convert';
import '../models/genre.dart';
import '../models/popular_genres_data.dart';
import '../providers/base_provider.dart';
import 'package:http/http.dart' as http;

class GenreProvider extends BaseProvider<Genre> {
  final String _endpoint = "Genre";

  GenreProvider() : super("Genre");

  @override
  Genre fromJson(data) {
    return Genre.fromJson(data);
  }

  /// Fetch all genres
  Future<List<Genre>> fetchAll() async {
    final url = "${BaseProvider.baseUrl}$_endpoint";
    final uri = Uri.parse(url);
    final headers = createHeaders();

    final response = await http.get(uri, headers: headers);

    if (!isValidResponse(response)) {
      throw Exception("Failed to load genres");
    }

    final data = jsonDecode(response.body);
    final genresList = data['items'] as List? ?? [];

    return genresList.map((item) => Genre.fromJson(item)).toList();
  }

  /// Get the most popular genres
  Future<List<PopularGenresData>> getMostPopularGenres() async {
    final url = "${BaseProvider.baseUrl}$_endpoint/Popular";
    final uri = Uri.parse(url);
    final headers = createHeaders();

    final response = await http.get(uri, headers: headers);

    if (!isValidResponse(response)) {
      throw Exception("Failed to load popular genres");
    }

    final data = jsonDecode(response.body);
    final popularList = data['items'] as List? ?? [];

    return popularList.map((item) {
      final genreName = item["genreName"] ?? '';
      final usersCount = item["usersWhoLikeIt"] ?? 0;
      return PopularGenresData(genreName, usersCount);
    }).toList();
  }
}
