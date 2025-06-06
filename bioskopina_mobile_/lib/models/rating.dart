import 'package:json_annotation/json_annotation.dart';
import 'bioskopina.dart';
import 'user.dart';

part 'rating.g.dart';

@JsonSerializable()
class Rating {
  int? id;
  int? userId;
  int? movieId;
  int? ratingValue;
  String? reviewText;
  DateTime? dateAdded;
  Bioskopina? movie;
  User? user;

  Rating(
      this.id,
      this.userId,
      this.movieId,
      this.ratingValue,
      this.reviewText,
      this.dateAdded,
      this.movie,
      this.user,
      );

  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);

  Map<String, dynamic> toJson() => _$RatingToJson(this);
}
