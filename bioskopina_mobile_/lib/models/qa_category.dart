import 'package:json_annotation/json_annotation.dart';

part 'qa_category.g.dart';

@JsonSerializable()
class QAcategory {
  int? id;
  String? name;

  QAcategory(
    this.id,
    this.name,
  );

  factory QAcategory.fromJson(Map<String, dynamic> json) =>
      _$QAcategoryFromJson(json);

  Map<String, dynamic> toJson() => _$QAcategoryToJson(this);
}
