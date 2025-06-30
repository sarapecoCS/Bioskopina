// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_comment_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCommentAction _$UserCommentActionFromJson(Map<String, dynamic> json) =>
    UserCommentAction(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      commentId: (json['commentId'] as num?)?.toInt(),
      action: json['action'] as String?,
    );

Map<String, dynamic> _$UserCommentActionToJson(UserCommentAction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'commentId': instance.commentId,
      'action': instance.action,
    };
