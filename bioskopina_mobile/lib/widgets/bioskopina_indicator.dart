import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/colors.dart';

class BioskopinaIndicator extends StatefulWidget {
  const BioskopinaIndicator({super.key});

  @override
  State<BioskopinaIndicator> createState() => _BioskopinaIndicatorState();
}

class _BioskopinaIndicatorState extends State<BioskopinaIndicator> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    double? cardWidth = screenSize.width * 0.44;
    double? cardHeight = screenSize.height * 0.3;

    double topPadding = cardHeight * 0.1 < 23.4 ? 10 : 0;

    return Container(
      width: cardWidth,
      height: cardHeight,
      margin: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Palette.lightPurple.withOpacity(0.3)),
        color: Palette.darkPurple.withOpacity(0),
      ),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: cardWidth,
                  height: cardHeight * 0.85,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                  ),
                ).asGlass(
                    tintColor: Palette.lightPurple,
                    clipBorderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    blurX: 3,
                    blurY: 3),
                Positioned(
                  bottom: (cardHeight * 0.1 < 23.4)
                      ? -(cardHeight * 0.025)
                      : (cardHeight * 0.015),
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: cardHeight * 0.135,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
            EdgeInsets.only(bottom: 10, left: 8, right: 8, top: topPadding),
            child: Shimmer.fromColors(
              baseColor: Palette.lightPurple,
              highlightColor: Palette.white,
              child: Container(
                width: double.infinity,
                height: 10,
                color: Palette.lightPurple.withOpacity(0.2),
              ).asGlass(
                  tintColor: Palette.lightPurple,
                  clipBorderRadius: BorderRadius.circular(4)),
            ),
          ),
        ],
      ),
    );
  }
}
