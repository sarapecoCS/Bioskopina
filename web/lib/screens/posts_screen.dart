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

class PostsScreen extends StatefulWidget {
  final User user;
  const PostsScreen({super.key, required this.user});

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
    super.initState();
    _postProvider = context.read<PostProvider>();
    _loadPosts();
    _postProvider.addListener(_onPostProviderChanged);
  }

  void _loadPosts() {
    _postFuture = _postProvider.get(filter: {
      "UserId": "${widget.user.id}",
      "NewestFirst": "true",
      "CommentsIncluded": "true",
      "Page": "$page",
      "PageSize": "$pageSize"
    });
    _postFuture.then((result) {
      if (mounted) {
        setState(() {
          totalItems = result.count;
        });
      }
    });
  }

  void _onPostProviderChanged() {
    if (mounted) {
      _loadPosts();
    }
  }

  @override
  void dispose() {
    _postProvider.removeListener(_onPostProviderChanged);
    super.dispose();
  }

  void _confirmDeletePost(Post post) {
    showConfirmationDialog(
      context,
      const Icon(Icons.warning_rounded, color: Palette.lightRed, size: 55),
      const Text("Are you sure you want to delete this post?"),
      () async {
        await _postProvider.delete(post.id!);
        Navigator.pop(context);
        showDeletedSuccessDialog(context);
        _loadPosts();
      },
    );
  }

  void _reloadData() {
    _loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (widget.user.profilePicture?.profilePicture != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.memory(
                imageFromBase64String(widget.user.profilePicture!.profilePicture!),
                width: 25,
                height: 25,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(width: 5),
          Text("${widget.user.username}: "),
          const SizedBox(width: 5),
          const Text("Posts"),
          const SizedBox(width: 5),
          const Icon(Icons.post_add, size: 24),
        ],
      ),
      showBackArrow: true,
      child: FutureBuilder<SearchResult<Post>>(
        future: _postFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MyProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final postList = snapshot.data!.result;
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Wrap(
                      children: postList.map((post) => _buildPostCard(post)).toList(),
                    ),
                    MyPaginationButtons(
                      page: page,
                      pageSize: pageSize,
                      totalItems: totalItems,
                      fetchPage: _fetchPage,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _fetchPage(int requestedPage) async {
    try {
      final result = await _postProvider.get(filter: {
        "UserId": "${widget.user.id}",
        "NewestFirst": "true",
        "CommentsIncluded": "true",
        "Page": "$requestedPage",
        "PageSize": "$pageSize",
      });

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

  Widget _buildPostCard(Post post) {
    final isHighlyDisliked = (post.dislikesCount ?? 0) >= 5;
    final hasNegativeFeedback = (post.dislikesCount ?? 0) >= 3;

    return Container(
      width: 600,
      margin: const EdgeInsets.only(top: 20, right: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Palette.darkPurple,
        border: hasNegativeFeedback
            ? Border.all(
                color: isHighlyDisliked ? Colors.red : Colors.orange,
                width: 1)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.memory(
                  imageFromBase64String(widget.user.profilePicture!.profilePicture!),
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.user.firstName} ${widget.user.lastName}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      DateFormat('MMM d, y').format(post.datePosted!),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              _buildPopupMenu(post),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            post.content ?? '',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildReactionCount(Icons.thumb_up, post.likesCount ?? 0),
              const SizedBox(width: 16),
              _buildReactionCount(
                Icons.thumb_down,
                post.dislikesCount ?? 0,
                isNegative: hasNegativeFeedback,
                isCritical: isHighlyDisliked,
              ),
              const SizedBox(width: 16),
              Text(
                "${post.comments?.length ?? 0} replies",
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
          if (hasNegativeFeedback) _buildDislikeWarning(post),
        ],
      ),
    );
  }

  Widget _buildReactionCount(IconData icon, int count, {
    bool isNegative = false,
    bool isCritical = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: isNegative ? (isCritical ? Colors.red : Colors.orange) : null,
        ),
        const SizedBox(width: 4),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 13,
            color: isNegative ? (isCritical ? Colors.red : Colors.orange) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDislikeWarning(Post post) {
    final isHighlyDisliked = (post.dislikesCount ?? 0) >= 5;
    final color = isHighlyDisliked ? Colors.red : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Negative feedback: ${post.dislikesCount} dislikes',
              style: TextStyle(fontSize: 12, color: color),
            ),
          ),


        ],
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
              icon: const Icon(Icons.more_vert_rounded),
              splashRadius: 1,
              padding: EdgeInsets.zero,
              color: Colors.black,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.3),
                    ),
                    hoverColor: Palette.lightRed.withOpacity(0.1),
                   leading: const Icon(
                     Icons.delete,
                     color: Colors.red,
                     size: 24,
                   ),

                    title: const Text(
                      'Delete',
                      style: TextStyle(color: Palette.lightRed),
                    ),
                    subtitle: Container(
                      child: Text(
                        'Delete permanently',
                        style: TextStyle(color: Palette.lightRed.withOpacity(0.5)),
                      ),
                    ),
                    onTap: () async {
                      // Show confirmation dialog
                      showConfirmationDialog(
                        context,
                        const Icon(Icons.warning_rounded, color: Palette.lightRed, size: 55),
                        const Text("Are you sure you want to delete this post?"),
                        () async {
                          // On confirm delete:
                          await _postProvider.delete(post.id!);

                          Navigator.pop(context); // Close confirmation dialog
                          showDeletedSuccessDialog(context); // Show success dialog
                          _reloadData(); // Refresh UI or data after delete
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

  void showDeletedSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.grey.withOpacity(0.5), // light grey border
              width: 1.5,
            ),
          ),
          backgroundColor: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.task_alt,
                  color: Color.fromRGBO(102, 204, 204, 1),
                  size: 50,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Deleted successfully!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 80,
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: Palette.buttonGradient,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}