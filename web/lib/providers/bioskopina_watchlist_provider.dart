import '../models/watchlist.dart';
import '../providers/base_provider.dart';

class WatchlistProvider extends BaseProvider<Watchlist> {
  WatchlistProvider() : super("Watchlist");

  @override
  Watchlist fromJson(data) {
    return Watchlist.fromJson(data);
  }
}