import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_post_action_provider.dart';
import '../models/comment.dart';
import '../models/post.dart';
import '../providers/comment_provider.dart';
import '../providers/post_provider.dart';
import '../providers/user_comment_action_provider.dart';
import '../utils/colors.dart';

class LikeDislikeButton extends StatefulWidget {
  final Post? post;
  final Comment? comment;

  const LikeDislikeButton({
    super.key,
    this.post,
    this.comment,
  })  : assert(post != null || comment != null,
            "Either post or comment must be provided."),
        assert(!(post != null && comment != null),
            "Only one of post or comment can be provided.");

  @override
  State<LikeDislikeButton> createState() => LikeDislikeButtonState();
}

class LikeDislikeButtonState extends State<LikeDislikeButton> {
  String userAction = 'none';

  late Post post;
  late final PostProvider _postProvider;
  late final UserPostActionProvider _userPostActionProvider;

  late Comment comment;
  late final CommentProvider _commentProvider;

  late final UserCommentActionProvider _userCommentActionProvider;

  @override
  void initState() {
    if (widget.post != null) {
      post = widget.post!;
    } else {
      comment = widget.comment!;
    }

    _postProvider = context.read<PostProvider>();
    _userPostActionProvider = context.read<UserPostActionProvider>();

    _commentProvider = context.read<CommentProvider>();
    _userCommentActionProvider = context.read<UserCommentActionProvider>();

    loadUserAction();

    super.initState();
  }

  @override
  void didUpdateWidget(LikeDislikeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.post != oldWidget.post) {
      post = widget.post!;
      loadUserAction();
    }
  }

  void loadUserAction() async {
    String? action;
    if (widget.post != null) {
      action = await _userPostActionProvider.getUserAction(widget.post!.id!);
    } else {
      action =
          await _userCommentActionProvider.getUserAction(widget.comment!.id!);
    }

    if (mounted) {
      setState(() {
        userAction = action ?? 'none';
      });
    }
  }

  void _toggleLike() async {
    if (widget.post != null) {
      await _postProvider.toggleLike(post);
    } else {
      await _commentProvider.toggleLike(comment);
    }

    loadUserAction();
  }

  void _toggleDislike() async {
    if (widget.post != null) {
      await _postProvider.toggleDislike(post);
    } else {
      await _commentProvider.toggleDislike(comment);
    }

    loadUserAction();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: _toggleLike,
              child: Icon(
                userAction == 'like'
                    ? Icons.thumb_up_rounded
                    : Icons.thumb_up_off_alt,
                color: userAction == 'like'
                    ? Palette.turquoiseLight
                    : Palette.lightPurple,
              ),
            ),
            const SizedBox(width: 5),
            (widget.post != null)
                ? Text("${post.likesCount}")
                : Text("${comment.likesCount}"),
          ],
        ),
        const SizedBox(width: 25),
        Row(
          children: [
            GestureDetector(
              onTap: _toggleDislike,
              child: Icon(
                userAction == 'dislike'
                    ? Icons.thumb_down_rounded
                    : Icons.thumb_down_off_alt,
                color: userAction == 'dislike'
                    ? Palette.lightRed
                    : Palette.lightPurple,
              ),
            ),
            const SizedBox(width: 5),
            (widget.post != null)
                ? Text("${post.dislikesCount}")
                : Text("${comment.dislikesCount}"),
          ],
        ),
      ],
    );
  }
}
