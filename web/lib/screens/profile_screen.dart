import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import '../widgets/change_password_form.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../models/user_profile_picture.dart';
import '../providers/user_profile_picture_provider.dart';
import '../widgets/gradient_button.dart';
import '../widgets/master_screen.dart';
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
  File? _image;
  String? _base64Image;
  bool usernameTaken = false;
  bool emailTaken = false;
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();

  Future getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      _image = File(result.files.single.path!);
      setState(() {
        _base64Image = base64Encode(_image!.readAsBytesSync());
      });
    }
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

    super.initState();
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();

    super.dispose();
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
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: const Text("My profile"),
      showBackArrow: true,
      showProfileIcon: false,
      child: Center(
        child: SingleChildScrollView(
          child: Container(
              width: 500,
              decoration: BoxDecoration(
                color: Palette.midnightPurple.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  FormBuilder(
                      key: _formKey,
                      initialValue: _initialValue,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.memory(
                                  imageFromBase64String(_base64Image!),
                                  width: 400,
                                  height: 250,
                                  fit: BoxFit.cover,
                                )),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Tooltip(
                                message: "Date joined",
                                verticalOffset: 15,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.calendar_today, size: 18),
                                    const SizedBox(width: 5),
                                    Text(
                                        DateFormat('MMM d, y')
                                            .format(widget.user.dateJoined!),
                                        style: const TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 145),
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
                                      gradient: Palette.buttonGradient2,
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.photo,
                                              color: Palette.lightPurple),
                                          SizedBox(width: 5),
                                          Text("Change photo",
                                              style: TextStyle(
                                                  color: Palette.lightPurple)),
                                        ],
                                      ));
                                },
                              )
                            ],
                          ),
                          const SizedBox(height: 30),
                          MyFormBuilderTextField(
                            name: "username",
                            labelText: "Username",
                            fillColor: Palette.textFieldPurple.withOpacity(0.3),
                            width: 400,
                            paddingBottom: 25,
                            borderRadius: 50,
                            focusNode: _focusNode1,
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
                            name: "firstName",
                            labelText: "First name",
                            fillColor: Palette.textFieldPurple.withOpacity(0.3),
                            width: 400,
                            paddingBottom: 25,
                            borderRadius: 50,
                            focusNode: _focusNode2,
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
                            name: "lastName",
                            labelText: "Last name",
                            fillColor: Palette.textFieldPurple.withOpacity(0.3),
                            width: 400,
                            paddingBottom: 25,
                            borderRadius: 50,
                            focusNode: _focusNode3,
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
                            name: "email",
                            labelText: "E-mail",
                            fillColor: Palette.textFieldPurple.withOpacity(0.3),
                            width: 400,
                            borderRadius: 50,
                            focusNode: _focusNode4,
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
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (builder) =>
                                    const ChangePasswordForm());
                          },
                          child: const Text("Change password",
                              style: TextStyle(color: Palette.lightPurple)),
                        ),
                        GradientButton(
                            onPressed: () {
                              _saveProfileData();
                            },
                            width: 100,
                            height: 30,
                            borderRadius: 50,
                            paddingTop: 30,
                            paddingBottom: 30,
                            gradient: Palette.buttonGradient,
                            child: const Text("Save",
                                style: TextStyle(
                                    color: Palette.white,
                                    fontWeight: FontWeight.w500))),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void _saveProfileData() async {
    _formKey.currentState?.saveAndValidate();
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
          widget.user.profilePictureId = pic.id;
          userData["profilePictureId"] = pic.id;
        } else {
          await _userProfilePictureProvider
              .update(widget.user.profilePictureId!, request: profilePic);
          userData["profilePictureId"] = widget.user.profilePictureId!;
        }
      }

      await _userProvider.update(widget.user.id!, request: userData).then((_) {
        LoggedUser.user!.username = request["username"];
        LoggedUser.user!.firstName = request["firstName"];
        LoggedUser.user!.lastName = request["lastName"];
        LoggedUser.user!.email = request["email"];
        LoggedUser.user!.profilePicture?.profilePicture = _base64Image;
        Authorization.username = request["username"];
        if (mounted) {
          showInfoDialog(
              context,
              const Icon(Icons.task_alt, color: Palette.lightPurple, size: 50),
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
