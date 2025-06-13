import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glass/glass.dart';
import 'package:intl/intl.dart';
import '../models/recommender.dart';
import '../providers/bioskopina_provider.dart';
import '../providers/recommender_provider.dart';
import '../widgets/bioskopina_card.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../providers/genre_provider.dart';
import '../providers/rating_provider.dart';
import '../screens/ratings_screen.dart';
import '../screens/video_screen.dart';
import '../widgets/master_screen.dart';
import '../widgets/separator.dart';
import '../models/bioskopina.dart';
import '../models/genre.dart';
import '../models/rating.dart';
import '../models/search_result.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/colors.dart';
import '../utils/util.dart';
import '../widgets/circular_progress_indicator.dart';
import '../widgets/gradient_button.dart';

class BioskopinaDetailScreen extends StatefulWidget {
  final Bioskopina bioskopina;
  final int selectedIndex;

  const BioskopinaDetailScreen(
  {super.key, required this.selectedIndex, required this.bioskopina});

  @override
  State<BioskopinaDetailScreen> createState() => _BioskopinaDetailScreenState();
}

class _BioskopinaDetailScreenState extends State<BioskopinaDetailScreen> {
  late GenreProvider _genreProvider;
  late Future<SearchResult<Genre>> _genreFuture;
  late YoutubePlayerController _youtubePlayerController;
  late ValueNotifier<int> playbackPosition;
  late ValueNotifier<bool> isPlaying;
  late RatingProvider _ratingProvider;
  late Future<SearchResult<Rating>> _ratingFuture;
  late UserProvider _userProvider;
  late RecommenderProvider _recommenderProvider;
  late MovieProvider _movieProvider;

@override
void initState() {
  super.initState();

  _genreProvider = context.read<GenreProvider>();
  _genreFuture = _genreProvider.get(filter: {"SortAlphabetically": "true"});

  _recommenderProvider = context.read<RecommenderProvider>();
  _movieProvider = context.read<MovieProvider>();
  _userProvider = context.read<UserProvider>();
  _ratingProvider = context.read<RatingProvider>();

  _ratingFuture = _ratingProvider.get(filter: {
    "MovieId": "${widget.bioskopina.id}",
    "NewestFirst": "true",
    "TakeItems": 1,
  });

  // Get trailer URL, use empty string if null, trim whitespace
  String videoLink = (widget.bioskopina.trailerUrl ?? '').trim();

  // Extract YouTube video ID from URL
  String videoId = extractVideoId(videoLink);

  // If extraction failed, use fallback video ID
  if (videoId.isEmpty) {
    videoId = '9RXs4tnExXM'; // fallback ID (e.g., classic Black Wave example)
  }

  print('Trailer URL: $videoLink');
  print('Extracted videoId: $videoId');

  // Initialize YouTube player controller
  _youtubePlayerController = YoutubePlayerController(
    initialVideoId: videoId,
    flags: const YoutubePlayerFlags(
      autoPlay: true,
      mute: false,
    ),
  );

  // Add listener for updating playback status
  _youtubePlayerController.addListener(updateVideoProgress);

  // Initialize playback value notifiers
  playbackPosition = ValueNotifier<int>(0);
  isPlaying = ValueNotifier<bool>(false);
}

// Update the playbackPosition and isPlaying value notifiers, inside setState
void _updatePlaybackStatus(int position, bool playing) {
  setState(() {
    playbackPosition.value = position;
    isPlaying.value = playing;
  });
}

// Listener for YoutubePlayerController that updates playback info
void updateVideoProgress() {
  playbackPosition.value = _youtubePlayerController.value.position.inSeconds;
  isPlaying.value = _youtubePlayerController.value.isPlaying;
}

// Safely parse date string, returning null if invalid or placeholder
DateTime? parseDate(String? dateString) {
  if (dateString == null || dateString.contains("0001-01-01")) {
    return null;
  }
  return DateTime.tryParse(dateString);
}

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    double? imgWidth = screenSize.width * 0.7;

    return MasterScreenWidget(
      selectedIndex: widget.selectedIndex,
      showNavBar: false,
      showProfileIcon: false,
      showBackArrow: true,
      title: "Movie details",
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Palette.lightPurple.withOpacity(0.5),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(15)),
                  child: (widget.bioskopina.imageUrl != null)
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      widget.bioskopina.imageUrl!,
                      width: imgWidth,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  )
                      : const SizedBox(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 10,
                  right: 10,
                ),
                child: Text("${widget.bioskopina.titleEn}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500)),
              ),
              _buildGenres(),
              _buildDetails(),
              _buildSynopsis(),
              _buildTrailer(),
              MySeparator(
                width: MediaQuery.of(context).size.width * 0.8,
                paddingTop: 20,
                paddingBottom: 10,
                borderRadius: 50,
                opacity: 0.8,
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Text("Reviews",
                    style:
                    TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
              ),
              _buildRating(),
              _buildRecommendations(),
            ],
          ),
        ),
      ),
    );
  }

 Widget _buildRecommendations() {
   return FutureBuilder<List<Bioskopina>>(
     future: _movieProvider.getRecommendedMovies(widget.bioskopina.id!),
     builder: (context, snapshot) {
       if (snapshot.connectionState == ConnectionState.waiting) {
         return const Center(child: CircularProgressIndicator());
       } else if (snapshot.hasError) {
         return Text('Error: ${snapshot.error}');
       } else {
         var recommendedMovies = snapshot.data ?? [];
         print('Recommended movies fetched: ${recommendedMovies.length}');

         if (recommendedMovies.isEmpty) {
           return const Padding(
             padding: EdgeInsets.all(8.0),
             child: Text('No recommendations found.'),
           );
         }

         return Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             MySeparator(
               width: MediaQuery.of(context).size.width * 0.8,
               paddingTop: 20,
               paddingBottom: 10,
               borderRadius: 50,
               opacity: 0.8,
             ),
             const Padding(
               padding: EdgeInsets.only(bottom: 15, left: 12),
               child: Text(
                 "Recommendations",
                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
               ),
             ),
             SingleChildScrollView(
               scrollDirection: Axis.horizontal,
               child: Row(
                 children: _buildRecBioskopinaCards(recommendedMovies),
               ),
             ),
           ],
         );
       }
     },
   );
 }

 List<Widget> _buildRecBioskopinaCards(List<Bioskopina> movies) {
   return movies.asMap().entries.map((entry) {
     int index = entry.key;
     Bioskopina movie = entry.value;
     return GestureDetector(
       onTap: () {
         Navigator.push(
           context,
           MaterialPageRoute(
             builder: (context) => BioskopinaDetailScreen(
               bioskopina: movie,
               selectedIndex: index,  // pass the index here
             ),
           ),
         );
       },
       child: Container(
         width: 150,
         margin: const EdgeInsets.symmetric(horizontal: 8),
         child: Column(
           children: [
             ClipRRect(
               borderRadius: BorderRadius.circular(8),
               child: Image.network(
                 movie.imageUrl ?? '',
                 width: 140,
                 height: 200,
                 fit: BoxFit.cover,
                 errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
               ),
             ),
             const SizedBox(height: 6),
             Text(
               movie.titleEn ?? 'Unknown',
               maxLines: 2,
               overflow: TextOverflow.ellipsis,
               textAlign: TextAlign.center,
             ),
           ],
         ),
       ),
     );
   }).toList();
 }


  Widget _buildSeeMoreRatings() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RatingsScreen(bioskopina: widget.bioskopina)));
        },
        child: const Text("See more",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
      ),
    );
  }

  Widget _buildRating() {
    return FutureBuilder<SearchResult<Rating>>(
        future: _ratingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MyProgressIndicator(); // Loading state
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Error state
          } else {
            // Data loaded successfully

            Rating? rating;
            if (snapshot.data!.result.isNotEmpty) {
              rating = snapshot.data!.result.single;
            }

            return _buildReviewCard(rating);
          }
        });
  }

  Widget _buildReviewCard(Rating? rating) {
    if (rating == null) {
      return Text("No reviews yet",
          style: TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              color: Palette.lightPurple.withOpacity(0.5)));
    }

    final Size screenSize = MediaQuery.of(context).size;
    double? ratingHeight =
    rating.reviewText != "" ? screenSize.width * 0.45 : 42;

    return Center(
      child: Column(
        children: [
          Padding(
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                    Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 16,
                                  ),
                                      const SizedBox(width: 3),
                                      Text(
                                        "${rating.ratingValue.toString()}/10",
                                        style: const TextStyle(
                                          color: Palette.starYellow,
                                          fontSize: 13,
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
                        padding: const EdgeInsets.only(
                            right: 10, left: 10, bottom: 10),
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
          _buildSeeMoreRatings(),
        ],
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

Widget _buildTrailer() {
  final Size screenSize = MediaQuery.of(context).size;

  final String? trailerUrl = widget.bioskopina.trailerUrl;

  final String videoId = YoutubePlayer.convertUrlToId(trailerUrl ?? "") ?? "";

  if (trailerUrl == null || trailerUrl.isEmpty || videoId.isEmpty) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        "Trailer unavailable.",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        textAlign: TextAlign.center,
      ),
    );
  }

  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              "Trailer",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: YoutubePlayer(
              width: screenSize.width,
              controller: _youtubePlayerController,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blue,
              progressColors: const ProgressBarColors(
                playedColor: Colors.blue,
                handleColor: Colors.blue,
              ),
              bottomActions: [
                CurrentPosition(),
                ProgressBar(
                  isExpanded: true,
                  colors: const ProgressBarColors(
                    playedColor: Colors.blue,
                    handleColor: Colors.blue,
                  ),
                ),
                RemainingDuration(),
                GestureDetector(
                  onTap: () {
                    _youtubePlayerController.pause();
                    // Remove _controller.enterFullScreen(); as it doesn't exist
                    // If you want fullscreen, handle separately
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Icon(Icons.fullscreen_rounded,
                        color: Colors.white, size: 30),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


 void _enterFullScreen() {
   SystemChrome.setPreferredOrientations([
     DeviceOrientation.landscapeRight,
     DeviceOrientation.landscapeLeft,
   ]);

   String? videoLink = widget.bioskopina.trailerUrl;
   print('Trailer URL: $videoLink');

   // Defensive: check trailerUrl type and null
   if (videoLink == null || videoLink.isEmpty) {
     print('Error: trailerUrl is null or empty!');
     return;
   }

   // Extract video ID safely
   String videoId = YoutubePlayer.convertUrlToId(videoLink) ?? "";
   print('Extracted videoId: $videoId');

   if (videoId.isEmpty) {
     print('Error: Could not extract valid video ID!');
     return;
   }

   Navigator.push(
     context,
     MaterialPageRoute(
       builder: (context) => VideoScreen(
         videoId: videoId,
         playbackPosition: playbackPosition,
         isPlaying: isPlaying,
         updatePlaybackStatus: _updatePlaybackStatus,
       ),
     ),
   ).then((value) {
     SystemChrome.setPreferredOrientations([
       DeviceOrientation.portraitUp,
     ]);

     if (value != null && value is List && value.length == 2) {
       int position = value[0];
       bool playing = value[1];

       _youtubePlayerController.seekTo(Duration(seconds: position));

       if (playing) {
         _youtubePlayerController.play();
       } else {
         _youtubePlayerController.pause();
       }
     }
   });
 }

  @override
  void dispose() {
    _youtubePlayerController.dispose();
    playbackPosition.dispose();

    super.dispose();
  }

  Widget _buildSynopsis() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
        top: 30,
        bottom: 20,
      ),
      child: Text(
        "${widget.bioskopina.synopsis}",
      ),
    );
  }

Widget _buildDetails() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Palette.darkPurple.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Palette.lightPurple.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Rating
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Rating",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.yellow , size: 16),
                  const SizedBox(width: 4),
                  Text(
                    widget.bioskopina.score.toString(),
                    style: const TextStyle(color: Palette.starYellow, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),

          // Divider
          Container(
            height: 40,
            width: 1,
            color: Palette.lightPurple.withOpacity(0.5),
          ),

          // Duration
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Duration",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                "${widget.bioskopina.runtime} min",
                style: const TextStyle(color: Palette.lightPurple, fontSize: 14),
              ),
            ],
          ),

          // Divider
          Container(
            height: 40,
            width: 1,
            color: Palette.lightPurple.withOpacity(0.5),
          ),

          // Director (fixed here)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Director",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 120, // adjust width if needed
                child: Text(
                  widget.bioskopina.director ?? "Unknown",
                  style: const TextStyle(color: Palette.lightPurple, fontSize: 14),
                  overflow: TextOverflow.visible,
                  maxLines: 1,
                  softWrap: false,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
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
            return const MyProgressIndicator(
              height: 48,
              width: 48,
              strokeWidth: 4,
            ); // Loading state
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Error state
          } else {
            // Data loaded successfully
            var genreList = snapshot.data!;

            List<int> bioskopinaGenreIDs = widget.bioskopina.genreMovies!
                .map((genreBioskopina) => genreBioskopina.genreId!)
                .toList();

            List<String> bioskopinaGenres = genreList.result
                .where((genre) => bioskopinaGenreIDs.contains(genre.id))
                .map((genre) => genre.name!)
                .toList();

            return Wrap(
              spacing: 8,
              children: bioskopinaGenres.map((e) {
                return GradientButton(
                  contentPaddingBottom: 3,
                  contentPaddingLeft: 8,
                  contentPaddingRight: 8,
                  contentPaddingTop: 3,
                  gradient: Palette.navGradient4,
                  borderRadius: 50,
                  child: Text(e,
                      style: const TextStyle(color: Palette.lightPurple)),
                );
              }).toList(),
            );
          }
        });
  }
}
