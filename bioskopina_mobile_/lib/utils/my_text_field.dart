import 'package:flutter/material.dart';
import '../utils/colors.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Color? fillColor;
  final double width;
  final double borderRadius;
  final bool obscureText;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;

  const MyTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.fillColor,
    required this.width,
    this.borderRadius = 8,
    this.obscureText = false,
    this.focusNode,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
  }) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleObscure() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        obscureText: _obscureText,
        keyboardType: widget.keyboardType,
        textCapitalization: widget.textCapitalization,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.fillColor ?? Colors.grey.withOpacity(0.1),
          hintText: widget.hintText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide.none,
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Palette.lightPurple),
                  onPressed: _toggleObscure,
                )
              : null,
        ),
      ),
    );
  }
}
