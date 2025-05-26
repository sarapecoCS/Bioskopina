import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/comment.dart';
import '../providers/comment_provider.dart';
import '../models/post.dart';
import '../models/search_result.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../providers/post_provider.dart';
import '../utils/colors.dart';
import '../widgets/circular_progress_indicator.dart';
import '../widgets/master_screen.dart';
import '../widgets/pagination_buttons.dart';
import '../widgets/separator.dart';
import '../screens/user_detail_screen.dart';
import 'dart:convert';
import 'dart:typed_data';


// ignore: must_be_immutable
class PostDetailScreen extends StatefulWidget {
  Post post;
  int ownerId;
  PostDetailScreen({
  super.key,
  required this.post,
  required this.ownerId,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

Uint8List imageFromBase64String(String base64String) {
  return base64Decode(base64String);
}
class _PostDetailScreenState extends State<PostDetailScreen> {
  late UserProvider _userProvider;
  late CommentProvider _commentProvider;
  late Future<SearchResult<Comment>> _commentFuture;
  late PostProvider _postProvider;

  int page = 0;
  int pageSize = 15;
  int totalItems = 0;
  int? replies;

  @override
  void initState() {
    _userProvider = context.read<UserProvider>();
    _commentProvider = context.read<CommentProvider>();
    _commentFuture = _commentProvider.get(filter: {
      "PostId": "${widget.post.id}",
      "NewestFirst": "true",
      "Page": "$page",
      "PageSize": "$pageSize",
    });
    _postProvider = context.read<PostProvider>();

    _commentProvider.addListener(() {
      _reloadComments();
      setTotalItems();
    });

    replies = widget.post.comments!.length;
    setTotalItems();

    super.initState();
  }

  void _reloadComments() async {
    var commentsList = _commentProvider.get(filter: {
      "PostId": "${widget.post.id}",
      "NewestFirst": "true",
      "Page": "$page",
      "PageSize": "$pageSize",
    });

    var tmp = await _commentProvider.get(filter: {
      "PostId": "${widget.post.id}",
    });

    replies = tmp.result.length;

    if (mounted) {
      setState(() {
        _commentFuture = commentsList;
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

  Future<void> fetchPage(int requestedPage) async {
    try {
      var result = await _commentProvider.get(
        filter: {
          "PostId": "${widget.post.id}",
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

  Widget _buildPost(Post post) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Palette.lightPurple,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.content ?? "No Title",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Here you can decide if you want to show the content or some other detail
              Text(
                post.content ?? "No Content",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              if (post.datePosted != null)
                Text(
                  DateFormat('MMM d, y').format(post.datePosted!),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: Row(
        children: [
          Icon(Icons.post_add, size: 22),
          const SizedBox(width: 5),
          const Text("Post"),
        ],
      ),
      showBackArrow: true,
      child: Center(
        child: Column(
          children: [
            _buildPost(widget.post),
            MySeparator(
              width: 824,
              opacity: 0.5,
              paddingTop: 20,
              paddingBottom: 5,
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "Comments",
                style: TextStyle(fontSize: 20),
              ),
            ),
            FutureBuilder<SearchResult<Comment>>(
                future: _commentFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const MyProgressIndicator(); // Loading state
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}'); // Error state
                  } else {
                    // Data loaded successfully
                    var commentsList = snapshot.data!.result;
                    return Expanded(
                      child: SingleChildScrollView(
                        controller: ScrollController(),
                        child: Column(
                          children: [
                            Column(
                              children: _buildCommentCards(commentsList),
                            ),
                            MyPaginationButtons(
                              page: page,
                              pageSize: pageSize,
                              totalItems: totalItems,
                              fetchPage: fetchPage,
                              noResults: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "No one has commented under this post yet...",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontStyle: FontStyle.italic,
                                    color: Palette.lightPurple.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCommentCards(List<Comment> commentList) {
    return List.generate(
      commentList.length,
          (index) => _buildComment(commentList[index]),
    );
  }

  Widget _buildComment(Comment comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: 804,
        decoration: BoxDecoration(
          color: Palette.darkPurple,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<SearchResult<User>>(
                    future: _userProvider.get(filter: {
                      "Id": "${comment.userId}",
                      "ProfilePictureIncluded": "true"
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const MyProgressIndicator(); // Loading state
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}'); // Error state
                      } else {
                        // Data loaded successfully
                        User user = snapshot.data!.result.first;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.memory(
                                  imageFromBase64String(
                                      user.profilePicture!.profilePicture!),
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UserDetailScreen(user: user)));
                                  },
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Text(
                                      "${user.username}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                                Text(
                                  DateFormat('MMM d, y')
                                      .format(comment.dateCommented!),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            )
                          ],
                        );
                      }
                    },
                  ),
                  _buildPopupMenu(comment)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    // ignore: sized_box_for_whitespace
                    Container(
                      width: 774,
                      height: 70,
                      child: SingleChildScrollView(
                        controller: ScrollController(),
                        child: Text(
                          "${comment.content}",
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopupMenu(Comment comment) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert),
      onSelected: (item) {
        switch (item) {
          case 0:
            _showDeleteDialog(comment);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<int>(
          value: 0,
          child: Text("Delete"),
        ),
      ],
    );
  }

  void _showDeleteDialog(Comment comment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Comment'),
          content: const Text('Are you sure you want to delete this comment?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await _commentProvider.delete(comment.id!);
                  setState(() {
                    widget.post.comments!.remove(comment);
                    replies = widget.post.comments!.length;
                  });
                  Navigator.pop(context);
                } catch (e) {
                  showErrorDialog(context, e);
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Handle errors
  void showErrorDialog(BuildContext context, dynamic error) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(error.toString()),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
