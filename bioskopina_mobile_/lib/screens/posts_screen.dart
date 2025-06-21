// lib/screens/posts_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/master_screen.dart';
import '../widgets/separator.dart';
import '../widgets/post_cards.dart';
import '../models/post.dart';
import '../models/search_result.dart';
import '../utils/colors.dart';
import '../widgets/content_form.dart';
import '../widgets/gradient_button.dart';

class PostsScreen extends StatefulWidget {
  final int selectedIndex;

  const PostsScreen({
    super.key,
    required this.selectedIndex,
  });

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late final PostProvider _postProvider;
  late final UserProvider _userProvider;

  int page = 0;
  int pageSize = 20;

  Map<String, dynamic> _filter = {
    "NewestFirst": "true",
    "CommentsIncluded": "true",
  };

  @override
  void initState() {
    _postProvider = context.read<PostProvider>();
    _userProvider = context.read<UserProvider>();
    super.initState();
  }

  void _showAddPostDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: ContentForm(isPost: true),
        );
      },
    ).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double coverWidth = screenSize.width;

    return MasterScreenWidget(
      showProfileIcon: true,
      selectedIndex: widget.selectedIndex,
      title: "Posts",
      showNavBar: true,
      showHelpIcon: true,
      showFloatingActionButton: true,
      floatingButtonOnPressed: _showAddPostDialog,
      gradientButton: GradientButton(
        width: 60,
        height: 60,
        borderRadius: 100,
        onPressed: _showAddPostDialog,
        gradient: Palette.navGradient2,
        child: const Icon(
          Icons.edit_note_rounded,
          size: 26,
          color: Palette.white,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: coverWidth * 0.7,
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Palette.lightPurple.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: PostCards(
                selectedIndex: widget.selectedIndex,
                page: page,
                pageSize: pageSize,
                fetchPosts: fetchPosts,
                fetchPage: fetchPage,
                filter: _filter,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<SearchResult<Post>> fetchPosts() {
    return _postProvider.get(filter: {
      ..._filter,
      "Page": "$page",
      "PageSize": "$pageSize",
    });
  }

  Future<SearchResult<Post>> fetchPage(Map<String, dynamic> filter) {
    return _postProvider.get(filter: filter);
  }
}