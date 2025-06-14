import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:flutter/material.dart';
import 'package:responsive_navigation_bar/responsive_navigation_bar.dart';

import '../screens/help_screen.dart';
import '../screens/constellation_screen.dart';
import '../screens/explore_screen.dart';
import '../screens/home_screen.dart';
import '../widgets/user_profile_dialog.dart';

import '../screens/all_posts_screen.dart';
import '../utils/colors.dart';
import '../utils/util.dart';
import 'gradient_button.dart';
import '../screens/posts_screen.dart';
// ignore: must_be_immutable
class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;
  Widget? titleWidget;

  /// Controller for search
  TextEditingController? controller;

  /// onSubmitted event for search
  void Function(String)? onSubmitted;

  /// onClosed event for search
  void Function()? onClosed;

  /// onChanged event for search
  void Function(String)? onChanged;

  /// onCleared event for search
  void Function()? onCleared;

  void Function()? floatingButtonOnPressed;
  bool? showBackArrow;
  bool? showSearch;
  bool? showFloatingActionButton;
  Widget? floatingActionButtonIcon;

  /// This widget will be used for floatingActionButton
  GradientButton? gradientButton;
  bool? showProfileIcon;
  String? floatingButtonTooltip;
  bool? showTabBar;
  TabController? tabController;
  List<Widget>? tabs;
  bool? showNavBar;
  int? selectedIndex;

  /// If set to true, it makes tabs scrollable horizontally
  bool? isScrollable;

  /// Border radius for TabBar tabs
  BorderRadius? borderRadius;

  /// Padding around tabs' labels
  EdgeInsets? labelPadding;

  /// Floating action button location
  FloatingActionButtonLocation? floatingActionButtonLocation;

  bool? showHelpIcon;

  /// Called once the leading icon is pressed, defaults to Navigator.pop() if not passed
  void Function()? onLeadingPressed;

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
    this.showTabBar = false,
    this.tabController,
    this.tabs,
    this.showNavBar = true,
    this.selectedIndex,
    this.isScrollable,
    this.borderRadius,
    this.labelPadding,
    this.floatingActionButtonLocation,
    this.showHelpIcon,
    this.onLeadingPressed,
  });

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  bool? removeAppBar;
  int _selectedIndex = 0;

  final isSearchMode = ValueNotifier<bool>(false);
  final searchText = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    double appBarHeight = (widget.showTabBar == true)
        ? screenSize.height * 0.12
        : screenSize.height * 0.08;

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (searchText.value != '') {
          isSearchMode.value = false;
          searchText.value = '';
          return false;
        }
        return true;
      },
      child: Scaffold(
        floatingActionButton: _buildFloatingActionButton(),
        floatingActionButtonLocation:
            widget.floatingActionButtonLocation ?? FloatingActionButtonLocation.endFloat,
        appBar: AppBarWithSearchSwitch(
          customIsSearchModeNotifier: isSearchMode,
          customTextNotifier: searchText,
          toolbarHeight: appBarHeight,
          closeOnSubmit: true,
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
              hintStyle: const TextStyle(color: Palette.lightPurple, fontSize: 16),
              fillColor: Palette.searchBar,
              constraints: const BoxConstraints(maxHeight: 40, maxWidth: 500),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none, borderRadius: BorderRadius.circular(50))),
          iconTheme: const IconThemeData(color: Palette.lightPurple),
          appBarBuilder: (context) {
            return AppBar(
              centerTitle: true,
              leading: _buildLeading(context),
              title: widget.titleWidget ?? Text(widget.title ?? ""),
              actions: _buildActions,
              iconTheme: const IconThemeData(color: Palette.lightPurple),
              bottom: _buildTabBar(),
            );
          },
        ),
        bottomNavigationBar: _buildNavigationBar(),
        body: Stack(children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset('assets/images/starsBg.png', fit: BoxFit.cover),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: widget.child!,
          )
        ]),
      ),
    );
  }

  ResponsiveNavigationBar? _buildNavigationBar() {
    return (widget.showNavBar == true)
        ? ResponsiveNavigationBar(
            backgroundColor: Palette.darkPurple,
            backgroundOpacity: 1,
            activeIconColor: Palette.white,
            inactiveIconColor: Palette.lightPurple,
            fontSize: 25,
            padding: const EdgeInsets.all(4),
            showActiveButtonText: false,
            textStyle: const TextStyle(
              color: Palette.white,
              fontWeight: FontWeight.w500,
            ),
            outerPadding: const EdgeInsets.all(0),
            borderRadius: 30,
            selectedIndex: (widget.selectedIndex != null) ? widget.selectedIndex! : _selectedIndex,
            onTabChange: (index) {
              setState(() {
                widget.selectedIndex = index;
                _selectedIndex = index;
              });

              switch (index) {
                case 0:
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => HomeScreen(selectedIndex: index)));
                  break;
                case 1:
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => PostsScreen(selectedIndex: index)));
                  break;
                case 2:
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => ExploreScreen(selectedIndex: index)));
                  break;
                case 3:
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => ConstellationScreen(selectedIndex: index)));
                  break;
              }
            },
            navigationBarButtons: <NavigationBarButton>[
              NavigationBarButton(
                text: 'Home',
                icon: Icons.home,
                backgroundGradient: Palette.navGradient1,
              ),
              NavigationBarButton(
                text: 'Posts',
                icon: Icons.article_rounded,
                backgroundGradient: Palette.navGradient2,
              ),
              NavigationBarButton(
                text: 'Explore',
                icon: Icons.find_in_page_rounded,
                backgroundGradient: Palette.navGradient3,
                padding: const EdgeInsets.all(10),
              ),
              NavigationBarButton(
                text: 'Watchlists',
                icon: Icons.playlist_add_rounded,
                backgroundGradient: Palette.navGradient4,
                padding: const EdgeInsets.only(right: 31, left: 10, top: 10, bottom: 10),
              ),

            ],
          )
        : null;
  }

  TabBar? _buildTabBar() {
    return (widget.showTabBar ?? false)
        ? TabBar(
            tabAlignment: (widget.isScrollable ?? false) ? TabAlignment.start : null,
            dividerColor: Colors.transparent,
            isScrollable: widget.isScrollable ?? false,
            indicatorSize: TabBarIndicatorSize.tab,
            controller: widget.tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelPadding: widget.labelPadding ?? const EdgeInsets.all(5),
            tabs: widget.tabs ?? [],
            indicator: BoxDecoration(
              color: const Color.fromRGBO(45, 45, 55, 0.85),
              borderRadius: widget.borderRadius ??
                  const BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
            ),
          )
        : null;
  }


  Widget _buildFloatingActionButton() {
    if (widget.showFloatingActionButton == false) {
      return Container();
    }

    return Tooltip(
      message: widget.floatingButtonTooltip ?? "",
      verticalOffset: 50,
      child: GradientButton(
          width: 60,
          height: 60,
          borderRadius: 100,
          onPressed: widget.floatingButtonOnPressed,
          gradient: Palette.navGradient2,
          child: widget.floatingActionButtonIcon ??
              const Icon(Icons.add_rounded, size: 40, color: Palette.white)),
    );
  }

  List<Widget> get _buildActions {
    List<Widget> actions = [];

    if (widget.showSearch == true) {
      actions.add(AppBarSearchButton(
        searchIcon: Icons.search_rounded, // <- Here: IconData, not Icon widget
        searchActiveButtonColor: Palette.lightRed,
        searchActiveIcon: Icons.search_rounded, // <- Here too
      ));
    }
    actions.add(const SizedBox(width: 10));
    if (widget.showProfileIcon == true) {
      actions.add(IconButton(
          splashRadius: 24,
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return UserProfileDialog(
                  loggedUser: LoggedUser.user!,
                );
              },
            );
          },
         icon: const Icon(Icons.account_circle)));
    }

    return actions;
  }

  Widget _buildLeading(BuildContext context) {
    if (widget.showBackArrow == true) {
      return IconButton(
        splashRadius: 24,
        onPressed: () {
          if (widget.onLeadingPressed != null) {
            widget.onLeadingPressed!();
          } else {
            Navigator.pop(context);
          }
        },
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: Palette.lightPurple,
        ),
      );
    } else if (widget.showHelpIcon == true) {
      return IconButton(
        splashRadius: 24,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpScreen()));
        },
        icon: const Icon(Icons.help_outline_rounded, size: 24),
      );
    } else {
      return Container();
    }
  }
}
