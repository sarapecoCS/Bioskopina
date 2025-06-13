import 'dart:convert';
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

    var response = await http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      List<PopularBioskopinaData> result = [];

      for (var item in data) {
        result.add(PopularBioskopinaData(
          bioskopinaTitleEN: item["bioskopinaTitleEN"],
          bioskopinaTitleYugo: item["bioskopinaTitleYugo"],
          imageUrl: item["imageUrl"],
          score: item["score"],
          numberOfRatings: item["numberOfRatings"],
        ));
      }

      return result;
    } else {
      throw Exception("Unknown error");
    }
  }

  // ✅ New: Get recommended movies for a given movieId
  Future<List<Bioskopina>> getRecommendedMovies(int movieId) async {
    var url = "${BaseProvider.baseUrl}Recommender/recommend-movies/$movieId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      List<Bioskopina> recommendedMovies = [];

      for (var item in data) {
        recommendedMovies.add(Bioskopina.fromJson(item));
      }

      return recommendedMovies;
    } else {
      throw Exception("Unknown error");
    }
  }
}
