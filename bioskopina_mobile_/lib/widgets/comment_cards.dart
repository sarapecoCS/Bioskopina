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

typedef FetchPage = Future<SearchResult<Comment>> Function(Map<String, dynamic> filter);

class CommentCards extends StatefulWidget {
  final Future<SearchResult<Comment>> Function() fetchComments;
  final Map<String, dynamic> filter;
  final FetchPage fetchPage;
  int page;
  final int pageSize;

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

class _CommentCardsState extends State<CommentCards> with AutomaticKeepAliveClientMixin<CommentCards> {
  late Future<SearchResult<Comment>> _commentFuture;
  final ScrollController _scrollController = ScrollController();
  late final CommentProvider _commentProvider;

  int totalItems = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _commentFuture = widget.fetchComments();
    _commentProvider = context.read<CommentProvider>();

    // Set total items once after initial fetch
    _commentFuture.then((result) {
      if (mounted) {
        setState(() {
          totalItems = result.count;
        });
      }
    });

    _commentProvider.addListener(() {
      // Reload data when CommentProvider updates
      _reloadData();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _commentProvider.removeListener(_reloadData);
    super.dispose();
  }

  void _reloadData() {
    if (mounted) {
      setState(() {
        _commentFuture = _commentProvider.get(filter: {
          ...widget.filter,
          "Page": "${widget.page}",
          "PageSize": "${widget.pageSize}"
        });

        // Update total items after fetch completes
        _commentFuture.then((result) {
          if (mounted) {
            setState(() {
              totalItems = result.count;
            });
          }
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
                children: List.generate(6, (_) => const ContentIndicator()),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
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
      },
    );
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

          // Update total items on page change
          totalItems = result.count;
        });
      }
    } catch (e) {
      if (mounted) {
        final ex = e is Exception ? e : Exception(e.toString());
        showErrorDialog(context, ex);
      }
    }
  }


  List<Widget> _buildCommentCards(List<Comment> commentList) {
    if (commentList.isEmpty) {
      return [
        const Empty(
          text: Text("No comments yet.."),
          showGradientButton: false,
          iconSize: 128,
        ),
      ];
    }
    return commentList
        .map((comment) => ContentCard(
              comment: comment,
              cardColor: Palette.midnightPurple.withOpacity(0.1),
            ))
        .toList();
  }
}
