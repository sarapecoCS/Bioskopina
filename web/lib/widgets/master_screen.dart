import 'package:flutter/material.dart';
import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';

import '../screens/donations_screen.dart';
import '../screens/bioskopina_screen.dart';
import '../screens/help_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/users_screen.dart';
import '../screens/login_screen.dart';
import '../utils/colors.dart';
import '../utils/util.dart';
import 'gradient_button.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;
  Widget? titleWidget;
  TextEditingController? controller;
  void Function(String)? onSubmitted;
  void Function()? onClosed;
  void Function(String)? onChanged;
  void Function()? onCleared;
  void Function()? floatingButtonOnPressed;
  bool? showBackArrow;
  bool? showSearch;
  bool? showFloatingActionButton;
  Widget? floatingActionButtonIcon;
  GradientButton? gradientButton;
  bool? showProfileIcon;
  String? floatingButtonTooltip;

  MasterScreenWidget({
  super.key,
  required this.child,
  this.title,
  this.titleWidget,
  this.controller,
  this.onSubmitted,
  this.onClosed,
  this.onChanged,
  this.onCleared,
  this.showBackArrow,
  this.showSearch,
  this.showFloatingActionButton = false,
  this.floatingActionButtonIcon,
  this.gradientButton,
  this.floatingButtonOnPressed,
  this.showProfileIcon = true,
  this.floatingButtonTooltip,
  });

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  bool? removeAppBar;

  Map<String, bool> hoverStates = {
    'Login': false,
    'Anime': false,
    'Users': false,
    'Analytics': false,
    'Clubs': false,
    'Help': false
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFloatingActionButton(),
      appBar: AppBarWithSearchSwitch(
        onSubmitted: widget.onSubmitted,
        onClosed: widget.onClosed,
        onChanged: widget.onChanged,
        onCleared: widget.onCleared,
        closeSearchIcon: Icons.close_rounded,
        clearSearchIcon: Icons.backspace_rounded,
        customTextEditingController: widget.controller,
        titleTextStyle: const TextStyle(fontSize: 16),
        centerTitle: true,
        searchInputDecoration: InputDecoration(
            contentPadding: const EdgeInsets.only(top: 5, left: 15),
            hintText: "Search",
            hintStyle:
            const TextStyle(color: Palette.lightPurple, fontSize: 16),
            fillColor: Palette.searchBar,
            constraints: const BoxConstraints(maxHeight: 40, maxWidth: 500),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(50))),
        iconTheme: const IconThemeData(color: Palette.lightPurple),
        appBarBuilder: (context) {
          return AppBar(
              leading: _buildLeading(context),
              title: widget.titleWidget ?? Text(widget.title ?? ""),
              actions: _buildActions,
              iconTheme: const IconThemeData(color: Palette.lightPurple));
        },
      ),
      drawer: Drawer(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      child: Image.asset('assets/images/logo.png', width: 220),
                    ),
                    buildListTile(
                        context, 'Biskopina', Icons.tv_rounded, const BioskopinaScreen()),
                    buildListTile(
                        context, 'Users', Icons.people_rounded, const UsersScreen()),
                    buildListTile(
                        context, 'Reports', Icons.analytics_rounded, const ReportsScreen()),

                    buildListTile(
                        context, 'Help', Icons.help_rounded, const HelpScreen()),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: buildListTile(
                      context,
                      'Log out',
                      Icons.logout_rounded,
                      LoginScreen()),
                )
              ])),
      body: Stack(children: [
        Positioned.fill(
          child: Opacity(
            opacity: 0.1,
            child: Image.asset('assets/images/starsBg.png', fit: BoxFit.cover),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: widget.child!,
        )
      ]),
    );
  }

  Widget _buildFloatingActionButton() {
    if (widget.showFloatingActionButton == false) {
      return Container();
    }

    return Tooltip(
      message: widget.floatingButtonTooltip ?? "",
      verticalOffset: 50,
      child: GradientButton(
          width: 90,
          height: 90,
          borderRadius: 100,
          onPressed: widget.floatingButtonOnPressed,
          gradient: Palette.menuGradient,
          child: widget.floatingActionButtonIcon ??
              const Icon(Icons.add_rounded,
                  size: 48, color: Palette.lightPurple)),
    );
  }

  List<Widget> get _buildActions {
    List<Widget> actions = [];
    if (widget.showSearch == true) {
      actions.add(AppBarSearchButton(
        searchIcon: Icons.search_rounded,
        searchActiveButtonColor: Palette.lightRed,
        searchActiveIcon: Icons.search_rounded,
      ));
    }
    actions.add(const SizedBox(width: 10));
    if (widget.showProfileIcon == true) {
      actions.add(_buildPopupMenu());
    }

    actions.add(const SizedBox(width: 40));
    return actions;
  }


  Widget _buildLeading(BuildContext context) {
    if (widget.showBackArrow == true) {
      return InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Palette.lightPurple,
          ));
    } else {
      return Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ));
    }
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton<String>(
      offset: const Offset(0, 35),
      tooltip: "More",
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Palette.lightPurple.withOpacity(0.3)),
      ),
      icon: const Icon(Icons.more_vert_rounded),
      splashRadius: 1,
      padding: EdgeInsets.zero,
      color: Colors.black,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            hoverColor: Palette.lightPurple.withOpacity(0.1),
            leading: Icon(Icons.person_rounded, color: Palette.lightPurple),
            title: const Text('View profile',
                style: TextStyle(color: Palette.lightPurple)),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfileScreen(user: LoggedUser.user!)));
            },
          ),
        ),
        PopupMenuItem<String>(
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            hoverColor: Palette.lightPurple.withOpacity(0.1),
            leading: const Icon(Icons.credit_card_rounded,
                color: Palette.lightPurple),
            title: const Text('View Donations',
                style: TextStyle(color: Palette.lightPurple)),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const DonationsScreen()));
            },
          ),
        ),
      ],
    );
  }

  MouseRegion buildListTile(
      BuildContext context, String title, IconData leading, Widget screen) {
    return MouseRegion(
      onEnter: (event) => setState(() {
        hoverStates[title] = true;
      }),
      onExit: (event) => setState(() {
        hoverStates[title] = false;
      }),
      child: Container(
        decoration: BoxDecoration(
            gradient:
            (hoverStates[title] == true) ? Palette.menuGradient : null,
            borderRadius: BorderRadius.circular(50)),
        child: ListTile(
          title: Text(title,
              style: const TextStyle(fontSize: 16, color: Palette.lightPurple)),
          leading: Icon(leading, color: Palette.lightPurple),
          onTap: () {
            if (title == 'Log out') {
              Authorization.username = "";
              Authorization.password = "";
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => screen,
                ),
              );
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => screen,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
