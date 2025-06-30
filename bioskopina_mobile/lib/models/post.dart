import 'package:json_annotation/json_annotation.dart';
import '../models/comment.dart';
import '../models/user.dart';  // Import User model

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
  User? user; // NEW: Embedded User object

  Post(
    this.id,
    this.userId,
    this.content,
    this.likesCount,
    this.dislikesCount,
    this.datePosted,
    this.comments,
    this.user, // NEW
  );

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
