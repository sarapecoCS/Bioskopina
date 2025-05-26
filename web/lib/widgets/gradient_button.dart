import 'package:flutter/material.dart';

import '../utils/colors.dart';

// ignore: must_be_immutable
class GradientButton extends StatefulWidget {
  void Function()? onPressed;
  double? width;
  double? height;
  double? borderRadius;
  LinearGradient? gradient;
  Widget? child;
  double? paddingLeft;
  double? paddingRight;
  double? paddingTop;
  double? paddingBottom;
  double? contentPaddingLeft;
  double? contentPaddingRight;
  double? contentPaddingTop;
  double? contentPaddingBottom;

  GradientButton({
    super.key,
    this.onPressed,
    this.width,
    this.height,
    this.borderRadius = 0,
    this.gradient,
    this.child,
    this.paddingLeft = 0,
    this.paddingRight = 0,
    this.paddingTop = 0,
    this.paddingBottom = 0,
    this.contentPaddingLeft,
    this.contentPaddingRight,
    this.contentPaddingTop,
    this.contentPaddingBottom,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.width != null &&
        widget.height != null &&
        widget.contentPaddingLeft == null &&
        widget.contentPaddingRight == null &&
        widget.contentPaddingTop == null &&
        widget.contentPaddingBottom == null) {
      return _buildOldButton();
    } else {
      return _buildDynamicButton();
    }
  }

  Widget _buildOldButton() {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.paddingLeft!,
        right: widget.paddingRight!,
        top: widget.paddingTop!,
        bottom: widget.paddingBottom!,
      ),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size(widget.width!, widget.height!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            border: Border.all(color: Palette.lightPurple.withOpacity(0.3)),
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
          ),
          child: Container(
            width: widget.width,
            height: widget.height,
            alignment: Alignment.center,
            child: widget.child,
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicButton() {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.paddingLeft!,
        right: widget.paddingRight!,
        top: widget.paddingTop!,
        bottom: widget.paddingBottom!,
      ),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            border: Border.all(color: Palette.lightPurple.withOpacity(0.3)),
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                left: widget.contentPaddingLeft ?? 0,
                right: widget.contentPaddingRight ?? 0,
                top: widget.contentPaddingTop ?? 0,
                bottom: widget.contentPaddingBottom ?? 0),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
