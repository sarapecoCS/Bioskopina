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

  Future<List<GenreBioskopina>> fetchGenresForMovie(int movieId) async {
    var url = "${BaseProvider.baseUrl}$_endpoint/ByMovie/$movieId";
    print("Fetching genres from URL: $url");

    var uri = Uri.parse(url);
    var headers = createHeaders();
    var response = await http!.get(uri, headers: headers);

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      if (data is List) {
        return data.map((e) => GenreBioskopina.fromJson(e)).toList();
      } else {
        throw Exception("Unexpected response format: Expected a list");
      }
    } else {
      throw Exception("Genres for movie not found");
    }
  }





 Future<List<GenreBioskopina>> fetchAllGenres() async {
   var url = "${BaseProvider.baseUrl}$_endpoint"; // Your API endpoint
   var uri = Uri.parse(url);
   var headers = createHeaders();

   var response = await http!.get(uri, headers: headers);

   if (isValidResponse(response)) {
     // Decode response body as Map because the root JSON object has keys "result" and "count"
     var data = jsonDecode(response.body) as Map<String, dynamic>;

     print("Fetched genres: $data");

     // Extract the list from the "result" key
     var genresJson = data['result'] as List<dynamic>;

     // Map each JSON object to GenreBioskopina model using fromJson
     return genresJson.map((json) => GenreBioskopina.fromJson(json)).toList();
   } else {
     print("Invalid response: Status Code: ${response.statusCode}");
     print("Response Body: ${response.body}");
     throw Exception("Something bad happened, please try again.");
   }
 }



}
