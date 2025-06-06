// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class Palette {
  static const Color midnightPurple = Color.fromRGBO(10, 10, 10, 1); // Deep black
  static const Color darkPurple = Color.fromRGBO(20, 20, 20, 1.0); // Dark gray
  static const Color plumPurple = Color.fromRGBO(30, 30, 30, 1.0); // Slightly lighter black
  static const Color lightPurple = Color.fromRGBO(255, 255, 255, 1.0);// Light gray for readability
  static const Color starYellow = Color.fromRGBO(240, 127, 255, 1.0); // Accent remains
  static const Color teal = Color.fromRGBO(153, 255, 255, 1); // Accent remains
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color black = Color.fromRGBO(0, 0, 0, 1);
  static const Color lightRed = Color.fromRGBO(255, 0, 0, 1.0);
  static const Color textFieldPurple = Color.fromRGBO(120, 120, 120, 1); // Muted gray tone
  static const Color searchBar = Color.fromRGBO(40, 40, 40, 1); // Neutral dark
  static const Color dropdownMenu = Color.fromRGBO(50, 50, 50, 1); // Neutral dark gray
  static const Color disabledControl = Color.fromRGBO(80, 80, 80, 1); // Soft gray
  static const Color selectedGenre = Color.fromRGBO(245, 184, 255, 1);
  static const Color popupMenu = Color.fromRGBO(35, 35, 35, 1); // Deep gray
  static const Color listTile = Color.fromRGBO(25, 25, 25, 1.0); // Black base

  static const LinearGradient menuGradient = LinearGradient(colors: [
    Color.fromRGBO(10, 10, 10, 1.0),
    Color.fromRGBO(20, 20, 20, 1.0),
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
      Color.fromRGBO(30, 30, 30, 1.0),
      Color.fromRGBO(60, 60, 60, 1.0),
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
  static const LinearGradient barChartGradient2 = LinearGradient(
    colors: [
      Color.fromRGBO(40, 40, 40, 1),
      Color.fromRGBO(70, 70, 70, 1.0),
      Color.fromRGBO(90, 90, 90, 1.0),
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
  static const LinearGradient barChartGradient3 = LinearGradient(
    colors: [
      Color.fromRGBO(60, 60, 60, 1.0),
      Color.fromRGBO(35, 35, 35, 1.0),
      Color.fromRGBO(45, 45, 45, 1.0),
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
  static const LinearGradient barChartGradient4 = LinearGradient(
    colors: [
      Color.fromRGBO(70, 70, 70, 1.0),
      Color.fromRGBO(40, 40, 40, 1.0),
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
  static const LinearGradient barChartGradient5 = LinearGradient(
    colors: [
      Color.fromRGBO(45, 45, 45, 1.0),
      Color.fromRGBO(35, 35, 35, 1.0),
      Color.fromRGBO(80, 80, 80, 1.0),
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
  static const LinearGradient barChartGradient6 = LinearGradient(colors: [
    Color.fromRGBO(90, 90, 90, 1.0),
    Color.fromRGBO(25, 25, 25, 1.0),
    Color.fromRGBO(50, 50, 50, 1.0),
  ], begin: Alignment.topCenter, end: Alignment.bottomCenter);

  static const LinearGradient barChartGradient7 = LinearGradient(colors: [
    Color.fromRGBO(110, 110, 110, 1.0),
    Color.fromRGBO(55, 55, 55, 1.0),
    Color.fromRGBO(30, 30, 30, 1),
  ], begin: Alignment.topCenter, end: Alignment.bottomCenter);

  static List<LinearGradient> gradientList = [
    barChartGradient2,
    barChartGradient3,
    barChartGradient5,
    barChartGradient,
    barChartGradient4
  ];

  static List<LinearGradient> gradientList2 = [
    barChartGradient7,
    barChartGradient3,
    barChartGradient6,
    barChartGradient,
    barChartGradient4
  ];

  static const LinearGradient buttonGradient2 = LinearGradient(
    colors: [
      Color.fromRGBO(38, 70, 64, 1.0),
      Color.fromRGBO(38, 70, 64, 1.0),
    ],
  );

  static const Color movieIco_e902 = Color.fromRGBO(110, 110, 110, 1);
  static const Color movieIco_e903 = Color.fromRGBO(140, 140, 140, 1);
  static const Color movieIco_e904_e905_e906 = Color.fromRGBO(180, 180, 180, 1);
  static const Color movieIco_e907_e908_e909_e90a = white;

  static const Color starIco_e918 = Color.fromRGBO(255, 141, 145, 1.0);
  static const Color starIco_e919 = white;
  static const Color starIco_e91a = Color.fromRGBO(212, 59, 149, 1.0);

  static const Color pdfIco_e911 = lightPurple;
  static const Color pdfIco_e912 = Color.fromRGBO(235, 235, 235, 1);
  static const Color pdfIco_e913_e914_e915 = Color.fromRGBO(130, 130, 130, 1);

  static const Color snowflakeIco1 = Color.fromRGBO(135, 206, 217, 1);
  static const Color snowflakeIco2 = Color.fromRGBO(167, 225, 235, 1);
}