import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../models/recommender.dart';
import '../utils/util.dart';

class RecommenderProvider extends ChangeNotifier {
  String? _baseUrl;
  final String _endpoint = "Recommender";

  final HttpClient _client = HttpClient();
  IOClient? _http;

  RecommenderProvider() {
    _baseUrl = const String.fromEnvironment(
      "baseUrl",
      defaultValue: "http://192.168.1.9:5262/",
    );

    _client.badCertificateCallback = (cert, host, port) => true;
    _http = IOClient(_client);
  }

  /// Headers builder
  Map<String, String> createHeaders() {
    String username = Authorization.username ?? "";
    String password = Authorization.password ?? "";

    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    return {
      "Content-Type": "application/json",
      "Authorization": basicAuth,
    };
  }

  /// Validate HTTP response status code
  bool isValidResponse(http.Response response) {
    if (response.statusCode < 300) {
      return true;
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    } else {
      print(response.body);
      throw Exception("Something bad happened, please try again.");
    }
  }

  /// Fetch Recommender by movieId
  Future<Recommender> getById(int movieId) async {
    var url = "$_baseUrl$_endpoint/$movieId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await _http!.get(uri, headers: headers);
    print("Requesting recommendations for movieId: $movieId");
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      print("Parsed data: $data");
      return Recommender.fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  /// Returns a list of recommended movie IDs, ignoring nulls
  Future<List<int>> getRecommendedMovieIds(int movieId) async {
    Recommender recommender = await getById(movieId);
    return [
      recommender.coMovieId1,
      recommender.coMovieId2,
      recommender.coMovieId3,
    ].whereType<int>().toList();
  }

  /// Calls API endpoint to trigger training
  Future<dynamic> trainData() async {
    var url = "$_baseUrl/TrainModelAsync";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await _http!.post(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Unknown error");
    }
  }

  /// Calls API endpoint to clear recommendations
  Future<void> deleteData() async {
    var url = "$_baseUrl/ClearRecommendations";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await _http!.delete(uri, headers: headers);
    if (!isValidResponse(response)) {
      throw Exception("Unknown error");
    }
  }

  /// Utility to convert Map params to query string (optional)
  String getQueryString(Map params,
      {String prefix = '&', bool inRecursion = false}) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }
      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        query += '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$prefix$key=${(value).toIso8601String()}';
      } else if (value is List<int>) {
        for (int id in value) {
          query += '$prefix$key=$id&';
        }
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    return query;
  }
}
