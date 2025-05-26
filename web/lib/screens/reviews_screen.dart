import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bioskopina_provider.dart';
import '../providers/rating_provider.dart';
import '../widgets/master_screen.dart';
import '../widgets/pagination_buttons.dart';
import '../models/bioskopina.dart';
import '../models/rating.dart';
import '../models/search_result.dart';
import '../models/user.dart';
import '../utils/colors.dart';
import '../utils/util.dart';
import '../widgets/circular_progress_indicator.dart';
import 'bioskopina_detail_screen.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ReviewsScreen extends StatefulWidget {
  User user;

  ReviewsScreen({
  required this.user,
  super.key,
});

@override
State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  late RatingProvider _ratingProvider;
  late Future<SearchResult<Rating>> _ratingFuture;

  late MovieProvider _movieProvider;

  int page = 0;
  int pageSize = 6;
  int totalItems = 0;

  @override
  void initState() {
    _ratingProvider = context.read<RatingProvider>();
    _ratingFuture = _ratingProvider.get(filter: {
      "UserId": "${widget.user.id}",
      "NewestFirst": "true",
      "Page": "$page",
      "PageSize": "$pageSize"
    });

    setTotalItems();
    _movieProvider = context.read<MovieProvider>();

    _ratingProvider.addListener(() {
      _reloadReviews();
      setTotalItems();
    });

    super.initState();
  }

  void _reloadReviews() {
    var ratings = _ratingProvider.get(filter: {
      "UserId": "${widget.user.id}",
      "NewestFirst": "true",
      "Page": "$page",
      "PageSize": "$pageSize"
    });

    if (mounted) {
      setState(() {
        _ratingFuture = ratings;
      });
    }
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
      titleWidget: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          widget.user.profilePicture!.profilePicture != null
              ? ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.memory(
              imageFromBase64String(
                  widget.user.profilePicture!.profilePicture!),
              width: 25,
              height: 25,
              fit: BoxFit.cover,
            ),
          )
              : const Text(""),
          const SizedBox(width: 5),
          Text("${widget.user.username}: "),
          const SizedBox(width: 5),
          const Text("Reviews"),
          const SizedBox(width: 5),
          Icon(Icons.star, size: 24, color: Colors.yellow),
        ],
      ),
      showBackArrow: true,
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
              child: Center(
                child: Column(
                  children: [
                    Wrap(
                      children: _buildReviewCards(ratingList),
                    ),
                    MyPaginationButtons(
                        page: page,
                        pageSize: pageSize,
                        totalItems: totalItems,
                        fetchPage: fetchPage),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> fetchPage(int requestedPage) async {
    try {
      var result = await _ratingProvider.get(
        filter: {
          "UserId": "${widget.user.id}",
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

  List<Widget> _buildReviewCards(List<Rating> ratingList) {
    return List.generate(
      ratingList.length,
          (index) => _buildReviewCard(ratingList[index]),
    );
  }

  Widget _buildReviewCard(Rating rating) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0, right: 20, top: 20),
      child: Container(
        constraints: const BoxConstraints(minHeight: 100, maxHeight: 200),
        height: 194,
        width: 600,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Palette.darkPurple),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.memory(
                            imageFromBase64String(
                                widget.user.profilePicture!.profilePicture!),
                            width: 43,
                            height: 43,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            constraints: const BoxConstraints(maxWidth: 350),
                            child: Text(
                                "${widget.user.firstName} ${widget.user.lastName}",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                          ),
                          FutureBuilder<SearchResult<Bioskopina>>(
                              future: _movieProvider.get(filter: {
                                "Id": "${rating.movieId!}",
                                "GenresIncluded": "True"
                              }),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const MyProgressIndicator(
                                    width: 10,
                                    height: 10,
                                    strokeWidth: 2,
                                  ); // Loading state
                                } else if (snapshot.hasError) {
                                  return Text(
                                      'Error: ${snapshot.error}'); // Error state
                                } else {
                                  // Data loaded successfully

                                  Bioskopina? tmp = snapshot.data?.result.single;
                                  if (tmp != null) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BioskopinaDetailScreen(movie: tmp),
                                          ),
                                        );
                                      },
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: Text("${tmp.titleEn}"),
                                      ),
                                    );
                                  } else {
                                    return const Text("Anime not found");
                                  }
                                }
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(Icons.star, size: 24, color: Colors.yellow),
                          const SizedBox(width: 3),
                          Text("${rating.ratingValue.toString()}/10",
                              style: const TextStyle(
                                  color: Palette.starYellow, fontSize: 13)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        DateFormat('MMM d, y').format(
                          rating.dateAdded!,
                        ),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
                _buildPopupMenu(rating)
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                alignment: Alignment.topLeft,
                constraints:
                const BoxConstraints(minHeight: 30, maxHeight: 100),
                //height: 100,
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Column(
                    children: [
                      (rating.reviewText != null && rating.reviewText != "")
                          ? Text(
                        "${rating.reviewText}",
                        style: const TextStyle(fontSize: 15),
                      )
                          : Text(
                        "User left no review text...",
                        style: TextStyle(
                            fontSize: 15,
                            color: Palette.lightPurple.withOpacity(0.5),
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  ConstrainedBox _buildPopupMenu(Rating rating) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 23),
      child: Container(
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            PopupMenuButton<String>(
              tooltip: "More actions",
              offset: const Offset(195, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Palette.lightPurple.withOpacity(0.3)),
              ),
              icon: const Icon(Icons.more_vert_rounded),
              splashRadius: 1,
              padding: EdgeInsets.zero,
              color: const Color.fromRGBO(50, 48, 90, 1),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hoverColor: Palette.lightRed.withOpacity(0.1),
                    leading: Icon(Icons.delete, size: 24, color: Colors.red),
                    title: const Text('Delete',
                        style: TextStyle(color: Palette.lightRed)),
                    subtitle: Text('Delete permanently',
                        style: TextStyle(
                            color: Palette.lightRed.withOpacity(0.5))),
                    onTap: () async {
                      Navigator.pop(context);
                      showConfirmationDialog(
                          context,
                          const Icon(Icons.warning_rounded,
                              color: Palette.lightRed, size: 55),
                          const Text(
                              "Are you sure you want to delete this review?"),
                              () async {
                            await _ratingProvider.delete(rating.id!);
                          });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}