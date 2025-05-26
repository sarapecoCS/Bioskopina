// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre_bioskopina.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenreBioskopina _$GenreBioskopinaFromJson(Map<String, dynamic> json) =>
    GenreBioskopina(
      (json['id'] as num?)?.toInt(),
      (json['genreId'] as num?)?.toInt(),
      (json['movieId'] as num?)?.toInt(),
      json['movie'] == null
          ? null
          : Bioskopina.fromJson(json['movie'] as Map<String, dynamic>),
      json['genre'] == null
          ? null
          : Genre.fromJson(json['genre'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GenreBioskopinaToJson(GenreBioskopina instance) =>
    <String, dynamic>{
      'id': instance.id,
      'genreId': instance.genreId,
      'movieId': instance.movieId,
      'movie': instance.movie,
      'genre': instance.genre,
    };
