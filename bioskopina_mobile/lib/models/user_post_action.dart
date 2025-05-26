import 'package:json_annotation/json_annotation.dart';
part 'user_post_action.g.dart';

@JsonSerializable()
class UserPostAction {
  int? id;
  int? userId;
  int? postId;
  String? action;

  UserPostAction({this.id, this.userId, this.postId, this.action});

  factory UserPostAction.fromJson(Map<String, dynamic> json) =>
      _$UserPostActionFromJson(json);

  Map<String, dynamic> toJson() => _$UserPostActionToJson(this);
}