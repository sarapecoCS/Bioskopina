import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

// ignore: must_be_immutable
class MyDateTimePicker extends StatefulWidget {
  String? name;
  String? labelText;
  DateTime? initialValue;
  Color? fillColor;
  double? width;
  double? height;
  double? borderRadius;
  double? paddingLeft;
  double? paddingRight;
  double? paddingTop;
  double? paddingBottom;
  String? Function(DateTime?)? validator;
  void Function(DateTime?)? onChanged;
  GlobalKey<FormBuilderState>? formKey;
  FocusNode? focusNode;

  MyDateTimePicker({
    super.key,
    required this.name,
    this.width = 100,
    this.height = 40,
    this.labelText,
    this.borderRadius = 0,
    this.paddingLeft = 0,
    this.paddingRight = 0,
    this.paddingTop = 0,
    this.paddingBottom = 0,
    this.initialValue,
    this.fillColor,
    this.validator,
    this.onChanged,
    this.formKey,
    this.focusNode,
  });

  @override
  State<MyDateTimePicker> createState() => _MyDateTimePickerState();
}

class _MyDateTimePickerState extends State<MyDateTimePicker> {
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
        child: FormBuilderDateTimePicker(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          focusNode: widget.focusNode,
          style: const TextStyle(fontSize: 14, height: 1),
          validator: widget.validator,
          valueTransformer: (selectedDate) {
            return selectedDate?.toIso8601String();
          },
          name: widget.name!,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 12.0),
            suffixIcon: GestureDetector(
              onTap: () {
                if (widget.formKey != null) {
                  widget.formKey!.currentState?.fields["${widget.name}"]
                      ?.didChange(null);
                }
              },
              child: Icon(Icons.clear_rounded,
                  color: Palette.lightPurple.withOpacity(0.5)),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child:  Icon(
                Icons.calendar_today, // Use the icon you need here
                size: 24, // Size of the icon
              ),
            ),
            errorStyle: const TextStyle(
              fontSize: 11,
              color: Palette.lightRed,
              height: 0.3,
              textBaseline: TextBaseline.alphabetic,
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Palette.lightRed),
              borderRadius: BorderRadius.circular(50),
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
              borderRadius: BorderRadius.circular(widget.borderRadius!),
            ),
          ),
          inputType: InputType.date,
          format: DateFormat('MMM d, y'),
        ),
      ),
    );
  }
}
