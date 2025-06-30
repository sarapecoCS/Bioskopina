// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_picture.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfilePicture _$UserProfilePictureFromJson(Map<String, dynamic> json) =>
    UserProfilePicture(
      (json['id'] as num?)?.toInt(),
      json['profilePicture'] as String?,
    );

Map<String, dynamic> _$UserProfilePictureToJson(UserProfilePicture instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profilePicture': instance.profilePicture,
    };
