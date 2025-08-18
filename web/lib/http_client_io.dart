import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

http.Client createHttpClient() {
  final client = HttpClient()
    ..badCertificateCallback = (cert, host, port) => true; // allow self-signed
  return IOClient(client);
}
