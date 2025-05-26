import 'package:flutter/material.dart';

import '../utils/colors.dart';

// ignore: must_be_immutable
class MyTextField extends StatefulWidget {
  String? hintText;
  Color? fillColor;
  bool? obscureText;
  double? width;
  double? height;
  double? borderRadius;
  TextEditingController? controller;
  TextInputType keyboardType;
  TextCapitalization textCapitalization;

  MyTextField({
    super.key,
    this.hintText,
    this.fillColor,
    this.obscureText,
    this.width,
    this.height,
    this.borderRadius,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: TextField(
        controller: widget.controller,
        style: const TextStyle(color: Palette.lightPurple, fontSize: 13),
        textCapitalization: widget.textCapitalization,
        obscuringCharacter: '✮',
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText ?? false,
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
            hintText: widget.hintText ?? "",
            hintStyle: const TextStyle(
                height: 0,
                fontWeight: FontWeight.w400,
                color: Palette.lightPurple),
            fillColor: widget.fillColor,
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Palette.lightPurple.withOpacity(0.0)),
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 0)),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Palette.lightPurple.withOpacity(0.8)),
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 0)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 0))),
      ),
    );
  }
}
