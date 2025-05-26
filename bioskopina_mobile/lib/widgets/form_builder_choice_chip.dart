import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../utils/colors.dart';

// ignore: must_be_immutable
class MyFormBuilderChoiceChip extends StatefulWidget {
  String? name;
  List<FormBuilderChipOption<Object>> options;
  String? labelText;
  final dynamic initialValue;
  void Function(dynamic)? onChanged;
  String? Function(dynamic)? validator;
  Color? selectedColor;
  FocusNode? focusNode;

  MyFormBuilderChoiceChip({
    super.key,
    required this.name,
    required this.options,
    this.labelText,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.selectedColor,
    this.focusNode,
  });

  @override
  State<MyFormBuilderChoiceChip> createState() =>
      _MyFormBuilderChoiceChipState();
}

class _MyFormBuilderChoiceChipState extends State<MyFormBuilderChoiceChip> {
  @override
  Widget build(BuildContext context) {
    return FormBuilderChoiceChip(
      focusNode: widget.focusNode,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(50),
      ),
      name: widget.name!,
      initialValue: widget.initialValue ?? "",
      backgroundColor: Palette.lightPurple,
      options: widget.options,
      selectedColor: widget.selectedColor ?? Palette.rose.withOpacity(0.5),
      padding: const EdgeInsets.all(4),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: widget.labelText ?? "",
        fillColor: Colors.transparent,
        isDense: true,
        contentPadding: const EdgeInsets.only(bottom: 10),
        labelStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Palette.lightPurple,
          height: 0.2,
        ),
        border: InputBorder.none,
        errorStyle: const TextStyle(
          color: Palette.lightRed,
          height: 0.05,
          textBaseline: TextBaseline.alphabetic,
        ),
      ),
      onChanged: widget.onChanged,
      spacing: 5,
      runSpacing: 0,
      validator: widget.validator,
      visualDensity: VisualDensity.compact,
    );
  }
}
