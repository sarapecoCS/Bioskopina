import '../models/bioskopina_watchlist.dart';
import '../providers/base_provider.dart';

class BioskopinaWatchlistProvider extends BaseProvider<BioskopinaWatchlist> {
  BioskopinaWatchlistProvider() : super("BioskopinaWatchlist");

  @override
  BioskopinaWatchlist fromJson(data) {
    return BioskopinaWatchlist.fromJson(data);
  }
}