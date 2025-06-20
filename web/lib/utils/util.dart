import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/user.dart';

import '../widgets/gradient_button.dart';
import 'colors.dart';

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1);

class Authorization {
  static String? username;
  static String? password;
}

class LoggedUser {
  static User? user;
}

Future<void> showErrorDialog(BuildContext context, Exception e) async {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Palette.lightPurple.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(15)),
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: Palette.darkPurple,
          title: const Icon(Icons.warning_rounded,
              color: Palette.lightRed, size: 55),
          content: Text(e.toString(), textAlign: TextAlign.center),
          actions: [
            Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 5),
                child: GradientButton(
                    onPressed: () => Navigator.pop(context),
                    width: 85,
                    height: 28,
                    borderRadius: 15,
                    gradient: Palette.buttonGradient,
                    child: const Text("OK",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Palette.white)))),
          ]));
}

Future<void> showInfoDialog(
    BuildContext context, Widget? title, Widget? content,
    {void Function()? onPressed, barrierDismissible = true}) async {
  showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Palette.lightPurple.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(15)),
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: Palette.darkPurple,
          title: title,
          content: content,
          actions: [
            Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 5),
                child: GradientButton(
                    onPressed: onPressed ?? () => Navigator.pop(context),
                    width: 85,
                    height: 28,
                    borderRadius: 15,
                    gradient: Palette.buttonGradient,
                    child: const Text("OK",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Palette.white)))),
          ]));
}

Future<void> showConfirmationDialog(BuildContext context, Widget? dialogTitle,
    Widget? content, VoidCallback onPressedYes) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // Dialog cannot be dismissed by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Palette.lightPurple.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(15)),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        backgroundColor: Colors.black,
        title: dialogTitle,
        content: content,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 10, top: 10),
            child: GradientButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              width: 85,
              height: 28,
              borderRadius: 15,
              gradient: Palette.buttonGradient2,
              child: const Text(
                "Cancel",
                style: TextStyle(color: Palette.white),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 10, top: 10),
              child: GradientButton(
                  onPressed: () {
                    onPressedYes();
                    Navigator.of(context).pop();
                  },
                  width: 85,
                  height: 28,
                  borderRadius: 15,
                  gradient: Palette.buttonGradient,
                  child: const Text("Delete",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Palette.white)))),
        ],
      );
    },
  );
}

Uint8List imageFromBase64String(String base64Image) {
  return base64Decode(base64Image);
}

bool containsNumbers(String text) {
  return RegExp(r'[0-9]').hasMatch(text);
}

bool containsUppercase(String text) {
  return RegExp(r'[A-Z]').hasMatch(text);
}

bool containsLowercase(String text) {
  return RegExp(r'[a-z]').hasMatch(text);
}

bool isValidUsername(String text) {
  return RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(text);
}

bool isValidName(String text) {
  return RegExp(r'^[a-zA-ZšđčćžŠĐČĆŽ]+$').hasMatch(text);
}

bool isValidEmail(String text) {
  return RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  ).hasMatch(text);
}

bool isValidImageUrl(String url) {
  return RegExp(
    r'^https?:\/\/.*\.(png|jpg|jpeg|gif|bmp|webp)$',
  ).hasMatch(url);
}

bool isValidYouTubeUrl(String url) {
  RegExp youtubeRegex =
  RegExp(r'^(https?:\/\/)?(www\.)?(youtube\.com|youtu\.be)\/.+$');

  return youtubeRegex.hasMatch(url);
}

bool isOnlyDigits(String text) {
  return RegExp(r'^\d+$').hasMatch(text);
}