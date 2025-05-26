import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screens/post_detail_screen.dart';
import '../models/post.dart';
import '../providers/comment_provider.dart';
import '../providers/post_provider.dart';
import '../utils/colors.dart';
import '../widgets/master_screen.dart';
import '../models/comment.dart';
import '../models/search_result.dart';
import '../models/user.dart';
import '../utils/util.dart';
import '../widgets/circular_progress_indicator.dart';
import '../widgets/pagination_buttons.dart';
import 'dart:convert';
import 'dart:typed_data';

Uint8List imageFromBase64String(String base64String) {
  return base64Decode(base64String);
}

// ignore: must_be_immutable
class CommentsScreen extends StatefulWidget {
  User user;
  CommentsScreen({super.key, required this.user});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late CommentProvider _commentProvider;
  late Future<SearchResult<Comment>> _commentFuture;
  late PostProvider _postProvider;
  Post? post;

  int page = 0;
  int pageSize = 6;
  int totalItems = 0;

  @override
  void initState() {
    _commentProvider = context.read<CommentProvider>();
    _commentFuture = _commentProvider.get(filter: {
      "UserId": "${widget.user.id}",
      "NewestFirst": "true",
      "Page": "$page",
      "PageSize": "$pageSize"
    });

    _postProvider = context.read<PostProvider>();

    _commentProvider.addListener(() {
      _reloadData();
      setTotalItems();
    });

    setTotalItems();

    super.initState();
  }

  void _reloadData() {
    if (mounted) {
      setState(() {
        _commentFuture = _commentProvider.get(filter: {
          "UserId": "${widget.user.id}",
          "NewestFirst": "true",
          "Page": "$page",
          "PageSize": "$pageSize"
        });
      });
    }
  }

  void setTotalItems() async {
    var commentResult = await _commentFuture;
    if (mounted) {
      setState(() {
        totalItems = commentResult.count;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          widget.user.profilePicture!.profilePicture != null
              ? ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.memory(
              imageFromBase64String(
                  widget.user.profilePicture!.profilePicture!),
              width: 25,
              height: 25,
              fit: BoxFit.cover,
            ),
          )
              : const Text(""),
          const SizedBox(width: 5),
          Text("${widget.user.username}: "),
          const SizedBox(width: 5),
          const Text("Comments"),
          const SizedBox(width: 8),
          Icon(Icons.comment, size: 20),
        ],
      ),
      showBackArrow: true,
      child: FutureBuilder<SearchResult<Comment>>(
        future: _commentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MyProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var commentList = snapshot.data!.result;
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Wrap(
                      children: _buildCommentCards(commentList),
                    ),
                    MyPaginationButtons(
                        page: page,
                        pageSize: pageSize,
                        totalItems: totalItems,
                        fetchPage: fetchPage),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> fetchPage(int requestedPage) async {
    try {
      var result = await _commentProvider.get(
        filter: {
          "UserId": "${widget.user.id}",
          "NewestFirst": "true",
          "Page": "$requestedPage",
          "PageSize": "$pageSize",
        },
      );

      if (mounted) {
        setState(() {
          _commentFuture = Future.value(result);
          page = requestedPage;
        });
      }
    } on Exception catch (e) {
      if (mounted) {
        showErrorDialog(context, e);
      }
    }
  }

  List<Widget> _buildCommentCards(List<Comment> commentList) {
    return List.generate(
      commentList.length,
          (index) => _buildCommentCard(commentList[index]),
    );
  }

  Widget _buildCommentCard(Comment comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0, right: 20, top: 20),
      child: Container(
        constraints: const BoxConstraints(minHeight: 100, maxHeight: 300),
        height: 215,
        width: 600,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Palette.darkPurple),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.memory(
                            imageFromBase64String(
                                widget.user.profilePicture!.profilePicture!),
                            width: 43,
                            height: 43,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            constraints: const BoxConstraints(maxWidth: 350),
                            child: Text(
                                "${widget.user.firstName} ${widget.user.lastName}",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                          ),
                          FutureBuilder<SearchResult<Post>>(
                              future: _postProvider.get(filter: {
                                "Id": "${comment.postId!}",
                                "CommentsIncluded": "True"
                              }),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const MyProgressIndicator(
                                    width: 10,
                                    height: 10,
                                    strokeWidth: 2,
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  Post? postObj = snapshot.data?.result.first;

                                  if (postObj != null) {
                                    post = postObj;
                                    return GestureDetector(
                                      onTap: () async {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PostDetailScreen(
                                                  post: postObj,
                                                  ownerId: postObj.userId!,
                                                ),
                                          ),
                                        );
                                      },
                                      child: const MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: Text("Post"),
                                      ),
                                    );
                                  } else {
                                    return const Text("Post not found");
                                  }
                                }
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        DateFormat('MMM d, y').format(
                          comment.dateCommented!,
                        ),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
                _buildPopupMenu(comment)
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                alignment: Alignment.topLeft,
                constraints:
                const BoxConstraints(minHeight: 30, maxHeight: 100),
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Column(
                    children: [
                      Text(
                        "${comment.content}",
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              constraints: const BoxConstraints(maxHeight: 30),
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                          const Icon(Icons.thumb_up_rounded),
                          const SizedBox(width: 5),
                          Text("${comment.likesCount}")
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                          const Icon(Icons.thumb_down_rounded),
                          const SizedBox(width: 5),
                          Text("${comment.dislikesCount}")
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  ConstrainedBox _buildPopupMenu(Comment comment) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 23),
      child: Container(
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            PopupMenuButton<String>(
              tooltip: "More actions",
              offset: const Offset(195, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Palette.lightPurple.withOpacity(0.3)),
              ),
              icon: const Icon(Icons.more_vert_rounded),
              splashRadius: 1,
              padding: EdgeInsets.zero,
              color: const Color.fromRGBO(50, 48, 90, 1),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hoverColor: Palette.lightRed.withOpacity(0.1),
                    leading: Icon(Icons.delete, size: 24),

                    title: const Text('Delete',
                        style: TextStyle(color: Palette.lightRed)),
                    subtitle: Text('Delete permanently',
                        style: TextStyle(
                            color: Palette.lightRed.withOpacity(0.5))),
                    onTap: () async {
                      Navigator.pop(context);
                      showConfirmationDialog(
                          context,
                          const Icon(Icons.warning_rounded,
                              color: Palette.lightRed, size: 55),
                          const Text(
                              "Are you sure you want to delete this comment?"),
                              () async {
                            await _commentProvider.delete(comment.id!);
                          });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
