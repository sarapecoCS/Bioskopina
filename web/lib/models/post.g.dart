// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      (json['id'] as num?)?.toInt(),
      (json['userId'] as num?)?.toInt(),
      json['content'] as String?,
      (json['likesCount'] as num?)?.toInt(),
      (json['dislikesCount'] as num?)?.toInt(),
      json['datePosted'] == null
          ? null
          : DateTime.parse(json['datePosted'] as String),
      (json['comments'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'content': instance.content,
      'likesCount': instance.likesCount,
      'dislikesCount': instance.dislikesCount,
      'datePosted': instance.datePosted?.toIso8601String(),
      'comments': instance.comments,
    };
