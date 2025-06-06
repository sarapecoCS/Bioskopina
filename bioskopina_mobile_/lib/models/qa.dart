import 'package:json_annotation/json_annotation.dart';

import '../models/qa_category.dart';
import '../models/user.dart';

part 'qa.g.dart';

@JsonSerializable()
class QA {
  int? id;
  int? userId;
  int? categoryId;
  String? question;
  String? answer;
  bool? displayed;
  QAcategory? category;
  User? user;

  QA({
    this.id,
    this.userId,
    this.categoryId,
    this.question,
    this.answer,
    this.displayed,
    this.category,
    this.user,
  });

  factory QA.fromJson(Map<String, dynamic> json) => _$QAFromJson(json);

  Map<String, dynamic> toJson() => _$QAToJson(this);
}
