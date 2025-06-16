import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:provider/provider.dart';

import '../providers/rating_provider.dart';
import '../screens/bioskopina_detail_screen.dart';
import '../widgets/cinema_indicator.dart';
import '../widgets/pagination_buttons.dart';
import '../models/bioskopina_watchlist.dart';
import '../models/rating.dart';
import '../models/search_result.dart';
import '../providers/bioskopina_watchlist_provider.dart';
import '../screens/home_screen.dart';
import '../utils/colors.dart';
import '../utils/util.dart';
import 'circular_progress_indicator.dart';
import 'empty.dart';
import 'cinema_form.dart';

typedef FetchPage = Future<SearchResult<BioskopinaWatchlist>> Function(
    Map<String, dynamic> filter);

// ignore: must_be_immutable
class CinemaCards extends StatefulWidget {
  final int selectedIndex;
  final Future<SearchResult<BioskopinaWatchlist>> Function() fetch;
  final FetchPage fetchPage;
  final Map<String, dynamic> filter;
  int page;
  int pageSize;

  CinemaCards({
    super.key,
    required this.selectedIndex,
    required this.fetch,
    required this.fetchPage,
    required this.filter,
    required this.page,
    required this.pageSize,
  });

  @override
  State<CinemaCards> createState() => _CinemaCardsState();
}

class _CinemaCardsState extends State<CinemaCards>
    with AutomaticKeepAliveClientMixin<CinemaCards> {
  late Future<SearchResult<BioskopinaWatchlist>> _bioskopinaWatchlistFuture;
  late BioskopinaWatchlistProvider _bioskopinaWatchlistProvider;
  final ScrollController _scrollController = ScrollController();
  late RatingProvider _ratingProvider;
  int totalItems = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _bioskopinaWatchlistFuture = widget.fetch();
    _bioskopinaWatchlistProvider = context.read<BioskopinaWatchlistProvider>();
    _ratingProvider = context.read<RatingProvider>();

    _bioskopinaWatchlistProvider.addListener(() {
      _reloadData();
      setTotalItems();
    });

    _ratingProvider.addListener(() {
      _reloadData();
    });

    setTotalItems();

    super.initState();
  }

  void _reloadData() {
    if (mounted) {
      setState(() {
        _bioskopinaWatchlistFuture = _bioskopinaWatchlistProvider.get(filter: {
          ...widget.filter,
          "Page": "${widget.page}",
          "PageSize": "${widget.pageSize}"
        });
      });
    }
  }

  void setTotalItems() async {
    var bioskopinaResult = await _bioskopinaWatchlistFuture;
    if (mounted) {
      setState(() {
        totalItems = bioskopinaResult.count;
      });
    }
  }

  Widget buildEditIcon(double size) {
    return Icon(
      Icons.edit,
      size: size,
      color: Palette.lightPurple,
    );
  }

  Widget buildStarIcon(double size) {
    return Icon(
      Icons.star,
      size: size,
      color: Palette.starYellow,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder<SearchResult<BioskopinaWatchlist>>(
        future: _bioskopinaWatchlistFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Center(
                child: Wrap(
                    children: List.generate(5, (_) => const CinemaIndicator())),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var bioskopinaWatchlists = snapshot.data!.result;
            if (bioskopinaWatchlists.isEmpty) {
              return const Empty(
                  text: Text("No movies in your watchlist yet"),
                  screen: HomeScreen(selectedIndex: 0),
                  child: Text("Browse Movies",
                      style: TextStyle(color: Palette.lightPurple)));
            }
            return SingleChildScrollView(
              controller: _scrollController,
              child: Center(
                child: Column(
                  children: [
                    Wrap(
                      children: _buildCinemaCards(bioskopinaWatchlists),
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
          _bioskopinaWatchlistFuture = Future.value(result);
          widget.page = requestedPage;
        });
      }
    } on Exception catch (e) {
      if (mounted) {
        showErrorDialog(context, e);
      }
    }
  }

  List<Widget> _buildCinemaCards(List<BioskopinaWatchlist> bioskopinaWatchlists) {
    return List.generate(
      bioskopinaWatchlists.length,
      (index) => _buildCinemaCard(bioskopinaWatchlists[index]),
    );
  }

  Widget _buildCinemaCard(BioskopinaWatchlist bioskopinaWatchlist) {
    Size screenSize = MediaQuery.of(context).size;
    double containerWidth = screenSize.width;
    double containerHeight = screenSize.height * 0.15;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BioskopinaDetailScreen(
                      bioskopina: bioskopinaWatchlist.bioskopina!,
                      selectedIndex: widget.selectedIndex,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          width: containerWidth,
          height: containerHeight,
          decoration: BoxDecoration(color: Palette.buttonPurple.withOpacity(0.1)),
          child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                bioskopinaWatchlist.bioskopina!.imageUrl!,
                fit: BoxFit.cover,
                width: containerWidth * 0.25,
                height: containerHeight,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth: containerWidth * 0.6),
                              child: Text(
                                bioskopinaWatchlist.bioskopina?.titleEn ?? "No Title",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 14),
                              ),
                            ),
                            Text(
                              bioskopinaWatchlist.bioskopina?.yearRelease?.toString() ?? "",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CinemaForm(
                                  bioskopina: bioskopinaWatchlist.bioskopina!,
                                  bioskopinaWatchlist: bioskopinaWatchlist,
                                );
                              },
                            );
                          },
                          child: buildEditIcon(30),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            buildStarIcon(20),
                            _buildRating(bioskopinaWatchlist),
                          ],
                        ),
                        Text(
                          "Status: ${bioskopinaWatchlist.watchStatus ?? 'Not Set'}",
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ).asGlass(
          blurX: 2,
          blurY: 2,
          tintColor: Palette.lightPurple,
        ),
      ),
    );
  }

  Widget _buildRating(BioskopinaWatchlist bioskopinaWatchlist) {
    return FutureBuilder<SearchResult<Rating>>(
      future: _ratingProvider.get(filter: {
        "UserId": "${LoggedUser.user!.id}",
        "BioskopinaId": "${bioskopinaWatchlist.bioskopina!.id}"
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyProgressIndicator(
            height: 10,
            width: 10,
            strokeWidth: 2,
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Rating? rating;
          if (snapshot.data!.count == 1) {
            rating = snapshot.data!.result.single;
          }

          return (rating?.ratingValue != null)
              ? Text("${rating?.ratingValue}",
                  style: const TextStyle(color: Palette.starYellow))
              : const Text("-", style: TextStyle(color: Palette.starYellow));
        }
      },
    );
  }
}