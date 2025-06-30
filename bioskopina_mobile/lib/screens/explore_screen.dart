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
import '../widgets/add_review.dart';

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
    super.initState();
    _genreProvider = context.read<GenreProvider>();
    _bioskopinaProvider = context.read<MovieProvider>();
    _genreFuture = _genreProvider.get(filter: {"SortAlphabetically": "true"});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    setState(() {
      page = 0;
    });
    _updateFilter();
  }

  void _updateFilter() {
    _exploreFormKey.currentState?.saveAndValidate();
    var genreIds = _exploreFormKey.currentState?.fields["genres"]?.value;

    final searchText = _searchController.text.trim();

    if ((genreIds == null || genreIds.isEmpty) && searchText.isEmpty) {
      setState(() {
        page = 0;
        _filter = {"GetEmptyList": "true"};
      });
    } else {
      setState(() {
        page = 0;
        _filter = {
          if (searchText.isNotEmpty) "FTS": searchText,
          "GenresIncluded": (genreIds != null && genreIds.isNotEmpty).toString(),
          if (genreIds != null && genreIds.isNotEmpty) "GenreIds": genreIds,
          "TopFirst": "true",
        };
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      selectedIndex: widget.selectedIndex,
      showNavBar: true,
      showHelpIcon: true,
      showProfileIcon: true,
      controller: _searchController,
      showSearch: false,
      onCleared: _updateFilter,
      title: "Explore",
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search movies...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: _search,
                    tooltip: "Search",
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            _updateFilter();
                          },
                          tooltip: "Clear search",
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _search(),
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.blueAccent,
              ),
            ),

            // Genres filter chips
            _buildGenres(),

            // Results list (wrapped in SizedBox to limit height)
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: BioskopinaCards(
                selectedIndex: widget.selectedIndex,
                page: page,
                pageSize: pageSize,
                fetchMovie: fetchMovie,
                fetchPage: fetchPage,
                filter: _filter,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenres() {
    return FutureBuilder<SearchResult<Genre>>(
      future: _genreFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              children: List.generate(12, (_) => const ChipIndicator()),
            ),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.redAccent)),
          );
        } else {
          var genres = snapshot.data!.result;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: FormBuilder(
              key: _exploreFormKey,
              child: MyFormBuilderFilterChip(
                name: 'genres',
                options: genres.map((genre) {
                  return FormBuilderChipOption(
                    value: genre.id.toString(),
                    child: Text(
                      genre.name ?? '',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                showCheckmark: false,
                onChanged: (_) => _updateFilter(),
              ),
            ),
          );
        }
      },
    );
  }
}
