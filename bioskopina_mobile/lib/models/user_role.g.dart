// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRole _$UserRoleFromJson(Map<String, dynamic> json) => UserRole(
      (json['id'] as num?)?.toInt(),
      (json['userId'] as num?)?.toInt(),
      (json['roleId'] as num?)?.toInt(),
      json['canReview'] as bool?,
      json['canAskQuestions'] as bool?,
      json['canParticipateInClubs'] as bool?,
      json['role'] == null
          ? null
          : Role.fromJson(json['role'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserRoleToJson(UserRole instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'roleId': instance.roleId,
      'canReview': instance.canReview,
      'canAskQuestions': instance.canAskQuestions,
      'canParticipateInClubs': instance.canParticipateInClubs,
      'role': instance.role,
    };
