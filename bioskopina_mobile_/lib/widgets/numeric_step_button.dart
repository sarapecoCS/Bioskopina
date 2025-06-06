import 'package:flutter/material.dart';

import '../utils/colors.dart';

class NumericStepButton extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int? initialValue;

  final ValueChanged<int> onChanged;

  const NumericStepButton({
    super.key,
    this.minValue = 0,
    this.maxValue = 10,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<NumericStepButton> createState() {
    return _NumericStepButtonState();
  }
}

class _NumericStepButtonState extends State<NumericStepButton> {
  int counter = 0;

  @override
  void initState() {
    if (widget.initialValue != null) {
      counter = widget.initialValue!;
      widget.onChanged(widget.initialValue!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(
            Icons.remove_rounded,
            color: Palette.lightPurple,
          ),
          iconSize: 32.0,
          color: Palette.lightPurple,
          onPressed: () {
            setState(() {
              if (counter > widget.minValue) {
                counter--;
              }
              widget.onChanged(counter);
            });
          },
        ),
        Container(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 5,
            bottom: 5,
          ),
          decoration: BoxDecoration(
              color: Palette.buttonRed2,
              borderRadius: BorderRadius.circular(4)),
          child: Text(
            '$counter',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Palette.lightPurple,
              fontSize: 18.0,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.add_rounded,
            color: Palette.lightPurple,
          ),
          iconSize: 32.0,
          color: Palette.lightPurple,
          onPressed: () {
            setState(() {
              if (counter < widget.maxValue) {
                counter++;
              }
              widget.onChanged(counter);
            });
          },
        ),
      ],
    );
  }
}
