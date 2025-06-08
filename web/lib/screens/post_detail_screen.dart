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
import '../screens/user_detail_screen.dart';
import 'dart:convert';
import 'dart:typed_data';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  final int ownerId;

  PostDetailScreen({super.key, required this.post, required this.ownerId});

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
    super.initState();
    _userProvider = context.read<UserProvider>();
    _commentProvider = context.read<CommentProvider>();
    _postProvider = context.read<PostProvider>();

    _commentFuture = _commentProvider.get(filter: {
      "PostId": "${widget.post.id}",
      "NewestFirst": "true",
      "Page": "$page",
      "PageSize": "$pageSize",
    });

    _commentProvider.addListener(() {
      _reloadComments();
      setTotalItems();
    });

    replies = widget.post.comments?.length;
    setTotalItems();
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
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
      child: Container(
        constraints: BoxConstraints(maxWidth: 800), // Set a maxWidth
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Palette.darkPurple, Palette.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              offset: Offset(0, 10),
              blurRadius: 20,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title is removed here per your request
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/images/movie_icon.png', // Replace with your asset path
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              // Movie content description only
              Text(
                post.content ?? "No Content",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
              if (post.datePosted != null)
                Text(
                  DateFormat('MMM d, y').format(post.datePosted!),
                  style: TextStyle(
                    fontSize: 16,
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
        children: [
          Icon(Icons.post_add, size: 22, color: Colors.white),
          const SizedBox(width: 5),
          const Text(
            "Post",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      showBackArrow: true,
      child: Center(
        child: SingleChildScrollView( // Wrapping the content with SingleChildScrollView
          child: Column(
            children: [
              _buildPost(widget.post),
            ],
          ),
        ),
      ),
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
