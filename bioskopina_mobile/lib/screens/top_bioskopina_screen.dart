import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/bioskopina.dart';
import '../models/search_result.dart';
import '../providers/bioskopina_provider.dart';
import '../widgets/bioskopina_cards.dart';

class TopBioskopinaScreen extends StatefulWidget {
  final int selectedIndex;
  const TopBioskopinaScreen({super.key, required this.selectedIndex});

  @override
  State<TopBioskopinaScreen> createState() => _TopBioskopinaScreenState();
}

class _TopBioskopinaScreenState extends State<TopBioskopinaScreen> {
  late MovieProvider _bioskopinaProvider;

  int page = 0;
  int pageSize = 20;

  final Map<String, dynamic> _filter = {
    "GenresIncluded": "true",
    "TopFirst": "true",
  };

  @override
  void initState() {
    _bioskopinaProvider = context.read<MovieProvider>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BioskopinaCards(
      selectedIndex: widget.selectedIndex,
      page: page,
      pageSize: pageSize,
      fetchMovie: fetchMovies,
      fetchPage: fetchPage,
      filter: _filter,
    );
  }

  Future<SearchResult<Bioskopina>> fetchMovies() {
    return _bioskopinaProvider.get(filter: {
      ..._filter,
      "Page": "$page",
      "PageSize": "$pageSize",
    });
  }

  Future<SearchResult<Bioskopina>> fetchPage(Map<String, dynamic> filter) {
    return _bioskopinaProvider.get(filter: filter);
  }
}
