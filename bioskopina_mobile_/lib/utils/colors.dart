import 'package:flutter/material.dart';

class Palette {
  // Core colors
    static const Color midnightPurple = Color.fromRGBO(10, 10, 10, 1); // Deep black
    static const Color darkPurple = Color.fromRGBO(20, 20, 20, 1.0); // Dark gray
    static const Color plumPurple = Color.fromRGBO(30, 30, 30, 1.0); // Slightly lighter black
    static const Color lightPurple = Color.fromRGBO(255, 255, 255, 1.0);// Light gray for readability
    static const Color starYellow = Color.fromRGBO(240, 127, 255, 1.0); // Accent remains
      static const Color teal = Color.fromRGBO(153, 255, 255, 1);
   // #00BCD4
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color black = Color.fromRGBO(0, 0, 0, 1);
  static const Color lightRed = Color.fromRGBO(255, 80, 80, 1.0); // Softer red
  static const Color textFieldPurple = Color.fromRGBO(100, 100, 100, 1); // Muted gray
  static const Color searchBar = Color.fromRGBO(35, 35, 35, 1); // Neutral dark gray
  static const Color dropdownMenu = Color.fromRGBO(50, 50, 50, 1); // Dark gray
  static const Color disabledControl = Color.fromRGBO(80, 80, 80, 1); // Soft neutral
  static const Color selectedGenre = Color.fromRGBO(245, 184, 255, 1); // Accent pink
  static const Color popupMenu = Color.fromRGBO(30, 30, 30, 1); // Deep gray
  static const Color listTile = Color.fromRGBO(25, 25, 25, 1.0); // Nearly black
  static const Color ratingPurple = Color.fromRGBO(70, 70, 70, 1); // Soft dark gray
  static const Color buttonRed = Color.fromRGBO(138, 38, 58, 1); // Keep slight red
  static const Color buttonRed2 = Color.fromRGBO(200, 80, 100, 1.0); // Muted rose red
  static const Color stardust = Color.fromRGBO(216, 218, 254, 1); // Keep as faint highlight
  static const Color lightYellow = Color.fromRGBO(255, 255, 200, 1); // Soft yellow highlight
  static const Color turquoise = Color.fromRGBO(120, 200, 200, 1); // Muted turquoise
  static const Color turquoiseLight = Color.fromRGBO(100, 180, 180, 1); // Softer turquoise
  static const Color techPurple = Color.fromRGBO(140, 120, 140, 1); // Muted tech purple
  static const Color rose = Color.fromRGBO(200, 120, 140, 1); // Muted rose
  static const Color lime = Color.fromRGBO(180, 200, 100, 1); // Soft lime green

  // Gradients
  static const LinearGradient menuGradient = LinearGradient(colors: [
    Color.fromRGBO(10, 10, 10, 1.0),
    Color.fromRGBO(20, 20, 20, 1.0),
  ]);

  static const LinearGradient buttonGradient = LinearGradient(colors: [
    Color.fromRGBO(163, 212, 255, 1.0),  // Burgundy red (adjusted to blue-ish from first)
          Color.fromRGBO(7, 44, 109, 1.0),   // Muted dark maroon (blue shade from first)
  ]);

  static const LinearGradient buttonGradientReverse = LinearGradient(colors: [
    Color.fromRGBO(40, 60, 80, 1.0),
    Color.fromRGBO(120, 180, 200, 1.0),
  ]);

  static const LinearGradient buttonGradient2 = LinearGradient(
    colors: [
      Color.fromRGBO(50, 70, 60, 1.0),
      Color.fromRGBO(50, 70, 60, 1.0),
    ],
  );

  // Bar Chart Gradients
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

  static const LinearGradient barChartGradient6 = LinearGradient(
    colors: [
      Color.fromRGBO(90, 90, 90, 1.0),
      Color.fromRGBO(25, 25, 25, 1.0),
      Color.fromRGBO(50, 50, 50, 1.0),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient barChartGradient7 = LinearGradient(
    colors: [
      Color.fromRGBO(110, 110, 110, 1.0),
      Color.fromRGBO(55, 55, 55, 1.0),
      Color.fromRGBO(30, 30, 30, 1),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

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

// Nav Gradients (modern icy blue vibe, popping like buttonGradient)
static const LinearGradient navGradient1 = LinearGradient(
  colors: [
    Color.fromRGBO(163, 212, 255, 1.0), // Soft icy blue
    Color.fromRGBO(7, 44, 109, 1.0),    // Deep cold navy
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

static const LinearGradient navGradient2 = LinearGradient(
  colors: [
    Color.fromRGBO(140, 190, 240, 1.0), // Slightly stronger ice blue
    Color.fromRGBO(40, 80, 140, 1.0),   // Muted rich blue
    Color.fromRGBO(10, 30, 80, 1.0),    // Dark navy
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

static const LinearGradient navGradient3 = LinearGradient(
  colors: [
    Color.fromRGBO(180, 220, 255, 1.0), // Very light sky blue
    Color.fromRGBO(60, 100, 160, 1.0),  // Cold blue
    Color.fromRGBO(20, 50, 100, 1.0),   // Deep navy blue
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

static const LinearGradient navGradient4 = LinearGradient(
  colors: [
    Color.fromRGBO(150, 200, 255, 0.9), // Soft blue glow
    Color.fromRGBO(30, 60, 120, 0.9),   // Mid blue navy
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

static const LinearGradient navGradient5 = LinearGradient(
  colors: [
    Color.fromRGBO(170, 220, 255, 1.0), // Bright cold blue
    Color.fromRGBO(80, 130, 200, 1.0),  // Rich navy blue
    Color.fromRGBO(20, 40, 80, 1.0),    // Deep dark navy
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

  // Icon Colors
  static const Color movieIco_e902 = Color.fromRGBO(110, 110, 110, 1);
  static const Color movieIco_e903 = Color.fromRGBO(130, 130, 130, 1);
  static const Color movieIco_e904_e905_e906 = Color.fromRGBO(160, 160, 160, 1);
  static const Color movieIco_e907_e908_e909_e90a = white;

  static const Color starIco_e918 = Color.fromRGBO(255, 141, 145, 1.0);
  static const Color starIco_e919 = white;
  static const Color starIco_e91a = Color.fromRGBO(200, 80, 120, 1.0);

  static const Color pdfIco_e911 = lightPurple;
  static const Color pdfIco_e912 = Color.fromRGBO(255, 235, 238, 1);
  static const Color pdfIco_e913_e914_e915 = Color.fromRGBO(120, 120, 180, 1);

  static const Color snowflakeIco1 = Color.fromRGBO(135, 206, 217, 1);
  static const Color snowflakeIco2 = Color.fromRGBO(167, 225, 235, 1);
}