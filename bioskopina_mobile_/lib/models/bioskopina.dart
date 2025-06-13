import 'package:json_annotation/json_annotation.dart';
import 'genre_bioskopina.dart';

part 'bioskopina.g.dart';

@JsonSerializable()
class Bioskopina {
  final int? id;
  @JsonKey(name: 'titleEn')
  final String? titleEn;

  final String? synopsis;
  final String? director;
  @JsonKey(name: 'score')
  final double? score;
  @JsonKey(name: 'genreMovies')
  final List<GenreBioskopina>? genreMovies;
  @JsonKey(name: 'runtime')
  final int? runtime;
  final int? yearRelease;

  @JsonKey(name: 'imageUrl')
  final String? imageUrl;
  @JsonKey(name: 'trailerUrl')
  final String? trailerUrl;

  Bioskopina({
    this.id,
    this.titleEn,
    this.synopsis,
    this.director,
    this.score,
    this.genreMovies,
    this.runtime,
    this.yearRelease,
    this.imageUrl,
    this.trailerUrl,
  });

  factory Bioskopina.fromJson(Map<String, dynamic> json) =>
      _$BioskopinaFromJson(json);

  Map<String, dynamic> toJson() => _$BioskopinaToJson(this);
}
