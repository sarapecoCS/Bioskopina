import 'dart:convert';

import '../providers/base_provider.dart';

import '../models/genre.dart';
import '../models/popular_genres_data.dart';

class GenreProvider extends BaseProvider<Genre> {
  final String _endpoint = "Genre";
  GenreProvider() : super("Genre");

  @override
  Genre fromJson(data) {
    return Genre.fromJson(data);
  }

  Future<List<PopularGenresData>> getMostPopularGenres() async {
    var url = "${BaseProvider.baseUrl}$_endpoint/GetMostPopularGenres";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      List<PopularGenresData> result = [];

      for (var item in data) {
        result
            .add(PopularGenresData(item["genreName"], item["usersWhoLikeIt"]));
      }

      return result;
    } else {
      throw Exception("Unknown error");
    }
  }
}
