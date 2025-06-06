import 'package:json_annotation/json_annotation.dart';
import '../models/comment.dart';
part 'post.g.dart';

@JsonSerializable()
class Post {
  int? id;
  int? userId;
  String? content;
  int? likesCount;
  int? dislikesCount;
  DateTime? datePosted;
  List<Comment>? comments;

  Post(
    this.id,
    this.userId,
    this.content,
    this.likesCount,
    this.dislikesCount,
    this.datePosted,
    this.comments,
  );

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
