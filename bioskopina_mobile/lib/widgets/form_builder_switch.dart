import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../utils/colors.dart';

// ignore: must_be_immutable
class MyFormBuilderSwitch extends StatefulWidget {
  String name;
  Widget title;
  Widget? subtitle;
  bool? initialValue;
  bool? enabled;
  void Function(bool?)? onChanged;
  String? Function(bool?)? validator;

  MyFormBuilderSwitch({
    super.key,
    required this.name,
    required this.title,
    this.subtitle,
    this.initialValue,
    this.enabled,
    this.onChanged,
    this.validator,
  });

  @override
  State<MyFormBuilderSwitch> createState() => _MyFormBuilderSwitchState();
}

class _MyFormBuilderSwitchState extends State<MyFormBuilderSwitch> {
  @override
  Widget build(BuildContext context) {
    return FormBuilderSwitch(
      initialValue: widget.initialValue,
      enabled: widget.enabled ?? true,
      name: widget.name,
      title: widget.title,
      onChanged: widget.onChanged,
      subtitle: widget.subtitle ?? const Text(""),
      decoration: const InputDecoration(
        border: InputBorder.none,
        errorStyle: TextStyle(
          color: Palette.lightRed,
          height: 0.1,
        ),
      ),
      activeColor: Palette.teal,
      validator: widget.validator,
    );
  }
}
