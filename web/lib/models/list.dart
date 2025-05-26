import 'package:json_annotation/json_annotation.dart';

part 'list.g.dart';  // Make sure the part file name matches

@JsonSerializable()
class CustomList {  // Rename List to CustomList or another name of your choice
  int? id;
  int? userId;
  String? name;
  DateTime? dateCreated;

  CustomList(this.id, this.userId, this.name, this.dateCreated);

  factory CustomList.fromJson(Map<String, dynamic> json) => _$CustomListFromJson(json);

  Map<String, dynamic> toJson() => _$CustomListToJson(this);
}
