import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../utils/colors.dart';

// ignore: must_be_immutable
class MyFormBuilderTextField extends StatefulWidget {
  String name;
  String? labelText;
  Color? fillColor;
  bool? obscureText;
  double? width;
  double? height;
  bool? readOnly;
  double? borderRadius;
  double? borderWidth;
  Color? borderColor;
  TextInputType? keyboardType;
  String? initialValue;
  int? maxLines;
  int? minLines;
  final bool? enabled;
  final TextStyle? style;
  final TextStyle? disabledStyle;

  double? paddingLeft;
  double? paddingRight;
  double? paddingTop;
  double? paddingBottom;
  void Function(String?)? onChanged;
  String? Function(String?)? validator;
  void Function(String?)? onSubmitted;
  void Function(String?)? onSaved;
  FocusNode? focusNode;
  EdgeInsetsGeometry? contentPadding;
  Widget? suffixIcon;

  MyFormBuilderTextField({
    super.key,
    required this.name,
    this.labelText,
    this.fillColor,
    this.obscureText,
    this.width,
    this.height,
    this.borderRadius,
    this.readOnly,
    this.keyboardType,
    this.initialValue,
    this.maxLines = 1,
    this.minLines = 1,
    this.paddingLeft = 0,
    this.paddingRight = 0,
    this.paddingTop = 0,
    this.paddingBottom = 0,
    this.onChanged,
    this.validator,
    this.borderWidth = 0,
    this.borderColor = Colors.transparent,
    this.onSubmitted,
    this.onSaved,
    this.focusNode,
    this.contentPadding,
    this.suffixIcon,
    this.enabled,
    this.style,
    this.disabledStyle,
  });

  @override
  State<MyFormBuilderTextField> createState() => _MyFormBuilderTextFieldState();
}

class _MyFormBuilderTextFieldState extends State<MyFormBuilderTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText ?? false;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
@override
Widget build(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(
      left: widget.paddingLeft!,
      right: widget.paddingRight!,
      top: widget.paddingTop!,
      bottom: widget.paddingBottom!,
    ),
    child: SizedBox(
      width: widget.width,
      height: widget.height,
      child: FormBuilderTextField(
        textAlignVertical: TextAlignVertical.top,
        focusNode: widget.focusNode,
        initialValue: widget.initialValue,
        minLines: widget.minLines,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.validator,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        onSaved: widget.onSaved,
        maxLines: _maxLines(),
        keyboardType: widget.keyboardType ?? TextInputType.text,
        readOnly: widget.readOnly ?? false,
        name: widget.name,
        enabled: widget.enabled ?? true,
        style: (widget.enabled == false)
            ? (widget.disabledStyle ?? TextStyle(color: Colors.grey.shade600))
            : (widget.style ?? const TextStyle(color: Palette.lightPurple)),
        obscuringCharacter: '•',
        obscureText: _obscureText,
        decoration: InputDecoration(
          contentPadding: widget.contentPadding ??
              const EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          filled: true,
          fillColor: _fillColor(),
          labelText: widget.labelText ?? "",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: (widget.enabled == false)
              ? (widget.disabledStyle ?? TextStyle(color: Colors.grey.shade600))
              : const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Palette.lightPurple,
                ),
          errorStyle: TextStyle(color: Colors.red[300], height: 0.5), // Updated line
          suffixIcon: widget.suffixIcon ??
              (widget.obscureText == true
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Palette.lightPurple,
                      ),
                      onPressed: _toggleVisibility,
                    )
                  : null),
        ),
      ),
    ),
  );
}

  int? _maxLines() {
    if (widget.maxLines == null) {
      return null;
    }
    return widget.maxLines;
  }

  Color? _fillColor() {
    if (widget.readOnly == true) {
      return Palette.disabledControl;
    }
    return widget.fillColor;
  }
}
