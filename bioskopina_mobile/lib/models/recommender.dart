import 'package:json_annotation/json_annotation.dart';
part 'recommender.g.dart';

@JsonSerializable()
class Recommender {
  int? id;
  int? movieId;
  int? coMovieId1;
  int? coMovieId2;
  int? coMovieId3;

  Recommender(
      this.id, this.movieId, this.coMovieId1, this.coMovieId2, this.coMovieId3);

  factory Recommender.fromJson(Map<String, dynamic> json) =>
      _$RecommenderFromJson(json);

  Map<String, dynamic> toJson() => _$RecommenderToJson(this);
}