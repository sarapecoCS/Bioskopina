import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../utils/colors.dart';
import '../utils/util.dart';
import '../widgets/form_builder_text_field.dart';
import '../widgets/gradient_button.dart';
import '../widgets/separator.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  late final UserProvider _userProvider;

  @override
  void initState() {
    _userProvider = context.read<UserProvider>();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(17),
      alignment: Alignment.center,
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Palette.darkPurple,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Palette.lightPurple.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: _buildChild(context),
      ),
    );
  }

  Widget _buildChild(BuildContext context) {
    return FormBuilder(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 25, bottom: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyFormBuilderTextField(
                name: "oldPassword",
                labelText: "Old password",
                fillColor: Palette.textFieldPurple.withOpacity(0.5),
                width: 400,
                paddingBottom: 25,
                borderRadius: 50,
                obscureText: true,
                focusNode: _focusNode1,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "This field cannot be empty.";
                  }
                  return null;
                },
              ),
              MySeparator(
                width: 450,
                borderRadius: 50,
                opacity: 0.7,
                paddingBottom: 25,
              ),
              MyFormBuilderTextField(
                name: "newPassword",
                labelText: "New password",
                fillColor: Palette.textFieldPurple.withOpacity(0.5),
                width: 400,
                paddingBottom: 25,
                borderRadius: 50,
                obscureText: true,
                focusNode: _focusNode2,
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
                labelText: "Repeat new password",
                fillColor: Palette.textFieldPurple.withOpacity(0.5),
                width: 400,
                paddingBottom: 25,
                borderRadius: 50,
                obscureText: true,
                focusNode: _focusNode3,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "This field cannot be empty.";
                  } else if (_formKey
                          .currentState?.fields['newPassword']?.value !=
                      val) {
                    return "Passwords do not match.";
                  }
                  return null;
                },
              ),
              GradientButton(
                onPressed: () async {
                  if (_formKey.currentState?.saveAndValidate() == true) {
                    try {
                      var changePassRequest = {
                        "userId": "${LoggedUser.user!.id!}",
                        "oldPassword":
                            _formKey.currentState?.fields["oldPassword"]?.value,
                        "newPassword":
                            _formKey.currentState?.fields["newPassword"]?.value,
                        "passwordConfirmation": _formKey.currentState
                            ?.fields["passwordConfirmation"]?.value,
                      };
                      await _userProvider.changePassword(
                          LoggedUser.user!.id!, changePassRequest);
                      Authorization.password =
                          _formKey.currentState?.fields["newPassword"]?.value;

                      if (context.mounted) {
                        Navigator.of(context).pop();
                        showInfoDialog(
                            context,
                            const Icon(Icons.task_alt,
                                color: Palette.lightPurple, size: 50),
                            const Text(
                              "Password changed successfully!",
                              textAlign: TextAlign.center,
                            ));
                      }
                    } on Exception catch (e) {
                      if (context.mounted) {
                        showInfoDialog(
                            context,
                            const Icon(Icons.warning_rounded,
                                color: Palette.lightRed, size: 50),
                            Text(
                              "Invalid old password. \n\n $e",
                              textAlign: TextAlign.center,
                            ));

                        // showErrorDialog(context, e);
                      }
                    }
                  } else {
                    showInfoDialog(
                        context,
                        const Icon(Icons.warning_rounded,
                            color: Palette.lightRed, size: 50),
                        const Text(
                          "There are validation errors.",
                          textAlign: TextAlign.center,
                        ));
                  }
                },
                gradient: Palette.buttonGradient,
                borderRadius: 50,
                width: 150,
                height: 30,
                paddingTop: 10,
                child: const Text("Change Password",
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Palette.white)),
              ),
            ],
          ),
        ));
  }
}
