import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final Color fillColor;
  final bool obscureText;
  final double width;
  final double borderRadius;
  final TextEditingController controller;
  final Widget? suffixIcon; // Add this line to accept the suffixIcon parameter

  const MyTextField({
    Key? key,
    required this.hintText,
    required this.fillColor,
    required this.obscureText,
    required this.width,
    required this.borderRadius,
    required this.controller,
    this.suffixIcon, // Include this in the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: fillColor,
          border: InputBorder.none,
          suffixIcon: suffixIcon, // Use the suffixIcon here
        ),
      ),
    );
  }
}
