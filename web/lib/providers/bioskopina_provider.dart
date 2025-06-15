import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../models/popular_bioskopina_data.dart';
import '../providers/base_provider.dart';
import '../models/bioskopina.dart';

class MovieProvider extends BaseProvider<Bioskopina> {
  final String _endpoint = "Bioskopina";

  MovieProvider() : super("Bioskopina");

  @override
  Bioskopina fromJson(data) {
    try {
      return Bioskopina.fromJson(data);
    } catch (e) {
      debugPrint('Error parsing movie data: $e');
      debugPrint('Problematic data: $data');
      rethrow;
    }
  }

  Future<List<PopularBioskopinaData>> getMostPopularMovies() async {
    try {
      var url = "${BaseProvider.baseUrl}$_endpoint/GetMostPopularMovies";
      debugPrint('Fetching popular movies from: $url');

      var uri = Uri.parse(url);
      var headers = createHeaders();
      var response = await http.get(uri, headers: headers);

      if (isValidResponse(response)) {
        var data = jsonDecode(response.body);
        List<PopularBioskopinaData> result = [];

        for (var item in data) {
          result.add(PopularBioskopinaData(
            bioskopinaTitleEN: item["bioskopinaTitleEN"] ?? '',
            imageUrl: item["imageUrl"] ?? '',
            score: (item["score"] is int)
                ? (item["score"] as int).toDouble()
                : (item["score"] as double? ?? 0.0),
            numberOfRatings: item["numberOfRatings"] ?? 0,
            director: item["director"] ?? 'Unknown Director',
          ));
        }

        return result;
      } else {
        throw Exception("Failed to load popular movies: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint('Error in getMostPopularMovies: $e');
      rethrow;
    }
  }

  Future<Bioskopina> fetchById(int id) async {
    try {
      var url = "${BaseProvider.baseUrl}$_endpoint/$id";
      debugPrint('Fetching movie details from: $url');

      var uri = Uri.parse(url);
      var headers = createHeaders();
      var response = await http.get(uri, headers: headers);

      if (isValidResponse(response)) {
        var data = jsonDecode(response.body);
        debugPrint('Received movie data: $data');

        // Handle both single object and paginated response
        if (data is Map<String, dynamic> && data.containsKey('items')) {
          var items = data['items'] as List;
          var movieData = items.firstWhere(
            (item) => item['id'] == id,
            orElse: () => throw Exception('Movie $id not found in items list')
          );
          return fromJson(movieData);
        }
        return fromJson(data);
      } else {
        throw Exception("Failed to fetch movie: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint('Error in fetchById: $e');
      rethrow;
    }
  }

  Future<void> addMovie(Bioskopina movie) async {
    try {
      var url = "${BaseProvider.baseUrl}$_endpoint";
      debugPrint('Adding movie at: $url');
      debugPrint('Movie data: ${movie.toJson()}');

      var uri = Uri.parse(url);
      var headers = createHeaders();
      var body = jsonEncode(movie.toJson());

      var response = await http.post(uri, headers: headers, body: body);

      if (!isValidResponse(response)) {
        debugPrint('Error response: ${response.body}');
        throw Exception('Failed to add movie: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in addMovie: $e');
      rethrow;
    }
  }
Future<Bioskopina?> updateMovie(Bioskopina movie) async {
  try {
    final url = "${BaseProvider.baseUrl}$_endpoint/${movie.id}";
    final uri = Uri.parse(url);
    final headers = createHeaders();
    final body = jsonEncode(movie.toJson());

    debugPrint('Updating movie at: $url');
    debugPrint('Request body: ${const JsonEncoder.withIndent('  ').convert(movie.toJson())}');

    final response = await http.put(uri, headers: headers, body: body);

    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final responseData = jsonDecode(response.body);
        return Bioskopina.fromJson(responseData);
      } catch (e) {
        debugPrint('Error parsing response: $e');
        return movie; // Return original movie if parsing fails but status was 200
      }
    }

    throw Exception('Failed to update movie. Status: ${response.statusCode}');
  } catch (e) {
    debugPrint('Error in updateMovie: $e');
    rethrow;
  }
}
  @override
  bool isValidResponse(http.Response response) {
    debugPrint('Response status: ${response.statusCode}');
    if (kDebugMode) {
      debugPrint('Response body: ${response.body}');
    }
    return response.statusCode >= 200 && response.statusCode < 300;
  }
}
