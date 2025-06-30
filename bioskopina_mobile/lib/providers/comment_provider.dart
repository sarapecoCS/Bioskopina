import '../providers/user_comment_action_provider.dart';
import '../providers/base_provider.dart';
import '../models/comment.dart';
import '../models/search_result.dart';

class CommentProvider extends BaseProvider<Comment> {
  final UserCommentActionProvider userCommentActionProvider;
  List<Comment> _comments = [];

  CommentProvider({required this.userCommentActionProvider}) : super("Comment");

  @override
  Comment fromJson(data) {
    return Comment.fromJson(data);
  }

  List<Comment> get comments => _comments;

  // Sort comments by date (newest first) with null safety
  void _sortComments() {
    _comments.sort((a, b) {
      // Handle cases where date might be null
      if (a.dateCommented == null && b.dateCommented == null) return 0;
      if (a.dateCommented == null) return 1; // nulls last
      if (b.dateCommented == null) return -1; // nulls last
      return b.dateCommented!.compareTo(a.dateCommented!);
    });
  }

  Future<void> fetchAll() async {
    SearchResult<Comment> result = await get();
    _comments = result.result;
    _sortComments();
    notifyListeners();
  }

  Future<void> toggleLike(Comment comment) async {
    String? userAction = await userCommentActionProvider.getUserAction(comment.id!);
    int originalLikesCount = comment.likesCount ?? 0;
    int originalDislikesCount = comment.dislikesCount ?? 0;

    if (userAction == 'like') {
      comment.likesCount = (comment.likesCount ?? 0) - 1;
      await userCommentActionProvider.saveUserAction(comment.id!, 'none');
    } else {
      if (userAction == 'dislike') {
        comment.dislikesCount = (comment.dislikesCount ?? 0) - 1;
      }
      comment.likesCount = (comment.likesCount ?? 0) + 1;
      await userCommentActionProvider.saveUserAction(comment.id!, 'like');
    }

    try {
      await update(comment.id!, request: comment.toJson(), notifyAllListeners: false);
      _sortComments();
      notifyListeners();
    } catch (e) {
      // Reverts changes in case of error
      comment.likesCount = originalLikesCount;
      comment.dislikesCount = originalDislikesCount;
      await userCommentActionProvider.saveUserAction(comment.id!, userAction ?? 'none');
      throw Exception('Failed to update comment on server');
    }
  }

  Future<void> toggleDislike(Comment comment) async {
    String? userAction = await userCommentActionProvider.getUserAction(comment.id!);
    int originalLikesCount = comment.likesCount ?? 0;
    int originalDislikesCount = comment.dislikesCount ?? 0;

    if (userAction == 'dislike') {
      comment.dislikesCount = (comment.dislikesCount ?? 0) - 1;
      await userCommentActionProvider.saveUserAction(comment.id!, 'none');
    } else {
      if (userAction == 'like') {
        comment.likesCount = (comment.likesCount ?? 0) - 1;
      }
      comment.dislikesCount = (comment.dislikesCount ?? 0) + 1;
      await userCommentActionProvider.saveUserAction(comment.id!, 'dislike');
    }

    try {
      await update(comment.id!, request: comment.toJson(), notifyAllListeners: false);
      _sortComments();
      notifyListeners();
    } catch (e) {
      // Reverts changes in case of error
      comment.likesCount = originalLikesCount;
      comment.dislikesCount = originalDislikesCount;
      await userCommentActionProvider.saveUserAction(comment.id!, userAction ?? 'none');
      throw Exception('Failed to update comment on server');
    }
  }

  Future<Comment> addComment({
    required int userId,
    required String content,
    required int postId,
  }) async {
    try {
      final commentData = {
        'userId': userId,
        'content': content,
        'postId': postId,
        'likesCount': 0,
        'dislikesCount': 0,
        'dateCommented': DateTime.now().toIso8601String(),
      };

      var response = await insert(commentData);
      Comment newComment = fromJson(response);
      _comments.insert(0, newComment);
      notifyListeners();

      return newComment;
    } catch (e) {
      throw Exception('Failed to create comment: ${e.toString()}');
    }
  }

  Future<void> deleteComment(int commentId) async {
    try {
      await delete(commentId);
      _comments.removeWhere((comment) => comment.id == commentId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}