
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/bioskopina_provider.dart';
import '../providers/comment_provider.dart';
import '../providers/post_provider.dart';
import '../providers/rating_provider.dart';
import '../screens/comments_screen.dart';
import '../screens/posts_screen.dart';
import '../screens/reviews_screen.dart';
import '../widgets/master_screen.dart';
import '../widgets/separator.dart';
import '../models/comment.dart';
import '../models/post.dart';
import '../models/rating.dart';
import '../models/search_result.dart';
import '../models/user.dart';
import '../utils/colors.dart';
import '../utils/util.dart';
import '../widgets/circular_progress_indicator.dart';
import 'dart:convert';
import 'dart:typed_data';

Uint8List imageFromBase64String(String base64String) {
  return base64Decode(base64String);
}

class UserDetailScreen extends StatefulWidget {
  final User user;
  const UserDetailScreen({super.key, required this.user});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late RatingProvider _ratingProvider;
  late Future<SearchResult<Rating>> _ratingFuture;
  late Future<SearchResult<Post>> _postFuture;
  late Future<SearchResult<Comment>> _commentFuture;
  late PostProvider _postProvider;
  late CommentProvider _commentProvider;
  late MovieProvider _movieProvider;

  Rating? rating;
  Post? post;
  Comment? comment;

  @override
  void initState() {
    super.initState();

    _ratingProvider = context.read<RatingProvider>();
    _ratingFuture = _ratingProvider.get(filter: {
      "UserId": "${widget.user.id}",
      "NewestFirst": "true",
      "Page": "0",
      "PageSize": "1"
    });

    _postProvider = context.read<PostProvider>();
    _postFuture = _postProvider.get(filter: {
      "UserId": "${widget.user.id}",
      "NewestFirst": "true",
      "Page": "0",
      "PageSize": "1"
    });

    _commentProvider = context.read<CommentProvider>();
    _commentFuture = _commentProvider.get(filter: {
      "UserId": "${widget.user.id}",
      "NewestFirst": "true",
      "Page": "0",
      "PageSize": "1"
    });

    _ratingProvider.addListener(_reloadReview);
    _postProvider.addListener(() {
      _reloadPost();
      _reloadComment();
    });
    _commentProvider.addListener(_reloadComment);
  }

  void _reloadReview() {
    setState(() {
      _ratingFuture = _ratingProvider.get(filter: {
        "UserId": "${widget.user.id}",
        "NewestFirst": "true",
        "Page": "0",
        "PageSize": "1"
      });
    });
  }

  void _reloadPost() {
    setState(() {
      _postFuture = _postProvider.get(filter: {
        "UserId": "${widget.user.id}",
        "NewestFirst": "true",
        "Page": "0",
        "PageSize": "1"
      });
    });
  }

  void _reloadComment() {
    setState(() {
      _commentFuture = _commentProvider.get(filter: {
        "UserId": "${widget.user.id}",
        "NewestFirst": "true",
        "Page": "0",
        "PageSize": "1"
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: Text("User details: ${widget.user.username}"),
      showBackArrow: true,
      child: Center(
        child: Row(
          children: [
            _buildUserInfo(),
            _buildUserContent(),
          ],
        ),
      ),
    );
  }

  Padding _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 60),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Palette.darkPurple,
              ),
              width: 430,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.memory(
                          imageFromBase64String(widget.user.profilePicture!.profilePicture!),
                          width: 360,
                          height: 330,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    _buildUserTile("Username", widget.user.username?? 'N/A',Icons.person_rounded),
                    _buildUserTile("First name", widget.user.firstName??'N/A', Icons.person_rounded),
                    _buildUserTile("Last name", widget.user.lastName ??'N/A', Icons.person_rounded),
                    _buildUserTile(
                      "E-mail",
                      (widget.user.email?.trim().isEmpty ?? true) ? '-' : widget.user.email!,
                      Icons.email_rounded,
                    ),
                    _buildUserTile(
                      "Date joined",
                      DateFormat('MMM d, y').format(widget.user.dateJoined!),
                      Icons.calendar_today_rounded,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTile(String subtitle, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Palette.listTile,
        ),
        child: ListTile(
          horizontalTitleGap: 25,
          title: Text(title, style: const TextStyle(color: Palette.lightPurple)),
          subtitle: Text(subtitle, style: TextStyle(color: Palette.lightPurple.withOpacity(0.5))),
          leading: Icon(icon, color: Palette.lightPurple.withOpacity(0.7), size: 40),
        ),
      ),
    );
  }

  Expanded _buildUserContent() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 150),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection("Reviews", _ratingFutureBuilder, buildStarTrailIcon(22)),
              MySeparator(width: 600, borderRadius: 50, opacity: 0.5, marginVertical: 10),
              _buildSection("Posts", _postFutureBuilder, buildPostIcon(23)),
              MySeparator(width: 600, borderRadius: 50, opacity: 0.5, marginVertical: 10),
              _buildSection("Comments", _commentFutureBuilder, buildCommentIcon(19)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget Function() builder, Widget icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(title, style: const TextStyle(fontSize: 20)),
            Padding(padding: const EdgeInsets.only(left: 5), child: icon),
          ],
        ),
        builder(),
      ],
    );
  }

  FutureBuilder<SearchResult<Comment>> _commentFutureBuilder() {
    return FutureBuilder<SearchResult<Comment>>(
      future: _commentFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data!.result.isNotEmpty) {
          comment = snapshot.data!.result.single;
        } else {
          comment = null;
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildCard(object: comment),
            if (comment != null) _buildSeeMoreButton(CommentsScreen(user: widget.user)),
          ],
        );
      },
    );
  }

  FutureBuilder<SearchResult<Post>> _postFutureBuilder() {
    return FutureBuilder<SearchResult<Post>>(
      future: _postFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data!.result.isNotEmpty) {
          post = snapshot.data!.result.single;
        } else {
          post = null;
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildCard(object: post),
            if (post != null) _buildSeeMoreButton(PostsScreen(user: widget.user)),
          ],
        );
      },
    );
  }

  FutureBuilder<SearchResult<Rating>> _ratingFutureBuilder() {
    return FutureBuilder<SearchResult<Rating>>(
      future: _ratingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data!.result.isNotEmpty) {
          rating = snapshot.data!.result.single;
        } else {
          rating = null;
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildCard(object: rating),
            if (rating != null) _buildSeeMoreButton(ReviewsScreen(user: widget.user)),
          ],
        );
      },
    );
  }

  Widget _buildCard({required dynamic object}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(object?.toString() ?? 'No data available'),
          ],
        ),
      ),
    );
  }

  Widget _buildSeeMoreButton(Widget screen) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Text("See more", style: TextStyle(color: Palette.lightPurple)),
    );
  }

  // Define the methods for buildStarTrailIcon, buildPostIcon, buildCommentIcon
  Widget buildStarTrailIcon(double size) {
    return Icon(Icons.star, size: size, color: Palette.lightPurple);
  }

  Widget buildPostIcon(double size) {
    return Icon(Icons.article, size: size, color: Palette.lightPurple);
  }

  Widget buildCommentIcon(double size) {
    return Icon(Icons.comment, size: size, color: Palette.lightPurple);
  }
}