import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/bioskopina.dart';
import '../models/search_result.dart';
import '../providers/bioskopina_provider.dart';
import '../widgets/bioskopina_cards.dart';

class LatestScreen extends StatefulWidget {
  final int selectedIndex;
  const LatestScreen({super.key, required this.selectedIndex});

  @override
  State<LatestScreen> createState() => _LatestScreenState();
}

class _LatestScreenState extends State<LatestScreen> {
  late MovieProvider _movieProvider;
  int page = 0;
  int pageSize = 20;

  final Map<String, dynamic> _filter = {
    "GenresIncluded": "true",
    "NewestFirst": "true",
  };

  @override
  void initState() {
    _movieProvider = context.read<MovieProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BioskopinaCards(
      selectedIndex: widget.selectedIndex,
      page: page,
      pageSize: pageSize,
      fetchMovie: fetchMovie,
      fetchPage: fetchPage,
      filter: _filter,
    );
  }

  Future<SearchResult<Bioskopina>> fetchMovie() {
    return _movieProvider.get(filter: {
      ..._filter,
      "Page": "$page",
      "PageSize": "$pageSize",
    });
  }

  Future<SearchResult<Bioskopina>> fetchPage(Map<String, dynamic> filter) {
    return _movieProvider.get(filter: filter);
  }
}
