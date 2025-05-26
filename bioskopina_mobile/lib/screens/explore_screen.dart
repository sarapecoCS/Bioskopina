import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/bioskopina.dart';
import '../models/genre.dart';
import '../models/search_result.dart';
import '../providers/bioskopina_provider.dart';
import '../utils/colors.dart';
import '../widgets/bioskopina_cards.dart';
import '../widgets/master_screen.dart';
import '../providers/genre_provider.dart';
import '../widgets/chip_indicator.dart';
import '../widgets/form_builder_filter_chip.dart';

class ExploreScreen extends StatefulWidget {
  final int selectedIndex;
  const ExploreScreen({super.key, required this.selectedIndex});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late Future<SearchResult<Genre>> _genreFuture;
  late final GenreProvider _genreProvider;
  final _exploreFormKey = GlobalKey<FormBuilderState>();
  late MovieProvider _bioskopinaProvider;
  final TextEditingController _searchController = TextEditingController();

  int page = 0;
  int pageSize = 10;


  Map<String, dynamic> _filter = {
    "GetEmptyList": "true",
  };

  @override
  void initState() {
    _genreProvider = context.read<GenreProvider>();
    _bioskopinaProvider = context.read<MovieProvider>();
    _genreFuture = _genreProvider.get(filter: {"SortAlphabetically": "true"});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      selectedIndex: widget.selectedIndex,
      showNavBar: true,
      showProfileIcon: false,
      controller: _searchController,
      showSearch: true,
      onSubmitted: _search,
      onCleared: _updateFilter,
      title: "Explore",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildGenres(),
          Expanded(
            child: BioskopinaCards(
              selectedIndex: widget.selectedIndex,
              page: page,
              pageSize: pageSize,
              fetchMovie: fetchMovie,
              fetchPage: fetchPage,
              filter: _filter,
            ), // Search results section
          ),
        ],
      ),
    );
  }

  void _search(String text) {
    _updateFilter();
  }

  Future<SearchResult<Bioskopina>> fetchMovie() {
    return _bioskopinaProvider.get(filter: {
      ..._filter,
      "Page": "$page",
      "PageSize": "$pageSize",
    });
  }

  Future<SearchResult<Bioskopina>> fetchPage(Map<String, dynamic> filter) {
    return _bioskopinaProvider.get(filter: filter);
  }


  Widget _buildGenres() {
    return FutureBuilder<SearchResult<Genre>>(
        future: _genreFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Wrap(
                children: List.generate(12, (_) => const ChipIndicator()),
              ),
            ); // Loading state
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Error state
          } else {
            // Data loaded successfully
            var genres = snapshot.data!.result;
            return FormBuilder(
              key: _exploreFormKey,
              child: MyFormBuilderFilterChip(
                onChanged: ((p0) {
                  _updateFilter();
                }),
                width: 500,
                showCheckmark: false,
                padding:
                    const EdgeInsets.only(top: 0, bottom: 0, left: 1, right: 1),
                name: 'genres',
                options: [
                  ...genres.map(
                    (genre) => FormBuilderChipOption(
                      value: genre.id.toString(),
                      child: Text(genre.name!,
                          style:
                              const TextStyle(color: Palette.midnightPurple)),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }

  void _updateFilter() {
    _exploreFormKey.currentState?.saveAndValidate();
    var genreIds = _exploreFormKey.currentState?.fields["genres"]?.value;

    if (genreIds.isEmpty && _searchController.text.isEmpty) {
      setState(() {
        _filter = {"GetEmptyList": "true"};
      });
    } else {
      setState(() {
        _filter = {
          "FTS": _searchController.text,
          "GenresIncluded": "true",
          "TopFirst": "true",
          "GenreIds": genreIds,
        };
      });
    }
  }
}
