import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'package:provider/provider.dart';
import '../providers/watchlist_provider.dart';
import '../utils/util.dart';
import '../widgets/empty.dart';
import '../widgets/cinema_cards.dart';
import '../models/bioskopina_watchlist.dart';
import '../models/search_result.dart';
import '../models/watchlist.dart';
import '../providers/bioskopina_watchlist_provider.dart';
import '../widgets/cinema_indicator.dart';
import 'home_screen.dart';

class CinemaAllScreen extends StatefulWidget {
  final int selectedIndex;
  const CinemaAllScreen({super.key, required this.selectedIndex});

  @override
  State<CinemaAllScreen> createState() => _CinemaAllScreenState();
}

class _CinemaAllScreenState extends State<CinemaAllScreen> {
  late BioskopinaWatchlistProvider _bioskopinaWatchlistProvider;
  late WatchlistProvider _watchlistProvider;
  SearchResult<Watchlist>? _watchlist;

  int page = 0;
  int pageSize = 20;

  Map<String, dynamic> _filter = {};
  late Future<Map<String, dynamic>> _filterFuture;

  @override
  void initState() {
    super.initState();
    _bioskopinaWatchlistProvider = context.read<BioskopinaWatchlistProvider>();
    _watchlistProvider = context.read<WatchlistProvider>();
    _filterFuture = _initializeData();
  }

  Future<Map<String, dynamic>> _initializeData() async {
    try {
      // Null-safe user check
      final user = LoggedUser.user;
      if (user == null || user.id == null) {
        return {};
      }

      _watchlist = await _watchlistProvider.get(
        filter: {"UserId": user.id.toString()},
      );

      if (_watchlist?.result.isNotEmpty ?? false) {
        return {
          "WatchlistId": _watchlist!.result[0].id.toString(),
          "GenresIncluded": "true",
          "NewestFirst": "true",
        };
      }
      return {};
    } catch (e) {
      debugPrint('Error initializing data: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _filterFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Center(
              child: Wrap(
                children: [
                  CinemaIndicator(),
                  CinemaIndicator(),
                  CinemaIndicator(),
                  CinemaIndicator(),
                  CinemaIndicator(),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final filter = snapshot.data ?? {};

        if (filter.isNotEmpty) {
          return CinemaCards(
            selectedIndex: widget.selectedIndex,
            page: page,
            pageSize: pageSize,
            fetch: fetchBioskopina,
            fetchPage: fetchPage,
            filter: filter,
          );
        }

        return const Empty(
          text: Text("Nothing to be found here"),
          screen: HomeScreen(selectedIndex: 0),
          child: Text(
            "Explore Movies",
            style: TextStyle(color: Palette.lightPurple),
          ),
        );
      },
    );
  }

  Future<SearchResult<BioskopinaWatchlist>> fetchBioskopina() async {
    try {
      return await _bioskopinaWatchlistProvider.get(
        filter: {
          ..._filter,
          "Page": page.toString(),
          "PageSize": pageSize.toString(),
        },
      );
    } catch (e) {
      debugPrint('Error fetching bioskopina: $e');
      return SearchResult<BioskopinaWatchlist>();
    }
  }

  Future<SearchResult<BioskopinaWatchlist>> fetchPage(Map<String, dynamic> filter) async {
    try {
      return await _bioskopinaWatchlistProvider.get(filter: filter);
    } catch (e) {
      debugPrint('Error fetching page: $e');
      return SearchResult<BioskopinaWatchlist>();
    }
  }
}