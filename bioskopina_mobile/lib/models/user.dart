import 'package:json_annotation/json_annotation.dart';
import '../models/user_profile_picture.dart';
import '../models/user_role.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int? id;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  int? profilePictureId;
  DateTime? dateJoined;
  UserProfilePicture? profilePicture;
  List<UserRole>? userRoles;

  User(
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.profilePictureId,
    this.dateJoined,
    this.profilePicture,
    this.userRoles,
  );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
