import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import '../models/user_role.dart';
import 'package:provider/provider.dart';

import '../providers/user_comment_action_provider.dart';
import '../providers/user_post_action_provider.dart';
import '../screens/home_screen.dart';
import '../screens/registration_screen.dart';
import '../providers/bioskopina_provider.dart';
import '../providers/user_provider.dart';
import '../utils/colors.dart';
import '../utils/util.dart';
import '../widgets/gradient_button.dart';
import '../widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late MovieProvider _movieProvider;
  late UserProvider _userProvider;
  late UserPostActionProvider _userPostActionProvider;
  late UserCommentActionProvider _userCommentActionProvider;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    double? containerWidth =
        screenSize.width * 0.95; // Using 95% of the screen width
    double? containerHeight =
        screenSize.height * 0.67; //  Using 70% of the screen height
    double? textFieldWidth = containerWidth * 0.9; // Using % of containerWidth

    _movieProvider = context.read<MovieProvider>();
    _userProvider = context.read<UserProvider>();
    _userPostActionProvider = context.read<UserPostActionProvider>();
    _userCommentActionProvider = context.read<UserCommentActionProvider>();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.9,
              child: Image.asset(
                'assets/images/bg.png',
                fit: BoxFit.cover,
              ),
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
                    const SizedBox(height: 40),
                    Image.asset("assets/images/logo.png", width: 220),
                    const SizedBox(height: 40),
                    MyTextField(
                        hintText: "Username",
                        fillColor: Palette.textFieldPurple.withOpacity(0.5),
                        obscureText: false,
                        width: textFieldWidth,
                        textCapitalization: TextCapitalization.sentences,
                        //height: 48,
                        borderRadius: 50,
                        controller: _usernameController),
                    const SizedBox(height: 20),
                    MyTextField(
                      hintText: "Password",
                      fillColor: Palette.textFieldPurple.withOpacity(0.5),
                      obscureText: true,
                      width: textFieldWidth,
                      // height: 38,
                      borderRadius: 50,
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 20),
                    GradientButton(
                        onPressed: () async {
                          var username = _usernameController.text;
                          var password = _passwordController.text;
                          print("Login proceed: $username $password");

                          Authorization.username = username;
                          Authorization.password = password;

                          try {
                            await _movieProvider.get();
                            var userResult = await _userProvider.get(filter: {
                              "RolesIncluded": "true",
                              "Username": "${Authorization.username}",
                              "ProfilePictureIncluded": "true",
                            });
                            if (userResult.count == 1) {
                              LoggedUser.user = userResult.result.single;
                            }
                            List<UserRole> userRoles =
                                userResult.result.first.userRoles!;

                            if (userRoles
                                .any((userRole) => userRole.roleId == 2)) {
                              if (context.mounted) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const HomeScreen(selectedIndex: 0),
                                  ),
                                );
                              }

                              await _userPostActionProvider.syncUserActions();
                              await _userCommentActionProvider
                                  .syncUserActions();
                            } else {
                              if (context.mounted) {
                                showInfoDialog(
                                    context,
                                    const Icon(Icons.warning_rounded,
                                        color: Palette.lightRed, size: 55),
                                    const SizedBox(
                                      width: 300,
                                      child: Text(
                                        "User is registered but does not have privileges to login to mobile app.",
                                        textAlign: TextAlign.center,
                                      ),
                                    ));
                              }
                            }
                          } on Exception catch (e) {
                            if (context.mounted) {
                              showInfoDialog(
                                  context,
                                  const Icon(Icons.warning_rounded,
                                      color: Palette.lightRed, size: 55),
                                  SizedBox(
                                    width: 300,
                                    child:
                                        (e.toString().contains("Unauthorized"))
                                            ? Text(
                                                "Username or password is incorrect, or the user is not registered.\n\n ${e.toString()}",
                                                textAlign: TextAlign.center,
                                              )
                                            : Text(
                                                e.toString(),
                                                textAlign: TextAlign.center,
                                              ),
                                  ));
                            }
                          }
                        },
                        width: 90,
                        height: 32,
                        borderRadius: 50,
                        gradient: Palette.buttonGradient,
                        child: const Text("Log In",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Palette.white))),
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (builder) =>
                                  const RegistrationScreen()));
                        },
                        child: const Text("Not registered?",
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
