import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../utils/colors.dart';

// ignore: must_be_immutable
class MyFormBuilderCheckBox extends StatefulWidget {
  String name;
  Widget title;
  bool? initialValue;
  void Function(bool?)? onChanged;
  String? Function(bool?)? validator;

  MyFormBuilderCheckBox({
  super.key,
  required this.name,
  required this.title,
  this.initialValue,
  this.onChanged,
  this.validator,
  });

  @override
  State<MyFormBuilderCheckBox> createState() => _MyFormBuilderCheckBoxState();
}

class _MyFormBuilderCheckBoxState extends State<MyFormBuilderCheckBox> {
  @override
  Widget build(BuildContext context) {
    return FormBuilderCheckbox(
      name: widget.name,
      title: widget.title,
      initialValue: widget.initialValue,
      onChanged: widget.onChanged,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        errorStyle: TextStyle(color: Palette.lightRed),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
    );
  }
}