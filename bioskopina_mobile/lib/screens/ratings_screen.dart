import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/bioskopina.dart';
import '../models/rating.dart';
import '../models/search_result.dart';
import '../models/user.dart';
import '../providers/rating_provider.dart';
import '../providers/user_provider.dart';
import '../utils/colors.dart';
import '../utils/util.dart';
import '../widgets/circular_progress_indicator.dart';
import '../widgets/master_screen.dart';
import '../widgets/pagination_buttons.dart';

class RatingsScreen extends StatefulWidget {
  final Bioskopina bioskopina;
  const RatingsScreen({super.key, required this.bioskopina});

  @override
  State<RatingsScreen> createState() => _RatingsScreenState();
}

class _RatingsScreenState extends State<RatingsScreen> {
  late RatingProvider _ratingProvider;
  late Future<SearchResult<Rating>> _ratingFuture;
  final ScrollController _scrollController = ScrollController();
  late UserProvider _userProvider;

  int page = 0;
  int pageSize = 10;
  int totalItems = 0;

  @override
  void initState() {
    _userProvider = context.read<UserProvider>();

    _ratingProvider = context.read<RatingProvider>();
    _ratingFuture = _ratingProvider.get(filter: {
      "MovieId": "${widget.bioskopina.id}",
      "NewestFirst": "true",
      "Page": "$page",
      "PageSize": "$pageSize",
    });

    setTotalItems();

    super.initState();
  }

  void setTotalItems() async {
    var ratingResult = await _ratingFuture;
    if (mounted) {
      setState(() {
        totalItems = ratingResult.count;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        showBackArrow: true,
        showSearch: false,
        showProfileIcon: false,
        showNavBar: false,
        title: "Reviews",
        child: FutureBuilder<SearchResult<Rating>>(
            future: _ratingFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const MyProgressIndicator(); // Loading state
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}'); // Error state
              } else {
                // Data loaded successfully
                var ratingList = snapshot.data!.result;

                return SingleChildScrollView(
                  controller: _scrollController,
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Wrap(
                            children: _buildRatingCards(ratingList),
                          ),
                        ),
                        MyPaginationButtons(
                          page: page,
                          pageSize: pageSize,
                          totalItems: totalItems,
                          fetchPage: fetchPage,
                          hasSearch: false,
                        ),
                      ],
                    ),
                  ),
                );
              }
            }));
  }

  List<Widget> _buildRatingCards(List<Rating> ratingList) {
    return List.generate(
      ratingList.length,
      (index) => _buildReviewCard(ratingList[index]),
    );
  }

  Widget _buildReviewCard(Rating rating) {
    final Size screenSize = MediaQuery.of(context).size;
    double? ratingHeight =
        rating.reviewText != "" ? screenSize.width * 0.45 : 42;

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(right: 15, left: 15, bottom: 10),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 48,
            maxHeight: 200,
            minWidth: 315,
          ),
          height: ratingHeight,
          decoration: BoxDecoration(
            border: Border.all(color: Palette.lightPurple.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(15),
            color: Palette.darkPurple.withOpacity(0.4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 1),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.star,color:Colors.yellow, size: 15)
                                  ,
                                  const SizedBox(width: 3),
                                  Text(
                                    "${rating.ratingValue.toString()}/10",
                                    style: const TextStyle(
                                      color: Palette.starYellow,
                                      fontSize: 10,
                                    ),
                                  ),
                                  const Text(" by"),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildUsername(rating),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      DateFormat('MMM d, y').format(
                        rating.dateAdded!,
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: rating.reviewText != "",
                child: Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 10, left: 10, bottom: 10),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 200,
                        ),
                        child: Text(
                          "${rating.reviewText}",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ).asGlass(
            blurX: 5,
            blurY: 5,
            tintColor: Palette.darkPurple,
            clipBorderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildUsername(Rating rating) {
    return FutureBuilder<SearchResult<User>>(
        future: _userProvider.get(filter: {"Id": "${rating.userId}"}),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MyProgressIndicator(
              height: 10,
              width: 10,
              strokeWidth: 2,
            ); // Loading state
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Error state
          } else {
            // Data loaded successfully
            User? user;
            if (snapshot.data!.result.isNotEmpty) {
              user = snapshot.data!.result.single;
            }

            return (user != null)
                ? Container(
                    constraints: const BoxConstraints(maxWidth: 120),
                    child: Text("${user.username}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                  )
                : const Text("");
          }
        });
  }

  Future<void> fetchPage(int requestedPage) async {
    try {
      var result = await _ratingProvider.get(
        filter: {
          "MovieId": "${widget.bioskopina.id}",
          "NewestFirst": "true",
          "Page": "$requestedPage",
          "PageSize": "$pageSize",
        },
      );

      if (mounted) {
        setState(() {
          _ratingFuture = Future.value(result);
          page = requestedPage;
        });
      }
    } on Exception catch (e) {
      if (mounted) {
        showErrorDialog(context, e);
      }
    }
  }
}
