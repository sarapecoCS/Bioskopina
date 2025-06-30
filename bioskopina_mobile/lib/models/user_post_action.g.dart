// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_post_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPostAction _$UserPostActionFromJson(Map<String, dynamic> json) =>
    UserPostAction(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      postId: (json['postId'] as num?)?.toInt(),
      action: json['action'] as String?,
    );

Map<String, dynamic> _$UserPostActionToJson(UserPostAction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'postId': instance.postId,
      'action': instance.action,
    };
