import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:glass/glass.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../providers/user_role_provider.dart';
import '../screens/login_screen.dart';
import '../models/user.dart';
import '../utils/colors.dart';
import '../utils/util.dart';
import '../widgets/form_builder_text_field.dart';
import '../widgets/gradient_button.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late UserProvider _userProvider;
  bool usernameTaken = false;
  bool emailTaken = false;
  late UserRoleProvider _userRoleProvider;

  late Size screenSize;
  double? containerWidth;
  double? containerHeight;

  double? textFieldWidth;

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();

  @override
  void initState() {
    _userProvider = context.read<UserProvider>();
    _userRoleProvider = context.read<UserRoleProvider>();

    super.initState();
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
    _focusNode5.dispose();
    _focusNode6.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    containerWidth = screenSize.width * 0.95;
    containerHeight = screenSize.height * 0.9;
    textFieldWidth = containerWidth! * 0.9;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.9,
              child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
            ),
          ),
          Center(
            child: Container(
              width: containerWidth,
              height: containerHeight,
              decoration: BoxDecoration(
                  color: Palette.darkPurple.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(15)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      width: 170,
                    ),
                    const SizedBox(height: 20),
                    FormBuilder(
                        key: _formKey,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            MyFormBuilderTextField(
                              name: "username",
                              labelText: "Username",
                              fillColor:
                                  Palette.textFieldPurple.withOpacity(0.5),
                              width: textFieldWidth,
                              paddingBottom: 25,
                              keyboardType: TextInputType.text,
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
                              name: "email",
                              labelText: "E-mail",
                              fillColor:
                                  Palette.textFieldPurple.withOpacity(0.5),
                              width: textFieldWidth,
                              paddingBottom: 25,
                              keyboardType: TextInputType.emailAddress,
                              textCapitalization: TextCapitalization.none,
                              borderRadius: 50,
                              focusNode: _focusNode2,
                              onChanged: (val) async {
                                if (val != null &&
                                    val != "" &&
                                    val.isNotEmpty) {
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
                            MyFormBuilderTextField(
                              name: "firstName",
                              labelText: "First name",
                              fillColor:
                                  Palette.textFieldPurple.withOpacity(0.5),
                              width: textFieldWidth,
                              paddingBottom: 25,
                              keyboardType: TextInputType.text,
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
                              name: "lastName",
                              labelText: "Last name",
                              fillColor:
                                  Palette.textFieldPurple.withOpacity(0.5),
                              width: textFieldWidth,
                              paddingBottom: 25,
                              keyboardType: TextInputType.text,
                              borderRadius: 50,
                              focusNode: _focusNode4,
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
                              name: "password",
                              labelText: "Password",
                              fillColor:
                                  Palette.textFieldPurple.withOpacity(0.5),
                              width: textFieldWidth,
                              paddingBottom: 25,
                              borderRadius: 50,
                              obscureText: true,
                              focusNode: _focusNode5,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "This field cannot be empty.";
                                } else if (val.length < 8) {
                                  return 'Password is too short.';
                                } else if (containsNumbers(val) == false) {
                                  return 'Password must contain at least one number';
                                } else if (containsUppercase(val) == false) {
                                  return 'Password must contain at least one uppercase letter.';
                                } else if (containsLowercase(val) == false) {
                                  return 'Password must contain at least one lowercase letter.';
                                }
                                return null;
                              },
                            ),
                            MyFormBuilderTextField(
                              name: "passwordConfirmation",
                              labelText: "Repeat password",
                              fillColor:
                                  Palette.textFieldPurple.withOpacity(0.5),
                              width: textFieldWidth,
                              paddingBottom: 25,
                              borderRadius: 50,
                              obscureText: true,
                              focusNode: _focusNode6,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "This field cannot be empty.";
                                } else if (_formKey.currentState
                                        ?.fields['password']?.value !=
                                    val) {
                                  return "Passwords do not match.";
                                }
                                return null;
                              },
                            ),
                          ],
                        )),
                    GradientButton(
                        onPressed: () async {
                          if (_formKey.currentState?.saveAndValidate() ==
                              true) {
                            _formKey.currentState?.saveAndValidate();
                            var userInsertRequest =
                                Map.from(_formKey.currentState!.value);

                            userInsertRequest["dateJoined"] =
                                DateTime.now().toIso8601String();

                            userInsertRequest["profilePictureId"] = 1;
                            User? user;

                            await _userProvider
                                .insert(userInsertRequest)
                                .then((response) async {
                              user = response;

                              if (user != null) {
                                Map<dynamic, dynamic> userRole = {
                                  "userId": "${user!.id}",
                                  "roleId": 2,
                                  "canReview": true,
                                  "canAskQuestions": true,
                                  "canParticipateInClubs": true
                                };
                                await _userRoleProvider.insert(userRole);
                              }

                              if (context.mounted) {
                                showInfoDialog(
                                    context,
                                    const Icon(Icons.task_alt,
                                        color: Palette.lightPurple, size: 50),
                                    const Text(
                                      "Successfully registered.",
                                      textAlign: TextAlign.center,
                                    ), onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()));
                                }, barrierDismissible: false);
                              }
                            }).catchError((error) {
                              if (context.mounted) {
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
                          } else {
                            showInfoDialog(
                                context,
                                const Icon(Icons.warning_rounded,
                                    color: Palette.lightRed, size: 55),
                                const Text(
                                  "There are validation errors.",
                                  textAlign: TextAlign.center,
                                ));
                          }
                        },
                        width: 90,
                        height: 32,
                        borderRadius: 50,
                        gradient: Palette.buttonGradient,
                        child: const Text("Register",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Palette.white))),
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Back",
                            style: TextStyle(
                                color: Palette.lightPurple,
                                fontWeight: FontWeight.normal)),
                      ),
                    ),
                  ],
                ),
              ),
            ).asGlass(
              clipBorderRadius: BorderRadius.circular(15),
              tintColor: Palette.darkPurple,
            ),
          ),
        ],
      ),
    );
  }
}
