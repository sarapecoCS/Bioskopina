// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qa.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QA _$QAFromJson(Map<String, dynamic> json) => QA(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      categoryId: (json['categoryId'] as num?)?.toInt(),
      question: json['question'] as String?,
      answer: json['answer'] as String?,
      displayed: json['displayed'] as bool?,
      category: json['category'] == null
          ? null
          : QAcategory.fromJson(json['category'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QAToJson(QA instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'categoryId': instance.categoryId,
      'question': instance.question,
      'answer': instance.answer,
      'displayed': instance.displayed,
      'category': instance.category,
      'user': instance.user,
    };
