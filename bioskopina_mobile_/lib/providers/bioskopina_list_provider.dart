import 'dart:convert';

import '../providers/base_provider.dart';
import '../models/bioskopina_list.dart';

class BioskopinaListProvider extends BaseProvider<BioskopinaList> {
  final String _endpoint = "BioskopinaList";
  BioskopinaListProvider() : super("BioskopinaList");

  @override
  BioskopinaList fromJson(data) {
    return BioskopinaList.fromJson(data);
  }

  Future<bool> updateListsForMovie(
      int movieId, List<BioskopinaList> newLists) async {
    var url = "${BaseProvider.baseUrl}$_endpoint/UpdateLists/$movieId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(newLists);
    var response = await http!.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      notifyListeners();
      return true;
    } else {
      throw Exception("Unknown error");
    }
  }
}
