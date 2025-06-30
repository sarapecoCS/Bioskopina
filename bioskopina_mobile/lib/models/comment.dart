import 'package:json_annotation/json_annotation.dart';
part 'comment.g.dart';

@JsonSerializable()
class Comment {
  int? id;
  int? postId;
  int? userId;
  String? content;
  int? likesCount;
  int? dislikesCount;
  DateTime? dateCommented;

  Comment(
    this.id,
    this.postId,
    this.userId,
    this.content,
    this.likesCount,
    this.dislikesCount,
    this.dateCommented,
  );

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
