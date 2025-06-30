import 'package:flutter/material.dart';

import '../utils/colors.dart';

// ignore: must_be_immutable
class MyPaginationButtons extends StatefulWidget {
  int page;
  int pageSize;
  int totalItems;
  Future<void> Function(int) fetchPage;
  Widget? noResults;
  bool? hasSearch;

  MyPaginationButtons({
    super.key,
    required this.page,
    required this.pageSize,
    required this.totalItems,
    required this.fetchPage,
    this.noResults,
    required this.hasSearch,
  });

  @override
  State<MyPaginationButtons> createState() => _MyPaginationButtonsState();
}

class _MyPaginationButtonsState extends State<MyPaginationButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: widget.totalItems > 0,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.textFieldPurple.withOpacity(0.7),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    onPressed: widget.page > 0
                        ? () => widget.fetchPage(widget.page - 1)
                        : null,
                    child: const Icon(Icons.arrow_back_ios_rounded),
                  ),
                ),
                Text(
                    'Page ${widget.page + 1} of ${(widget.totalItems / widget.pageSize).ceil()}'),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Palette.textFieldPurple.withOpacity(0.7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    onPressed: widget.page + 1 ==
                            (widget.totalItems / widget.pageSize).ceil()
                        ? null
                        : () => widget.fetchPage(widget.page + 1),
                    child: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildNoResults(),
      ],
    );
  }

  Widget _buildNoResults() {
    if (widget.hasSearch == false) {
      return Container();
    }
    if (widget.noResults != null) {
      return Visibility(
        visible: widget.totalItems <= 0,
        child: widget.noResults!,
      );
    }
    return Visibility(
        visible: widget.totalItems <= 0,
        child: Stack(
          children: [
            Positioned(
              top: 130,
              left: 105,
              child: Text(
                "No results found.",
                style: TextStyle(
                    fontSize: 25, color: Palette.lightPurple.withOpacity(0.6)),
              ),
            ),
            Opacity(
                opacity: 0.8,
                child: Image.asset(
                  "assets/images/starFrame.png",
                  width: 400,
                )),
          ],
        ));
  }
}
