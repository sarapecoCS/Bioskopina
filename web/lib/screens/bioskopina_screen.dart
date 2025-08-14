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
import 'bioskopina_add_screen.dart';
import '../widgets/custom_dialogs.dart';

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.grey.withOpacity(0.5), // light grey border
            width: 1.5,
          ),
        ),
        backgroundColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.task_alt,
                color: Color.fromRGBO(102, 204, 204, 1),
                size: 50,
              ),
              const SizedBox(height: 20),
              const Text(
                "Deleted successfully!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 80,
                  height: 30,
                  decoration: BoxDecoration(
                    gradient: Palette.buttonGradient,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showDeleteConfirmationDialog(BuildContext context, Bioskopina bioskopina) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        elevation: 30,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 380,
            minHeight: 200,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 28.0
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.warning_rounded,  // Using the warning icon from your first dialog
                  color: Palette.lightRed,
                  size: 55,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Are you sure you want to delete this movie?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Cancel Button
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF264640),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 36
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 60),
                    // Delete Button
                    Container(
                      decoration: BoxDecoration(
                        gradient: Palette.buttonGradient,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 36
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          await _bioskopinaProvider.delete(bioskopina.id);
                          if (mounted) {
                            showDeletedSuccessDialog(context);
                            _reloadBioskopinaList();
                          }
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: Row(
        children: [
          const Icon(Icons.theater_comedy, size: 28, color: Palette.lightPurple),
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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
            child: Center(
              child: Text(
                'Truth hides in the shadows between frames',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'PlayfairDisplay',
                  shadows: [
                    Shadow(
                      offset: Offset(1.5, 1.5),
                      blurRadius: 4.0,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<SearchResult<Bioskopina>>(
              future: _bioskopinaFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const MyProgressIndicator();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
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
          ),
        ],
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
      color: const Color.fromRGBO(0, 0, 0, 1),
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
                'Delete this movie',
                style: TextStyle(
                  color: _hoveredMenuItem == 'delete-${bioskopina.id}'
                      ? Palette.lightRed.withOpacity(0.7)
                      : Palette.lightRed.withOpacity(0.4),
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                showDeleteConfirmationDialog(context, bioskopina);
              },
            ),
          ),
        ),
      ],
    );
  }

Widget _buildBioskopinaCard(Bioskopina bioskopina, int index) {
  bool isHovered = _hoveredCardIndex == index;
  return MouseRegion(
    onEnter: (_) => setState(() => _hoveredCardIndex = index),
    onExit: (_) => setState(() => _hoveredCardIndex = null),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: 320,
      height: 480, // Fixed card height
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Palette.lightPurple.withOpacity(isHovered ? 1.0 : 0.3),
          width: 2,
        ),
        boxShadow: isHovered
            ? [
                BoxShadow(
                  color: Palette.lightPurple.withOpacity(0.5),
                  offset: const Offset(0, 0),
                  blurRadius: 12,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section (fixed height)
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 240,
                  child: bioskopina.imageUrl != null
                      ? Image.network(
                          bioskopina.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[900],
                            child: const Center(
                              child: Icon(Icons.broken_image, color: Colors.grey),
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey[900],
                          child: const Center(
                            child: Icon(Icons.movie, size: 80, color: Colors.grey),
                          ),
                        ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: _buildPopupMenu(bioskopina),
                  ),
                ),
              ],
            ),
            // Content section (scrollable if needed)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bioskopina.titleEn,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Director: ${bioskopina.director}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Palette.starYellow, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          bioskopina.score.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Scrollable synopsis section
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: Text(
                                bioskopina.synopsis,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 14
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
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