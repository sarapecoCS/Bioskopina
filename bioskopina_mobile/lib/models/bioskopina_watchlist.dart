import 'package:json_annotation/json_annotation.dart';

import 'bioskopina.dart';  // Import the Bioskopina model
part 'bioskopina_watchlist.g.dart';

@JsonSerializable()
class BioskopinaWatchlist {
  int? id;
  int? movieId;
  int? watchlistId;
  String? watchStatus;
  int? progress;
  DateTime? dateStarted;
  DateTime? dateFinished;
  Bioskopina? bioskopina;

  BioskopinaWatchlist(
      this.id,
      this.movieId,
      this.watchlistId,
      this.watchStatus,
      this.progress,
      this.dateStarted,
      this.dateFinished,
      this.bioskopina,
      );

  factory BioskopinaWatchlist.fromJson(Map<String, dynamic> json) =>
      _$BioskopinaWatchlistFromJson(json);

  Map<String, dynamic> toJson() => _$BioskopinaWatchlistToJson(this);
}
