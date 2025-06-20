import '../models/rating.dart';
import 'base_provider.dart';

class RatingProvider extends BaseProvider<Rating> {
  RatingProvider() : super("Rating");

  @override
  Rating fromJson(data) => Rating.fromJson(data);

  // This is the fixed create method:
  Future<Rating> create(Rating rating) async {
    final requestBody = {
      "insert": rating.toJson()
    };
    return await insert(requestBody);
  }
}
