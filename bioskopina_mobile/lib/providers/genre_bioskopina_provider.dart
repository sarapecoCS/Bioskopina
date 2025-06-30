import '../providers/base_provider.dart';
import '../models/genre_bioskopina.dart';
import 'dart:convert';

class GenreMovieProvider extends BaseProvider<GenreBioskopina> {
  final String _endpoint = "GenreBioskopina";

  GenreMovieProvider() : super("GenreBioskopina");

  @override
  GenreBioskopina fromJson(data) {
    return GenreBioskopina.fromJson(data);
  }

  Future<bool> updateGenresForMovie(int movieId, List<GenreBioskopina> newGenres) async {
    var url = "${BaseProvider.baseUrl}$_endpoint/UpdateGenres/$movieId";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    var jsonRequest = jsonEncode(newGenres);

    var response = await http!.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      notifyListeners();
      return true;
    } else {
      throw Exception("Unknown error");
    }
  }
}
