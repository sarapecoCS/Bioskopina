import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/colors.dart';

class ContentIndicator extends StatefulWidget {
  const ContentIndicator({super.key});

  @override
  State<ContentIndicator> createState() => _ContentIndicatorState();
}

class _ContentIndicatorState extends State<ContentIndicator> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    double? cardWidth = screenSize.width * 0.95;
    double? cardHeight = screenSize.height * 0.2;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Palette.lightPurple.withOpacity(0.3)),
          color: Palette.buttonRed.withOpacity(0.1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100)),
                              ).asGlass(
                                tintColor: Palette.lightPurple,
                                clipBorderRadius: BorderRadius.circular(100),
                                blurX: 3,
                                blurY: 3,
                              ),
                              const SizedBox(width: 5),
                              Shimmer.fromColors(
                                baseColor: Palette.lightPurple,
                                highlightColor: Palette.white,
                                child: Container(
                                  constraints:
                                      BoxConstraints(maxWidth: cardWidth * 0.3),
                                  child: const SizedBox(
                                    width: 150,
                                    height: 12,
                                  ).asGlass(),
                                ).asGlass(
                                    clipBorderRadius: BorderRadius.circular(4),
                                    tintColor: Palette.lightPurple),
                              ),
                            ],
                          ),
                          Shimmer.fromColors(
                            baseColor: Palette.lightPurple,
                            highlightColor: Palette.white,
                            child: SizedBox(
                              width: cardWidth * 0.25,
                              height: 9,
                            ).asGlass(
                              clipBorderRadius: BorderRadius.circular(3),
                              tintColor: Palette.lightPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...List.generate(
                      3,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: SizedBox(
                          width: cardWidth,
                          height: 12,
                          child: Shimmer.fromColors(
                            baseColor: Palette.lightPurple,
                            highlightColor: Palette.white,
                            child: SizedBox(
                              width: cardWidth * 0.6,
                              height: 9,
                            ).asGlass(
                              clipBorderRadius: BorderRadius.circular(3),
                              tintColor: Palette.lightPurple,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
        ),
      ).asGlass(
        blurX: 0,
        blurY: 0,
        tintColor: Palette.lightPurple,
        clipBorderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
