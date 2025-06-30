// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bioskopina_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BioskopinaList _$BioskopinaListFromJson(Map<String, dynamic> json) =>
    BioskopinaList(
      (json['id'] as num?)?.toInt(),
      (json['listId'] as num?)?.toInt(),
      (json['movieId'] as num?)?.toInt(),
      json['movie'] == null
          ? null
          : Bioskopina.fromJson(json['movie'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BioskopinaListToJson(BioskopinaList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'listId': instance.listId,
      'movieId': instance.movieId,
      'movie': instance.movie,
    };
