import 'dart:convert';

import '../models/search_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_comment_action.dart';
import '../providers/base_provider.dart';
import '../utils/util.dart';

class UserCommentActionProvider extends BaseProvider<UserCommentAction> {
  final String _endpoint = "UserCommentAction";
  UserCommentActionProvider() : super("UserCommentAction");

  @override
  UserCommentAction fromJson(data) {
    return UserCommentAction.fromJson(data);
  }

  Future<void> saveUserAction(int commentId, String action) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('comment_$commentId', action);

    await _sendUserActionToServer(commentId, action);
  }

  Future<String?> getUserAction(int commentId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('comment_$commentId');
  }

  Future<void> _sendUserActionToServer(int commentId, String action) async {
    var url = "${BaseProvider.baseUrl}$_endpoint/action/$commentId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode({
      "action": action,
      "userId": LoggedUser.user!.id,
      "commentId": commentId,
    });
    var response = await http!.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      notifyListeners();
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<void> syncUserActions() async {
    try {
      SearchResult<UserCommentAction> actions =
      await super.get(filter: {"UserId": "${LoggedUser.user!.id!}"});

      final prefs = await SharedPreferences.getInstance();

      for (var key in prefs.getKeys()) {
        if (key.startsWith('comment_')) {
          await prefs.remove(key);
        }
      }

      for (var action in actions.result) {
        await prefs.setString('comment_${action.commentId}', action.action!);
      }
    } catch (e) {
      print("Error syncing user comment actions: $e");
    }
  }
}