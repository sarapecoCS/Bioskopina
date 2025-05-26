import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/empty.dart';
import '../widgets/pagination_buttons.dart';
import '../widgets/content_card.dart';
import '../widgets/content_indicator.dart';
import '../models/comment.dart';
import '../models/search_result.dart';
import '../providers/comment_provider.dart';
import '../utils/colors.dart';
import '../utils/util.dart';

typedef FetchPage = Future<SearchResult<Comment>> Function(
    Map<String, dynamic> filter);

// ignore: must_be_immutable
class CommentCards extends StatefulWidget {
  final Future<SearchResult<Comment>> Function() fetchComments;
  Map<String, dynamic> filter;
  final FetchPage fetchPage;
  int page;
  int pageSize;

  CommentCards({
    super.key,
    required this.fetchComments,
    required this.fetchPage,
    required this.filter,
    required this.page,
    required this.pageSize,
  });

  @override
  State<CommentCards> createState() => _CommentCardsState();
}

class _CommentCardsState extends State<CommentCards>
    with AutomaticKeepAliveClientMixin<CommentCards> {
  late Future<SearchResult<Comment>> _commentFuture;
  final ScrollController _scrollController = ScrollController();
  late final CommentProvider _commentProvider;

  int totalItems = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _commentFuture = widget.fetchComments();
    _commentProvider = context.read<CommentProvider>();

    setTotalItems();

    _commentProvider.addListener(() {
      _reloadData();
      setTotalItems();
    });

    super.initState();
  }

  void setTotalItems() async {
    var commentResult = await _commentFuture;
    if (mounted) {
      setState(() {
        totalItems = commentResult.count;
      });
    }
  }

  void _reloadData() {
    if (mounted) {
      setState(() {
        _commentFuture = _commentProvider.get(filter: {
          ...widget.filter,
          "Page": "${widget.page}",
          "PageSize": "${widget.pageSize}"
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<SearchResult<Comment>>(
        future: _commentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Center(
                child: Wrap(
                  //Implement proper post indicator
                  children: List.generate(6, (_) => const ContentIndicator()),
                ),
              ),
            );
            // Loading state
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Error state
          } else {
            // Data loaded successfully
            var commentList = snapshot.data!.result;

            return SingleChildScrollView(
              controller: _scrollController,
              child: Center(
                child: Column(
                  children: [
                    Wrap(
                      children: _buildCommentCards(commentList),
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
          _commentFuture = Future.value(result);
          widget.page = requestedPage;
        });
      }
    } on Exception catch (e) {
      if (mounted) {
        showErrorDialog(context, e);
      }
    }
  }

  List<Widget> _buildCommentCards(List<Comment> commentList) {
    if (commentList.isEmpty) {
      return List.generate(
          1,
          (index) => const Empty(
                text: Text("No comments yet.."),
                showGradientButton: false,
                iconSize: 128,
              ));
    }
    return List.generate(
      commentList.length,
      (index) => ContentCard(
        comment: commentList[index],
        cardColor: Palette.midnightPurple.withOpacity(0.1),
      ),
    );
  }
}
