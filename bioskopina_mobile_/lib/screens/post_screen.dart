import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';
import '../providers/post_provider.dart';

import 'post_detail_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch posts once when widget is inserted into widget tree
    _loadData();
  }

  Future<void> _loadData() async {
    final postProvider = context.read<PostProvider>();
    try {
      await postProvider.fetchAll();
    } catch (e) {
      // Show error if fetch fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load posts: $e')),
      );
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshPosts() async {
    setState(() {
      _isLoading = true;
    });
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Consumer<PostProvider>(
      builder: (context, provider, _) {
        if (provider.posts.isEmpty) {
          return const Center(
            child: Text(
              'No posts available',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refreshPosts,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: provider.posts.length,
            itemBuilder: (context, index) {
              final Post post = provider.posts[index];
              return GestureDetector(
                onTap: () async {
                  // Await for possible updates from PostDetailScreen
                  final updatedPost = await Navigator.push<Post?>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PostDetailScreen(post: post),
                    ),
                  );

                  // If post was updated, refresh locally to update UI
                  if (updatedPost != null) {
                    provider.updatePostLocally(updatedPost);
                  }
                },
                child: Card(
                  color: Colors.grey[900],
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.content ?? 'No content',
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.thumb_up,
                                    color: (post.likesCount ?? 0) > 0
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                  onPressed: () async {
                                    try {
                                      await provider.toggleLike(post);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('Error liking post: $e'),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                Text(
                                  '${post.likesCount ?? 0}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.thumb_down,
                                    color: (post.dislikesCount ?? 0) > 0
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                  onPressed: () async {
                                    try {
                                      await provider.toggleDislike(post);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Error disliking post: $e'),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                Text(
                                  '${post.dislikesCount ?? 0}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
