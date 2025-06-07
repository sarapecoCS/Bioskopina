import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/popular_bioskopina_data.dart';
import '../providers/base_provider.dart';
import '../models/bioskopina.dart';

class MovieProvider extends BaseProvider<Bioskopina> {
  final String _endpoint = "Bioskopina";

  MovieProvider() : super("Bioskopina");

  @override
  Bioskopina fromJson(data) {
    return Bioskopina.fromJson(data);
  }

  Future<List<PopularBioskopinaData>> getMostPopularMovies() async {
    var url = "${BaseProvider.baseUrl}$_endpoint/GetMostPopularMovies";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      List<PopularBioskopinaData> result = [];

      for (var item in data) {
        result.add(PopularBioskopinaData(
          bioskopinaTitleEN: item["bioskopinaTitleEN"] ?? '',
          bioskopinaTitleYugo: item["bioskopinaTitleYugo"] ?? '',
          imageUrl: item["imageUrl"] ?? '',
          // Convert score safely to double:
          score: (item["score"] is int)
              ? (item["score"] as int).toDouble()
              : (item["score"] as double? ?? 0.0),
          numberOfRatings: item["numberOfRatings"] ?? 0,
          director: item["director"] ?? 'Unknown Director',  // added director
        ));
      }

      return result;
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<Bioskopina> fetchById(int id) async {
    var url = "${BaseProvider.baseUrl}$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Movie not found");
    }
  }

  Future<void> addMovie(Bioskopina movie) async {
    var url = "${BaseProvider.baseUrl}$_endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    var body = jsonEncode(movie.toJson());

    var response = await http.post(uri, headers: headers, body: body);

    if (!isValidResponse(response)) {
      throw Exception('Failed to add movie');
    }
  }

  Future<void> updateMovie(Bioskopina movie) async {
    var url = "${BaseProvider.baseUrl}$_endpoint/${movie.id}";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    var body = jsonEncode(movie.toJson());

    var response = await http.put(uri, headers: headers, body: body);

    if (!isValidResponse(response)) {
      throw Exception('Failed to update movie');
    }
  }
}
