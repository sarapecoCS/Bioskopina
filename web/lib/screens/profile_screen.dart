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

class ProfileScreen extends StatefulWidget {
  final User user;
  ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late Map<String, dynamic> _initialValue;
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

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'firstName': widget.user.firstName ?? "",
      'lastName': widget.user.lastName ?? "",
      'username': widget.user.username ?? "",
      'email': widget.user.email ?? "",
    };
    _base64Image = widget.user.profilePicture?.profilePicture;
    _userProfilePictureProvider = context.read<UserProfilePictureProvider>();
    _userProvider = context.read<UserProvider>();
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    super.dispose();
  }

  Future getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      _image = File(result.files.single.path!);
      setState(() {
        _base64Image = base64Encode(_image!.readAsBytesSync());
      });
    }
  }

  Future<void> checkUsernameAvailability(String val) async {
    try {
      var tmp = await _userProvider.get(filter: {"Username": val});
      if (mounted) setState(() => usernameTaken = tmp.count > 0);
    } catch (e) {
      print('Error checking username availability: $e');
    }
  }

  Future<void> checkEmailAvailability(String val) async {
    try {
      var tmp = await _userProvider.get(filter: {"Email": val});
      if (mounted) setState(() => emailTaken = tmp.count > 0);
    } catch (e) {
      print('Error checking email availability: $e');
    }
  }

  void _saveProfileData() async {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) return;
    var request = Map.from(_formKey.currentState!.value);
    Map<dynamic, dynamic> userData = {
      "firstName": request["firstName"],
      "lastName": request["lastName"],
      "username": request["username"],
      "email": request["email"],
      "profilePictureId": widget.user.profilePictureId,
    };
    Map<dynamic, dynamic> profilePic = {"profilePicture": _base64Image};

    try {
      if (_base64Image != widget.user.profilePicture?.profilePicture) {
        if (widget.user.profilePictureId == 1) {
          var pic = await _userProfilePictureProvider.insert(profilePic);
          widget.user.profilePictureId = pic.id;
          userData["profilePictureId"] = pic.id;
        } else {
          await _userProfilePictureProvider
              .update(widget.user.profilePictureId!, request: profilePic);
          userData["profilePictureId"] = widget.user.profilePictureId!;
        }
      }

      await _userProvider.update(widget.user.id!, request: userData);
      LoggedUser.user!
        ..username = request["username"]
        ..firstName = request["firstName"]
        ..lastName = request["lastName"]
        ..email = request["email"]
        ..profilePicture?.profilePicture = _base64Image;
      Authorization.username = request["username"];
      if (mounted) {
        showInfoDialog(
          context,
          const Icon(Icons.task_alt, color: Palette.lightPurple, size: 50),
          const Text("Updated successfully!", textAlign: TextAlign.center),
        );
      }
    } catch (e) {

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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Palette.midnightPurple.withOpacity(0.85),
              borderRadius: BorderRadius.circular(15),
            ),
            child: FormBuilder(
              key: _formKey,
              initialValue: _initialValue,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: _base64Image == null
                        ? const SizedBox(
                            width: 400,
                            height: 200,
                            child: Center(child: Icon(Icons.person, size: 80)))
                        : Image.memory(
                            imageFromBase64String(_base64Image!),
                            width: 400,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Tooltip(
                        message: "Date joined",
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 18),
                            const SizedBox(width: 5),
                            Text(
                              DateFormat('MMM d, y').format(widget.user.dateJoined!),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                       const SizedBox(width: 60),
                      GradientButton(
                        onPressed: getImage,
                        width: 120,
                        height: 30,
                        borderRadius: 50,
                        paddingTop: 6,
                        paddingBottom: 6,
                        gradient: Palette.buttonGradient2,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo, color: Palette.lightPurple, size: 18),
                            SizedBox(width: 5),
                            Text("Change photo", style: TextStyle(color: Palette.lightPurple, fontSize: 14)),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  MyFormBuilderTextField(
                    name: "username",
                    labelText: "Username",
                    fillColor: Palette.textFieldPurple.withOpacity(0.3),
                    width: 400,
                    paddingBottom: 15,
                    borderRadius: 50,
                    focusNode: _focusNode1,
                    onChanged: (val) async {
                      if (val != null) await checkUsernameAvailability(val);
                    },
                    validator: (val) {
                      if (val == null || val.isEmpty) return "This field cannot be empty.";
                      if (val.length > 50) return 'Character limit exceeded: ${val.length}/50';
                      if (!isValidUsername(val)) return 'Use only letters, numbers, _ and -';
                      if (usernameTaken) return 'This username is taken.';
                      return null;
                    },
                  ),
                  MyFormBuilderTextField(
                    name: "firstName",
                    labelText: "First name",
                    fillColor: Palette.textFieldPurple.withOpacity(0.3),
                    width: 400,
                    paddingBottom: 15,
                    borderRadius: 50,
                    focusNode: _focusNode2,
                    validator: (val) {
                      if (val == null || val.isEmpty) return "This field cannot be empty.";
                      if (val.length > 50) return 'Character limit exceeded: ${val.length}/50';
                      if (!isValidName(val)) return 'Use only letters.';
                      return null;
                    },
                  ),
                  MyFormBuilderTextField(
                    name: "lastName",
                    labelText: "Last name",
                    fillColor: Palette.textFieldPurple.withOpacity(0.3),
                    width: 400,
                    paddingBottom: 15,
                    borderRadius: 50,
                    focusNode: _focusNode3,
                    validator: (val) {
                      if (val == null || val.isEmpty) return "This field cannot be empty.";
                      if (val.length > 50) return 'Character limit exceeded: ${val.length}/50';
                      if (!isValidName(val)) return 'Use only letters.';
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
                      if (val != null && val.isNotEmpty) await checkEmailAvailability(val);
                    },
                    validator: (val) {
                      if (val != null && val.length > 100) return 'Character limit exceeded: ${val.length}/100';
                      if (val != null && val.isNotEmpty && !isValidEmail(val)) return 'Invalid email.';
                      if (emailTaken) return 'This email is taken.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => showDialog(
                            context: context,
                            builder: (_) => const ChangePasswordForm(),
                          ),
                          child: const Text("Change password", style: TextStyle(color: Palette.lightPurple, fontSize: 14)),
                        ),
                        GradientButton(
                          onPressed: _saveProfileData,
                          width: 100,
                          height: 30,
                          borderRadius: 50,
                          paddingTop: 6,
                          paddingBottom: 6,
                          gradient: Palette.buttonGradient,
                          child: const Text("Save", style: TextStyle(color: Palette.white)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
