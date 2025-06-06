import 'package:json_annotation/json_annotation.dart';

part 'list.g.dart';

@JsonSerializable()
class Listt {
  int? id;
  int? userId;
  String? name;
  DateTime? dateCreated;

  Listt(this.id, this.userId, this.name, this.dateCreated);

  factory Listt.fromJson(Map<String, dynamic> json) => _$ListtFromJson(json);

  Map<String, dynamic> toJson() => _$ListtToJson(this);
}