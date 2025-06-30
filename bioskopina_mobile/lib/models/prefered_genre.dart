import 'package:json_annotation/json_annotation.dart';
part 'prefered_genre.g.dart';

@JsonSerializable()
class PreferredGenre {
  int? id;
  int? genreId;
  int? userId;

  PreferredGenre({this.id, this.genreId, this.userId});

  factory PreferredGenre.fromJson(Map<String, dynamic> json) =>
      _$PreferredGenreFromJson(json);

  Map<String, dynamic> toJson() => _$PreferredGenreToJson(this);
}