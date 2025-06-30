import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/colors.dart';

class CinemaIndicator extends StatefulWidget {
  const CinemaIndicator({super.key});

  @override
  State<CinemaIndicator> createState() => _CinemaIndicatorState();
}

class _CinemaIndicatorState extends State<CinemaIndicator> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double containerWidth = screenSize.width;
    double containerHeight = screenSize.height * 0.15;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: containerWidth,
        height: containerHeight,
        decoration: BoxDecoration(color: Palette.buttonPurple.withOpacity(0.1)),
        child: Row(children: [
          Shimmer.fromColors(
            baseColor: Palette.lightPurple,
            highlightColor: Palette.white,
            enabled: false,
            child: SizedBox(
              width: containerWidth * 0.25,
              height: containerHeight,
            ).asGlass(
              tintColor: Palette.lightPurple,
              clipBorderRadius: BorderRadius.circular(4),
              blurX: 3,
              blurY: 3,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Palette.lightPurple,
                            highlightColor: Palette.white,
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth: containerWidth * 0.6),
                              child: const SizedBox(
                                width: 150,
                                height: 12,
                              ).asGlass(),
                            ).asGlass(
                                clipBorderRadius: BorderRadius.circular(4),
                                tintColor: Palette.lightPurple),
                          ),
                          const SizedBox(height: 5),
                          Shimmer.fromColors(
                            baseColor: Palette.lightPurple,
                            highlightColor: Palette.white,
                            child: const SizedBox(
                              width: 75,
                              height: 8,
                            ).asGlass(
                              clipBorderRadius: BorderRadius.circular(3),
                              tintColor: Palette.lightPurple,
                            ),
                          ),
                        ],
                      ),
                      Shimmer.fromColors(
                        baseColor: Palette.lightPurple,
                        highlightColor: Palette.white,
                        child: Icon(
                          Icons.edit,
                          size: 30,
                          color: Palette.lightPurple.withOpacity(0.4),
                        ).asGlass(
                          tintColor: Palette.lightPurple,
                          clipBorderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Shimmer.fromColors(
                            baseColor: Palette.starYellow,
                            highlightColor: Palette.lightYellow,
                            child: Icon(
                              Icons.star,
                              size: 20,
                              color: Palette.starYellow.withOpacity(0.4),
                            ).asGlass(
                              tintColor: Palette.starYellow,
                              clipBorderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                      Shimmer.fromColors(
                        baseColor: Palette.lightPurple,
                        highlightColor: Palette.white,
                        child: const SizedBox(
                          width: 95,
                          height: 9,
                        ).asGlass(
                          clipBorderRadius: BorderRadius.circular(3),
                          tintColor: Palette.lightPurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]),
      ).asGlass(
        blurX: 2,
        blurY: 2,
        tintColor: Palette.lightPurple,
      ),
    );
  }
}