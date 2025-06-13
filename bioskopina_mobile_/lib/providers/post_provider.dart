import '../providers/user_post_action_provider.dart';
import '../providers/base_provider.dart';
import '../models/post.dart';
import '../models/search_result.dart';

class PostProvider extends BaseProvider<Post> {
  // Make it private and non-final for ProxyProvider updates
  late UserPostActionProvider _userPostActionProvider;

  List<Post> _posts = [];

  PostProvider({required UserPostActionProvider userPostActionProvider})
      : _userPostActionProvider = userPostActionProvider,
        super("Post");

  // Getter to access UserPostActionProvider
  UserPostActionProvider get userPostActionProvider => _userPostActionProvider;

  // Setter for ProxyProvider to update dependency
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

  Future<void> fetchAll() async {
    SearchResult<Post> result = await get();
    _posts = result.result;
    notifyListeners();
  }


  void updatePostLocally(Post updatedPost) {
    final index = _posts.indexWhere((post) => post.id == updatedPost.id);
    if (index != -1) {
      _posts[index] = updatedPost;
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
      await delete(postId);  // <-- call inherited delete method
      _posts.removeWhere((post) => post.id == postId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }


}
