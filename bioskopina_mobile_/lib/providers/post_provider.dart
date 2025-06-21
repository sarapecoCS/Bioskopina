import '../providers/user_post_action_provider.dart';
import '../providers/base_provider.dart';
import '../models/post.dart';
import '../models/search_result.dart';

class PostProvider extends BaseProvider<Post> {
  late UserPostActionProvider _userPostActionProvider;
  List<Post> _posts = [];

  PostProvider({required UserPostActionProvider userPostActionProvider})
      : _userPostActionProvider = userPostActionProvider,
        super("Post");

  UserPostActionProvider get userPostActionProvider => _userPostActionProvider;

  set userPostActionProvider(UserPostActionProvider value) {
    if (_userPostActionProvider != value) {
      _userPostActionProvider = value;
      notifyListeners();
    }
  }

  @override
  Post fromJson(data) {
    return Post.fromJson(data);
  }

  List<Post> get posts => _posts;

  // Sort posts by date (newest first)
  void _sortPosts() {
    _posts.sort((a, b) => b.datePosted!.compareTo(a.datePosted!));
  }

  Future<void> fetchAll() async {
    SearchResult<Post> result = await get();
    _posts = result.result;
    _sortPosts();
    notifyListeners();
  }

  void updatePostLocally(Post updatedPost) {
    final index = _posts.indexWhere((post) => post.id == updatedPost.id);
    if (index != -1) {
      _posts[index] = updatedPost;
      _sortPosts();
      notifyListeners();
    }
  }

  Future<void> toggleLike(Post post) async {
    String? userAction = await _userPostActionProvider.getUserAction(post.id!);
    int originalLikesCount = post.likesCount!;
    int originalDislikesCount = post.dislikesCount!;

    if (userAction == 'like') {
      post.likesCount = post.likesCount! - 1;
      await _userPostActionProvider.saveUserAction(post.id!, 'none');
    } else {
      if (userAction == 'dislike') {
        post.dislikesCount = post.dislikesCount! - 1;
      }
      post.likesCount = post.likesCount! + 1;
      await _userPostActionProvider.saveUserAction(post.id!, 'like');
    }

    try {
      await update(post.id!, request: post.toJson(), notifyAllListeners: false);
      _sortPosts();
      notifyListeners();
    } catch (e) {
      post.likesCount = originalLikesCount;
      post.dislikesCount = originalDislikesCount;
      await _userPostActionProvider.saveUserAction(post.id!, userAction!);
      throw Exception('Failed to update post on server');
    }
  }

  Future<void> toggleDislike(Post post) async {
    String? userAction = await _userPostActionProvider.getUserAction(post.id!);
    int originalLikesCount = post.likesCount!;
    int originalDislikesCount = post.dislikesCount!;

    if (userAction == 'dislike') {
      post.dislikesCount = post.dislikesCount! - 1;
      await _userPostActionProvider.saveUserAction(post.id!, 'none');
    } else {
      if (userAction == 'like') {
        post.likesCount = post.likesCount! - 1;
      }
      post.dislikesCount = post.dislikesCount! + 1;
      await _userPostActionProvider.saveUserAction(post.id!, 'dislike');
    }

    try {
      await update(post.id!, request: post.toJson(), notifyAllListeners: false);
      _sortPosts();
      notifyListeners();
    } catch (e) {
      post.likesCount = originalLikesCount;
      post.dislikesCount = originalDislikesCount;
      await _userPostActionProvider.saveUserAction(post.id!, userAction!);
      throw Exception('Failed to update post on server');
    }
  }

  Future<void> deletePost(int postId) async {
    try {
      await delete(postId);
      _posts.removeWhere((post) => post.id == postId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<Post> addPost({
    required int userId,
    required String content,
  }) async {
    try {
      final postData = {
        'userId': userId,
        'content': content,
        'likesCount': 0,
        'dislikesCount': 0,
        'datePosted': DateTime.now().toIso8601String(),
      };

      var response = await insert(postData);
      Post newPost = fromJson(response);
      _posts.insert(0, newPost); // Add at beginning (already newest)
      notifyListeners();

      return newPost;
    } catch (e) {
      throw Exception('Failed to create post: ${e.toString()}');
    }
  }
}