import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class MyDateTimePicker extends StatefulWidget {
  final String name;
  final String? labelText;
  final Color? fillColor;
  final double width;

  final double borderRadius;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;
  final String? Function(DateTime?)? validator;
  final GlobalKey<FormBuilderState>? formKey;
  final FocusNode? focusNode;
  final void Function(DateTime?)? onChanged;

  const MyDateTimePicker({
    super.key,
    required this.name,
    this.width = 100,
    this.labelText,
    this.borderRadius = 0,
    this.paddingLeft = 0,
    this.paddingRight = 0,
    this.paddingTop = 0,
    this.paddingBottom = 0,
    this.fillColor,
    this.validator,
    this.formKey,
    this.focusNode,
    this.onChanged,
  });

  @override
  State<MyDateTimePicker> createState() => _MyDateTimePickerState();
}

class _MyDateTimePickerState extends State<MyDateTimePicker> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.paddingLeft,
        right: widget.paddingRight,
        top: widget.paddingTop,
        bottom: widget.paddingBottom,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SizedBox(
              width: widget.width,
              child: FormBuilderDateTimePicker(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: widget.onChanged,
                focusNode: widget.focusNode ?? FocusNode(),
                validator: widget.validator,
                valueTransformer: (selectedDate) {
                  return selectedDate?.toIso8601String();
                },
                name: widget.name,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
                  errorStyle:
                      const TextStyle(color: Palette.lightRed, height: 0.5),
                  errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Palette.lightRed),
                      borderRadius: BorderRadius.circular(50)),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 10),
                    child: Icon(
                      Icons.calendar_today,
                      size: 24,
                      color: Palette.lightPurple,
                    ),
                  ),
                  fillColor: widget.fillColor,
                  labelText: widget.labelText,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Palette.lightPurple,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                ),
                inputType: InputType.date,
                format: DateFormat('MMM d, y'),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.clear_rounded,
              color: Palette.lightPurple.withOpacity(0.5),
            ),
            onPressed: () {
              setState(() {
                widget.formKey?.currentState?.fields[widget.name]
                    ?.didChange(null);
              });
            },
          ),
        ],
      ),
    );
  }
}
