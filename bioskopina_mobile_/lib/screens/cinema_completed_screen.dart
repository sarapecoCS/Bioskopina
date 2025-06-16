import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'package:provider/provider.dart';

import '../providers/watchlist_provider.dart';
import '../utils/util.dart';
import '../widgets/cinema_cards.dart';
import '../models/bioskopina_watchlist.dart';
import '../models/search_result.dart';
import '../models/watchlist.dart';
import '../providers/bioskopina_watchlist_provider.dart';
import '../widgets/empty.dart';
import '../widgets/cinema_indicator.dart';
import 'home_screen.dart';

class CinemaCompletedScreen extends StatefulWidget {
  final int selectedIndex;
  const CinemaCompletedScreen({super.key, required this.selectedIndex});

  @override
  State<CinemaCompletedScreen> createState() => _CinemaCompletedScreenState();
}

class _CinemaCompletedScreenState extends State<CinemaCompletedScreen> {
  late BioskopinaWatchlistProvider _bioskopinaWatchlistProvider;
  late WatchlistProvider _watchlistProvider;
  late SearchResult<Watchlist> _watchlist;

  int page = 0;
  int pageSize = 20;

  late final Map<String, dynamic> _filter;
  late Future<Map<String, dynamic>> _filterFuture;

  @override
  void initState() {
    _bioskopinaWatchlistProvider = context.read<BioskopinaWatchlistProvider>();
    _watchlistProvider = context.read<WatchlistProvider>();
    _filterFuture = getFilter();

    super.initState();
  }

  Future<Map<String, dynamic>> getFilter() async {
    _watchlist = await _watchlistProvider
        .get(filter: {"UserId": "${LoggedUser.user!.id}"});

    if (_watchlist.result.isNotEmpty) {
      _filter = {
        "WatchlistId": "${_watchlist.result[0].id}",
        "GenresIncluded": "true",
        "WatchStatus": "Completed",
        "NewestFirst": "true",
      };
      return _filter;
    }
    return {};
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
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final filter = snapshot.data!;

          if (filter.isNotEmpty) {
            return CinemaCards(
              selectedIndex: widget.selectedIndex,
              page: page,
              pageSize: pageSize,
              fetch: fetchMovies,
              fetchPage: fetchPage,
              filter: filter,
            );
          }
          return const Empty(
              text: Text("Nothing to be found here"),
              screen: HomeScreen(selectedIndex: 0),
              child: Text("Explore Movies",
                  style: TextStyle(color: Palette.lightPurple)));
        }
      },
    );
  }

  Future<SearchResult<BioskopinaWatchlist>> fetchMovies() {
    return _bioskopinaWatchlistProvider.get(filter: {
      ..._filter,
      "Page": "$page",
      "PageSize": "$pageSize",
    });
  }

  Future<SearchResult<BioskopinaWatchlist>> fetchPage(Map<String, dynamic> filter) {
    return _bioskopinaWatchlistProvider.get(filter: filter);
  }
}