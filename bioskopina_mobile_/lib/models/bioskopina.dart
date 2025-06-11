import 'package:json_annotation/json_annotation.dart';
import 'genre_bioskopina.dart';

part 'bioskopina.g.dart';

@JsonSerializable()
class Bioskopina {
  final int id;
  final String titleEn;
  final String? titleYugo;
  final String synopsis;
  final String director;
  final double score;
  final List<GenreBioskopina> genreMovies;
  final int? duration;
  final String? imageUrl;
  final String? trailerUrl;
  final DateTime? releaseDate;

  Bioskopina(
      this.id,
      this.titleEn,
      this.titleYugo,
      this.synopsis,
      this.director,
      this.score,
      this.genreMovies, {
        this.duration,
        this.imageUrl,
        this.trailerUrl,
        this.releaseDate,
      });

  factory Bioskopina.fromJson(Map<String, dynamic> json) =>
      _$BioskopinaFromJson(json);

  Map<String, dynamic> toJson() => _$BioskopinaToJson(this);
}