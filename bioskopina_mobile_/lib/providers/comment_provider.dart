import '../providers/user_comment_action_provider.dart';

import '../providers/base_provider.dart';
import '../models/comment.dart';

class CommentProvider extends BaseProvider<Comment> {
  final UserCommentActionProvider userCommentActionProvider;
  CommentProvider({required this.userCommentActionProvider}) : super("Comment");

  @override
  Comment fromJson(data) {
    return Comment.fromJson(data);
  }

  Future<void> toggleLike(Comment comment) async {
    String? userAction =
    await userCommentActionProvider.getUserAction(comment.id!);
    int originalLikesCount = comment.likesCount!;
    int originalDislikesCount = comment.dislikesCount!;

    if (userAction == 'like') {
      comment.likesCount = comment.likesCount! - 1;
      await userCommentActionProvider.saveUserAction(comment.id!, 'none');
    } else {
      if (userAction == 'dislike') {
        comment.dislikesCount = comment.dislikesCount! - 1;
      }

      comment.likesCount = comment.likesCount! + 1;
      await userCommentActionProvider.saveUserAction(comment.id!, 'like');
    }

    //notifyListeners();

    try {
      await update(comment.id!,
          request: comment.toJson(), notifyAllListeners: false);
    } catch (e) {
      // Reverts changes in case of error
      comment.likesCount = originalLikesCount;
      comment.dislikesCount = originalDislikesCount;
      await userCommentActionProvider.saveUserAction(comment.id!, userAction!);
      // notifyListeners();
      throw Exception('Failed to update comment on server');
    }
  }

  Future<void> toggleDislike(Comment comment) async {
    String? userAction =
    await userCommentActionProvider.getUserAction(comment.id!);
    int originalLikesCount = comment.likesCount!;
    int originalDislikesCount = comment.dislikesCount!;

    if (userAction == 'dislike') {
      comment.dislikesCount = comment.dislikesCount! - 1;
      await userCommentActionProvider.saveUserAction(comment.id!, 'none');
    } else {
      if (userAction == 'like') {
        comment.likesCount = comment.likesCount! - 1;
      }

      comment.dislikesCount = comment.dislikesCount! + 1;
      await userCommentActionProvider.saveUserAction(comment.id!, 'dislike');
    }

    //notifyListeners();

    try {
      await update(comment.id!,
          request: comment.toJson(), notifyAllListeners: false);
    } catch (e) {
      // Reverts changes in case of error
      comment.likesCount = originalLikesCount;
      comment.dislikesCount = originalDislikesCount;
      await userCommentActionProvider.saveUserAction(comment.id!, userAction!);
      // notifyListeners();
      throw Exception('Failed to update comment on server');
    }
  }
}