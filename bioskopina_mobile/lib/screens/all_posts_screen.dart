import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/post_provider.dart';
import '../models/post.dart';
import '../models/search_result.dart';
import '../utils/colors.dart';
import '../widgets/post_cards.dart';
import '../widgets/gradient_button.dart';
import '../widgets/master_screen.dart';

class AllPostsScreen extends StatefulWidget {
  final int selectedIndex;
  const AllPostsScreen({super.key, required this.selectedIndex});

  @override
  State<AllPostsScreen> createState() => _AllPostsScreenState();
}

class _AllPostsScreenState extends State<AllPostsScreen> {
  late PostProvider _postProvider;
  bool _showPosts = false; // Controls whether to show the posts or just the placeholder

  @override
  void initState() {
    super.initState();
    _postProvider = context.read<PostProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      selectedIndex: widget.selectedIndex,
      showNavBar: true,
      showSearch: false,
      showHelpIcon: true,
      title: "All Posts",
      child: Center(
        child: _showPosts ? _buildPostsList() : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Replace with your asset image path
        SizedBox(
          width: 200,
          height: 200,
          child: Image.asset(
            'assets/images/placeholder.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 20),
        GradientButton(
          onPressed: () {
            setState(() {
              _showPosts = true;
            });
          },
          width: 140,
          height: 40,
          gradient: Palette.buttonGradient2,
          borderRadius: 30,
          child: const Text(
            "See all posts",
            style: TextStyle(color: Palette.lightPurple, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildPostsList() {
    // Simple PostCards widget usage without problematic parameters
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: PostCards(
        selectedIndex: widget.selectedIndex,
        page: 0,
        pageSize: 20,
        fetchPosts: fetchPosts,
        fetchPage: fetchPage,
        filter: {
          "IncludeDetails": "true",
          "OrderByDate": "true",
          "Page": "0",
          "PageSize": "20",
        },
      ),
    );
  }

  Future<SearchResult<Post>> fetchPosts() {
    return _postProvider.get(filter: {
      "IncludeDetails": "true",
      "OrderByDate": "true",
      "Page": "0",
      "PageSize": "20",
    });
  }

  Future<SearchResult<Post>> fetchPage(Map<String, dynamic> filter) {
    return _postProvider.get(filter: filter);
  }
}
