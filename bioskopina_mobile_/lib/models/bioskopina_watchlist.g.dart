// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bioskopina_watchlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BioskopinaWatchlist _$BioskopinaWatchlistFromJson(Map<String, dynamic> json) =>
    BioskopinaWatchlist(
      (json['id'] as num?)?.toInt(),
      (json['movieId'] as num?)?.toInt(),
      (json['watchlistId'] as num?)?.toInt(),
      json['watchStatus'] as String?,
      (json['progress'] as num?)?.toInt(),
      json['dateStarted'] == null
          ? null
          : DateTime.parse(json['dateStarted'] as String),
      json['dateFinished'] == null
          ? null
          : DateTime.parse(json['dateFinished'] as String),
      json['bioskopina'] == null
          ? null
          : Bioskopina.fromJson(json['bioskopina'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BioskopinaWatchlistToJson(BioskopinaWatchlist instance) =>
    <String, dynamic>{
      'id': instance.id,
      'movieId': instance.movieId,
      'watchlistId': instance.watchlistId,
      'watchStatus': instance.watchStatus,
      'progress': instance.progress,
      'dateStarted': instance.dateStarted?.toIso8601String(),
      'dateFinished': instance.dateFinished?.toIso8601String(),
      'bioskopina': instance.bioskopina,
    };
