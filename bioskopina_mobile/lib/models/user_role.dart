import 'package:json_annotation/json_annotation.dart';
import '../models/role.dart';
part 'user_role.g.dart';

@JsonSerializable()
class UserRole {
  int? id;
  int? userId;
  int? roleId;
  bool? canReview;
  bool? canAskQuestions;
  bool? canParticipateInClubs;
  Role? role;

  UserRole(
    this.id,
    this.userId,
    this.roleId,
    this.canReview,
    this.canAskQuestions,
    this.canParticipateInClubs,
    this.role,
  );

  factory UserRole.fromJson(Map<String, dynamic> json) =>
      _$UserRoleFromJson(json);

  Map<String, dynamic> toJson() => _$UserRoleToJson(this);
}
