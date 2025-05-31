import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bioskopina_provider.dart';
import '../providers/genre_bioskopina_provider.dart';
import '../utils/util.dart';
import '../widgets/master_screen.dart';
import '../models/bioskopina.dart';
import '../models/search_result.dart';
import '../utils/colors.dart';
import '../widgets/circular_progress_indicator.dart';
import 'bioskopina_detail_screen.dart';

class BioskopinaScreen extends StatefulWidget {
  const BioskopinaScreen({super.key});

  @override
  State<BioskopinaScreen> createState() => _BioskopinaScreenState();
}

class _BioskopinaScreenState extends State<BioskopinaScreen> {
  late MovieProvider _bioskopinaProvider;
  late GenreMovieProvider _genreBioskopinaProvider;
  late Future<SearchResult<Bioskopina>> _bioskopinaFuture;
  final TextEditingController _bioskopinaController = TextEditingController();

  bool isSearching = false;

  @override
  void initState() {
    super.initState();

    _bioskopinaProvider = context.read<MovieProvider>();
    _genreBioskopinaProvider = context.read<GenreMovieProvider>();

    _bioskopinaProvider.addListener(() {
      _reloadBioskopinaList();
    });
    _genreBioskopinaProvider.addListener(() {
      _reloadBioskopinaList();
    });

    // Load all movies without paging parameters
    _bioskopinaFuture = _bioskopinaProvider.get(filter: {
      "GenresIncluded": "true",
      "NewestFirst": "true",
      // No Page or PageSize, load all
    });
  }

  void _reloadBioskopinaList() {
    if (mounted) {
      setState(() {
        _bioskopinaFuture = _bioskopinaProvider.get(filter: {
          "GenresIncluded": "true",
          "NewestFirst": "true",
          // Load all
          if (isSearching) "FTS": _bioskopinaController.text,
        });
      });
    }
  }

  void _search(String searchText) async {

      var result = await _bioskopinaProvider.get(filter: {
        "FTS": searchText,
        "GenresIncluded": "true",
        "NewestFirst": "true",
        // load all search results
      });

      if (mounted) {
        setState(() {
          _bioskopinaFuture = Future.value(result);
          isSearching = true;
        });

    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: Row(
        children: [
          Icon(Icons.movie, size: 28, color: Palette.lightPurple),
          const SizedBox(width: 5),
          const Text("Bioskopina"),
        ],
      ),
      showFloatingActionButton: true,
      floatingButtonOnPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => BioskopinaDetailScreen()))
            .then((_) {
          if (mounted) _reloadBioskopinaList();
        });
      },
      showSearch: true,
      onSubmitted: _search,
      controller: _bioskopinaController,
      child: FutureBuilder<SearchResult<Bioskopina>>(
        future: _bioskopinaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MyProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var bioskopinaList = snapshot.data!.result;
            return SingleChildScrollView(
              child: Center(
                child: Wrap(
                  children: _buildBioskopinaCards(bioskopinaList),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  List<Widget> _buildBioskopinaCards(List<Bioskopina> bioskopinaList) {
    return List.generate(
      bioskopinaList.length,
          (index) => _buildBioskopinaCard(bioskopinaList[index]),
    );
  }

  Widget _buildPopupMenu(Bioskopina bioskopina) {
    return PopupMenuButton<String>(
      tooltip: "Actions",
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
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            hoverColor: Palette.lightPurple.withOpacity(0.1),
            leading: const Icon(Icons.text_snippet_rounded,
                color: Palette.lightPurple),
            title: const Text('See details',
                style: TextStyle(color: Palette.lightPurple)),
            subtitle: Text('See more information about this movie',
                style: TextStyle(color: Palette.lightPurple.withOpacity(0.5))),
            onTap: () async {
              Navigator.pop(context);
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BioskopinaDetailScreen(movie: bioskopina),
                ),
              );
              if (mounted) _reloadBioskopinaList();
            },
          ),
        ),
        PopupMenuItem<String>(
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            hoverColor: Palette.lightRed.withOpacity(0.1),
            leading: const Icon(Icons.delete, color: Palette.lightRed),
            title: const Text('Delete', style: TextStyle(color: Palette.lightRed)),
            subtitle: Text('Delete permanently',
                style: TextStyle(color: Palette.lightRed.withOpacity(0.5))),
            onTap: () {
              Navigator.pop(context);
              showConfirmationDialog(
                context,
                const Icon(Icons.warning_rounded,
                    color: Palette.lightRed, size: 55),
                const Text("Are you sure you want to delete this movie?"),
                    () async {
                  await _bioskopinaProvider.delete(bioskopina.id);
                  if (mounted) _reloadBioskopinaList();
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBioskopinaCard(Bioskopina bioskopina) {
    return Container(
      width: 300,
      height: 453,
      margin: const EdgeInsets.only(top: 20, left: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Palette.darkPurple),
      child: Column(
        children: [
          SizedBox(
            width: 300,
            height: 300,
            child: bioskopina.imageUrl != null && bioskopina.imageUrl!.isNotEmpty
                ? ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                bioskopina.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.broken_image, size: 100, color: Palette.lightPurple),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator(color: Palette.lightPurple));
                },
              ),
            )
                : Container(
              decoration: BoxDecoration(
                color: Palette.darkPurple,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: const Center(
                child: Icon(Icons.movie, size: 100, color: Palette.lightPurple),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, left: 10, bottom: 13),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Palette.starYellow, size: 17),
                    const SizedBox(width: 3),
                    Text(bioskopina.score.toString(),
                        style: const TextStyle(
                            color: Palette.starYellow, fontSize: 13)),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10, left: 5, top: 5),
                    child: Text(
                      bioskopina.titleEn,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: _buildPopupMenu(bioskopina),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  children: [
                    Text(bioskopina.synopsis),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

