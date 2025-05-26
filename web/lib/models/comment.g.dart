// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      (json['id'] as num?)?.toInt(),
      (json['postId'] as num?)?.toInt(),
      (json['userId'] as num?)?.toInt(),
      json['content'] as String?,
      (json['likesCount'] as num?)?.toInt(),
      (json['dislikesCount'] as num?)?.toInt(),
      json['dateCommented'] == null
          ? null
          : DateTime.parse(json['dateCommented'] as String),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'userId': instance.userId,
      'content': instance.content,
      'likesCount': instance.likesCount,
      'dislikesCount': instance.dislikesCount,
      'dateCommented': instance.dateCommented?.toIso8601String(),
    };
