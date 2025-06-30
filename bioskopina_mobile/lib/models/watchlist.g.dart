// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Watchlist _$WatchlistFromJson(Map<String, dynamic> json) => Watchlist(
      (json['id'] as num?)?.toInt(),
      (json['userId'] as num?)?.toInt(),
      json['dateAdded'] == null
          ? null
          : DateTime.parse(json['dateAdded'] as String),
    );

Map<String, dynamic> _$WatchlistToJson(Watchlist instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'dateAdded': instance.dateAdded?.toIso8601String(),
    };
