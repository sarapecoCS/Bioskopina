import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/bioskopina_list.dart';
import '../models/preferred_genre.dart';
import '../models/rating.dart';
import '../models/genre.dart';
import '../models/search_result.dart';

import '../providers/bioskopina_list_provider.dart';
import '../providers/preferred_genre_provider.dart';
import '../providers/rating_provider.dart';
import '../providers/genre_provider.dart';

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
  late BioskopinaListProvider _bioskopinaListProvider;
  late Future<SearchResult<BioskopinaList>> _bioskopinaListFuture;

  late RatingProvider _ratingProvider;
  late Future<SearchResult<Rating>> _ratingFuture;

  late PreferredGenreProvider _preferredGenreProvider;
  late Future<SearchResult<PreferredGenre>> _prefGenresFuture;

  late GenreProvider _genreProvider;
  late Future<SearchResult<Genre>> _genreFuture;

  @override
  void initState() {
    super.initState();

    _bioskopinaListProvider = context.read<BioskopinaListProvider>();
    _bioskopinaListFuture = _bioskopinaListProvider.get(
      filter: {"UserId": "${LoggedUser.user!.id}"},
    );

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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Palette.darkPurple?.withOpacity(0.7), // Replaced Palette.darkBlue
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "List Statistics",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildListStats(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Palette.darkPurple?.withOpacity(0.7), // Replaced Palette.darkBlue
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "Ratings Overview",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildRatingStats(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Palette.darkPurple?.withOpacity(0.7), // Replaced Palette.darkBlue
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Preferred Genres",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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
                    const SizedBox(height: 16),
                    _buildPrefGenres(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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


  Widget _buildListStats() {
    return FutureBuilder<SearchResult<BioskopinaList>>(
      future: _bioskopinaListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var bioskopinaLists = snapshot.data!.result;

          // Group by listId
          var listCounts = <int, int>{};
          for (var item in bioskopinaLists) {
            listCounts[item.listId!] = (listCounts[item.listId!] ?? 0) + 1;
          }

          // Get unique listIds
          var uniqueListIds = listCounts.keys.toList();
          var totalAssociations = bioskopinaLists.length;

          return Column(
            children: [
              _buildStatCard(
                icon: Icons.list_alt,
                title: "Total Lists",
                value: uniqueListIds.length.toString(),
                color: Palette.turquoiseLight,
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                icon: Icons.movie,
                title: "Total Associations",
                value: totalAssociations.toString(),
                color: Palette.rose,
              ),
              const SizedBox(height: 12),

            ],
          );
        }
      },
    );
  }

  Widget _buildRatingStats() {
    return FutureBuilder<SearchResult<Rating>>(
      future: _ratingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var ratings = snapshot.data!.result;
          if (ratings.isEmpty) {
            return Column(
              children: [
                _buildStatCard(
                  icon: Icons.star,
                  title: "Average Rating",
                  value: "-",
                  color: Palette.lightYellow,
                ),
                const SizedBox(height: 12),
                _buildStatCard(
                  icon: Icons.star_border,
                  title: "Total Ratings",
                  value: "0",
                  color: Palette.turquoiseLight,
                ),
              ],
            );
          }

          double mean = ratings.map((e) => e.ratingValue!).reduce((a, b) => a + b) / ratings.length;
          var fiveStarRatings = ratings.where((r) => r.ratingValue == 5).length;
          var oneStarRatings = ratings.where((r) => r.ratingValue == 1).length;

          return Column(
            children: [
              _buildStatCard(
                icon: Icons.star,
                title: "Average Rating",
                value: mean.toStringAsFixed(2),
                color: Palette.lightYellow,
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                icon: Icons.star_border,
                title: "Total Ratings",
                value: ratings.length.toString(),
                color: Palette.turquoiseLight,
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                icon: Icons.star_rate,
                title: "10-star Ratings",
                value: fiveStarRatings.toString(),
                color: Palette.rose,
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                icon: Icons.star_half,
                title: "1-star Ratings",
                value: oneStarRatings.toString(),
                color: Palette.lightPurple,
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Palette.darkPurple?.withOpacity(0.5), // Replaced Palette.darkBlue
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}