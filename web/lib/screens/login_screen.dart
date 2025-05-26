import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/registration_screen.dart';
import '../models/user_role.dart';
import '../providers/bioskopina_provider.dart';
import '../providers/user_provider.dart';
import '../utils/colors.dart';
import '../utils/util.dart';
import '../utils/my_text_field.dart';
import '../widgets/gradient_button.dart';
import 'bioskopina_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late MovieProvider _movieProvider;
  late UserProvider _userProvider;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    _movieProvider = context.read<MovieProvider>();
    _userProvider = context.read<UserProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.9,
              child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: 518,
                constraints: const BoxConstraints(maxWidth: 518),
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Palette.darkPurple.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 40),
                    Image.asset("assets/images/logo.png", width: 220),
                    const SizedBox(height: 40),
                    MyTextField(
                      hintText: "Username",
                      fillColor: Palette.textFieldPurple.withOpacity(0.5),
                      obscureText: false,
                      width: 417,
                      borderRadius: 50,
                      controller: _usernameController,
                    ),
                    const SizedBox(height: 20),
                    MyTextField(
                      hintText: "Password",
                      fillColor: Palette.textFieldPurple.withOpacity(0.5),
                      obscureText: _obscureText,
                      width: 417,
                      borderRadius: 50,
                      controller: _passwordController,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                          color: Palette.textFieldPurple,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                    GradientButton(
                      onPressed: () async {
                        var username = _usernameController.text;
                        var password = _passwordController.text;
                        print("Login proceed: $username $password");

                        Authorization.username = username;
                        Authorization.password = password;

                        try {
                          print("Fetching movie data...");
                          await _movieProvider.get();
                          print("Movie data fetched successfully.");

                          print("Fetching user data...");
                          var admin = await _userProvider.get(filter: {
                            "RolesIncluded": "true",
                            "ProfilePictureIncluded": "true",
                            "Username": username
                          });
                          print("User data fetched: ${admin.result}");

                          if (admin.count == 1) {
                            LoggedUser.user = admin.result.single;
                            print("Logged user: ${LoggedUser.user}");
                          }

                          List<UserRole> userRoles = admin.result.first.userRoles!;
                          print("User roles: $userRoles");

                          if (userRoles.any((userRole) => userRole.roleId == 1)) {
                            print("User has admin role, navigating to BioskopinaScreen");
                            if (context.mounted) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const BioskopinaScreen(),
                                ),
                              );
                            }
                          } else {
                            print("User doesn't have admin role, showing warning dialog");
                            if (context.mounted) {
                              showInfoDialog(
                                context,
                                const Icon(Icons.warning_rounded,
                                    color: Palette.lightRed, size: 55),
                                const SizedBox(
                                  width: 300,
                                  child: Text(
                                    "User is registered but does not have administrator privileges.",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                          }
                        } on Exception catch (e) {
                          print("Error during login: ${e.toString()}");

                          if (context.mounted) {
                            showInfoDialog(
                              context,
                              const Icon(Icons.warning_rounded,
                                  color: Palette.lightRed, size: 55),
                              SizedBox(
                                width: 300,
                                child: (e.toString().contains("Unauthorized"))
                                    ? Text(
                                  "Username or password is incorrect, or the user is not registered.\n\n ${e.toString()}",
                                  textAlign: TextAlign.center,
                                )
                                    : Text(
                                  e.toString(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                        }
                      },
                      width: 110,
                      height: 32,
                      borderRadius: 50,
                      gradient: Palette.buttonGradient,
                      child: const Text(
                        "Log In",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Palette.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (builder) => const RegistrationScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Not registered?",
                          style: TextStyle(
                              color: Palette.lightPurple,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
