import 'package:json_annotation/json_annotation.dart';
part 'user_profile_picture.g.dart';

@JsonSerializable()
class UserProfilePicture {
  int? id;
  String? profilePicture;

  UserProfilePicture(
    this.id,
    this.profilePicture,
  );

  factory UserProfilePicture.fromJson(Map<String, dynamic> json) =>
      _$UserProfilePictureFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfilePictureToJson(this);
}
