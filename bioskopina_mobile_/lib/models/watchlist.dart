import 'package:json_annotation/json_annotation.dart';

part 'watchlist.g.dart';

@JsonSerializable()
class Watchlist {
  int? id;
  int? userId;
  DateTime? dateAdded;

  Watchlist(
      this.id,
      this.userId,
      this.dateAdded,
      );

  factory Watchlist.fromJson(Map<String, dynamic> json) =>
      _$WatchlistFromJson(json);

  Map<String, dynamic> toJson() => _$WatchlistToJson(this);
}