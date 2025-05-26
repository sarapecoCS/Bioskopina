import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

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
                    width: 65,
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
        backgroundColor: Palette.darkPurple,
        title: dialogTitle,
        content: content,
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 5, top: 5),
              child: GradientButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  width: 85,
                  height: 28,
                  borderRadius: 15,
                  gradient: Palette.buttonGradient2,
                  child: const Text("No",
                      style: TextStyle(color: Palette.white)))),
          Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 5, top: 5),
              child: GradientButton(
                  onPressed: () {
                    onPressedYes();
                    Navigator.of(context).pop();
                  },
                  width: 85,
                  height: 28,
                  borderRadius: 15,
                  gradient: Palette.buttonGradient,
                  child: const Text("Yes",
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

String extractVideoId(String videoLink) {
  if (videoLink.contains('youtu.be/')) {
    List<String> parts = videoLink.split('youtu.be/');
    if (parts.length >= 2) {
      return parts[1];
    }
  }
  return '';
}

bool isValidReviewText(String text) {
  return RegExp(r"^[a-zA-Z0-9\s.,!?;:'()-]*$").hasMatch(text);
}

bool isEmptyOrWhiteSpace(String text) {
  return RegExp(r"^\s*$").hasMatch(text);
}

bool isImageSizeValid(String? base64String, int maxSizeInBytes) {
  if (base64String == null) {
    return true;
  }
  final decodedBytes = base64Decode(base64String);

  final imageSizeInBytes = decodedBytes.length;

  return imageSizeInBytes <= maxSizeInBytes;
}

Future<Uint8List> compressImage(File imageFile) async {
  img.Image? image = img.decodeImage(imageFile.readAsBytesSync());

  if (image == null) {
    throw Exception('Unable to decode image');
  }

  // Resize the image only if its width is greater than 800 pixels
  if (image.width > 800) {
    image = img.copyResize(image, width: 800, maintainAspect: true);
  }

  // Encode the image as JPEG with quality 85
  List<int> jpeg = img.encodeJpg(image, quality: 85);

  // Check if the compressed image is larger than the original
  if (jpeg.length > imageFile.lengthSync()) {
    // If it is, reduce the quality to make it smaller
    jpeg = img.encodeJpg(image, quality: 50);
  }

  return Uint8List.fromList(jpeg);
}

bool digitsOnly(String text) {
  return RegExp(r'^[0-9]+$').hasMatch(text);
}