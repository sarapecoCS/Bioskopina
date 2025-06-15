import 'dart:convert';
import '../models/genre.dart';
import '../models/popular_genres_data.dart';
import '../providers/base_provider.dart';

class GenreProvider extends BaseProvider<Genre> {
  final String _endpoint = "Genre";

  GenreProvider() : super("Genre");

  @override
  Genre fromJson(data) {
    return Genre.fromJson(data);
  }

  Future<List<Genre>> fetchAll() async {
    var url = "${BaseProvider.baseUrl}$_endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      List<dynamic> genresList = data['items'] ?? [];

      List<Genre> result = [];

      for (var item in genresList) {
        result.add(Genre.fromJson(item));
      }

      return result;
    } else {
      throw Exception("Failed to load genres");
    }
  }

  Future<List<PopularGenresData>> getMostPopularGenres() async {
    var url = "${BaseProvider.baseUrl}$_endpoint/Popular";  // Adjusted to your actual endpoint for popular genres
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      List<PopularGenresData> result = [];

      // Assuming `data` here is a List<dynamic>
      for (var item in data) {
        result.add(PopularGenresData(item["genreName"], item["usersWhoLikeIt"]));
      }

      return result;
    } else {
      throw Exception("Unknown error");
    }
  }
}
