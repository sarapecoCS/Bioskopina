import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../models/search_result.dart';
import '../utils/util.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  static String? _baseUrl;
  String _endpoint = "";

  static String? get baseUrl => _baseUrl;

  HttpClient client = HttpClient();
  IOClient? http;

  BaseProvider(String endpoint) {
    _endpoint = endpoint;

    // Use Android emulator localhost alias for Android, otherwise default to LAN IP or environment variable
    if (Platform.isAndroid) {
      _baseUrl = "http://10.0.2.2:5262/";
    } else {
      _baseUrl = const String.fromEnvironment("baseUrl",
          defaultValue: "http://192.168.1.9:5262/");
    }

    client.badCertificateCallback = (cert, host, port) => true;
    http = IOClient(client);
  }

  Future<SearchResult<T>> get({dynamic filter}) async {
    var url = "$_baseUrl$_endpoint";

    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = SearchResult<T>();

      // Set count safely with fallback
      result.count = (data['totalCount'] ?? 0) as int;

      // Safely parse list of items
      var items = data['items'] as List<dynamic>?;
      if (items != null) {
        for (var item in items) {
          result.result.add(fromJson(item));
        }
      } else {
        // Maybe log warning or set empty list
        result.result = [];
      }
      return result;
    } else {
      throw Exception("Unknown error");
    }
  }


  Future<T> insert(dynamic request, {bool notifyAllListeners = true}) async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http!.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      if (notifyAllListeners == true) {
        notifyListeners();
      }

      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<T> update(int id,
      {dynamic request, bool notifyAllListeners = true}) async {
    var url = "$_baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http!.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      if (notifyAllListeners == true) {
        notifyListeners();
      }

      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<T> delete(int id,
      {dynamic request, bool notifyAllListeners = true}) async {
    var url = "$_baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http!.delete(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      if (notifyAllListeners == true) {
        notifyListeners();
      }

      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  T fromJson(data) {
    throw Exception("Method not implemented");
  }

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