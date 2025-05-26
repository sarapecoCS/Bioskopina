import 'package:flutter/material.dart';

import '../utils/colors.dart';

class MyProgressIndicator extends StatefulWidget {
  final double? width;
  final double? height;
  final double? strokeWidth;
  final Color? color;

  const MyProgressIndicator({
    super.key,
    this.height,
    this.width,
    this.strokeWidth,
    this.color,
  });

  @override
  State<MyProgressIndicator> createState() => _MyProgressIndicatorState();
}

class _MyProgressIndicatorState extends State<MyProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: CircularProgressIndicator(
          strokeWidth: widget.strokeWidth ?? 4,
          color: widget.color ?? Palette.lightPurple.withOpacity(0.7),
        ),
      ),
    );
  }
}
