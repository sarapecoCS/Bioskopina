import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/comment.dart';
import '../providers/comment_provider.dart';
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
  late Future<SearchResult<Comment>> _commentsFuture;
  List<Comment> _comments = [];

  int page = 0;
  int pageSize = 20;

  @override
  void initState() {
    _commentProvider = context.read<CommentProvider>();
    _loadComments();
    super.initState();
  }

  void _loadComments() {
    setState(() {
      _commentsFuture = _commentProvider.get(filter: {
        "PostId": "${widget.post.id}",
        "MostLikedFirst": "true",
        "Page": "$page",
        "PageSize": "$pageSize",
      }).then((result) {
        // Filter comments to ensure they belong to this post
        _comments = result.result.where((comment) => comment.postId == widget.post.id).toList();
        return result;
      });
    });
  }

  void updatePost(Post updatedPost) {
    setState(() {
      _postUpdated = updatedPost;
      _loadComments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _postUpdated ?? widget.post);
        return false;
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
            builder: (_) => ContentForm(post: widget.post),
          ).then((_) {
            _loadComments();
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
                post: _postUpdated ?? widget.post,
                navigateToPostDetails: false,
                contentMaxLines: 15,
                largeProfilePhoto: true,
                onPostUpdated: updatePost,
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
              FutureBuilder<SearchResult<Comment>>(
                future: _commentsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (_comments.isEmpty) {
                    return const Center(child: Text('No comments yet'));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      return ContentCard(
                        comment: _comments[index],
                        onPostUpdated: (post) {
                          // This won't be called for comments
                        },
                      );
                    },
                  );
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}