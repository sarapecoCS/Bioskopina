import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

import '../providers/recommender_provider.dart';
import '../providers/donation_provider.dart';
import '../providers/payment_intent_provider.dart';
import '../providers/preferred_genre_provider.dart';
import '../providers/user_comment_action_provider.dart';
import '../providers/user_post_action_provider.dart';
import '../providers/bioskopina_list_provider.dart';
import '../providers/bioskopina_watchlist_provider.dart';
import '../providers/list_provider.dart';
import '../providers/watchlist_provider.dart';
import '../providers/bioskopina_provider.dart';
import '../providers/comment_provider.dart';
import '../providers/genre_provider.dart';
import '../providers/post_provider.dart';
import '../providers/qa_category_provider.dart';
import '../providers/qa_provider.dart';
import '../providers/rating_provider.dart';
import '../providers/role_provider.dart';
import '../providers/user_profile_picture_provider.dart';
import '../providers/user_provider.dart';
import '../providers/user_role_provider.dart';
import '../screens/login_screen.dart';
import './utils/colors.dart';
import './utils/util.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey =
      const String.fromEnvironment('STRIPE_PUBLISHABLE_KEY', defaultValue: "");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        ChangeNotifierProvider(create: (_) => GenreProvider()),
        ChangeNotifierProvider(create: (_) => QAProvider()),
        ChangeNotifierProvider(create: (_) => QAcategoryProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => UserProfilePictureProvider()),
        ChangeNotifierProvider(create: (_) => RatingProvider()),
        ChangeNotifierProvider(create: (_) => UserPostActionProvider()),

        // ✅ Correct ProxyProvider for PostProvider
        ProxyProvider<UserPostActionProvider, PostProvider>(
          update: (_, userPostActionProvider, __) =>
              PostProvider(userPostActionProvider: userPostActionProvider),
        ),

        ChangeNotifierProvider(create: (_) => UserCommentActionProvider()),

        // ✅ Correct ProxyProvider for CommentProvider
        ProxyProvider<UserCommentActionProvider, CommentProvider>(
          update: (_, userCommentActionProvider, __) =>
              CommentProvider(userCommentActionProvider: userCommentActionProvider),
        ),

        ChangeNotifierProvider(create: (_) => RoleProvider()),
        ChangeNotifierProvider(create: (_) => UserRoleProvider()),
        ChangeNotifierProvider(create: (_) => BioskopinaWatchlistProvider()),
        ChangeNotifierProvider(create: (_) => WatchlistProvider()),
        ChangeNotifierProvider(create: (_) => ListtProvider()),
        ChangeNotifierProvider(create: (_) => BioskopinaListProvider()),
        ChangeNotifierProvider(create: (_) => PreferredGenreProvider()),
        ChangeNotifierProvider(create: (_) => PaymentIntentProvider()),
        ChangeNotifierProvider(create: (_) => DonationProvider()),
        ChangeNotifierProvider(create: (_) => RecommenderProvider()),
      ],
      child: const MyMaterialApp(),
    ),
  );
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bioskopina',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        primarySwatch: generateMaterialColor(Palette.darkPurple),
        scaffoldBackgroundColor: Palette.midnightPurple,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Palette.lightPurple,
              displayColor: const Color.fromARGB(255, 90, 83, 155),
              decorationColor: Palette.lightPurple,
            ),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: MyCustomPageTransitionBuilder(),
            TargetPlatform.iOS: MyCustomPageTransitionBuilder(),
          },
        ),
        chipTheme: const ChipThemeData(
          padding: EdgeInsets.all(8),
          selectedColor: Palette.rose,
          checkmarkColor: Palette.midnightPurple,
          backgroundColor: Palette.textFieldPurple,
          labelPadding: EdgeInsets.symmetric(horizontal: 5),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Palette.lightPurple,
          selectionColor: Palette.midnightPurple.withOpacity(0.6),
          selectionHandleColor: Colors.transparent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Palette.darkPurple,
          titleTextStyle: TextStyle(
            color: Palette.lightPurple,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Palette.white,
            backgroundColor: Palette.teal.withOpacity(0.5),
            textStyle: const TextStyle(color: Palette.white),
          ),
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: Palette.midnightPurple,
          scrimColor: Palette.black.withOpacity(0.3),
        ),
        iconTheme: const IconThemeData(color: Palette.lightPurple),
        scrollbarTheme: ScrollbarThemeData(
          crossAxisMargin: -10,
          thickness: MaterialStateProperty.all(7),
          trackBorderColor: MaterialStateProperty.all(Palette.white),
          thumbColor: MaterialStateProperty.all(
            Palette.lightPurple.withOpacity(0.5),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Palette.darkPurple,
          labelStyle: TextStyle(color: Palette.lightPurple),
          helperStyle: TextStyle(color: Palette.lightPurple),
        ),
      ),
      home: const LoginScreen(), // 👈 Starting screen
    );
  }
}

// Custom Page Transition
class MyCustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
