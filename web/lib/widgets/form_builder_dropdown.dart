import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../utils/colors.dart';

// ignore: must_be_immutable
class MyFormBuilderDropdown extends StatefulWidget {
  String name;
  String? labelText;
  Color? fillColor;
  Color? dropdownColor;
  double? width;
  double? height;
  double? borderRadius;
  String? initialValue;
  double? paddingLeft;
  double? paddingRight;
  double? paddingTop;
  double? paddingBottom;
  Widget? icon;
  void Function(String?)? onChanged;
  void Function()? onTap;
  List<DropdownMenuItem<String>> items;
  MyFormBuilderDropdown({
    super.key,
    required this.name,
    this.labelText,
    this.fillColor,
    this.dropdownColor,
    this.width,
    this.height,
    this.borderRadius,
    this.initialValue,
    this.paddingLeft = 0,
    this.paddingRight = 0,
    this.paddingTop = 0,
    this.paddingBottom = 0,
    this.onChanged,
    this.onTap,
    this.icon,
    required this.items,
  });

  @override
  State<MyFormBuilderDropdown> createState() => _MyFormBuilderDropdownState();
}

class _MyFormBuilderDropdownState extends State<MyFormBuilderDropdown> {
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
        child: FormBuilderDropdown(
          borderRadius: BorderRadius.circular(25),
          initialValue: widget.initialValue,
          focusColor: Palette.darkPurple,
          icon: widget.icon,
          dropdownColor: widget.dropdownColor ?? Palette.darkPurple,
          items: widget.items,
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          name: widget.name,
          style: const TextStyle(color: Palette.lightPurple),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
            labelText: widget.labelText ?? "",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Palette.lightPurple,
            ),
            fillColor: widget.fillColor,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
            ),
          ),
        ),
      ),
    );
  }
}
