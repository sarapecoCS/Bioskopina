import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_animate/flutter_animate.dart';

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
    _loadData();
  }

  Future<void> _loadData() async {
    final postProvider = context.read<PostProvider>();
    try {
      await postProvider.fetchAll();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load posts: $e')),
        );
      }
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _refreshPosts() async {
    setState(() => _isLoading = true);
    await _loadData();
  }

  void _addNewPost() {
    Navigator.pushNamed(context, '/add-post');
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();


    const int currentUserId = 1;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }


    final myPosts = postProvider.posts.where((post) => post.user?.id == currentUserId).toList();
    final otherPosts = postProvider.posts.where((post) => post.user?.id != currentUserId).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Posts', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _addNewPost,
            tooltip: 'Add New Post',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Posts',
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (myPosts.isEmpty)
                const Text('No posts yet.', style: TextStyle(color: Colors.white70))
              else
                ...myPosts.map((post) => _buildPostItem(context, post, isOwner: true)).toList(),

              const SizedBox(height: 32),

              Text(
                'Posts by others',
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (otherPosts.isEmpty)
                const Text('No posts available.', style: TextStyle(color: Colors.white70))
              else
                ...otherPosts.map((post) => _buildPostItem(context, post, isOwner: false)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostItem(BuildContext context, Post post, {required bool isOwner}) {
    final provider = context.read<PostProvider>();

    return Animate(
      effects: [FadeEffect(duration: 400.ms), ScaleEffect(duration: 400.ms)],
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Username & date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    post.user?.username ?? 'Unknown user',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    post.datePosted != null ? timeago.format(post.datePosted!) : '',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Post content
              Text(
                post.content ?? 'No content',
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),

              const SizedBox(height: 16),

              // Like/Dislike buttons + See Details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.thumb_up,
                            color: (post.likesCount ?? 0) > 0 ? Colors.greenAccent : Colors.grey),
                        onPressed: () async {
                          try {
                            await provider.toggleLike(post);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error liking post: $e')),
                            );
                          }
                        },
                      ),
                      Text('${post.likesCount ?? 0}', style: const TextStyle(color: Colors.white)),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: Icon(Icons.thumb_down,
                            color: (post.dislikesCount ?? 0) > 0 ? Colors.redAccent : Colors.grey),
                        onPressed: () async {
                          try {
                            await provider.toggleDislike(post);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error disliking post: $e')),
                            );
                          }
                        },
                      ),
                      Text('${post.dislikesCount ?? 0}', style: const TextStyle(color: Colors.white)),
                    ],
                  ),

                  // See Details Button
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      backgroundColor: Colors.blueGrey.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final updatedPost = await Navigator.push<Post?>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PostDetailScreen(post: post),
                        ),
                      );
                      if (updatedPost != null) {
                        provider.updatePostLocally(updatedPost);
                      }
                    },
                    child: const Text('See Details', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),

              if (isOwner) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.lightBlueAccent),
                      onPressed: () {
                        Navigator.pushNamed(context, '/edit-post', arguments: post);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: Colors.grey[900],
                            title: const Text('Confirm Delete', style: TextStyle(color: Colors.white)),
                            content: const Text('Are you sure you want to delete this post?',
                                style: TextStyle(color: Colors.white)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Cancel', style: TextStyle(color: Colors.green)),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('Delete', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          try {
                            await provider.deletePost(post.id!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Post deleted')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error deleting post: $e')),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
