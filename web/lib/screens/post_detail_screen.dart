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
import 'dart:convert';
import 'dart:typed_data';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  final int ownerId;

  const PostDetailScreen({
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

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
    _commentProvider = context.read<CommentProvider>();
    _postProvider = context.read<PostProvider>();

    _commentFuture = _commentProvider.get(filter: {
      "PostId": "${widget.post.id}",
      "NewestFirst": "true",
      "Page": "0",
      "PageSize": "15",
    });
  }

  Widget _buildPost(Post post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Palette.darkPurple, Palette.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              offset: const Offset(0, 8),
              blurRadius: 16,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [




              // Single Caption (Post Content)
              Text(
                post.content ?? "No content available.",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 15),

              // Date if available
              if (post.datePosted != null)
                Text(
                  DateFormat('MMM d, y').format(post.datePosted!),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white54,
                    fontStyle: FontStyle.italic,
                  ),
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
        children: const [
          Icon(Icons.post_add, size: 22, color: Colors.white),
          SizedBox(width: 5),
          Text(
            "Post Details",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      showBackArrow: true,
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: _buildPost(widget.post),
        ),
      ),
    );
  }

  void showErrorDialog(BuildContext context, dynamic error) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(error.toString()),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.black,
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.task_alt_rounded,
                color: Color.fromRGBO(102, 204, 204, 1), size: 64),
            SizedBox(height: 10),
            Text(
              'Success',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}