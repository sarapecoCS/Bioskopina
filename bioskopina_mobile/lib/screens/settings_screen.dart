import 'package:flutter/material.dart';

import '../screens/donate_screen.dart';
import '../screens/info_screen.dart';
import '../screens/profile_screen.dart';
import '../utils/util.dart';
import '../widgets/master_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "Settings",
        showTabBar: true,
        showBackArrow: true,
        tabController: _tabController,
        showProfileIcon: false,
        showNavBar: false,
        tabs: const [
          Text(
            "Profile",
          ),
          Text(
            "Info",
          ),
          Text(
            "Donate",
          ),
        ],
        labelPadding: const EdgeInsets.only(
          left: 15,
          right: 15,
          top: 8,
          bottom: 5,
        ),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        child: TabBarView(controller: _tabController, children: [
          ProfileScreen(user: LoggedUser.user!),
          const InfoScreen(),
          const DonateScreen(),
        ]));
  }
}
