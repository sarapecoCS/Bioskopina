// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bioskopina.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bioskopina _$BioskopinaFromJson(Map<String, dynamic> json) => Bioskopina(
      id: (json['id'] as num).toInt(),
      titleEn: json['titleEn'] as String,
      titleYugo: json['titleYugo'] as String,
      synopsis: json['synopsis'] as String,
      director: json['director'] as String,
      score: (json['score'] as num).toDouble(),
      genreMovies: (json['genreMovies'] as List<dynamic>)
          .map((e) => GenreBioskopina.fromJson(e as Map<String, dynamic>))
          .toList(),
      runtime: (json['runtime'] as num).toInt(),
      yearRelease: (json['yearRelease'] as num).toInt(),
      cast: json['cast'] as String,
      imDbRatings: json['imDbRatings'] as String,
      awards: json['awards'] as String?,
      imageUrl: json['imageUrl'] as String?,
      trailerUrl: json['trailerUrl'] as String?,
    );

Map<String, dynamic> _$BioskopinaToJson(Bioskopina instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titleEn': instance.titleEn,
      'titleYugo': instance.titleYugo,
      'synopsis': instance.synopsis,
      'director': instance.director,
      'score': instance.score,
      'genreMovies': instance.genreMovies,
      'runtime': instance.runtime,
      'yearRelease': instance.yearRelease,
      'cast': instance.cast,
      'imDbRatings': instance.imDbRatings,
      'awards': instance.awards,
      'imageUrl': instance.imageUrl,
      'trailerUrl': instance.trailerUrl,
    };
