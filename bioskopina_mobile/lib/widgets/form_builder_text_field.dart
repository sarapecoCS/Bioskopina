import 'dart:ui';
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
  double? paddingLeft;
  double? paddingRight;
  double? paddingTop;
  double? paddingBottom;
  void Function(String?)? onChanged;
  String? Function(String?)? validator;
  void Function(String?)? onSubmitted;
  void Function(String?)? onSaved;
  TextAlignVertical textAlignVertical;
  TextCapitalization textCapitalization;
  double? errorBorderRadius;
  FocusNode? focusNode;
  double? errorHeight;
  EdgeInsetsGeometry? contentPadding;

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
    this.textAlignVertical = TextAlignVertical.center,
    this.textCapitalization = TextCapitalization.sentences,
    this.errorBorderRadius,
    this.focusNode,
    this.errorHeight,
    this.contentPadding,
  });

  @override
  State<MyFormBuilderTextField> createState() => _MyFormBuilderTextFieldState();
}

class _MyFormBuilderTextFieldState extends State<MyFormBuilderTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: widget.paddingLeft!,
          right: widget.paddingRight!,
          top: widget.paddingTop!,
          bottom: widget.paddingBottom!),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: FormBuilderTextField(
          selectionHeightStyle: BoxHeightStyle.includeLineSpacingBottom,
          textAlignVertical: widget.textAlignVertical,
          textCapitalization: widget.textCapitalization,
          focusNode: widget.focusNode ?? FocusNode(),
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
          style: const TextStyle(
            color: Palette.lightPurple,
            //height: 1,
            fontSize: 13,
          ),
          obscuringCharacter: '✮',
          obscureText: widget.obscureText ?? false,
          decoration: InputDecoration(
            contentPadding: widget.contentPadding ??
                const EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
              borderSide: BorderSide(
                color: widget.borderColor!,
                width: widget.borderWidth ?? 0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Palette.lightRed),
                borderRadius:
                    BorderRadius.circular(widget.errorBorderRadius ?? 50)),
            errorStyle: TextStyle(
              color: Palette.lightRed,
              height: widget.errorHeight ?? 0.3,
              textBaseline: TextBaseline.alphabetic,
            ),
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Palette.lightRed),
                borderRadius:
                    BorderRadius.circular(widget.errorBorderRadius ?? 50)),
            labelText: widget.labelText ?? "",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Palette.lightPurple,
            ),
            fillColor: _fillColor(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
              borderSide: BorderSide(
                color: widget.borderColor!,
                width: widget.borderWidth ?? 0,
              ),
            ),
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
