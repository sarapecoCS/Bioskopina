import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/post_provider.dart';
import '../screens/post_detail_screen.dart';
import '../widgets/master_screen.dart';
import '../models/post.dart';
import '../models/search_result.dart';
import '../models/user.dart';
import '../utils/colors.dart';
import '../utils/util.dart';
import '../widgets/circular_progress_indicator.dart';
import '../widgets/pagination_buttons.dart';
import 'dart:convert';
import 'dart:typed_data';

Uint8List imageFromBase64String(String base64String) {
  return base64Decode(base64String);
}

// ignore: must_be_immutable
class PostsScreen extends StatefulWidget {
  User user;
  PostsScreen({super.key, required this.user});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late PostProvider _postProvider;
  late Future<SearchResult<Post>> _postFuture;
  int? ownerId;

  int page = 0;
  int pageSize = 6;
  int totalItems = 0;

  @override
  void initState() {
    _postProvider = context.read<PostProvider>();
    _postFuture = _postProvider.get(filter: {
      "UserId": "${widget.user.id}",
      "NewestFirst": "true",
      "CommentsIncluded": "true",
      "Page": "$page",
      "PageSize": "$pageSize"
    });

    _postProvider.addListener(() {
      _reloadData();
      setTotalItems();
    });

    setTotalItems();

    super.initState();
  }

  void _reloadData() {
    if (mounted) {
      setState(() {
        _postFuture = _postProvider.get(filter: {
          "UserId": "${widget.user.id}",
          "NewestFirst": "true",
          "CommentsIncluded": "true",
          "Page": "$page",
          "PageSize": "$pageSize"
        });
      });
    }
  }

  void setTotalItems() async {
    var postResult = await _postFuture;

    if (mounted) {
      setState(() {
        totalItems = postResult.count;
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
          const Text("Posts"),
          const SizedBox(width: 5),
          Icon(Icons.post_add, size: 24),
        ],
      ),
      showBackArrow: true,
      child: FutureBuilder<SearchResult<Post>>(
        future: _postFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MyProgressIndicator(); // Loading state
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Error state
          } else {
            // Data loaded successfully
            var postList = snapshot.data!.result;
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Wrap(
                      children: _buildPostCards(postList),
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
      var result = await _postProvider.get(
        filter: {
          "UserId": "${widget.user.id}",
          "NewestFirst": "true",
          "CommentsIncluded": "true",
          "Page": "$requestedPage",
          "PageSize": "$pageSize",
        },
      );

      if (mounted) {
        setState(() {
          _postFuture = Future.value(result);
          page = requestedPage;
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
          (index) => _buildPostCard(postList[index]),
    );
  }

  Widget _buildPostCard(Post post) {
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
                            Text(
                              DateFormat('MMM d, y').format(post.datePosted!),
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildPopupMenu(post)
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
                          "${post.content}",
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
                            Text("${post.likesCount}")
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Row(
                          children: [
                            const Icon(Icons.thumb_down_rounded),
                            const SizedBox(width: 5),
                            Text("${post.dislikesCount}")
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: () async {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => PostDetailScreen(
                                        post: post,
                                        ownerId: ownerId!,
                                      )));
                                },
                                child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Text("${post.comments?.length} replies"))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ])),
      ),
    );
  }

  ConstrainedBox _buildPopupMenu(Post post) {
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
              icon: const Icon(Icons.more_vert_rounded, color: Colors.white), // Icon color white
              splashRadius: 1,
              padding: EdgeInsets.zero,
              color: Colors.black, // Set the background color to black
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'delete',
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    tileColor: Colors.black, // Set the item background color to black
                    hoverColor: Palette.lightRed.withOpacity(0.1),
                    leading: const Icon(Icons.delete, size: 24, color: Colors.red), // Icon color white
                    title: const Text(
                      'Delete',
                      style: TextStyle(color: Palette.lightRed), // Title text color
                    ),
                    subtitle: Text(
                      'Delete permanently',
                      style: TextStyle(
                        color: Palette.lightRed.withOpacity(0.5), // Subtitle text color
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      showConfirmationDialog(
                        context,
                        const Icon(Icons.warning_rounded, color: Palette.lightRed, size: 55),
                        const Text("Are you sure you want to delete this post?"),
                        () async {
                          await _postProvider.delete(post.id!);
                          // Show success dialog after delete
                          showDeleteSuccessDialog(context);
                        },
                      );
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

void showConfirmationDialog(BuildContext context, Icon icon, Text text, VoidCallback onConfirm) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: icon,
        content: text,
        actions: [
          // Centered Row with space between buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // "No" button - Green
              Container(
                decoration: BoxDecoration(

                    color: const Color(0xFF15543F),

                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("No", style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 20), // Adds space between the buttons
              // "Yes" button - Blue Gradient
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                                     colors: [
                                       Color.fromRGBO(163, 212, 255, 1.0),  // Light Blue
                                       Color.fromRGBO(7, 44, 109, 1.0),    // Muted Dark Blue
                                     ],
                                     begin: Alignment.topLeft,
                                     end: Alignment.bottomRight,
                                   ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirm();
                  },
                  child: const Text("Yes", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

void showDeleteSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,

        content: const Text("Post deleted successfully", style: TextStyle(color: Colors.white)),
        actions: [
          // "OK" button with normal white text and no background
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );


}


}
