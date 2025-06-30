import 'dart:convert';

import '../models/payment_intent.dart';
import '../providers/base_provider.dart';

class PaymentIntentProvider extends BaseProvider<PaymentIntent> {
  final String _endpoint = "PaymentIntent";
  PaymentIntentProvider() : super("PaymentIntent");

  @override
  PaymentIntent fromJson(data) {
    return PaymentIntent.fromJson(data);
  }

  Future<PaymentIntent> createPaymentIntent(dynamic request) async {
    var url = "${BaseProvider.baseUrl}$_endpoint/CreatePaymentIntent";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);

    var response = await http!.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }
}