import 'dart:io';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../widgets/form_builder_checkbox.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../providers/user_provider.dart';
import '../widgets/circular_progress_indicator.dart';
import '../widgets/gradient_button.dart';
import '../models/popular_bioskopina_data.dart';
import '../providers/bioskopina_provider.dart';
import '../models/popular_genres_data.dart';
import '../models/registration_data.dart';
import '../models/search_result.dart';
import '../models/user.dart';
import '../providers/genre_provider.dart';
import '../utils/colors.dart';
import '../widgets/master_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late Future<List<UserRegistrationData>> userRegistrationDataFuture;
  late Future<SearchResult<User>> _userFuture;
  late UserProvider _userProvider;
  int totalUsers = 0;
  int days = 29;
  bool pastYear = false;
  bool pastWeek = false;
  double? bottomInterval = 1;
  final ScreenshotController _screenshotController = ScreenshotController();
  final ScreenshotController _screenshotController2 = ScreenshotController();
  final ScreenshotController _screenshotController3 = ScreenshotController();
  pw.Text userChartTextForPdf = pw.Text("");

  late MovieProvider _movieProvider;
  List<String> moviesTitles = [];
  late Future<List<PopularBioskopinaData>> popularBioskopinaDataFuture;
  List<PopularBioskopinaData> popularBioskopinaData = [];

  late GenreProvider _genreProvider;
  List<String> genreTitles = [];
  late Future<List<PopularGenresData>> popularGenresDataFuture;
  List<PopularGenresData> popularGenresData = [];
  Text genreBarChartText = const Text("");
  Text bioskopinaBarChartText = const Text("");

  bool includeRegUsersInPdf = true;
  bool includeTopBioskopinaInPdf = true;
  bool includeTopGenresInPdf = true;
  bool chartPdfMode = false;

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    _userProvider = context.read<UserProvider>();
    userRegistrationDataFuture = _userProvider.getUserRegistrations(days);
    _userFuture = _userProvider.get();
    getTotalusers();

    _movieProvider = context.read<MovieProvider>();
    getPopularMovieData();

    _genreProvider = context.read<GenreProvider>();
    getPopularGenresData();

    super.initState();
  }

  void getPopularGenresData() async {
    popularGenresData = await _genreProvider.getMostPopularGenres();
    popularGenresDataFuture = Future.value(popularGenresData);

    for (var genre in popularGenresData) {
      genreTitles.add(genre.genreName!);
    }
  }

  void getPopularMovieData() async {
    popularBioskopinaData = await _movieProvider.getMostPopularMovies();
    popularBioskopinaDataFuture = Future.value(popularBioskopinaData);

    for (var bio in popularBioskopinaData) {
      moviesTitles.add(bio.bioskopinaTitleEN!);
    }
  }


  void getTotalusers() async {
    var users = await _userFuture;

    setState(() {
      totalUsers = users.count;
    });
  }

  Future<void> exportToPdf() async {
    //Get device pixel ratio
    double pixelRatio = MediaQuery
        .of(context)
        .devicePixelRatio;

    //Get user registration chart image
    ui.Image? capturedImage =
    await _screenshotController.captureAsUiImage(pixelRatio: pixelRatio);
    ByteData? byteData =
    await capturedImage?.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    final ByteData logoByteData =
    await rootBundle.load("assets/images/logoFilled.png");
    final Uint8List logoBytes = logoByteData.buffer.asUint8List();


    ui.Image? capturedBioskopinaBarChartImg =
    await _screenshotController2.captureAsUiImage(pixelRatio: pixelRatio);
    ByteData? byteDataBioskopinaBarChart = await capturedBioskopinaBarChartImg
        ?.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytesBioskopinaBarChart =
    byteDataBioskopinaBarChart!.buffer.asUint8List();

    //Get genre bar chart image
    ui.Image? capturedGenreBarChartImg =
    await _screenshotController3.captureAsUiImage(pixelRatio: pixelRatio);
    ByteData? byteDataGenreBarChart = await capturedGenreBarChartImg
        ?.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytesGenreBarChart =
    byteDataGenreBarChart!.buffer.asUint8List();

    setState(() {
      chartPdfMode = false;
    });

    final pdf = pw.Document();

    final List<pw.Widget> contentWidgets = [];

    contentWidgets.add(
      pw.Header(
        level: 1,
        decoration: pw.BoxDecoration(
            border: pw.Border.all(width: 0, style: pw.BorderStyle.none)),
        child: pw.Column(children: [
          pw.Row(children: [
            pw.Image(pw.MemoryImage(logoBytes), width: 80),
            pw.SizedBox(width: 78),
            pw.Text('Report - ${DateFormat('MMM d, y').format(DateTime.now())}',
                style: pw.TextStyle(
                    color: PdfColor.fromHex("#0C0B1E"), fontSize: 22)),
          ]),
          pw.Container(
              width: 900, height: 1, color: PdfColor.fromHex("#0C0B1E")),
        ]),
      ),
    );

    if (includeRegUsersInPdf == true) {
      contentWidgets.add(pw.Image(pw.MemoryImage(pngBytes), width: 760));
      contentWidgets.add(pw.SizedBox(height: 10));
      contentWidgets.add(pw.Text("Total number of registered users:",
          style:
          pw.TextStyle(fontSize: 14, color: PdfColor.fromHex("#0C0B1E"))));
      contentWidgets.add(pw.Text("$totalUsers",
          style: pw.TextStyle(
              color: PdfColor.fromHex("#8A7CFA"),
              fontSize: 20,
              fontWeight: pw.FontWeight.bold)));
      contentWidgets.add(pw.SizedBox(height: 10));
      contentWidgets.add(userChartTextForPdf);
      contentWidgets.add(pw.SizedBox(height: 10));
    }

    if (includeTopBioskopinaInPdf == true) {
      contentWidgets
          .add(
          pw.Image(pw.MemoryImage(pngBytesBioskopinaBarChart), width: 760));
      contentWidgets.add(pw.SizedBox(height: 10));
      contentWidgets.add(pw.Text(bioskopinaBarChartText.data!,
          style:
          pw.TextStyle(color: PdfColor.fromHex("#0C0B1E"), fontSize: 11)));
      contentWidgets.add(pw.SizedBox(height: 10));
    }

    if (includeTopGenresInPdf == true) {
      contentWidgets
          .add(pw.Image(pw.MemoryImage(pngBytesGenreBarChart), width: 760));
      contentWidgets.add(pw.SizedBox(height: 10));
      contentWidgets.add(pw.Text(genreBarChartText.data!,
          style:
          pw.TextStyle(color: PdfColor.fromHex("#0C0B1E"), fontSize: 11)));
    }

    final double pageHeight = PdfPageFormat.a4.availableHeight;
    double currentHeight = 0;

    while (contentWidgets.isNotEmpty) {
      final List<pw.Widget> pageWidgets = [];

      for (final widget in List<pw.Widget>.from(contentWidgets)) {
        final estimatedHeight = estimateWidgetHeight(widget);

        if (currentHeight + estimatedHeight > pageHeight) {
          break;
        }

        pageWidgets.add(widget);
        currentHeight += estimatedHeight;
        contentWidgets.remove(widget);
      }

      pdf.addPage(
          pw.Page(build: (context) => pw.Column(children: pageWidgets)));

      currentHeight = 0;
    }

    final filePath = await FilePicker.platform.saveFile(
      dialogTitle: "Choose where to save report",
      fileName: 'Report - ${DateFormat('MMM d, y').format(DateTime.now())}.pdf',
      allowedExtensions: ['pdf'],
      type: FileType.custom,
    );

    if (filePath != null) {
      final file = File(filePath);
      // Ensures the file path has the .pdf extension even when name is changed
      if (!filePath.endsWith('.pdf')) {
        final newFilePath = '$filePath.pdf';
        final newFile = File(newFilePath);
        await newFile.writeAsBytes(await pdf.save());
      } else {
        await file.writeAsBytes(await pdf.save());
      }
    }
  }

  double estimateWidgetHeight(pw.Widget widget) {
    if (includeRegUsersInPdf == false &&
        includeTopBioskopinaInPdf == true &&
        includeTopGenresInPdf == true) {
      return 100;
    }
    return 70;
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        titleWidget: Row(
          children: [
            const Icon(Icons.bar_chart, size: 28),
            const SizedBox(width: 5),
            const Text("Reports"),
          ],
        ),
        showFloatingActionButton: true,
        floatingActionButtonIcon: Icon(
            Icons.picture_as_pdf, size: 48, color: Colors.red),
        floatingButtonOnPressed: () async {
          showDialog(
              context: context,
              builder: (builder) {
                return Dialog(
                    insetPadding: const EdgeInsets.all(17),
                    alignment: Alignment.center,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    child: Container(
                        width: 350,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Palette.darkPurple,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Palette.lightPurple.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: FormBuilder(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Select which data to show in report",
                                  style: TextStyle(
                                      color: Palette.lightPurple,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16)),
                              const SizedBox(height: 15),
                              MyFormBuilderCheckBox(
                                name: "userData",
                                initialValue: includeRegUsersInPdf,
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      includeRegUsersInPdf = val;
                                    });
                                  }
                                },
                                title: const Text("User registrations data",
                                    style: TextStyle(
                                        color: Palette.lightPurple,
                                        fontSize: 14)),
                                validator: (val) {
                                  bool? showAnimeData = _formKey
                                      .currentState?.fields["movieData"]?.value;
                                  bool? showGenreData = _formKey
                                      .currentState?.fields["genreData"]?.value;
                                  if (val == false &&
                                      showAnimeData == false &&
                                      showGenreData == false) {
                                    return "Must select at least one option.";
                                  }
                                  return null;
                                },
                              ),
                              MyFormBuilderCheckBox(
                                name: "bioskopinaData",
                                initialValue: includeTopBioskopinaInPdf,
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      includeTopBioskopinaInPdf = val;
                                    });
                                  }
                                },
                                title: const Text("Top 5 Black Wave Movies",
                                    style: TextStyle(
                                        color: Palette.lightPurple,
                                        fontSize: 14)),
                                validator: (val) {
                                  bool? showUserData = _formKey
                                      .currentState?.fields["userData"]?.value;
                                  bool? showGenreData = _formKey
                                      .currentState?.fields["genreData"]?.value;
                                  if (val == false &&
                                      showUserData == false &&
                                      showGenreData == false) {
                                    return "Must select at least one option.";
                                  }
                                  return null;
                                },
                              ),
                              MyFormBuilderCheckBox(
                                name: "genreData",
                                initialValue: includeTopGenresInPdf,
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      includeTopGenresInPdf = val;
                                    });
                                  }
                                },
                                title: const Text("Top 5 genres",
                                    style: TextStyle(
                                        color: Palette.lightPurple,
                                        fontSize: 14)),
                                validator: (val) {
                                  bool? showBioskopinaData = _formKey
                                      .currentState?.fields["movieData"]?.value;
                                  bool? showUserData = _formKey
                                      .currentState?.fields["userData"]?.value;
                                  if (val == false &&
                                      showBioskopinaData == false &&
                                      showUserData == false) {
                                    return "Must select at least one option.";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),
                              GradientButton(
                                  onPressed: () async {
                                    if (_formKey.currentState
                                        ?.saveAndValidate() ==
                                        true) {
                                      setState(() {
                                        chartPdfMode = true;
                                      });
                                      await exportToPdf();
                                    }
                                  },
                                  gradient: Palette.buttonGradient,
                                  borderRadius: 50,
                                  width: 90,
                                  height: 30,
                                  child: const Text(
                                    "Export",
                                    style: TextStyle(
                                        color: Palette.white,
                                        fontWeight: FontWeight.w500),
                                  ))
                            ],
                          ),
                        )));
              });
        },
        floatingButtonTooltip: "Export to .pdf",
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              buildFilterButtons(),
              const SizedBox(height: 20),
              buildRegistrationChart(),
              const SizedBox(height: 20),
              buildTotalUsers(),
              const SizedBox(height: 20),
              buildLineChartInterpretation(),
              const SizedBox(height: 20),
              Screenshot(
                  controller: _screenshotController2,
                  child: buildPopularBioskopinaChart()),
              const SizedBox(height: 20),
              buildBioskopinaBarChartInterpretation(),
              const SizedBox(height: 20),
              Screenshot(
                  controller: _screenshotController3,
                  child: buildPopularGenresChart()),
              const SizedBox(height: 20),
              buildGenresBarChartInterpretation(),
            ],
          ),
        ));
  }

  Widget buildTotalUsers() {
    return Column(
      children: [
        const Text("Total number of registered users:",
            style: TextStyle(fontSize: 20)),
        Text("$totalUsers",
            style: const TextStyle(
                color: Palette.teal, fontSize: 30, fontWeight: FontWeight.bold))
      ],
    );
  }

  Widget buildPopularGenresChart() {
    return FutureBuilder<List<PopularGenresData>>(
        future: _genreProvider.getMostPopularGenres(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MyProgressIndicator(); // Loading state
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Error state
          } else {
            // Data loaded successfully
            var genresData = snapshot.data!;

            return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(children: [
                    SizedBox(
                      width: 1100,
                      height: 500,
                      child: BarChart(
                        BarChartData(
                          barTouchData: BarTouchData(enabled: true),
                          barGroups: List.generate(
                            genresData.length,
                                (index) =>
                                BarChartGroupData(
                                  x: index,
                                  barRods: [
                                    BarChartRodData(
                                      toY: genresData[index].usersWhoLikeIt!
                                          .toDouble(),
                                      gradient: Palette.gradientList2[index],
                                      width: 35,
                                    ),
                                  ],
                                ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            verticalInterval: 1,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: (chartPdfMode == false)
                                    ? Palette.lightPurple.withOpacity(0.3)
                                    : Palette.darkPurple.withOpacity(0.8),
                                strokeWidth: 1,
                                dashArray: [8, 5],
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: const AxisTitles(
                                axisNameWidget: Text("")),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                getTitlesWidget: (double value,
                                    TitleMeta meta) {
                                  return Text(
                                    value.round().toString(),
                                    style: TextStyle(
                                      color: (chartPdfMode == false)
                                          ? Palette.lightPurple
                                          : Palette.darkPurple,
                                    ),
                                  );
                                },
                              ),
                              axisNameWidget: Text(
                                "Number of users who like the genre",
                                style: (chartPdfMode == false)
                                    ? const TextStyle(
                                    fontWeight: FontWeight.w500)
                                    : const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Palette.midnightPurple),
                              ),
                              axisNameSize: 22,
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                reservedSize: 100,
                                showTitles: true,
                                getTitlesWidget: ((value, meta) {
                                  if (value.toInt() >= 0 &&
                                      value.toInt() < genreTitles.length) {
                                    return SizedBox(
                                      width: 150,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              genreTitles[value.toInt()],
                                              softWrap: true,
                                              textAlign: ui.TextAlign.center,
                                              overflow: TextOverflow.clip,
                                              style: (chartPdfMode == false)
                                                  ? const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                              )
                                                  : const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  color:
                                                  Palette.midnightPurple),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return const Text('');
                                }),
                              ),
                            ),
                            topTitles: AxisTitles(
                              axisNameSize: 30,
                              axisNameWidget: Text(
                                "Top 5 most popular genres",
                                style: (chartPdfMode == false)
                                    ? const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18)
                                    : const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Palette.midnightPurple),
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                              show: true,
                              border: Border.all(
                                color: (chartPdfMode == false)
                                    ? Palette.teal.withOpacity(0.5)
                                    : Palette.darkPurple.withOpacity(0.8),
                                width: 2,
                              )),
                        ),

                        swapAnimationDuration:
                        const Duration(milliseconds: 150), // Optional
                        swapAnimationCurve: Curves.linear, // Optional
                      ),
                    ),
                  ]),
                ));
          }
        });
  }

  Widget buildGenresBarChartInterpretation() {
    return Column(
      children: [
        SizedBox(
          width: 900,
          child: FutureBuilder<List<PopularGenresData>>(
            future: _genreProvider.getMostPopularGenres(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const MyProgressIndicator(); // Loading state
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}'); // Error state
              } else {
                // Data loaded successfully
                var genresData = snapshot.data!;
                genreBarChartText = Text(
                  "The most popular genre on this app thus far is ${genresData[0]
                      .genreName} with a total of ${genresData[0]
                      .usersWhoLikeIt} user(s) who selected it as preferred.\n \n The following are:\n ${genresData[1]
                      .genreName} with a total of ${genresData[1]
                      .usersWhoLikeIt} user(s) who selected it as preferred, \n ${genresData[2]
                      .genreName} with a total of ${genresData[2]
                      .usersWhoLikeIt} user(s) who selected it as preferred, \n ${genresData[3]
                      .genreName} with a total of ${genresData[3]
                      .usersWhoLikeIt} user(s) who selected it as preferred, \n ${genresData[4]
                      .genreName} with a total of ${genresData[4]
                      .usersWhoLikeIt} user(s) who selected it as preferred.",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                );
                return genreBarChartText;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildBioskopinaBarChartInterpretation() {
    return Column(
      children: [
        SizedBox(
          width: 900,
          child: FutureBuilder<List<PopularBioskopinaData>>(
            future: _movieProvider.getMostPopularMovies(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const MyProgressIndicator(); // Loading state
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}'); // Error state
              } else {
                // Data loaded successfully
                var movieData = snapshot.data!;
                bioskopinaBarChartText = Text(
                  "The most popular black wave movie on this app thus far is ${movieData[0]
                      .bioskopinaTitleEN} (${movieData[0]
                      .bioskopinaTitleYugo}) with a score ${movieData[0].score
                      .toString()} and a total of ${movieData[0].numberOfRatings
                      .toString()} rating(s). \n \n The following are: \n ${movieData[1]
                      .bioskopinaTitleEN} (${movieData[1]
                      .bioskopinaTitleYugo}) with a score ${movieData[1].score
                      .toString()} and a total of ${movieData[1].numberOfRatings
                      .toString()} rating(s), \n ${movieData[2]
                      .bioskopinaTitleEN} (${movieData[2]
                      .bioskopinaTitleYugo}) with a score ${movieData[2].score
                      .toString()} and a total of ${movieData[2].numberOfRatings
                      .toString()} rating(s), \n ${movieData[3]
                      .bioskopinaTitleYugo} (${movieData[3]
                      .bioskopinaTitleYugo}) with a score ${movieData[3].score
                      .toString()} and a total of ${movieData[3].numberOfRatings
                      .toString()} rating(s), \n ${movieData[4]
                      .bioskopinaTitleEN} (${movieData[4]
                      .bioskopinaTitleYugo}) with a score ${movieData[4].score
                      .toString()} and a total of ${movieData[4].numberOfRatings
                      .toString()} rating(s).",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                );
                return bioskopinaBarChartText;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildLineChartInterpretation() {
    return FutureBuilder<List<UserRegistrationData>>(
        future: userRegistrationDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MyProgressIndicator(); // Loading state
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Error state
          } else {
            // Data loaded successfully
            var userData = snapshot.data!;

            UserRegistrationData mostRegistrationsDay = userData
                .reduce((a, b) => a.numberOfUsers! > b.numberOfUsers! ? a : b);

            double averageRegistrations = userData.isEmpty
                ? 0
                : userData
                .map((data) => data.numberOfUsers!)
                .reduce((a, b) => a + b) /
                userData.length;

            return Column(
              children: [
                SizedBox(
                    width: 900,
                    child: _buildLineChartInterpretation(
                        mostRegistrationsDay, averageRegistrations))
              ],
            );
          }
        });
  }

  Widget _buildLineChartInterpretation(
      UserRegistrationData mostRegistrationsDay, double averageRegistrations) {
    Text temp;

    if (mostRegistrationsDay.numberOfUsers == 0) {
      temp = const Text(
        "No user registrations in selected time period.",
        style: TextStyle(
          fontSize: 16,
        ),
      );

      userChartTextForPdf = pw.Text(
        temp.data!,
        style: pw.TextStyle(fontSize: 11, color: PdfColor.fromHex("#0C0B1E")),
      );
      return temp;
    }
    if (pastYear == true) {
      temp = Text(
        "A month with the most registrations (${mostRegistrationsDay
            .numberOfUsers} in total) in the past 365 days was ${DateFormat(
            'MMMM, yyyy').format(mostRegistrationsDay
            .date!)}. \n \n The average number of users registered in the past 365 days is ${averageRegistrations
            .toPrecision(2)}",
        style: const TextStyle(
          fontSize: 16,
        ),
      );

      userChartTextForPdf = pw.Text(
        temp.data!,
        style: pw.TextStyle(
          fontSize: 11,
          color: PdfColor.fromHex("#0C0B1E"),
        ),
      );

      return temp;
    }
    if (pastWeek == true) {
      temp = Text(
        "A day with the most registrations (${mostRegistrationsDay
            .numberOfUsers} in total) in the past 7 days was ${DateFormat(
            'MMMM d, y, EEEE').format(mostRegistrationsDay
            .date!)}. \n \n The average number of users registered in the past 7 days is ${averageRegistrations
            .toPrecision(2)}",
        style: const TextStyle(
          fontSize: 16,
        ),
      );

      userChartTextForPdf = pw.Text(
        temp.data!,
        style: pw.TextStyle(fontSize: 11, color: PdfColor.fromHex("#0C0B1E")),
      );

      return temp;
    }

    temp = Text(
      "A day with the most registrations (${mostRegistrationsDay
          .numberOfUsers} in total) in the past 30 days was ${DateFormat(
          'MMMM d, y').format(mostRegistrationsDay
          .date!)}. \n \n The average number of users registered in the past 30 days is ${averageRegistrations
          .toPrecision(2)}",
      style: const TextStyle(
        fontSize: 16,
      ),
    );

    userChartTextForPdf = pw.Text(
      temp.data!,
      style: pw.TextStyle(fontSize: 11, color: PdfColor.fromHex("#0C0B1E")),
    );

    return temp;
  }

  Row buildFilterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GradientButton(
          onPressed: () {
            setState(() {
              userRegistrationDataFuture =
                  _userProvider.getUserRegistrations(364, groupByMonths: true);
              days = 364;
              pastYear = true;
              pastWeek = false;
              bottomInterval = 1;
            });
          },
          width: 110,
          height: 30,
          gradient: Palette.buttonGradient,
          borderRadius: 50,
          child: const Text("Past year",
              style:
              TextStyle(fontWeight: FontWeight.w500, color: Palette.white)),
        ),
        const SizedBox(width: 20),
        GradientButton(
          onPressed: () {
            setState(() {
              userRegistrationDataFuture =
                  _userProvider.getUserRegistrations(29);
              days = 29;
              bottomInterval = 1;
              pastYear = false;
              pastWeek = false;
            });
          },
          width: 110,
          height: 30,
          gradient: Palette.buttonGradient,
          borderRadius: 50,
          child: const Text("Past month",
              style:
              TextStyle(fontWeight: FontWeight.w500, color: Palette.white)),
        ),
        const SizedBox(width: 20),
        GradientButton(
          onPressed: () {
            setState(() {
              userRegistrationDataFuture =
                  _userProvider.getUserRegistrations(6);
              days = 6;
              bottomInterval = 1;
              pastYear = false;
              pastWeek = true;
            });
          },
          width: 110,
          height: 30,
          gradient: Palette.buttonGradient,
          borderRadius: 50,
          child: const Text("Past week",
              style:
              TextStyle(fontWeight: FontWeight.w500, color: Palette.white)),
        ),
      ],
    );
  }

  Widget buildPopularBioskopinaChart() {
    final List<int> popularityValues = [5, 4, 3, 2, 1];
    return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(children: [
            SizedBox(
              width: 1100,
              height: 500,
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(enabled: false),
                  barGroups: List.generate(
                    5,
                        (index) =>
                        BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: popularityValues[index].toDouble(),
                              gradient: Palette.gradientList[index],
                              width: 35,
                            ),
                          ],
                        ),
                  ),
                  gridData: FlGridData(
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: (chartPdfMode == false)
                              ? Palette.lightPurple.withOpacity(0.3)
                              : Palette.darkPurple.withOpacity(0.8),
                          strokeWidth: 1,
                          dashArray: [8, 5],
                        );
                      },
                      show: true,
                      drawVerticalLine: true,
                      verticalInterval: 1),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(axisNameWidget: Text("")),
                    leftTitles: const AxisTitles(axisNameWidget: Text("")),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        reservedSize: 100,
                        showTitles: true,
                        getTitlesWidget: ((value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < moviesTitles.length) {
                            return SizedBox(
                              width: 150,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      moviesTitles[value.toInt()],
                                      softWrap: true,
                                      textAlign: ui.TextAlign.center,
                                      overflow: TextOverflow.clip,
                                      style: (chartPdfMode == false)
                                          ? const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      )
                                          : const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: Palette.midnightPurple),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return const Text('');
                        }),
                      ),
                    ),
                    topTitles: AxisTitles(
                      axisNameSize: 30,
                      axisNameWidget: Text(
                        "Top 5 most popular movies",
                        style: (chartPdfMode == false)
                            ? const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18)
                            : const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Palette.midnightPurple),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: (chartPdfMode == false)
                            ? Palette.teal.withOpacity(0.5)
                            : Palette.darkPurple.withOpacity(0.8),
                        width: 2,
                      )),
                ),

                swapAnimationDuration:
                const Duration(milliseconds: 150), // Optional
                swapAnimationCurve: Curves.linear, // Optional
              ),
            ),
          ]),
        ));
  }

  Widget buildRegistrationChart() {
    return FutureBuilder<List<UserRegistrationData>>(
      future: userRegistrationDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<UserRegistrationData> data = snapshot.data ?? [];

          // Convert dates to local time zone
          for (var item in data) {
            item.date = item.date?.toLocal();
          }

          return Screenshot(
            controller: _screenshotController,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    SizedBox(
                      width: 1100,
                      height: 500,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: chartPdfMode
                                    ? Palette.darkPurple.withOpacity(0.8)
                                    : Palette.lightPurple.withOpacity(0.3),
                                strokeWidth: 1,
                                dashArray: [8, 5],
                              );
                            },
                            getDrawingVerticalLine: (value) {
                              return FlLine(
                                color: chartPdfMode
                                    ? Palette.darkPurple.withOpacity(0.8)
                                    : Palette.lightPurple.withOpacity(0.3),
                                strokeWidth: 1,
                                dashArray: [8, 5],
                              );
                            },
                            show: true,
                            drawVerticalLine: true,
                            verticalInterval: 1,
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            leftTitles: AxisTitles(
                              axisNameWidget: Text(
                                "Number of registered users",
                                style: chartPdfMode
                                    ? const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Palette.midnightPurple)
                                    : const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              axisNameSize: 22,
                              sideTitles: SideTitles(
                                getTitlesWidget: (double value,
                                    TitleMeta meta) {
                                  return Text(
                                    value.round().toString(),
                                    style: TextStyle(
                                      color: chartPdfMode
                                          ? Palette.darkPurple
                                          : Palette.lightPurple,
                                    ),
                                  );
                                },
                                showTitles: true,
                                reservedSize: 25,
                                interval: 10,
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              axisNameWidget: Text(
                                "Past ${days + 1} days",
                                style: chartPdfMode
                                    ? const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Palette.midnightPurple)
                                    : const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              axisNameSize: 20,
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 80,
                                interval: bottomInterval,
                                getTitlesWidget: (value, meta) {
                                  List<String> timeLabels = data
                                      .map((element) =>
                                      DateFormat('MMM d, y')
                                          .format(element.date!))
                                      .toList();

                                  if (pastYear) {
                                    timeLabels = data
                                        .map((element) =>
                                        DateFormat('MMM, y')
                                            .format(element.date!))
                                        .toList();
                                  }

                                  if (pastWeek) {
                                    timeLabels = data
                                        .map((element) =>
                                        DateFormat(
                                            'MMM d, y, EEEE', 'en_US')
                                            .format(element.date!))
                                        .toList();
                                  }

                                  int index = value.toInt();

                                  if (index >= 0 && index < timeLabels.length) {
                                    return RotatedBox(
                                      quarterTurns: 3,
                                      child: Text(
                                        timeLabels[index],
                                        textAlign: TextAlign.center,
                                        style: chartPdfMode
                                            ? const TextStyle(
                                            fontSize: 12,
                                            color: Palette.midnightPurple)
                                            : const TextStyle(fontSize: 12),
                                      ),
                                    );
                                  }

                                  return Container();
                                },
                              ),
                            ),
                            rightTitles: const AxisTitles(
                                axisNameWidget: Text("")),
                            topTitles: AxisTitles(
                              axisNameSize: 30,
                              axisNameWidget: Text(
                                "Number of registered users in time",
                                style: chartPdfMode
                                    ? const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Palette.midnightPurple)
                                    : const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                              color: chartPdfMode
                                  ? Palette.darkPurple.withOpacity(0.8)
                                  : Palette.teal.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                          minX: 0,
                          maxX: data.length.toDouble() - 1,
                          minY: 0,
                          maxY: _getMaxYValue(data),
                          lineBarsData: [
                            LineChartBarData(
                              gradient: Palette.buttonGradientReverse,
                              spots: _getSpots(data),
                              isCurved: true,
                              barWidth: 4,
                              preventCurveOverShooting: true,
                              isStrokeCapRound: true,
                              belowBarData: BarAreaData(
                                show: true,
                                color: Palette.teal.withOpacity(0.3),
                              ),
                              shadow: const Shadow(
                                  color: Palette.teal, blurRadius: 30),
                              dotData: const FlDotData(show: true),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  List<FlSpot> _getSpots(List<UserRegistrationData> data) {
    return data
        .asMap()
        .entries
        .map((entry) {
      return FlSpot(
          entry.key.toDouble(), entry.value.numberOfUsers!.toDouble());
    }).toList();
  }

  double _getMaxYValue(List<UserRegistrationData> data) {
    return data.isNotEmpty
        ? data.map((entry) => entry.numberOfUsers!.toDouble()).reduce((a,
        b) => a > b ? a : b)
        : 1.0;
  }
}
