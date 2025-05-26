import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/post_provider.dart';
import '../widgets/pagination_buttons.dart';
import '../widgets/content_card.dart';
import '../widgets/content_indicator.dart';
import '../models/post.dart';
import '../models/search_result.dart';
import '../utils/util.dart';
import 'empty.dart';

typedef FetchPage = Future<SearchResult<Post>> Function(
    Map<String, dynamic> filter);

// ignore: must_be_immutable
class PostCards extends StatefulWidget {
  final int selectedIndex;
  final Future<SearchResult<Post>> Function() fetchPosts;
  Map<String, dynamic> filter;
  final FetchPage fetchPage;
  int page;
  int pageSize;

  PostCards({
    super.key,
    required this.selectedIndex,
    required this.fetchPosts,
    required this.fetchPage,
    required this.filter,
    required this.page,
    required this.pageSize,
  });

  @override
  State<PostCards> createState() => _PostCardsState();
}

class _PostCardsState extends State<PostCards> {
  late Future<SearchResult<Post>> _postFuture;
  final ScrollController _scrollController = ScrollController();
  late final PostProvider _postProvider;

  int totalItems = 0;

  @override
  void initState() {
    _postFuture = widget.fetchPosts();
    _postProvider = context.read<PostProvider>();

    setTotalItems();

    _postProvider.addListener(() {
      _reloadData();
      setTotalItems();
    });

    super.initState();
  }

  void setTotalItems() async {
    var postResult = await _postFuture;
    if (mounted) {
      setState(() {
        totalItems = postResult.count;
      });
    }
  }

  void _reloadData() {
    if (mounted) {
      setState(() {
        _postFuture = _postProvider.get(filter: {
          ...widget.filter,
          "Page": "${widget.page}",
          "PageSize": "${widget.pageSize}"
        });
      });
    }
  }

// Updates only one post
  void updatePost(Post updatedPost) async {
    setState(() {
      _postFuture.then((postResult) {
        final index =
            postResult.result.indexWhere((post) => post.id == updatedPost.id);
        if (index != -1) {
          postResult.result[index] = updatedPost;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SearchResult<Post>>(
        future: _postFuture,
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
            // Loading state
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Error state
          } else {
            // Data loaded successfully
            var postList = snapshot.data!.result;

            if (postList.isEmpty) {
              return const Empty(
                  iconSize: 150,
                  showGradientButton: false,
                  text: Text("No posts here~"));
            }

            return SingleChildScrollView(
              controller: _scrollController,
              child: Center(
                child: Column(
                  children: [
                    Wrap(
                      children: _buildPostCards(postList),
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
          _postFuture = Future.value(result);
          widget.page = requestedPage;
        });
      }
    } on Exception catch (e) {
      if (mounted) {
        showErrorDialog(context, e);
      }
    }
  }

  List<Widget> _buildPostCards(List<Post> postList) {
    return List.generate(
      postList.length,
      (index) => ContentCard(
        post: postList[index],
        onPostUpdated: (updatedPost) => updatePost(updatedPost),
      ),
    );
  }
}
