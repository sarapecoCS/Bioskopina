import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../providers/comment_provider.dart';
import '../providers/post_provider.dart';
import '../providers/user_provider.dart';
import '../screens/post_detail_screen.dart';
import '../widgets/like_dislike_button.dart';
import '../models/comment.dart';
import '../models/post.dart';
import '../models/search_result.dart';
import '../models/user.dart';
import '../utils/colors.dart';
import '../utils/util.dart';

// ignore: must_be_immutable
class ContentCard extends StatefulWidget {
  Post? post;
  final Comment? comment;
  final Color? cardColor;
  final bool? navigateToPostDetails;
  final int? contentMaxLines;
  final bool? largeProfilePhoto;
  final ValueChanged<Post>? onPostUpdated;
  final bool? hidePopupMenuButton;

  ContentCard({
    super.key,
    this.post,
    this.comment,
    this.cardColor,
    this.navigateToPostDetails = true,
    this.contentMaxLines = 3,
    this.largeProfilePhoto,
    this.onPostUpdated,
    this.hidePopupMenuButton,
  })  : assert(post != null || comment != null,
            "Either post or comment must be provided."),
        assert(!(post != null && comment != null),
            "Only one of post or comment can be provided.");

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  late final UserProvider _userProvider;
  late Future<SearchResult<User>> _userFuture;
  bool isExpanded = false;
  bool isOverflowing = false;
  late final PostProvider _postProvider;
  late final CommentProvider _commentProvider;
  final GlobalKey<LikeDislikeButtonState> _likeDislikeButtonKey =
      GlobalKey<LikeDislikeButtonState>();
  late Post _post;

  @override
  void initState() {
    if (widget.post != null) {
      _post = widget.post!;
    }

    _userProvider = context.read<UserProvider>();
    _userFuture = _userProvider.get(filter: {
      "Id": (widget.post != null)
          ? "${widget.post!.userId}"
          : "${widget.comment!.userId}",
      "ProfilePictureIncluded": "true"
    });

    _postProvider = context.read<PostProvider>();
    _commentProvider = context.read<CommentProvider>();

    _commentProvider.addListener(() {
      _reloadPost();
    });

    super.initState();
  }

  void _reloadPost() async {
    if (mounted && widget.post != null) {
      var updatedPost = await _postProvider.get(
          filter: {"Id": "${widget.post!.id}", "CommentsIncluded": "true"});

      if (updatedPost.count == 1) {
        setState(() {
          widget.post!.likesCount = updatedPost.result.single.likesCount;
          widget.post!.dislikesCount = updatedPost.result.single.dislikesCount;
          widget.post!.comments = updatedPost.result.single.comments;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    double cardWidth = screenSize.width * 0.95;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Palette.lightPurple.withOpacity(0.3)),
          color: widget.cardColor ?? Palette.darkPurple,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  _buildCardTop(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final text = widget.post != null
                            ? widget.post!.content!
                            : widget.comment!.content!;
                        final textSpan = TextSpan(
                            text: text,
                            style:
                                const TextStyle(fontWeight: FontWeight.w500));
                        final textPainter = TextPainter(
                          text: textSpan,
                          maxLines: widget.contentMaxLines,
                          textDirection: ui.TextDirection.ltr,
                        )..layout(maxWidth: constraints.maxWidth);

                        isOverflowing = textPainter.didExceedMaxLines;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                text,
                                overflow: TextOverflow.ellipsis,
                                maxLines:
                                    isExpanded ? 10000 : widget.contentMaxLines,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            if (isOverflowing)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isExpanded = !isExpanded;
                                  });
                                },
                                child: isExpanded
                                    ? const Text("See less",
                                        style: TextStyle(
                                            color: Palette.lightYellow))
                                    : const Text(
                                        "See more",
                                        style: TextStyle(color: Palette.rose),
                                      ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      widget.post != null
                          ? LikeDislikeButton(
                              key: _likeDislikeButtonKey, post: _post)
                          : LikeDislikeButton(comment: widget.comment!),
                      const SizedBox(width: 25),
                      (widget.post != null)
                          ? GestureDetector(
                              onTap: () async {
                                if (widget.post != null &&
                                    widget.navigateToPostDetails == true) {
                                  final currentPost =
                                      await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PostDetailScreen(post: _post),
                                    ),
                                  );

                                  final updatedPost =
                                      await _postProvider.get(filter: {
                                    "Id": "${(currentPost as Post).id!}",
                                    "CommentsIncluded": "true",
                                  });

                                  if (widget.onPostUpdated != null) {
                                    setState(() {
                                      _post = updatedPost.result.single;
                                    });

                                    widget.onPostUpdated!(_post);
                                    _likeDislikeButtonKey.currentState
                                        ?.loadUserAction();
                                  }
                                }
                              },
                              child: Container(
                                  padding: const EdgeInsets.only(
                                    left: 6,
                                    right: 6,
                                    top: 3,
                                    bottom: 3,
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Palette.lightPurple
                                              .withOpacity(0.1)),
                                      color:
                                          Palette.lightPurple.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: (_post.comments!.length == 1)
                                      ? Text("${_post.comments!.length} Reply")
                                      : Text(
                                          "${_post.comments!.length} Replies")))
                          : const Text(""),
                    ],
                  ),
                  (widget.hidePopupMenuButton != true)
                      ? _showPopup()
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ).asGlass(
        blurY: 3,
        blurX: 3,
        clipBorderRadius: BorderRadius.circular(15),
        tintColor: Palette.midnightPurple,
      ),
    );
  }

  Padding _buildCardTop() {
    if (widget.largeProfilePhoto == true) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                _buildUsername(),
              ],
            )
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildUsername(),
          (widget.largeProfilePhoto != true)
              ? Text(widget.post != null
                  ? DateFormat('MMM d, y').format(widget.post!.datePosted!)
                  : DateFormat('MMM d, y')
                      .format(widget.comment!.dateCommented!))
              : const Text(""),
        ],
      ),
    );
  }

  Widget _buildUsername() {
    final Size screenSize = MediaQuery.of(context).size;
    double cardWidth = screenSize.width * 0.95;

    return FutureBuilder<SearchResult<User>>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildProgressIndicator(cardWidth);
            // Loading state
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Error state
          } else {
            // Data loaded successfully
            var user = snapshot.data!;
            if (user.count == 1 && widget.largeProfilePhoto != true) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.memory(
                      imageFromBase64String(
                          user.result.single.profilePicture!.profilePicture!),
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 150),
                    child: Text("${user.result.single.username}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              );
            } else if (user.count == 1 && widget.largeProfilePhoto == true) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.memory(
                      imageFromBase64String(
                          user.result.single.profilePicture!.profilePicture!),
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxWidth: 230),
                        child: Text("${user.result.single.username}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17)),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.post != null
                            ? DateFormat('MMM d, y')
                                .format(widget.post!.datePosted!)
                            : DateFormat('MMM d, y')
                                .format(widget.comment!.dateCommented!),
                      ),
                    ],
                  ),
                ],
              );
            }
            return const Text("User not found");
          }
        });
  }

  Widget _buildProgressIndicator(double cardWidth) {
    if (widget.largeProfilePhoto == true) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
                  height: 64,
                  width: 64,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(100)))
              .asGlass(
            tintColor: Palette.lightPurple,
            clipBorderRadius: BorderRadius.circular(100),
            blurX: 3,
            blurY: 3,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 5),
              Shimmer.fromColors(
                baseColor: Palette.lightPurple,
                highlightColor: Palette.white,
                child: Container(
                  constraints: BoxConstraints(maxWidth: cardWidth * 0.3),
                  child: const SizedBox(
                    width: 150,
                    height: 15,
                  ).asGlass(),
                ).asGlass(
                    clipBorderRadius: BorderRadius.circular(4),
                    tintColor: Palette.lightPurple),
              ),
              const SizedBox(height: 8),
              Shimmer.fromColors(
                baseColor: Palette.lightPurple,
                highlightColor: Palette.white,
                child: SizedBox(
                  width: cardWidth * 0.25,
                  height: 10,
                ).asGlass(
                  clipBorderRadius: BorderRadius.circular(3),
                  tintColor: Palette.lightPurple,
                ),
              ),
            ],
          ),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
                height: 32,
                width: 32,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(100)))
            .asGlass(
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
            constraints: BoxConstraints(maxWidth: cardWidth * 0.3),
            child: const SizedBox(
              width: 150,
              height: 12,
            ).asGlass(),
          ).asGlass(
              clipBorderRadius: BorderRadius.circular(4),
              tintColor: Palette.lightPurple),
        ),
      ],
    );
  }

  Widget _buildPopupMenu(dynamic object) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Palette.darkPurple.withOpacity(0.8),
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
        color: Palette.darkPurple,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              hoverColor: Palette.lightRed.withOpacity(0.1),
              leading: Icon(Icons.delete, color: Palette.lightRed, size: 24),
              title: const Text('Delete',
                  style: TextStyle(color: Palette.lightRed)),
              onTap: () {
                Navigator.pop(context);
                showConfirmationDialog(
                    context,
                    const Icon(Icons.warning_rounded,
                        color: Palette.lightRed, size: 55),
                    (widget.post != null)
                        ? const Text(
                            "Are you sure you want to delete this post?",
                            textAlign: TextAlign.center,
                          )
                        : const Text(
                            "Are you sure you want to delete this comment?",
                            textAlign: TextAlign.center,
                          ), () async {
                  try {
                    if (widget.post != null) {
                      await _postProvider.delete((object as Post).id!);
                    } else {
                      await _commentProvider.delete((object as Comment).id!);
                    }
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

  Widget _showPopup() {
    if (widget.post != null && widget.post!.userId == LoggedUser.user!.id) {
      return Container(child: _buildPopupMenu(widget.post));
    } else if (widget.comment != null &&
        widget.comment!.userId == LoggedUser.user!.id) {
      return Container(child: _buildPopupMenu(widget.comment));
    }

    return const Text("");
  }
}
