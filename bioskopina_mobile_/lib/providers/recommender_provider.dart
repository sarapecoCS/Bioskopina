import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../models/recommender.dart';
import '../utils/util.dart';

class RecommenderProvider extends ChangeNotifier {
  String? _baseUrl;
  final String _endpoint = "Recommender";

  HttpClient client = HttpClient();
  IOClient? http;

  RecommenderProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://192.168.1.9:5262/");

    client.badCertificateCallback = (cert, host, port) => true;
    http = IOClient(client);
  }

  Future<Recommender> getById(int id) async {
    var url = "$_baseUrl$_endpoint/$id";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return Recommender.fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  Future trainData() async {
    var url = "$_baseUrl/TrainModelAsync";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    Response response = await post(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Unknown error");
    }
  }

  Future deleteData() async {
    var url = "$_baseUrl/ClearRecommendations";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    Response response = await delete(uri, headers: headers);
    if (isValidResponse(response)) {
    } else {
      throw Exception("Unknown error");
    }
  }

  // -----------------------------------
  // -----------------------------------

  bool isValidResponse(Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    } else {
      print(response.body);
      throw Exception("Something bad happened, please try again.");
    }
  }

  Map<String, String> createHeaders() {
    String username = Authorization.username ?? "";
    String password = Authorization.password ?? "";

    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };

    return headers;
  }

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
        query += '$prefix$key=${(value as DateTime).toIso8601String()}';
      } else if (value is List<int>) {
        // Handle list of integers (anime IDs)
        for (int id in value) {
          query += '$prefix$key=$id';
          query += '&'; // Add '&' to separate multiple IDs
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