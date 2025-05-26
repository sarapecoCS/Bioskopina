import 'package:json_annotation/json_annotation.dart';
import 'bioskopina.dart';
import 'genre.dart';

part 'genre_bioskopina.g.dart';

@JsonSerializable()
class GenreBioskopina {
  int? id;
  int? genreId;
  int? movieId;

  @JsonKey(name: 'movie')
  Bioskopina? movie;

  @JsonKey(name: 'genre')
  Genre? genre;

  GenreBioskopina(
      this.id,
      this.genreId,
      this.movieId,
      this.movie,
      this.genre,
      );

  factory GenreBioskopina.fromJson(Map<String, dynamic> json) =>
      _$GenreBioskopinaFromJson(json);

  Map<String, dynamic> toJson() => _$GenreBioskopinaToJson(this);
}
