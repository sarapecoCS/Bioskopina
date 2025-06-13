import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/bioskopina_watchlist.dart';
import '../models/preferred_genre.dart';
import '../models/rating.dart';
import '../models/genre.dart';
import '../models/search_result.dart';
import '../models/watchlist.dart';

import '../providers/bioskopina_watchlist_provider.dart';
import '../providers/preferred_genre_provider.dart';
import '../providers/rating_provider.dart';
import '../providers/genre_provider.dart';
import '../providers/watchlist_provider.dart';

import '../widgets/gradient_button.dart';
import '../widgets/preferred_genres_form.dart';
import '../widgets/separator.dart';
import '../utils/colors.dart';
import '../utils/util.dart';
import '../widgets/circular_progress_indicator.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  late WatchlistProvider _watchlistProvider;
  late Future<SearchResult<Watchlist>> _watchlistFuture;

  late BioskopinaWatchlistProvider _bioskopinaWatchlistProvider;

  late RatingProvider _ratingProvider;
  late Future<SearchResult<Rating>> _ratingFuture;

  late PreferredGenreProvider _preferredGenreProvider;
  late Future<SearchResult<PreferredGenre>> _prefGenresFuture;

  late GenreProvider _genreProvider;
  late Future<SearchResult<Genre>> _genreFuture;

  @override
  void initState() {
    super.initState();

    _watchlistProvider = context.read<WatchlistProvider>();
    _watchlistFuture = _watchlistProvider.get(
      filter: {"UserId": "${LoggedUser.user!.id}"},
    );

    _bioskopinaWatchlistProvider = context.read<BioskopinaWatchlistProvider>();

    _ratingProvider = context.read<RatingProvider>();
    _ratingFuture = _ratingProvider.get(
      filter: {"UserId": "${LoggedUser.user!.id}"},
    );

    _genreProvider = context.read<GenreProvider>();
    _genreFuture = _genreProvider.get(
      filter: {"SortAlphabetically": true},
    );

    _preferredGenreProvider = context.read<PreferredGenreProvider>();
    _prefGenresFuture = _preferredGenreProvider.get(
      filter: {"UserId": "${LoggedUser.user!.id}"},
    );

    _preferredGenreProvider.addListener(_updatePreferredGenres);
  }

  @override
  void dispose() {
    _preferredGenreProvider.removeListener(_updatePreferredGenres);
    super.dispose();
  }

  void _updatePreferredGenres() {
    if (mounted) {
      setState(() {
        _prefGenresFuture = _preferredGenreProvider.get(
          filter: {"UserId": "${LoggedUser.user!.id}"},
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildInfo(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MySeparator(
              width: screenSize.width * 0.7,
              paddingBottom: 20,
              opacity: 0.6,
              borderRadius: 50,
            ),
          ],
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Preferred genres",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const PreferredGenresForm(),
                      );
                    },
                    child: const Icon(
                      Icons.edit,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              _buildPrefGenres(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrefGenres() {
    return FutureBuilder<SearchResult<Genre>>(
      future: _genreFuture,
      builder: (context, genreSnapshot) {
        if (genreSnapshot.connectionState == ConnectionState.waiting) {
          return const MyProgressIndicator();
        } else if (genreSnapshot.hasError) {
          return Text('Error: ${genreSnapshot.error}');
        } else {
          var genres = genreSnapshot.data!.result;

          return FutureBuilder<SearchResult<PreferredGenre>>(
            future: _prefGenresFuture,
            builder: (context, prefSnapshot) {
              if (prefSnapshot.connectionState == ConnectionState.waiting) {
                return const MyProgressIndicator();
              } else if (prefSnapshot.hasError) {
                return Text('Error: ${prefSnapshot.error}');
              } else {
                var preferredGenres = prefSnapshot.data!.result;
                var genreNames = genres
                    .where((g) => preferredGenres
                    .any((pg) => pg.genreId == g.id))
                    .map((g) => g.name!);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: 8,
                    children: genreNames.map((name) {
                      return GradientButton(
                        gradient: Palette.navGradient4,
                        contentPaddingBottom: 2,
                        contentPaddingLeft: 5,
                        contentPaddingRight: 5,
                        contentPaddingTop: 2,
                        borderRadius: 50,
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Palette.lightPurple,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }
            },
          );
        }
      },
    );
  }

  Widget _buildInfo() {
    return FutureBuilder<SearchResult<Watchlist>>(
      future: _watchlistFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var watchlist = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                const Text("Total movies watched",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                _buildTotal(watchlist),
                const SizedBox(height: 30),
                const Text("Completed Movies",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                _buildCompleted(watchlist),
                const SizedBox(height: 30),
                ]
          )
          );
        }
      },
    );
  }

  Widget _buildTotal(SearchResult<Watchlist> watchlist) {
    if (watchlist.count == 1) {
      return FutureBuilder<SearchResult<BioskopinaWatchlist>>(
        future: _bioskopinaWatchlistProvider.get(
            filter: {"WatchlistId": "${watchlist.result[0].id}"}),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MyProgressIndicator(height: 19, width: 19, strokeWidth: 3);
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Text(
              "${snapshot.data!.count}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Palette.turquoiseLight,
              ),
            );
          }
        },
      );
    }
    return const Text(
      "0",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Palette.turquoiseLight,
      ),
    );
  }

  Widget _buildCompleted(SearchResult<Watchlist> watchlist) {
    if (watchlist.count == 1) {
      return FutureBuilder<SearchResult<BioskopinaWatchlist>>(
        future: _bioskopinaWatchlistProvider.get(
            filter: {"WatchlistId": "${watchlist.result[0].id}"}),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MyProgressIndicator(height: 19, width: 19, strokeWidth: 3);
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var completed = snapshot.data!.result
                .where((e) => e.watchStatus == "Completed")
                .length;
            return Text(
              "$completed",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Palette.rose,
              ),
            );
          }
        },
      );
    }
    return const Text(
      "0",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Palette.rose,
      ),
    );
  }

  Widget _buildMean() {
    return FutureBuilder<SearchResult<Rating>>(
      future: _ratingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyProgressIndicator(height: 19, width: 19, strokeWidth: 3);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var ratings = snapshot.data!.result;
          if (ratings.isEmpty) {
            return const Text(
              "-",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Palette.lightYellow,
              ),
            );
          }

          double mean = ratings.map((e) => e.ratingValue!).reduce((a, b) => a + b) / ratings.length;
          return Text(
            mean.toStringAsFixed(2),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Palette.lightYellow,
            ),
          );
        }
      },
    );
  }
}
