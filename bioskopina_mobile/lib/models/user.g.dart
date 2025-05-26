// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      (json['id'] as num?)?.toInt(),
      json['firstName'] as String?,
      json['lastName'] as String?,
      json['username'] as String?,
      json['email'] as String?,
      (json['profilePictureId'] as num?)?.toInt(),
      json['dateJoined'] == null
          ? null
          : DateTime.parse(json['dateJoined'] as String),
      json['profilePicture'] == null
          ? null
          : UserProfilePicture.fromJson(
              json['profilePicture'] as Map<String, dynamic>),
      (json['userRoles'] as List<dynamic>?)
          ?.map((e) => UserRole.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'username': instance.username,
      'email': instance.email,
      'profilePictureId': instance.profilePictureId,
      'dateJoined': instance.dateJoined?.toIso8601String(),
      'profilePicture': instance.profilePicture,
      'userRoles': instance.userRoles,
    };
