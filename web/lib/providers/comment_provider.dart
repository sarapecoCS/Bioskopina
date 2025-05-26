import '../providers/base_provider.dart';

import '../models/comment.dart';

class CommentProvider extends BaseProvider<Comment> {
  CommentProvider() : super("Comment");

  @override
  Comment fromJson(data) {
    return Comment.fromJson(data);
  }
}
