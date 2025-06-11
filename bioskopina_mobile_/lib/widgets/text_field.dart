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
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: TextField(
        controller: widget.controller,
        style: const TextStyle(color: Palette.lightPurple, fontSize: 13),
        textCapitalization: widget.textCapitalization,
        // Use dot '•' instead of star '✮' for obscuring character
        obscuringCharacter: '•',
        keyboardType: widget.keyboardType,
        obscureText: _obscureText,
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
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 0)),
          // Show eye icon only if obscureText is true (password field)
          suffixIcon: widget.obscureText == true
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Palette.lightPurple.withOpacity(0.8),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}

