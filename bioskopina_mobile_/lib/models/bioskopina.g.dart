part of 'bioskopina.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bioskopina _$BioskopinaFromJson(Map<String, dynamic> json) {
  return Bioskopina(
    json['id'] as int,
    json['titleEn'] as String,
    json['titleYugo'] as String,
    json['synopsis'] as String,
    json['director'] as String, //
    (json['score'] as num).toDouble(),
    (json['genreMovies'] as List<dynamic>)
        .map((e) => GenreBioskopina.fromJson(e as Map<String, dynamic>))
        .toList(),
    duration: json['duration'] as int?,
    imageUrl: json['imageUrl'] as String?,
    trailerUrl: json['trailerUrl'] as String?,
    releaseDate: json['releaseDate'] == null
        ? null
        : DateTime.parse(json['releaseDate'] as String),
  );
}

Map<String, dynamic> _$BioskopinaToJson(Bioskopina instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titleEn': instance.titleEn,
      'titleYugo': instance.titleYugo,
      'synopsis': instance.synopsis,
      'director': instance.director,
      'score': instance.score,
      'genreMovies': instance.genreMovies.map((e) => e.toJson()).toList(),
      'duration': instance.duration,
      'imageUrl': instance.imageUrl,
      'trailerUrl': instance.trailerUrl,
      'releaseDate': instance.releaseDate?.toIso8601String(),
    };
