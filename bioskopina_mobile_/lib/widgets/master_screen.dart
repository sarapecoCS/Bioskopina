import 'package:flutter/material.dart';
 import 'package:responsive_navigation_bar/responsive_navigation_bar.dart';

 import '../screens/constellation_screen.dart';
 import '../screens/explore_screen.dart';
 import '../screens/home_screen.dart';
 import '../widgets/user_profile_dialog.dart';
 import '../screens/help_screen.dart';
 import '../screens/post_screen.dart';
 import '../utils/colors.dart';
 import '../utils/util.dart';
 import 'gradient_button.dart';
 import '../models/post.dart';

 class MasterScreenWidget extends StatefulWidget {
   final Widget child;
   final String? title;
   final Widget? titleWidget;

   final TextEditingController? controller;
   final void Function(String)? onSubmitted;
   final void Function()? onClosed;
   final void Function(String)? onChanged;
   final void Function()? onCleared;
   final void Function()? floatingButtonOnPressed;

   final bool? showBackArrow;
   final bool? showSearch;
   final bool showFloatingActionButton;
   final Widget? floatingActionButtonIcon;
   final GradientButton? gradientButton;
   final bool showProfileIcon;
   final String? floatingButtonTooltip;
   final bool showTabBar;
   final TabController? tabController;
   final List<Widget>? tabs;
   final bool showNavBar;
   final int? selectedIndex;
   final bool? isScrollable;
   final BorderRadius? borderRadius;
   final EdgeInsets? labelPadding;
   final FloatingActionButtonLocation? floatingActionButtonLocation;
   final bool? showHelpIcon;
   final void Function()? onLeadingPressed;

   final Post? post;

   const MasterScreenWidget({
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
     this.post,
   });

   @override
   State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
 }

 class _MasterScreenWidgetState extends State<MasterScreenWidget> {
   late int _selectedIndex;

   final isSearchMode = ValueNotifier<bool>(false);
   final searchText = ValueNotifier<String>('');

   @override
   void initState() {
     super.initState();
     // Initialize _selectedIndex from widget.selectedIndex or 0 if null
     _selectedIndex = widget.selectedIndex ?? 0;
   }

   @override
   void didUpdateWidget(covariant MasterScreenWidget oldWidget) {
     super.didUpdateWidget(oldWidget);
     // Update _selectedIndex if parent passes new selectedIndex
     if (widget.selectedIndex != null && widget.selectedIndex != _selectedIndex) {
       setState(() {
         _selectedIndex = widget.selectedIndex!;
       });
     }
   }

   @override
   Widget build(BuildContext context) {
     final Size screenSize = MediaQuery.of(context).size;
     double appBarHeight = (widget.showTabBar)
         ? screenSize.height * 0.12
         : screenSize.height * 0.08;

     return WillPopScope(
       onWillPop: () async {
         if (searchText.value.isNotEmpty) {
           isSearchMode.value = false;
           searchText.value = '';
           return false;
         }
         return true;
       },
       child: Scaffold(
         floatingActionButton: _buildFloatingActionButton(),
         floatingActionButtonLocation: widget.floatingActionButtonLocation ??
             FloatingActionButtonLocation.endFloat,
         appBar: AppBar(
           centerTitle: true,
           leading: _buildLeading(context),
           title: widget.titleWidget ?? Text(widget.title ?? ""),
           actions: _buildActions,
           iconTheme: const IconThemeData(color: Colors.white),
           bottom: _buildTabBar(),
         ),
         bottomNavigationBar: _buildNavigationBar(),
         body: Stack(
           children: [
             Positioned.fill(
               child: Opacity(
                 opacity: 0.3,
                 child: Image.asset('assets/images/starsBg.png', fit: BoxFit.cover),
               ),
             ),
             Align(
               alignment: Alignment.topLeft,
               child: widget.child,
             )
           ],
         ),
       ),
     );
   }

   ResponsiveNavigationBar? _buildNavigationBar() {
     return widget.showNavBar
         ? ResponsiveNavigationBar(
             backgroundColor: const Color.fromRGBO(20, 20, 20, 1.0),
             backgroundOpacity: 1,
             activeIconColor: Colors.white,
             inactiveIconColor: Colors.white,
             fontSize: 25,
             padding: const EdgeInsets.all(4),
             showActiveButtonText: false,
             textStyle: const TextStyle(
               color: Colors.white,
               fontWeight: FontWeight.w500,
             ),
             outerPadding: const EdgeInsets.all(0),
             borderRadius: 30,
             selectedIndex: _selectedIndex,
             onTabChange: (index) {
               if (_selectedIndex == index) return; // prevent unnecessary navigation
               setState(() {
                 _selectedIndex = index; // <-- FIXED here: only update local state
               });

               Widget screen;
               switch (index) {
                 case 0:
                   screen = HomeScreen(selectedIndex: index);
                   break;
                 case 1:
                   screen = ExploreScreen(selectedIndex: index);
                   break;
                 case 2:
                   screen = ConstellationScreen(selectedIndex: index);
                   break;
                 case 3:
                   screen = const PostScreen();
                   break;
                 default:
                   screen = HomeScreen(selectedIndex: index);
               }

               Navigator.of(context).pushReplacement(
                 MaterialPageRoute(
                   builder: (_) => MasterScreenWidget(
                     child: screen,
                     selectedIndex: index,
                   ),
                 ),
               );
             },
             navigationBarButtons: <NavigationBarButton>[
               NavigationBarButton(
                 text: 'Home',
                 icon: Icons.home,
                 backgroundGradient: Palette.navGradient1,
               ),
               NavigationBarButton(
                 text: 'Explore',
                 icon: Icons.local_movies,
                 backgroundGradient: Palette.navGradient3,
                 padding: const EdgeInsets.all(10),
               ),
               NavigationBarButton(
                 text: 'Constellation',
                 icon: Icons.star_outline,
                 backgroundGradient: Palette.navGradient4,
                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
               ),
               NavigationBarButton(
                 text: 'CineOrbit',
                 icon: Icons.star,
                 backgroundGradient: Palette.navGradient5,
                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
               ),
             ],
           )
         : null;
   }

   TabBar? _buildTabBar() {
     return widget.showTabBar
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
     if (!widget.showFloatingActionButton) return Container();

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
             const Icon(Icons.add_rounded, size: 40, color: Colors.white),
       ),
     );
   }

   List<Widget> get _buildActions {
     List<Widget> actions = [];

     if (widget.showSearch == true) {
       actions.add(IconButton(
         icon: const Icon(Icons.search),
         onPressed: () {},
       ));
     }
     actions.add(const SizedBox(width: 10));
     if (widget.showProfileIcon) {
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
         onPressed: widget.onLeadingPressed ?? () => Navigator.pop(context),
         icon: const Icon(Icons.arrow_back_rounded, color: Colors.blue),
       );
     } else if (widget.showHelpIcon == true) {
       return IconButton(
         splashRadius: 24,
         onPressed: () {
           Navigator.push(
               context, MaterialPageRoute(builder: (context) => const HelpScreen()));
         },
         icon: const Icon(Icons.help_outline),
       );
     } else {
       return Container();
     }
   }
 }