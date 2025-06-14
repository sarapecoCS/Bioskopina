import '../models/rating.dart';
import 'base_provider.dart';

class RatingProvider extends BaseProvider<Rating> {
  RatingProvider() : super("Rating");

  @override
  Rating fromJson(data) => Rating.fromJson(data);

  Future<Rating> create(Rating rating) async {
    return await insert(rating.toJson());
  }
}
