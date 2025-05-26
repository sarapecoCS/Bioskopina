import '../providers/base_provider.dart';
import '../models/post.dart';

class PostProvider extends BaseProvider<Post> {
  PostProvider() : super("Post");

  @override
  Post fromJson(data) {
    return Post.fromJson(data);
  }
}
