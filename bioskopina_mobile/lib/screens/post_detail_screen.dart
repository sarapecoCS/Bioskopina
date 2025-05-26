import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/comment.dart';
import '../providers/comment_provider.dart';
import '../widgets/comment_cards.dart';
import '../widgets/content_form.dart';
import '../widgets/master_screen.dart';
import '../widgets/separator.dart';
import '../models/post.dart';
import '../models/search_result.dart';
import '../utils/colors.dart';
import '../widgets/content_card.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late final CommentProvider _commentProvider;
  Post? _postUpdated;

  int page = 0;
  int pageSize = 20;

  Map<String, dynamic> _filter = {};

  @override
  void initState() {
    _commentProvider = context.read<CommentProvider>();

    _filter = {
      "PostId": widget.post.id,
      "MostLikedFirst": "true",
    };

    super.initState();
  }

  void updatePost(Post updatedPost) {
    setState(() {
      _postUpdated = updatedPost;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _postUpdated ?? widget.post);
        return false; // Prevents default pop behavior
      },
      child: MasterScreenWidget(
        showBackArrow: true,
        showNavBar: false,
        title: "Post",
        showProfileIcon: false,
        showFloatingActionButton: true,
        onLeadingPressed: () {
          Navigator.pop(context, _postUpdated ?? widget.post);
        },
        floatingButtonOnPressed: () {
          showDialog(
              context: context,
              builder: (_) {
                return ContentForm(post: widget.post);
              });
        },
        floatingActionButtonIcon: const Icon(
          Icons.add_comment_rounded,
          size: 25,
          color: Palette.white,
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(children: [
              const SizedBox(height: 10),
              ContentCard(
                post: widget.post,
                navigateToPostDetails: false,
                contentMaxLines: 15,
                largeProfilePhoto: true,
                onPostUpdated: (updatedPost) => updatePost(updatedPost),
                hidePopupMenuButton: true,
              ),
              MySeparator(
                width: screenWidth,
                borderRadius: 50,
                opacity: 0.5,
                paddingTop: 5,
              ),
              const SizedBox(height: 5),
              const Text("Comments"),
              const SizedBox(height: 10),
              CommentCards(
                  fetchComments: fetchComments,
                  fetchPage: fetchPage,
                  filter: _filter,
                  page: page,
                  pageSize: pageSize)
            ]),
          ),
        ),
      ),
    );
  }

  Future<SearchResult<Comment>> fetchComments() {
    return _commentProvider.get(filter: {
      ..._filter,
      "Page": "$page",
      "PageSize": "$pageSize",
    });
  }

  Future<SearchResult<Comment>> fetchPage(Map<String, dynamic> filter) {
    return _commentProvider.get(filter: filter);
  }
}
