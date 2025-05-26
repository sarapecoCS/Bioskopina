import 'package:json_annotation/json_annotation.dart';
import '../models/user.dart';
part 'donation.g.dart';

@JsonSerializable()
class Donation {
  int? id;
  int? userId;
  double? amount;
  DateTime? dateDonated;
  String? transactionId;
  User? user;

  Donation({
    this.id,
    this.userId,
    this.amount,
    this.dateDonated,
    this.transactionId,
    this.user,
  });

  factory Donation.fromJson(Map<String, dynamic> json) =>
      _$DonationFromJson(json);

  Map<String, dynamic> toJson() => _$DonationToJson(this);
}
