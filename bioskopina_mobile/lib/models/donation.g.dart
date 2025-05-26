// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Donation _$DonationFromJson(Map<String, dynamic> json) => Donation(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toDouble(),
      dateDonated: json['dateDonated'] == null
          ? null
          : DateTime.parse(json['dateDonated'] as String),
      transactionId: json['transactionId'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DonationToJson(Donation instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'amount': instance.amount,
      'dateDonated': instance.dateDonated?.toIso8601String(),
      'transactionId': instance.transactionId,
      'user': instance.user,
    };
