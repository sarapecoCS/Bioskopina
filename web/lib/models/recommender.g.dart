// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommender.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recommender _$RecommenderFromJson(Map<String, dynamic> json) => Recommender(
      (json['id'] as num?)?.toInt(),
      (json['movieId'] as num?)?.toInt(),
      (json['coMovieId1'] as num?)?.toInt(),
      (json['coMovieId2'] as num?)?.toInt(),
      (json['coMovieId3'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RecommenderToJson(Recommender instance) =>
    <String, dynamic>{
      'id': instance.id,
      'movieId': instance.movieId,
      'coMovieId1': instance.coMovieId1,
      'coMovieId2': instance.coMovieId2,
      'coMovieId3': instance.coMovieId3,
    };
