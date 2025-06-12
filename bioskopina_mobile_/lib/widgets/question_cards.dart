import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../widgets/pagination_buttons.dart';
import '../widgets/qa_details.dart';
import '../models/qa.dart';
import '../models/search_result.dart';
import '../providers/qa_provider.dart';
import '../utils/colors.dart';
import '../utils/util.dart';
import 'empty.dart';
import 'gradient_button.dart';

typedef FetchPage = Future<SearchResult<QA>> Function(
    Map<String, dynamic> filter);

// ignore: must_be_immutable
class QuestionCards extends StatefulWidget {
  final Future<SearchResult<QA>> Function() fetchQA;
  final Future<Map<String, dynamic>> Function()? getFilter;
  final FetchPage fetchPage;
  Map<String, dynamic> filter;
  int page;
  int pageSize;
  bool showPopupIcon;

  QuestionCards({
    super.key,
    required this.fetchQA,
    this.getFilter,
    required this.fetchPage,
    required this.filter,
    required this.page,
    required this.pageSize,
    this.showPopupIcon = true,
  });

  @override
  State<QuestionCards> createState() => _QuestionCardsState();
}

class _QuestionCardsState extends State<QuestionCards>
    with AutomaticKeepAliveClientMixin<QuestionCards> {
  late Future<SearchResult<QA>> _qAFuture;
  final ScrollController _scrollController = ScrollController();
  late final QAProvider _qAProvider;

  int totalItems = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _qAFuture = widget.fetchQA();
    _qAProvider = context.read<QAProvider>();

    setTotalItems();

    _qAProvider.addListener(() {
      _reloadData();
      setTotalItems();
    });

    super.initState();
  }

  void _reloadData() async {
    if (mounted) {
      setState(() {
        _qAFuture = widget.fetchQA();
      });
    }
  }

  void setTotalItems() async {
    var qAResult = await _qAFuture;
    if (mounted) {
      setState(() {
        totalItems = qAResult.count;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder<SearchResult<QA>>(
        future: _qAFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Center(
                child: Wrap(
                  children: List.generate(6, (_) => _buildQAIndicator()),
                ),
              ),
            );
            // Loading state
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Error state
          } else {
            // Data loaded successfully
            var qAList = snapshot.data!.result;

            if (qAList.isEmpty) {
              return const Empty(
                showGradientButton: false,
                text: Text("Empty"),
              );
            }

            return SingleChildScrollView(
              controller: _scrollController,
              child: Center(
                child: Column(
                  children: [
                    Wrap(
                      children: _buildQACards(qAList),
                    ),
                    MyPaginationButtons(
                      page: widget.page,
                      pageSize: widget.pageSize,
                      totalItems: totalItems,
                      fetchPage: fetchPage,
                      hasSearch: false,
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }

  Future<void> fetchPage(int requestedPage) async {
    try {
      var result = await widget.fetchPage({
        ...widget.filter,
        "Page": "$requestedPage",
        "PageSize": "${widget.pageSize}",
      });

      if (mounted) {
        setState(() {
          _qAFuture = Future.value(result);
          widget.page = requestedPage;
        });
      }
    } on Exception catch (e) {
      if (mounted) {
        showErrorDialog(context, e);
      }
    }
  }

  List<Widget> _buildQACards(List<QA> qAList) {
    return List.generate(
      qAList.length,
      (index) => _buildQACard(qAList[index]),
    );
  }

  Widget _buildQACard(QA qa) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return QADetails(qa: qa);
            });
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
          bottom: 5,
        ),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 100),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Palette.textFieldPurple.withOpacity(0.2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(qa.question.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  Visibility(
                    visible: widget.showPopupIcon,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 23),
                      child: Container(
                        padding: EdgeInsets.zero,
                        child: _buildPopupMenu(qa),
                      ),
                    ),
                  )
                ],
              ),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GradientButton(
                        contentPaddingLeft: 5,
                        contentPaddingRight: 5,
                        contentPaddingBottom: 1,
                        contentPaddingTop: 0,
                        borderRadius: 50,
                        gradient: Palette.navGradient4,
                        child: Text(
                          qa.category!.name.toString(),
                          style: const TextStyle(
                              fontSize: 10,
                              color: Palette.lightPurple,
                              fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  qa.answer.toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ]),
          ),
        ).asGlass(
          blurX: 5,
          blurY: 5,
          tintColor: Palette.buttonRed,
          clipBorderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget _buildQAIndicator() {
    Size screenSize = MediaQuery.of(context).size;
    double containerWidth = screenSize.width;
    double containerHeight = screenSize.height * 0.15;

    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 5,
      ),
      child: Container(
        height: containerHeight,
        width: containerWidth,
        constraints: const BoxConstraints(maxHeight: 100),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Palette.textFieldPurple.withOpacity(0.2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Shimmer.fromColors(
                  baseColor: Palette.lightPurple,
                  highlightColor: Palette.white,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: containerWidth * 0.6),
                    child: const SizedBox(
                      width: 200,
                      height: 12,
                    ).asGlass(),
                  ).asGlass(
                      clipBorderRadius: BorderRadius.circular(4),
                      tintColor: Palette.lightPurple),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: List.generate(
                  2,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Shimmer.fromColors(
                      baseColor: Palette.lightPurple,
                      highlightColor: Palette.white,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: containerWidth),
                        height: 11,
                      ).asGlass(
                        clipBorderRadius: BorderRadius.circular(3),
                        tintColor: Palette.lightPurple,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ).asGlass(
        blurX: 5,
        blurY: 5,
        tintColor: Palette.buttonRed,
        clipBorderRadius: BorderRadius.circular(15),
      ),
    );
  }

  Widget _buildPopupMenu(QA qa) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Palette.darkPurple.withOpacity(0.5),
      ),
      child: PopupMenuButton<String>(
        tooltip: "Actions",
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: Palette.lightPurple.withOpacity(0.3)),
        ),
        icon: const Icon(Icons.more_horiz_rounded),
        splashRadius: 1,
        padding: EdgeInsets.zero,
        color: Palette.popupMenu,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              hoverColor: Palette.lightRed.withOpacity(0.1),
              leading: Icon(Icons.delete, color:Colors.red, size: 24),
              title: const Text('Delete',
                  style: TextStyle(color: Palette.lightRed)),
              onTap: () {
                Navigator.pop(context);
                showConfirmationDialog(
                    context,
                    const Icon(Icons.warning_rounded,
                        color: Colors.red, size: 55),
                    const Text(
                      "Are you sure you want to delete this question?",
                      textAlign: TextAlign.center,
                    ), () async {
                  try {
                    await _qAProvider.delete(qa.id!);
                  } on Exception catch (e) {
                    if (context.mounted) {
                      showErrorDialog(context, e);
                    }
                  }
                });
              },
            ),
          ),
        ],
      ),
    ).asGlass(
      blurX: 1,
      blurY: 1,
      clipBorderRadius: BorderRadius.circular(20),
      tintColor: Palette.darkPurple,
    );
  }
}
