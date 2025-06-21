import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'gradient_button.dart';

class Empty extends StatefulWidget {
  /// Text widget to portray
  final Text? text;

  /// Screen to navigate to by clicking a button, used in combination with showGradientButton
  final Widget? screen;

  /// Shows a gradient button under the icon
  final bool? showGradientButton;

  final double? iconSize;

  /// GradientButton height
  final double? height;

  /// GradientButton width
  final double? width;

  /// GradientButton gradient
  final LinearGradient? gradient;

  /// GradientButton child widget, usually Text
  final Widget? child;

  /// Custom icon to display inside the circle
  final IconData? innerIcon;

  /// Color for the inner icon
  final Color? innerIconColor;

  const Empty({
    super.key,
    this.text,
    this.screen,
    this.showGradientButton = true,
    this.iconSize,
    this.height,
    this.width,
    this.gradient,
    this.child,
    this.innerIcon,
    this.innerIconColor,
  });

  @override
  State<Empty> createState() => _EmptyState();
}

class _EmptyState extends State<Empty> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.circle,
                  size: widget.iconSize ?? 200,
                  color: Palette.lightPurple.withOpacity(0.8),
                ),
                Icon(
                  widget.innerIcon ?? Icons.search_off_rounded, // Default empty state icon
                  size: (widget.iconSize ?? 200) * 0.5, // 50% of circle size
                  color: widget.innerIconColor ?? Colors.black.withOpacity(0.9),
                ),
              ],
            ),
            widget.text ?? const Text(""),
            const SizedBox(height: 30),
            Visibility(
              visible: widget.showGradientButton ?? true,
              child: GradientButton(
                onPressed: () {
                  if (widget.screen != null) {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => widget.screen!));
                  }
                },
                width: widget.width ?? 120,
                height: widget.height ?? 30,
                borderRadius: 50,
                gradient: widget.gradient ?? Palette.navGradient4,
                child: widget.child ?? const Text("Go", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}