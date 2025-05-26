import '../providers/user_post_action_provider.dart';

import '../providers/base_provider.dart';
import '../models/post.dart';

class PostProvider extends BaseProvider<Post> {
  final UserPostActionProvider userPostActionProvider;

  PostProvider({required this.userPostActionProvider}) : super("Post");

  @override
  Post fromJson(data) {
    return Post.fromJson(data);
  }

  Future<void> toggleLike(Post post) async {
    String? userAction = await userPostActionProvider.getUserAction(post.id!);
    int originalLikesCount = post.likesCount!;
    int originalDislikesCount = post.dislikesCount!;

    if (userAction == 'like') {
      post.likesCount = post.likesCount! - 1;
      await userPostActionProvider.saveUserAction(post.id!, 'none');
    } else {
      if (userAction == 'dislike') {
        post.dislikesCount = post.dislikesCount! - 1;
      }

      post.likesCount = post.likesCount! + 1;
      await userPostActionProvider.saveUserAction(post.id!, 'like');
    }

    // notifyListeners();

    try {
      await update(post.id!, request: post.toJson(), notifyAllListeners: false);
    } catch (e) {
      // Reverts changes in case of error
      post.likesCount = originalLikesCount;
      post.dislikesCount = originalDislikesCount;
      await userPostActionProvider.saveUserAction(post.id!, userAction!);
      // notifyListeners();
      throw Exception('Failed to update post on server');
    }
  }

  Future<void> toggleDislike(Post post) async {
    String? userAction = await userPostActionProvider.getUserAction(post.id!);
    int originalLikesCount = post.likesCount!;
    int originalDislikesCount = post.dislikesCount!;

    if (userAction == 'dislike') {
      post.dislikesCount = post.dislikesCount! - 1;
      await userPostActionProvider.saveUserAction(post.id!, 'none');
    } else {
      if (userAction == 'like') {
        post.likesCount = post.likesCount! - 1;
      }

      post.dislikesCount = post.dislikesCount! + 1;
      await userPostActionProvider.saveUserAction(post.id!, 'dislike');
    }

    //  notifyListeners();

    try {
      await update(post.id!, request: post.toJson(), notifyAllListeners: false);
    } catch (e) {
      // Reverts changes in case of error
      post.likesCount = originalLikesCount;
      post.dislikesCount = originalDislikesCount;
      await userPostActionProvider.saveUserAction(post.id!, userAction!);
      //  notifyListeners();
      throw Exception('Failed to update post on server');
    }
  }
}