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

  final ScrollController _scrollController = ScrollController();
  bool isSearching = false;

  // Hover states
  int? _hoveredCardIndex;
  String? _hoveredMenuItem;

  @override
  void initState() {
    super.initState();

    _bioskopinaProvider = context.read<MovieProvider>();
    _genreBioskopinaProvider = context.read<GenreMovieProvider>();

    _bioskopinaProvider.addListener(_reloadBioskopinaList);
    _genreBioskopinaProvider.addListener(_reloadBioskopinaList);

    _bioskopinaFuture = _bioskopinaProvider.get(filter: {
      "GenresIncluded": "true",
      "NewestFirst": "true",
    });
  }

  void _reloadBioskopinaList() {
    if (mounted) {
      setState(() {
        _bioskopinaFuture = _bioskopinaProvider.get(filter: {
          "GenresIncluded": "true",
          "NewestFirst": "true",
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
    });

    if (mounted) {
      setState(() {
        _bioskopinaFuture = Future.value(result);
        isSearching = true;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bioskopinaController.dispose();
    super.dispose();
  }

  void showDeletedSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF0A0A0A), // super dark black
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.check_circle_outline, color: Colors.white, size: 50),
                SizedBox(height: 15),
                Text(
                  'Deleted successfully',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: Row(
        children: [
          const Icon(Icons.movie, size: 28, color: Palette.lightPurple),
          const SizedBox(width: 5),
          const Text("Bioskopina", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        ],
      ),
      showFloatingActionButton: true,
      floatingButtonOnPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const BioskopinaDetailScreen()))
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
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          } else {
            var bioskopinaList = snapshot.data?.result ?? [];
            if (bioskopinaList.isEmpty) {
              return const Center(
                child: Text(
                  'No movies found.',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
              );
            }
            return ScrollbarTheme(
              data: ScrollbarThemeData(
                thumbColor: MaterialStateProperty.all(Palette.lightPurple),
                thickness: MaterialStateProperty.all(6),
                radius: const Radius.circular(10),
              ),
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Center(
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: _buildBioskopinaCards(bioskopinaList),
                    ),
                  ),
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
      (index) => _buildBioskopinaCard(bioskopinaList[index], index),
    );
  }

  Widget _buildPopupMenu(Bioskopina bioskopina) {
    return PopupMenuButton<String>(
      tooltip: "Actions",
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Palette.lightPurple.withOpacity(0.3)),
      ),
      icon: const Icon(Icons.more_vert_rounded, color: Colors.white70),
      splashRadius: 20,
      padding: EdgeInsets.zero,
      color: const Color(0xFF0A0A0A),

      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          child: MouseRegion(
            onEnter: (_) => setState(() => _hoveredMenuItem = 'details-${bioskopina.id}'),
            onExit: (_) => setState(() => _hoveredMenuItem = null),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              hoverColor: Palette.lightPurple.withOpacity(0.1),
              leading: Icon(
                Icons.text_snippet_rounded,
                color: _hoveredMenuItem == 'details-${bioskopina.id}' ? Palette.lightPurple : Palette.lightPurple.withOpacity(0.7),
              ),
              title: Text(
                'See details',
                style: TextStyle(
                  color: _hoveredMenuItem == 'details-${bioskopina.id}' ? Palette.lightPurple : Palette.lightPurple.withOpacity(0.7),
                ),
              ),
              subtitle: Text(
                'More info about this movie',
                style: TextStyle(
                  color: _hoveredMenuItem == 'details-${bioskopina.id}'
                      ? Palette.lightPurple.withOpacity(0.7)
                      : Palette.lightPurple.withOpacity(0.4),
                ),
              ),
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
        ),
        PopupMenuItem<String>(
          child: MouseRegion(
            onEnter: (_) => setState(() => _hoveredMenuItem = 'delete-${bioskopina.id}'),
            onExit: (_) => setState(() => _hoveredMenuItem = null),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              hoverColor: Palette.lightRed.withOpacity(0.1),
              leading: Icon(
                Icons.delete,
                color: _hoveredMenuItem == 'delete-${bioskopina.id}' ? Palette.lightRed : Palette.lightRed.withOpacity(0.7),
              ),
              title: Text(
                'Delete',
                style: TextStyle(
                  color: _hoveredMenuItem == 'delete-${bioskopina.id}' ? Palette.lightRed : Palette.lightRed.withOpacity(0.7),
                ),
              ),
              subtitle: Text(
                'Delete permanently',
                style: TextStyle(
                  color: _hoveredMenuItem == 'delete-${bioskopina.id}'
                      ? Palette.lightRed.withOpacity(0.7)
                      : Palette.lightRed.withOpacity(0.4),
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                await showConfirmationDialog(
                  context,
                  const Icon(Icons.warning_rounded, color: Palette.lightRed, size: 55),
                  const Text("Are you sure you want to delete this movie?"),
                  () async {
                    await _bioskopinaProvider.delete(bioskopina.id);
                    if (mounted) {
                      _reloadBioskopinaList();
                      showDeletedSuccessDialog(context);
                    }
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBioskopinaCard(Bioskopina bioskopina, int index) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredCardIndex = index),
      onExit: (_) => setState(() => _hoveredCardIndex = null),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BioskopinaDetailScreen(movie: bioskopina),
          ));
        },
        borderRadius: BorderRadius.circular(15),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 300,
          height: 480,
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: _hoveredCardIndex == index ? Palette.darkPurple.withOpacity(0.85) : Palette.darkPurple,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_hoveredCardIndex == index ? 0.3 : 0.15),
                blurRadius: _hoveredCardIndex == index ? 15 : 10,
                offset: const Offset(3, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                width: 300,
                height: 300,
                child: bioskopina.imageUrl != null && bioskopina.imageUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                        child: Hero(
                          tag: bioskopina.id.toString(),
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
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Palette.midnightPurple,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                        ),
                        child: const Center(
                          child: Icon(Icons.movie, size: 100, color: Palette.lightPurple),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 8, 0),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Palette.starYellow, size: 18),
                    const SizedBox(width: 5),
                    Text(
                      bioskopina.score.toString(),
                      style: const TextStyle(
                        color: Palette.starYellow,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        bioskopina.titleEn,
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                    ),
                    _buildPopupMenu(bioskopina),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      bioskopina.synopsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
