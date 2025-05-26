import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/colors.dart';

class ChipIndicator extends StatelessWidget {
  const ChipIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
        baseColor: Palette.lightPurple,
        highlightColor: Palette.white,
        child: Container(
          width: screenSize.width * 0.2,
          height: 34,
          decoration: BoxDecoration(
              color: Palette.lightPurple.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20)),
        ).asGlass(
            clipBorderRadius: BorderRadius.circular(20),
            tintColor: Palette.lightPurple),
      ),
    );
  }
}
