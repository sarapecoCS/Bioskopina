import 'package:flutter/material.dart';
import '../widgets/bioskopina_card.dart';
import 'package:provider/provider.dart';

import '../providers/rating_provider.dart';
import '../widgets/bioskopina_indicator.dart';
import '../providers/bioskopina_list_provider.dart';
import '../models/bioskopina.dart';
import '../models/search_result.dart';
import '../utils/util.dart';
import '../widgets/pagination_buttons.dart';

typedef FetchPage = Future<SearchResult<Bioskopina>> Function(
    Map<String, dynamic> filter);

// ignore: must_be_immutable
class BioskopinaCards extends StatefulWidget {
  final int selectedIndex;
  final Future<SearchResult<Bioskopina>> Function() fetchMovie;
  final Future<Map<String, dynamic>> Function()? getFilter;
  final FetchPage fetchPage;
  Map<String, dynamic> filter;
  int page;
  int pageSize;

  BioskopinaCards({
  super.key,
  required this.selectedIndex,
  required this.fetchMovie,
  required this.fetchPage,
  required this.filter,
  required this.page,
  required this.pageSize,
  this.getFilter,
  });

  @override
  State<BioskopinaCards> createState() => _BioskopinaCardsState();
}

class _BioskopinaCardsState extends State<BioskopinaCards>
    with AutomaticKeepAliveClientMixin<BioskopinaCards> {
  late Future<SearchResult<Bioskopina>> _bioskopinaFuture;
  final ScrollController _scrollController = ScrollController();
  late final BioskopinaListProvider _bioskopinaListProvider;
  late final RatingProvider _ratingProvider;

  int totalItems = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void didUpdateWidget(BioskopinaCards oldWidget) {
    // Check if filter has changed
    if (widget.filter != oldWidget.filter) {
      _bioskopinaFuture = widget.fetchMovie();
      setTotalItems();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _bioskopinaFuture = widget.fetchMovie();
    _bioskopinaListProvider = context.read<BioskopinaListProvider>();
    _ratingProvider = context.read<RatingProvider>();

    setTotalItems();

    _bioskopinaListProvider.addListener(() {
      setTotalItems();
    });

    _ratingProvider.addListener(_listener);

    super.initState();
  }

  @override
  void dispose() {
    _ratingProvider.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    if (mounted) {
      setState(() {
        _bioskopinaFuture = widget.fetchMovie();
      });
    }
  }

  void setTotalItems() async {
    var bioskopinaResult = await _bioskopinaFuture;
    if (mounted) {
      setState(() {
        totalItems = bioskopinaResult.count;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder<SearchResult<Bioskopina>>(
        future: _bioskopinaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Center(
                child: Wrap(
                  children: List.generate(6, (_) => const BioskopinaIndicator()),
                ),
              ),
            );
            // Loading state
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Error state
          } else {
            // Data loaded successfully
            var bioskopinaList = snapshot.data!.result;
            return SingleChildScrollView(
              controller: _scrollController,
              child: Center(
                child: Column(
                  children: [
                    Wrap(
                      children: _buildBioskopinaCards(bioskopinaList),
                    ),
                    MyPaginationButtons(
                      page: widget.page,
                      pageSize: widget.pageSize,
                      totalItems: totalItems,
                      fetchPage: fetchPage,
                      hasSearch: false,
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }

  Future<void> fetchPage(int requestedPage) async {
    try {
      var result = await widget.fetchPage({
        ...widget.filter,
        "Page": "$requestedPage",
        "PageSize": "${widget.pageSize}",
      });

      if (mounted) {
        setState(() {
          _bioskopinaFuture = Future.value(result);
          widget.page = requestedPage;
        });
      }
    } on Exception catch (e) {
      if (mounted) {
        showErrorDialog(context, e);
      }

    }

  }

  List<Widget> _buildBioskopinaCards(List<Bioskopina> bioskopinaList) {
    return List.generate(
      bioskopinaList.length,
          (index) => BioskopinaCard(
          bioskopina: bioskopinaList[index], selectedIndex: widget.selectedIndex),
    );
  }
}