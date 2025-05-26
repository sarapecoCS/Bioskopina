// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rating _$RatingFromJson(Map<String, dynamic> json) => Rating(
      (json['id'] as num?)?.toInt(),
      (json['userId'] as num?)?.toInt(),
      (json['movieId'] as num?)?.toInt(),
      (json['ratingValue'] as num?)?.toInt(),
      json['reviewText'] as String?,
      json['dateAdded'] == null
          ? null
          : DateTime.parse(json['dateAdded'] as String),
      json['movie'] == null
          ? null
          : Bioskopina.fromJson(json['movie'] as Map<String, dynamic>),
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RatingToJson(Rating instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'movieId': instance.movieId,
      'ratingValue': instance.ratingValue,
      'reviewText': instance.reviewText,
      'dateAdded': instance.dateAdded?.toIso8601String(),
      'movie': instance.movie,
      'user': instance.user,
    };
