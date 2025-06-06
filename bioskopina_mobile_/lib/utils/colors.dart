// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class Palette {
  static const Color midnightPurple = Color.fromRGBO(12, 11, 30, 1);
  static const Color darkPurple = Color.fromRGBO(20, 23, 43, 1.0);
  static const Color plumPurple = Color.fromRGBO(21, 1, 28, 1.0);
  static const Color lightPurple = Color.fromRGBO(172, 190, 243, 1.0);
  static const Color starYellow = Color.fromRGBO(240, 127, 255, 1.0);
  static const Color teal = Color.fromRGBO(153, 255, 255, 1);
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color black = Color.fromRGBO(0, 0, 0, 1);
  static const Color lightRed = Color.fromRGBO(255, 112, 130, 1.0);
  static const Color textFieldPurple = Color.fromRGBO(140, 131, 215, 1);
  static const Color searchBar = Color.fromRGBO(52, 48, 110, 1);
  static const Color dropdownMenu = Color.fromRGBO(69, 67, 108, 1);
  static const Color disabledControl = Color.fromRGBO(105, 103, 154, 1);
  static const Color selectedGenre = Color.fromRGBO(245, 184, 255, 1);
  static const Color popupMenu = Color.fromRGBO(50, 48, 90, 1);
  static const Color listTile = Color.fromRGBO(20, 20, 43, 1.0);
  static const Color ratingPurple = Color.fromRGBO(49, 46, 103, 1); // kept from second file as is
  static const Color buttonRed = Color.fromRGBO(138, 38, 58, 1); // kept as is (red)
  static const Color buttonRed2 = Color.fromRGBO(241, 88, 132, 1.0); // kept as is (red)
  static const Color stardust = Color.fromRGBO(216, 218, 254, 1); // kept as is (light purple-ish)
  static const Color lightYellow = Color.fromRGBO(255, 255, 200, 1); // kept as is
  static const Color turquoise = Color.fromRGBO(153, 255, 255, 1); // from first file teal
  static const Color turquoiseLight = Color.fromRGBO(124, 204, 213, 1); // kept from second file
  static const Color techPurple = Color.fromRGBO(190, 162, 203, 1); // kept from second file
  static const Color rose = Color.fromRGBO(245, 149, 183, 1); // kept as is
  static const Color lime = Color.fromRGBO(205, 223, 102, 1); // kept as is

  // Gradients with more muted tones for a Yugoslavian Black Wave vibe
  static const LinearGradient menuGradient = LinearGradient(colors: [
    Color.fromRGBO(8, 8, 10, 1.0), // Dark muted blue-black (from first)
    Color.fromRGBO(13, 14, 19, 1.0), // Deep red with hint of vintage purple (from first)
  ]);
  static const LinearGradient buttonGradient = LinearGradient(colors: [
    Color.fromRGBO(163, 212, 255, 1.0),  // Burgundy red (adjusted to blue-ish from first)
    Color.fromRGBO(7, 44, 109, 1.0),   // Muted dark maroon (blue shade from first)
  ]);
  static const LinearGradient buttonGradientReverse = LinearGradient(colors: [
    Color.fromRGBO(18, 49, 73, 1.0),   // Muted dark maroon (blue shade from first)
    Color.fromRGBO(38, 71, 138, 1.0),  // Burgundy red (blue shade from first)
  ]);
  static const LinearGradient barChartGradient = LinearGradient(
    colors: [
      Color.fromRGBO(18, 71, 73, 1.0),   // Muted dark maroon (blue shade)
      Color.fromRGBO(38, 123, 138, 1.0),  // Burgundy red (blue shade)
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
  static const LinearGradient barChartGradient2 = LinearGradient(
    colors: [
      Color.fromRGBO(34, 34, 51, 1),   // Dark muted blue-black
      Color.fromRGBO(53, 69, 101, 1.0),  // Deep reddish-purple (blue shade)
      Color.fromRGBO(179, 177, 77, 1.0), // Earthy gold/olive tone
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static const LinearGradient barChartGradient3 = LinearGradient(
    colors: [
      Color.fromRGBO(49, 81, 120, 1.0),  // Earthy reddish-brown (blue shade)
      Color.fromRGBO(32, 38, 67, 1.0),   // Deep maroon (blue shade)
      Color.fromRGBO(59, 47, 113, 1.0),  // Rich burgundy red (blue shade)
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static const LinearGradient barChartGradient4 = LinearGradient(
    colors: [
      Color.fromRGBO(53, 114, 189, 1.0),  // Warm vintage gold (blue shade)
      Color.fromRGBO(54, 57, 112, 1.0),   // Deep purple-red (blue shade)
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static const LinearGradient barChartGradient5 = LinearGradient(
    colors: [
      Color.fromRGBO(45, 38, 138, 1.0),   // Burgundy red (blue shade)
      Color.fromRGBO(18, 47, 73, 1.0),    // Muted dark maroon (blue shade)
      Color.fromRGBO(77, 179, 176, 1.0),  // Earthy gold/olive tone
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static const LinearGradient barChartGradient6 = LinearGradient(colors: [
    Color.fromRGBO(77, 179, 170, 1.0),   // Earthy gold/olive tone
    Color.fromRGBO(26, 18, 73, 1.0),     // Muted dark maroon (blue shade)
    Color.fromRGBO(38, 63, 138, 1.0),    // Burgundy red (blue shade)
  ], begin: Alignment.topCenter, end: Alignment.bottomCenter);

  static const LinearGradient barChartGradient7 = LinearGradient(colors: [
    Color.fromRGBO(234, 228, 5, 1.0),   // Earthy gold/olive tone
    Color.fromRGBO(53, 75, 101, 1.0),    // Deep reddish-purple (blue shade)
    Color.fromRGBO(34, 34, 51, 1),     // Dark muted blue-black
  ], begin: Alignment.topCenter, end: Alignment.bottomCenter);

  static List<LinearGradient> gradientList = [
    barChartGradient2,
    barChartGradient3,
    barChartGradient5,
    barChartGradient,
    barChartGradient4
  ];

  static const LinearGradient navGradient1 = LinearGradient(
    colors: [
      Color.fromRGBO(163, 212, 255, 0.8),   // Burgundy red (from buttonGradient)
      Color.fromRGBO(7, 44, 109, 0.8),    // Muted dark maroon
    ],
  );

  static const LinearGradient navGradient2 = LinearGradient(
    colors: [
      Color.fromRGBO(53, 69, 101, 0.8),   // Deep reddish-purple
      Color.fromRGBO(179, 177, 77, 0.8),  // Earthy gold/olive tone
      Color.fromRGBO(34, 34, 51, 0.8),    // Dark muted blue-black
    ],
  );

  static const LinearGradient navGradient3 = LinearGradient(
    colors: [
      Color.fromRGBO(49, 81, 120, 0.8),   // Earthy reddish-brown
      Color.fromRGBO(59, 47, 113, 0.8),   // Rich burgundy red
      Color.fromRGBO(32, 38, 67, 0.8),    // Deep maroon
    ],
  );

  static const LinearGradient navGradient4 = LinearGradient(
    colors: [
      Color.fromRGBO(54, 57, 112, 0.85),  // Deep purple-red
      Color.fromRGBO(53, 114, 189, 0.85), // Warm vintage gold
    ],
  );

  static const LinearGradient navGradient5 = LinearGradient(
    colors: [
      Color.fromRGBO(163, 212, 255, 0.8),   // Burgundy red
      Color.fromRGBO(179, 177, 77, 0.8),  // Earthy gold/olive tone
      Color.fromRGBO(53, 69, 101, 0.8),   // Deep reddish-purple
    ],
  );

  static List<LinearGradient> gradientList2 = [
    barChartGradient7,
    barChartGradient3,
    barChartGradient6,
    barChartGradient,
    barChartGradient4
  ];

  static const LinearGradient buttonGradient2 = LinearGradient(
      colors: [Color.fromRGBO(52, 48, 110, 1), Color.fromRGBO(52, 48, 110, 1)]);

  // Detailed icon colors adjusted for the vibe
  static const Color movieIco_e902 = Color.fromRGBO(101, 91, 192, 1);
  static const Color movieIco_e903 = Color.fromRGBO(140, 131, 215, 1);
  static const Color movieIco_e904_e905_e906 = Color.fromRGBO(192, 185, 255, 1);
  static const Color movieIco_e907_e908_e909_e90a = white;

  static const Color starIco_e918 = Color.fromRGBO(255, 141, 145, 1.0);
  static const Color starIco_e919 = white;
  static const Color starIco_e91a = Color.fromRGBO(212, 59, 149, 1.0);

  static const Color pdfIco_e911 = lightPurple;
  static const Color pdfIco_e912 = Color.fromRGBO(255, 235, 238, 1);
  static const Color pdfIco_e913_e914_e915 = Color.fromRGBO(96, 87, 173, 1);

  static const Color snowflakeIco1 = Color.fromRGBO(135, 206, 217, 1);
  static const Color snowflakeIco2 = Color.fromRGBO(167, 225, 235, 1);
}
