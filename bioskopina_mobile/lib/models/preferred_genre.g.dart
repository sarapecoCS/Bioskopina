// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferred_genre.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreferredGenre _$PreferredGenreFromJson(Map<String, dynamic> json) =>
    PreferredGenre(
      id: (json['id'] as num?)?.toInt(),
      genreId: (json['genreId'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PreferredGenreToJson(PreferredGenre instance) =>
    <String, dynamic>{
      'id': instance.id,
      'genreId': instance.genreId,
      'userId': instance.userId,
    };
