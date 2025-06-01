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
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  late MovieProvider _movieProvider;
  late UserProvider _userProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _movieProvider = Provider.of<MovieProvider>(context);
    _userProvider = Provider.of<UserProvider>(context);
  }

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    Authorization.username = username;
    Authorization.password = password;

    try {
      await _movieProvider.get();

      var admin = await _userProvider.get(filter: {
        "RolesIncluded": "true",
        "ProfilePictureIncluded": "true",
        "Username": username,
      });

      if (admin.count == 1) {
        LoggedUser.user = admin.result.single;
      }

      List<UserRole> userRoles = admin.result.first.userRoles ?? [];

      if (userRoles.any((userRole) => userRole.roleId == 1)) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const BioskopinaScreen(),
          ),
        );
      } else {
        if (!mounted) return;
        showInfoDialog(
          context,
          const Icon(Icons.warning_rounded, color: Palette.lightRed, size: 55),
          const SizedBox(
            width: 300,
            child: Text(
              "User is registered but does not have administrator privileges.",
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      showInfoDialog(
        context,
        const Icon(Icons.warning_rounded, color: Palette.lightRed, size: 55),
        SizedBox(
          width: 300,
          child: Text(
            e.toString().contains("Unauthorized")
                ? "Username or password is incorrect, or the user is not registered.\n\n${e.toString()}"
                : e.toString(),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Palette.darkPurple.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 30),
                    Image.asset("assets/images/try.png", width: 220),

                    const SizedBox(height: 10),
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
                      onPressed: _login,
                      width: 110,
                      height: 32,
                      borderRadius: 50,
                      gradient: Palette.buttonGradient,
                      child: const Text(
                        "Log In",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Palette.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RegistrationScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Not registered?",
                          style: TextStyle(
                            color: Palette.lightPurple,
                            fontWeight: FontWeight.normal,
                          ),
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
