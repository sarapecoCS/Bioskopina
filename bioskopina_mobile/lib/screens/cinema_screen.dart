import 'package:flutter/material.dart';
import '../screens/cinema_all_screen.dart';
import '../screens/cinema_completed_screen.dart';
import '../screens/cinema_dropped_screen.dart';
import '../screens/cinema_planToWatch_screen.dart';
import '../widgets/master_screen.dart';

class CinemaScreen extends StatefulWidget {
  final int selectedIndex;
  const CinemaScreen({super.key, required this.selectedIndex});

  @override
  State<CinemaScreen> createState() => _CinemaScreenState();
}

class _CinemaScreenState extends State<CinemaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this); // ✅ Changed to 4
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Cinema",
      selectedIndex: widget.selectedIndex,
      showNavBar: true,
      showTabBar: true,
      showHelpIcon: true,
      tabController: _tabController,
      isScrollable: true,
      tabs: const [
        Text("All"),
        Text("Completed"),
        Text("Dropped"), // ❌ Removed "On Hold"
        Text("Plan to Watch"),
      ],
      labelPadding: const EdgeInsets.only(
        left: 15,
        right: 15,
        top: 8,
        bottom: 5,
      ),
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15)),
      child: TabBarView(
        controller: _tabController,
        children: [
          CinemaAllScreen(selectedIndex: widget.selectedIndex),
          CinemaCompletedScreen(selectedIndex: widget.selectedIndex),
          CinemaDroppedScreen(selectedIndex: widget.selectedIndex),
          CinemaPlanToWatchScreen(selectedIndex: widget.selectedIndex),
        ],
      ),
    );
  }
}