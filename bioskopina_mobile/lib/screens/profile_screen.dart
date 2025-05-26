import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import '../widgets/change_password_form.dart';
import '../providers/user_provider.dart';
import '../models/user_profile_picture.dart';
import '../providers/user_profile_picture_provider.dart';
import '../widgets/gradient_button.dart';
import '../models/user.dart';
import '../utils/colors.dart';
import '../utils/util.dart';
import '../widgets/form_builder_text_field.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  User user;
  ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late UserProfilePictureProvider _userProfilePictureProvider;
  late UserProvider _userProvider;
  String? _base64Image;
  late Size screenSize;
  double? textFieldWidth;
  double? imageWidth;
  double? containerWidth;
  double? containerHeight;
  bool usernameTaken = false;
  bool emailTaken = false;
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();

  Future getImage() async {
    try {
      var result = await FilePicker.platform
          .pickFiles(type: FileType.image, compressionQuality: 0);

      if (result != null && result.files.single.path != null) {
        File originalImage = File(result.files.single.path!);

        print("Original Image Size: ${originalImage.lengthSync()} bytes");

        Uint8List compressedImage = await compressImage(originalImage);

        print("Compressed Image Size: ${compressedImage.length} bytes");

        setState(() {
          _base64Image = base64Encode(compressedImage);
        });
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error picking or compressing image: $e");
    }
  }

  Future<void> checkUsernameAvailability(String val) async {
    try {
      var tmp = await _userProvider.get(filter: {"Username": val});
      if (mounted) {
        setState(() {
          usernameTaken = tmp.count > 0;
        });
      }
    } catch (error) {
      print('Error checking username availability: $error');
    }
  }

  Future<void> checkEmailAvailability(String val) async {
    try {
      var tmp = await _userProvider.get(filter: {"Email": val});
      if (mounted) {
        setState(() {
          emailTaken = tmp.count > 0;
        });
      }
    } catch (error) {
      print('Error checking email availability: $error');
    }
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _initialValue = {
      'firstName': widget.user.firstName ?? "",
      'lastName': widget.user.lastName ?? "",
      'username': widget.user.username ?? "",
      'email': widget.user.email ?? "",
    };
    _base64Image = widget.user.profilePicture!.profilePicture!;
    _userProfilePictureProvider = context.read<UserProfilePictureProvider>();
    _userProvider = context.read<UserProvider>();

    _userProvider.addListener(() {
      _reloadUserData();
    });

    super.initState();
  }

  void _reloadUserData() async {
    var userResult = await _userProvider.get(filter: {
      "Username": "${Authorization.username}",
      "ProfilePictureIncluded": "true",
    });

    if (mounted) {
      setState(() {
        if (userResult.count == 1) {
          LoggedUser.user = userResult.result.single;
          widget.user = userResult.result.single;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    containerWidth = screenSize.width;
    containerHeight = screenSize.height;
    textFieldWidth = containerWidth! * 0.9;
    imageWidth = containerWidth! * 0.9;

    return Center(
      child: SizedBox(
        width: containerWidth,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormBuilder(
                  key: _formKey,
                  initialValue: _initialValue,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Palette.lightPurple.withOpacity(0.5),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(17)),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.memory(
                                imageFromBase64String(_base64Image!),
                                //width: imageWidth,
                                height: 200,
                                fit: BoxFit.cover,
                              )),
                        ),
                      ),
                      SizedBox(
                        width: screenSize.width * 0.9,
                        child: Wrap(
                          alignment: screenSize.width >= 256
                              ? WrapAlignment.spaceBetween
                              : WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Tooltip(
                              message: "Date joined",
                              verticalOffset: 15,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.calendar_today, size: 15),

                                  const SizedBox(width: 5),
                                  Text(
                                      DateFormat('MMM d, y')
                                          .format(widget.user.dateJoined!),
                                      style: const TextStyle(fontSize: 15)),
                                ],
                              ),
                            ),
                            FormBuilderField(
                              name: "profilePicture",
                              builder: (field) {
                                return GradientButton(
                                    onPressed: () {
                                      getImage();
                                    },
                                    width: 135,
                                    height: 30,
                                    borderRadius: 50,
                                    paddingTop: 10,
                                    paddingBottom: 10,
                                    hideBorder: true,
                                    gradient: const LinearGradient(colors: [
                                      Palette.buttonRed,
                                      Palette.buttonRed,
                                    ]),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.photo, color: Palette.white),
                                        SizedBox(width: 5),
                                        Text("Change photo",
                                            style: TextStyle(
                                                color: Palette.white)),
                                      ],
                                    ));
                              },
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      MyFormBuilderTextField(
                        focusNode: _focusNode1,
                        name: "username",
                        labelText: "Username",
                        fillColor: Palette.textFieldPurple.withOpacity(0.5),
                        width: textFieldWidth,
                        paddingBottom: 25,
                        borderRadius: 50,
                        onChanged: (val) async {
                          if (val != null) {
                            await checkUsernameAvailability(val);
                          }
                        },
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "This field cannot be empty.";
                          } else if (val.length > 50) {
                            return 'Character limit exceeded: ${val.length}/50';
                          } else if (isValidUsername(val) == false) {
                            return 'Use only letters, numbers, _ and -';
                          } else if (usernameTaken == true) {
                            return 'This username is taken.';
                          }
                          return null;
                        },
                      ),
                      MyFormBuilderTextField(
                        focusNode: _focusNode2,
                        name: "firstName",
                        labelText: "First name",
                        fillColor: Palette.textFieldPurple.withOpacity(0.5),
                        width: textFieldWidth,
                        paddingBottom: 25,
                        borderRadius: 50,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "This field cannot be empty.";
                          } else if (val.length > 50) {
                            return 'Character limit exceeded: ${val.length}/50';
                          } else if (isValidName(val) == false) {
                            return 'Use only letters.';
                          }
                          return null;
                        },
                      ),
                      MyFormBuilderTextField(
                        focusNode: _focusNode3,
                        name: "lastName",
                        labelText: "Last name",
                        fillColor: Palette.textFieldPurple.withOpacity(0.5),
                        width: textFieldWidth,
                        paddingBottom: 25,
                        borderRadius: 50,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "This field cannot be empty.";
                          } else if (val.length > 50) {
                            return 'Character limit exceeded: ${val.length}/50';
                          } else if (isValidName(val) == false) {
                            return 'Use only letters.';
                          }
                          return null;
                        },
                      ),
                      MyFormBuilderTextField(
                        focusNode: _focusNode4,
                        name: "email",
                        labelText: "E-mail",
                        fillColor: Palette.textFieldPurple.withOpacity(0.5),
                        width: textFieldWidth,
                        borderRadius: 50,
                        onChanged: (val) async {
                          if (val != null && val != "" && val.isNotEmpty) {
                            await checkEmailAvailability(val);
                          }
                        },
                        validator: (val) {
                          if (val != null && val.length > 100) {
                            return 'Character limit exceeded: ${val.length}/100';
                          } else if (val != null &&
                              val.isNotEmpty &&
                              isValidEmail(val) == false) {
                            return 'Invalid email.';
                          } else if (emailTaken == true) {
                            return 'This email is taken.';
                          }
                          return null;
                        },
                      ),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (builder) => const ChangePasswordForm());
                      },
                      child: const Text("Change password",
                          style: TextStyle(color: Palette.lightPurple)),
                    ),
                    GradientButton(
                        onPressed: () {
                          _saveProfileData();
                        },
                        width: 90,
                        height: 30,
                        borderRadius: 50,
                        paddingTop: 20,
                        gradient: Palette.buttonGradient,
                        child: const Text("Save",
                            style: TextStyle(
                                color: Palette.white,
                                fontWeight: FontWeight.w500))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfileData() async {
    if (_formKey.currentState?.saveAndValidate() == true) {
      var request = Map.from(_formKey.currentState!.value);

      UserProfilePicture pic;

      Map<dynamic, dynamic> userData = {
        "firstName": request["firstName"],
        "lastName": request["lastName"],
        "username": request["username"],
        "email": request["email"],
        "profilePictureId": widget.user.profilePictureId,
      };

      Map<dynamic, dynamic> profilePic = {"profilePicture": _base64Image};

      try {
        if (_base64Image != widget.user.profilePicture!.profilePicture) {
          if (widget.user.profilePictureId == 1) {
            pic = await _userProfilePictureProvider.insert(profilePic);
            userData["profilePictureId"] = pic.id;
          } else {
            await _userProfilePictureProvider
                .update(widget.user.profilePictureId!, request: profilePic);
            userData["profilePictureId"] = widget.user.profilePictureId!;
          }
        }

        await _userProvider
            .update(widget.user.id!, request: userData)
            .then((_) {
          LoggedUser.user!.username = request["username"];
          LoggedUser.user!.firstName = request["firstName"];
          LoggedUser.user!.lastName = request["lastName"];
          LoggedUser.user!.email = request["email"];
          LoggedUser.user!.profilePicture?.profilePicture = _base64Image;
          Authorization.username = request["username"];

          if (mounted) {
            showInfoDialog(
                context,
                const Icon(Icons.task_alt,
                    color: Palette.lightPurple, size: 50),
                const Text(
                  "Updated successfully!",
                  textAlign: TextAlign.center,
                ));
          }
        }).catchError((error) {
          if (mounted) {
            showInfoDialog(
                context,
                const Icon(Icons.warning_rounded,
                    color: Palette.lightRed, size: 55),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                ));
          }
        });
      } on Exception catch (e) {
        if (mounted) {
          showErrorDialog(context, e);
        }
      }
    }
  }
}
