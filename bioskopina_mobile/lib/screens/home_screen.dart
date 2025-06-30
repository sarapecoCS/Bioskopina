import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/preferred_genre.dart';
import '../providers/preferred_genre_provider.dart';
import '../utils/util.dart';
import '../models/search_result.dart';
import 'latest_screen.dart';
import '../screens/top_bioskopina_screen.dart';
import '../widgets/master_screen.dart';
import '../widgets/preferred_genres_form.dart';

class HomeScreen extends StatefulWidget {
  final int selectedIndex;
  const HomeScreen({super.key, required this.selectedIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final PreferredGenreProvider _preferredGenreProvider;
  late final SearchResult<PreferredGenre> _prefGenres;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    _preferredGenreProvider = context.read<PreferredGenreProvider>();

    _checkPrefGenres();
    super.initState();
  }

  void _checkPrefGenres() async {
    _prefGenres = await _preferredGenreProvider
        .get(filter: {"UserId": "${LoggedUser.user!.id}"});

    if (_prefGenres.count < 3) {
      if (mounted) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: ((context) {
              return const PreferredGenresForm();
            }));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Home",
      selectedIndex: widget.selectedIndex,
      showTabBar: true,
      showHelpIcon: true,
      showSearch: false,
      tabController: _tabController,
      tabs: const [
        Text(
          "Top Black Wave movies",
        ),
        Text(
          "Latest found movies",
        )
      ],
      labelPadding: const EdgeInsets.only(
        left: 5,
        right: 5,
        top: 8,
        bottom: 5,
      ),
      child: TabBarView(controller: _tabController, children: [
        TopBioskopinaScreen(selectedIndex: widget.selectedIndex),
        LatestScreen(selectedIndex: widget.selectedIndex),
      ]),
    );
  }
}
