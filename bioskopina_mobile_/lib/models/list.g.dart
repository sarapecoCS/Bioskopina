// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Listt _$ListtFromJson(Map<String, dynamic> json) => Listt(
      (json['id'] as num?)?.toInt(),
      (json['userId'] as num?)?.toInt(),
      json['name'] as String?,
      json['dateCreated'] == null
          ? null
          : DateTime.parse(json['dateCreated'] as String),
    );

Map<String, dynamic> _$ListtToJson(Listt instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'dateCreated': instance.dateCreated?.toIso8601String(),
    };
