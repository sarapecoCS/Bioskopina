import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../providers/bioskopina_list_provider.dart';
import '../providers/list_provider.dart';
import '../screens/waves_detail_screen.dart';
import '../widgets/star_form.dart';
import '../models/bioskopina_list.dart';
import '../models/list.dart';
import '../models/search_result.dart';
import '../utils/colors.dart';
import '../utils/util.dart';
import '../widgets/pagination_buttons.dart';
import 'empty.dart';

class WaveCards extends StatefulWidget {
  final int selectedIndex;
  const WaveCards({super.key, required this.selectedIndex});

  @override
  State<WaveCards> createState() => _WaveCardsState();
}

class _WaveCardsState extends State<WaveCards> {
  late Future<SearchResult<Listt>> _listFuture;
  late final ListtProvider _listProvider;
  late final BioskopinaListProvider _bioskopinaListProvider;
  final ScrollController _scrollController = ScrollController();

  int page = 0;
  int pageSize = 6;
  int totalItems = 0;

  @override
  void initState() {
    _listProvider = context.read<ListtProvider>();
    _listFuture = _listProvider.get(
      filter: {
        "UserId": "${LoggedUser.user!.id}",
        "NewestFirst": "true",
        "Page": "$page",
        "PageSize": "$pageSize",
      },
    );

    _bioskopinaListProvider = context.read<BioskopinaListProvider>();

    _listProvider.addListener(() {
      _reloadData();
      setTotalItems();
    });

    _bioskopinaListProvider.addListener(
      () {
        _reloadData();
        setTotalItems();
      },
    );

    setTotalItems();

    super.initState();
  }

  void _reloadData() {
    if (mounted) {
      setState(() {
        _listFuture = _listProvider.get(filter: {
          "UserId": "${LoggedUser.user!.id}",
          "NewestFirst": "true",
          "Page": "$page",
          "PageSize": "$pageSize",
        });
      });
    }
  }

  void setTotalItems() async {
    var listResult = await _listFuture;
    if (mounted) {
      setState(() {
        totalItems = listResult.count;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SearchResult<Listt>>(
        future: _listFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Center(
                child: Wrap(
                    children:
                        List.generate(6, (index) => _waveIndicator())),
              ),
            ); // Loading state
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Error state
          } else {
            // Data loaded successfully
            var lists = snapshot.data!.result;
            if (lists.isEmpty) {
              return const Empty(
                text: Text(
                  "Your Waves are empty.\nTry adding some Stars!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Palette.lightPurple),
                ),
                showGradientButton: false,
              );
            }
            return SingleChildScrollView(
              controller: _scrollController,
              child: Center(
                child: Column(
                  children: [
                    Wrap(
                      children: _buildListCards(lists),
                    ),
                    MyPaginationButtons(
                      page: page,
                      pageSize: pageSize,
                      totalItems: totalItems,
                      fetchPage: fetchPage,
                      hasSearch: true,
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
      var result = await _listProvider.get(
        filter: {
          "UserId": "${LoggedUser.user!.id}",
          "NewestFirst": "true",
          "Page": "$requestedPage",
          "PageSize": "$pageSize",
        },
      );

      if (mounted) {
        setState(() {
          _listFuture = Future.value(result);
          page = requestedPage;
        });
      }
    } on Exception catch (e) {
      if (mounted) {
        showErrorDialog(context, e);
      }
    }
  }

  List<Widget> _buildListCards(List<Listt> lists) {
    return List.generate(
      lists.length,
      (index) => _buildListCard(lists[index]),
    );
  }

  Widget _buildListCard(Listt list) {
    final Size screenSize = MediaQuery.of(context).size;
    double? cardWidth = screenSize.width * 0.45;
    double? cardHeight = screenSize.height * 0.2;

    return FutureBuilder<SearchResult<BioskopinaList>>(
        future: _bioskopinaListProvider.get(
          filter: {
            "ListId": "${list.id}",
            "IncludeMovie": "true",
            "GetRandom": "true",
          },
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _waveIndicator(); // Loading state
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Error state
          } else {
            // Data loaded successfully
            var bioskopinaListObject = snapshot.data!.result;

            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WaveDetailScreen(
                          selectedIndex: widget.selectedIndex,
                          star: list,
                          bioskopinaListRandomObj: bioskopinaListObject,
                        )));
              },
              child: Container(
                height: cardHeight,
                width: cardWidth,
                margin: const EdgeInsets.all(7),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Opacity(
                        opacity: 0.7,
                        child: _buildCoverPhoto(
                            cardWidth, cardHeight, bioskopinaListObject),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: 5,
                          bottom: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Palette.darkPurple.withOpacity(0.5),
                        ),
                        child: Text("${list.name}",
                            style: const TextStyle(
                              fontSize: 17,
                            )),
                      ).asGlass(
                        blurX: 4,
                        blurY: 4,
                        clipBorderRadius: BorderRadius.circular(20),
                        tintColor: Palette.darkPurple,
                      ),
                    ),
                    Positioned(right: 0, child: _buildPopupMenu(list)),
                  ],
                ),
              ),
            );
          }
        });
  }

  Container _waveIndicator() {
    final Size screenSize = MediaQuery.of(context).size;
    double? cardWidth = screenSize.width * 0.45;
    double? cardHeight = screenSize.height * 0.2;

    return Container(
      height: cardHeight,
      width: cardWidth,
      margin: const EdgeInsets.all(7),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Palette.lightPurple.withOpacity(0.2)),
            ),
          ).asGlass(
              tintColor: Palette.lightPurple,
              clipBorderRadius: BorderRadius.circular(15),
              blurX: 3,
              blurY: 3),
          Center(
            child: Shimmer.fromColors(
              baseColor: Palette.lightPurple,
              highlightColor: Palette.white,
              child: Container(
                width: 70,
                height: 30,
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 8,
                  top: 5,
                  bottom: 5,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Palette.lightPurple.withOpacity(0.2)),
              ).asGlass(
                blurX: 1,
                blurY: 1,
                clipBorderRadius: BorderRadius.circular(20),
                tintColor: Palette.lightPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverPhoto(
      double cardWidth, double cardHeight, List<BioskopinaList> bioskopinaListObject) {
    if (bioskopinaListObject.isEmpty) {
      return Container(
        decoration: BoxDecoration(color: Palette.lightPurple.withOpacity(0.3)),
      );
    }
    return Image.network(
      bioskopinaListObject.single.movie!.imageUrl!,
      width: cardWidth,
      height: cardHeight,
      fit: BoxFit.cover,
      alignment: Alignment.center,
    );
  }

  Widget _buildPopupMenu(Listt list) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Palette.darkPurple.withOpacity(0.8),
      ),
      child: PopupMenuButton<String>(
        tooltip: "Actions",
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: Palette.lightPurple.withOpacity(0.3)),
        ),
        icon: const Icon(Icons.more_horiz_rounded),
        splashRadius: 1,
        padding: EdgeInsets.zero,
        color: Palette.darkPurple,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              hoverColor: Palette.lightPurple.withOpacity(0.1),
              leading:
                  const Icon(Icons.edit_rounded, color: Palette.lightPurple),
              title: const Text('Rename',
                  style: TextStyle(color: Palette.lightPurple)),
              onTap: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StarForm(
                      initialValue: list.name,
                      listId: list.id,
                    );
                  },
                );
              },
            ),
          ),
          PopupMenuItem<String>(
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              hoverColor: Palette.lightRed.withOpacity(0.1),
              leading: Icon(Icons.delete, color: Palette.lightRed, size: 24),
              title: const Text('Delete',
                  style: TextStyle(color: Palette.lightRed)),
              onTap: () {
                Navigator.pop(context);
                showConfirmationDialog(
                    context,
                    const Icon(Icons.warning_rounded,
                        color: Palette.lightRed, size: 55),
                    const Text(
                      "Are you sure you want to delete this Star?",
                      textAlign: TextAlign.center,
                    ), () async {
                  try {
                    await _listProvider.delete(list.id!);
                    if (mounted) {
                      showSuccessDialog(context, "Deleted successfully!");
                    }
                  } on Exception catch (e) {
                    if (context.mounted) {
                      showErrorDialog(context, e);
                    }
                  }
                });
              },
            ),
          ),
        ],
      ),
    ).asGlass(
      blurX: 1,
      blurY: 1,
      clipBorderRadius: BorderRadius.circular(20),
      tintColor: Palette.darkPurple,
    );
  }
}