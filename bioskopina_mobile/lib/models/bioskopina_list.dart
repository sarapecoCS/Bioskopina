import 'package:json_annotation/json_annotation.dart';

import 'bioskopina.dart';

part 'bioskopina_list.g.dart';

@JsonSerializable()
class BioskopinaList {
  int? id;
  int? listId;
  int? movieId;
  Bioskopina? movie; // This is referencing the Bioskopina class

  // Constructor
  BioskopinaList(this.id, this.listId, this.movieId, this.movie);

  // Factory method to create an instance of BioskopinaList from JSON
  factory BioskopinaList.fromJson(Map<String, dynamic> json) =>
      _$BioskopinaListFromJson(json);

  // Method to convert an instance of BioskopinaList to JSON
  Map<String, dynamic> toJson() => _$BioskopinaListToJson(this);
}
