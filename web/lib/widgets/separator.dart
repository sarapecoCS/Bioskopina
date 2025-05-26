import 'package:flutter/material.dart';

import '../utils/colors.dart';

// ignore: must_be_immutable
class MySeparator extends StatefulWidget {
  double? height;
  double? width;
  double? borderRadius;
  double? paddingLeft;
  double? paddingRight;
  double? paddingTop;
  double? paddingBottom;
  double? marginVertical;
  double? marginHorizontal;
  Color? color;
  double? opacity;
  MySeparator({
    super.key,
    this.height = 1,
    this.width = 100,
    this.borderRadius = 0,
    this.paddingLeft = 0,
    this.paddingRight = 0,
    this.paddingTop = 0,
    this.paddingBottom = 0,
    this.marginVertical = 0,
    this.marginHorizontal = 0,
    this.color = Palette.lightPurple,
    this.opacity = 1,
  });

  @override
  State<MySeparator> createState() => _MySeparatorState();
}

class _MySeparatorState extends State<MySeparator> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: widget.paddingLeft!,
          right: widget.paddingRight!,
          top: widget.paddingTop!,
          bottom: widget.paddingBottom!),
      child: Container(
        height: widget.height,
        width: widget.width,
        margin: EdgeInsets.symmetric(
            vertical: widget.marginVertical!,
            horizontal: widget.marginHorizontal!),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius!),
          color: Palette.lightPurple.withOpacity(widget.opacity!),
        ),
      ),
    );
  }
}
