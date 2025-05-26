import 'package:json_annotation/json_annotation.dart';
part 'user_comment_action.g.dart';

@JsonSerializable()
class UserCommentAction {
  int? id;
  int? userId;
  int? commentId;
  String? action;

  UserCommentAction({this.id, this.userId, this.commentId, this.action});

  factory UserCommentAction.fromJson(Map<String, dynamic> json) =>
      _$UserCommentActionFromJson(json);

  Map<String, dynamic> toJson() => _$UserCommentActionToJson(this);
}