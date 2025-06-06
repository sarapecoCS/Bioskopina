import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/colors.dart';
import '../widgets/bioskopina_indicator.dart';
import '../models/search_result.dart';
import '../providers/bioskopina_list_provider.dart';
import '../screens/home_screen.dart';
import '../widgets/master_screen.dart';
import '../models/bioskopina.dart';
import '../models/bioskopina_list.dart';
import '../models/list.dart';
import '../providers/bioskopina_provider.dart';
import '../widgets/bioskopina_cards.dart';
import '../widgets/empty.dart';

class ConstellationDetailScreen extends StatefulWidget {
  final int selectedIndex;
  final Listt star;
  final List<BioskopinaList> bioskopinaListRandomObj;

  const ConstellationDetailScreen({
  super.key,
  required this.selectedIndex,
  required this.star,
  required this.bioskopinaListRandomObj,
  });

  @override
  State<ConstellationDetailScreen> createState() =>
      _ConstellationDetailScreenState();
}

class _ConstellationDetailScreenState extends State<ConstellationDetailScreen> {
  late MovieProvider _bioskopinaProvider;
  late BioskopinaListProvider _bioskopinaListProvider;
  late SearchResult<BioskopinaList> _bioskopinaList;

  int page = 0;
  int pageSize = 20;

  Map<String, dynamic> _filter = {};
  late Future<Map<String, dynamic>> _filterFuture;

  @override
  void initState() {
    super.initState();
    _bioskopinaProvider = context.read<MovieProvider>();
    _bioskopinaListProvider = context.read<BioskopinaListProvider>();
    _bioskopinaListProvider.addListener(_bioskopinaListListener);

    _filterFuture = getFilter();
  }

  void _bioskopinaListListener() {
    if (mounted) {
      setState(() {
        _filterFuture = getFilter();
      });
    }
  }

  @override
  void dispose() {
    _bioskopinaListProvider.removeListener(_bioskopinaListListener);
    super.dispose();
  }

  Future<Map<String, dynamic>> getFilter() async {
    if (widget.bioskopinaListRandomObj.isEmpty) {
      _filter = {};
      return {};
    }

    _bioskopinaList = await _bioskopinaListProvider.get(
      filter: {
        "ListId": "${widget.bioskopinaListRandomObj.first.listId}"
      },
    );

    List<int> animeIds = _bioskopinaList.result
        .map((bioskopinaList) => bioskopinaList.movieId!)
        .toList();

    if (_bioskopinaList.result.isNotEmpty) {
      _filter = {
        "GenresIncluded": "true",
        "NewestFirst": "true",
        "Ids": animeIds,
      };
      return _filter;
    }

    _filter = {};
    return {};
  }

  Widget buildStarTrailIcon(double size) {
    return Icon(Icons.auto_awesome, size: size, color: Palette.lightPurple);
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      selectedIndex: widget.selectedIndex,
      showNavBar: true,
      showProfileIcon: false,
      showBackArrow: true,
      titleWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("${widget.star.name}"),
          const SizedBox(width: 5),
          buildStarTrailIcon(24),
        ],
      ),
      child: FutureBuilder<Map<String, dynamic>>(
        future: _filterFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Center(
                child: Wrap(
                  children: List.generate(6, (index) => const BioskopinaIndicator()),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            Map<String, dynamic> filter = snapshot.data!;
            if (widget.bioskopinaListRandomObj.isEmpty || filter.isEmpty) {
              return const Empty(
                text: Text("This Star is empty."),
                screen: HomeScreen(selectedIndex: 0),
                child: Text("Explore Anime",
                    style: TextStyle(color: Palette.lightPurple)),
              );
            }
            return BioskopinaCards(
              selectedIndex: widget.selectedIndex,
              page: page,
              pageSize: pageSize,
              fetchMovie: fetchAnime,
              fetchPage: fetchPage,
              filter: filter,
            );
          }
        },
      ),
    );
  }

  Future<SearchResult<Bioskopina>> fetchAnime() {
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
