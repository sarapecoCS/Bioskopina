import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:file_picker/file_picker.dart';

import '../models/popular_bioskopina_data.dart';
import '../providers/bioskopina_provider.dart';
import '../utils/colors.dart';
import '../widgets/gradient_button.dart';
import '../widgets/master_screen.dart';
import '../providers/user_provider.dart';
import '../models/search_result.dart';
import '../models/user.dart';
import '../models/registration_data.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late MovieProvider _movieProvider;
  int selectedIndex = 0;

  List<PopularBioskopinaData> popularBioskopinaData = [];
  bool isLoading = true;
  final ScreenshotController _registrationScreenshotController = ScreenshotController();
  final ScreenshotController _moviesScreenshotController = ScreenshotController();
  String pdfFileName = 'Black_Wave_Report';

  // User registration data
  late Future<List<UserRegistrationData>> userRegistrationDataFuture;
  late Future<SearchResult<User>> _userFuture;
  late UserProvider _userProvider;
  int totalUsers = 0;
  int days = 29;
  bool pastYear = false;
  bool pastWeek = false;
  double? bottomInterval = 1;

  @override
  void initState() {
    super.initState();
    _movieProvider = context.read<MovieProvider>();
    _userProvider = context.read<UserProvider>();

    // Initialize futures
    _userFuture = _userProvider.get();
    userRegistrationDataFuture = _userProvider.getUserRegistrations(days);

    getTotalusers();
    _loadPopularMovies();
  }

  Future<void> _loadPopularMovies() async {
    setState(() => isLoading = true);

    popularBioskopinaData = await _movieProvider.getMostPopularMovies();

    // Sort the movies by score from highest to lowest (descending)
    popularBioskopinaData.sort((a, b) {
      final scoreA = a.score ?? 0.0;
      final scoreB = b.score ?? 0.0;

      if (scoreA == 0.0 && scoreB == 0.0) return 0;
      if (scoreA == 0.0) return 1;
      if (scoreB == 0.0) return -1;

      return scoreB.compareTo(scoreA);
    });

    setState(() => isLoading = false);
  }

  void getTotalusers() async {
    var users = await _userFuture;
    setState(() {
      totalUsers = users.count;
    });
  }

  Future<void> _exportPdf() async {
    final shouldExport = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Palette.lightPurple.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(15),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        backgroundColor: Colors.black,
       title: Center(
         child: Container(
           width: 60,
           height: 60,
           decoration: BoxDecoration(
             color: Colors.blueGrey[800]!.withOpacity(0.5),
             shape: BoxShape.circle,
           ),
           child: Icon(
             Icons.file_download_rounded,  // Icon of your choice
             color: Color.fromRGBO(153, 255, 255, 1),
             size: 30,  // Icon size (smaller than container)
           ),
         ),

        ),
        content: Text(
          'Export ${selectedIndex == 0 ? 'User Registration' : 'Top Movies'} data to PDF?',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 10, top: 10),
            child: GradientButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              width: 85,
              height: 28,
              borderRadius: 15,
              gradient: Palette.buttonGradient2,
              child: const Text(
                "Cancel",
                style: TextStyle(color: Palette.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 10, top: 10),
            child: GradientButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              width: 85,
              height: 28,
              borderRadius: 15,
              gradient: Palette.buttonGradient,
              child: const Text(
                "Export",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Palette.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );


    if (shouldExport != true) return;

    final pdf = pw.Document();
    final ByteData logoData = await rootBundle.load("assets/images/logoFilled.png");
    final Uint8List logoBytes = logoData.buffer.asUint8List();
    PdfColor myTeal = PdfColor.fromInt(0x99FFFF);
    // PDF Theme
    final headerStyle = pw.TextStyle(
      color: PdfColors.white,
      fontSize: 18,
      fontWeight: pw.FontWeight.bold,
    );

    final contentStyle = pw.TextStyle(
      color: PdfColors.white,
      fontSize: 12,
    );

    if (selectedIndex == 0) {
      // User Registration PDF
      final registrationData = await userRegistrationDataFuture;
      final mostRegistrationsDay = registrationData.isEmpty
          ? UserRegistrationData(date: DateTime.now(), numberOfUsers: 0)
          : registrationData.reduce(
              (a, b) => a.numberOfUsers! > b.numberOfUsers! ? a : b);
      final averageRegistrations = registrationData.isEmpty
          ? 0.0
          : registrationData
                  .map((data) => data.numberOfUsers!)
                  .reduce((a, b) => a + b) /
              registrationData.length;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) => pw.Container(
            color: PdfColors.black,
            padding: const pw.EdgeInsets.all(30),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header with logo
                pw.Row(
                  children: [
                    pw.Image(
                      pw.MemoryImage(logoBytes),
                      width: 40,
                      height: 40,
                    ),
                    pw.SizedBox(width: 15),
                    pw.Text(
                      'User Registration Report',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Spacer(),
                    pw.Text(
                      DateFormat('MMM d, y').format(DateTime.now()),
                      style: contentStyle,
                    ),
                  ],
                ),
                pw.SizedBox(height: 30),
                pw.Divider(color: PdfColors.white),
                pw.SizedBox(height: 30),

                // Summary Stats
                pw.Text('Total Registered Users: $totalUsers', style: headerStyle),
                pw.SizedBox(height: 15),
                _buildRegistrationStats(mostRegistrationsDay, averageRegistrations),
                pw.SizedBox(height: 30),

                // Chart Data Table
                pw.Text('Daily Registration Data', style: headerStyle),
                pw.SizedBox(height: 15),
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.white),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(2),
                    1: const pw.FlexColumnWidth(1),
                  },
                  children: [
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.grey800),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Date', style: headerStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Registrations', style: headerStyle),
                        ),
                      ],
                    ),
                    ...registrationData.map((data) => pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.grey900),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            DateFormat('MMM d, y').format(data.date!),
                            style: contentStyle,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            data.numberOfUsers.toString(),
                            style: contentStyle,
                          ),
                        ),
                      ],
                    )).toList(),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // Top Movies PDF
      final topMovies = popularBioskopinaData.take(5).toList();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) => pw.Container(
            color: PdfColors.black,
            padding: const pw.EdgeInsets.all(30),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header with logo
                pw.Row(
                  children: [
                    pw.Image(
                      pw.MemoryImage(logoBytes),
                      width: 60,
                      height: 60,
                    ),
                    pw.SizedBox(width: 15),
                    pw.Text(
                      'Top 5 Movies Report',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Spacer(),
                    pw.Text(
                      DateFormat('MMM d, y').format(DateTime.now()),
                      style: contentStyle,
                    ),
                  ],
                ),
                pw.SizedBox(height: 30),
                pw.Divider(color: PdfColors.white),
                pw.SizedBox(height: 30),

                // Movies Table
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.white),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(3),
                    1: const pw.FlexColumnWidth(2),
                    2: const pw.FlexColumnWidth(2),
                    3: const pw.FlexColumnWidth(1),
                  },
                  children: [
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.grey800),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Title', style: headerStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Director', style: headerStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Genre', style: headerStyle),
                        ),
                       pw.Padding(
                         padding: const pw.EdgeInsets.all(8.0),
                         child: pw.SvgImage(
                           svg: '''
                           <svg width="24" height="24" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                             <path fill="#FFD700" d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2L9.19 8.63L2 9.24l5.46 4.73L5.82 21z"/>
                           </svg>
                           ''',
                           width: 16,
                           height: 16,
                         ),
                       ),
                      ],
                    ),
                    ...topMovies.map((movie) => pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.grey900),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            movie.bioskopinaTitleEN ?? 'Unknown',
                            style: contentStyle,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            movie.director ?? 'Unknown',
                            style: contentStyle,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            movie.genres?.join(', ') ?? 'Unknown',
                            style: contentStyle,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            movie.score?.toStringAsFixed(1) ?? 'N/A',
                            style: contentStyle.copyWith(
                              color: myTeal,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )).toList(),
                  ],
                ),
                pw.SizedBox(height: 30),

                // Summary
                pw.Text(
                  'Top Movie: ${topMovies.first.bioskopinaTitleEN ?? 'Unknown'} '
                  'with score ${topMovies.first.score?.toStringAsFixed(1) ?? 'N/A'}',
                  style: headerStyle,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Save PDF
    try {
      final filePath = await FilePicker.platform.saveFile(
        dialogTitle: "Save PDF Report",
        fileName: '${selectedIndex == 0 ? 'User_Report' : 'Movies_Report'}_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (filePath != null) {
        final file = File(filePath.endsWith('.pdf') ? filePath : '$filePath.pdf');
        await file.writeAsBytes(await pdf.save());
        if (!mounted) return;
        _showExportSuccessDialog();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: ${e.toString()}')),
      );
    }
  }

  pw.Widget _buildRegistrationStats(
      UserRegistrationData mostRegistrationsDay, double averageRegistrations) {
    if (mostRegistrationsDay.numberOfUsers == 0) {
      return pw.Text(
        "No user registrations in selected time period.",
        style: pw.TextStyle(color: PdfColors.white),
      );
    }

    final dateFormat = pastYear
      ? DateFormat('MMMM yyyy')
      : (pastWeek ? DateFormat('EEEE, MMMM d') : DateFormat('MMMM d'));

    final timePeriod = pastYear
      ? 'past year'
      : (pastWeek ? 'past week' : 'past month');

    final avgText = pastYear
      ? '${averageRegistrations.toStringAsFixed(2)}/month'
      : (pastWeek ? '${averageRegistrations.toStringAsFixed(2)}/day' : '${averageRegistrations.toStringAsFixed(2)}/day');

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Peak registrations: ${mostRegistrationsDay.numberOfUsers} on ${dateFormat.format(mostRegistrationsDay.date!)}',
          style: pw.TextStyle(color: PdfColors.white),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          'Average registrations: $avgText ($timePeriod)',
          style: pw.TextStyle(color: PdfColors.white),
        ),
      ],
    );
  }

  void _showExportSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.grey.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          backgroundColor: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.task_alt,
                  color: Color.fromRGBO(102, 204, 204, 1),
                  size: 50,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Successfully exported!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 80,
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: Palette.buttonGradient,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRegistrationChart() {
    return FutureBuilder<List<UserRegistrationData>>(
      future: userRegistrationDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No registration data available',
              style: TextStyle(color: Colors.white));
        } else {
          List<UserRegistrationData> data = snapshot.data!;

          for (var data in data) {
            data.date = data.date?.toLocal();
          }

          return Screenshot(
            controller: _registrationScreenshotController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                buildFilterButtons(),
                const SizedBox(height: 8),
                SizedBox(
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.white70.withOpacity(0.3),
                              strokeWidth: 1,
                              dashArray: [8, 5],
                            );
                          },
                          getDrawingVerticalLine: (value) {
                            return FlLine(
                              color: Colors.white70.withOpacity(0.3),
                              strokeWidth: 1,
                              dashArray: [8, 5],
                            );
                          },
                          show: true,
                          drawVerticalLine: true,
                          verticalInterval: 1
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          leftTitles: AxisTitles(
                            axisNameWidget: const Text(
                              "Users",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            axisNameSize: 22,
                            sideTitles: SideTitles(
                              getTitlesWidget:
                                  (double value, TitleMeta meta) {
                                return Text(
                                  value.round().toString(),
                                  style: const TextStyle(
                                    color: Colors.white70,
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
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            axisNameSize: 20,
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 80,
                              interval: bottomInterval,
                              getTitlesWidget: ((value, meta) {
                                List<String> timeLabels = data
                                    .map((element) => DateFormat('MMM d')
                                        .format(element.date!))
                                    .toList();

                                if (pastYear) {
                                  timeLabels = data
                                      .map((element) =>
                                          DateFormat('MMM, y', 'en_US')
                                              .format(element.date!))
                                      .toList();
                                }

                                if (pastWeek) {
                                  timeLabels = data
                                      .map((element) => DateFormat(
                                              'MMM d, E', 'en_US')
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
                                      style: const TextStyle(
                                          fontSize: 10, color: Colors.white70),
                                    ),
                                  );
                                }
                                return Container();
                              }),
                            ),
                          ),
                          rightTitles:
                              const AxisTitles(axisNameWidget: Text("")),
                          topTitles: AxisTitles(
                              axisNameSize: 30,
                              axisNameWidget: const Text(
                                "User Registrations Over Time",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.white),
                              )),
                        ),
                        borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                              color: Colors.teal.withOpacity(0.5),
                              width: 2,
                            )),
                        minX: 0,
                        maxX: data.length.toDouble() - 1,
                        minY: 0,
                        maxY: _getMaxYValue(data),
                        lineBarsData: [
                          LineChartBarData(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8A7CFA), Color(0xFFF07FFF)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            spots: _getSpots(data),
                            isCurved: true,
                            barWidth: 4,
                            preventCurveOverShooting: true,
                            isStrokeCapRound: true,
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.teal.withOpacity(0.3),
                            ),
                            shadow: const Shadow(
                                color: Colors.teal, blurRadius: 30),
                            dotData: const FlDotData(show: true),
                          )
                        ]),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                buildTotalUsers(),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildLineChartInterpretation(
                      data.isNotEmpty
                          ? data.reduce((a, b) =>
                              a.numberOfUsers! > b.numberOfUsers! ? a : b)
                          : UserRegistrationData(date: DateTime.now(), numberOfUsers: 0),
                      data.isEmpty
                          ? 0.0
                          : data
                                  .map((data) => data.numberOfUsers!)
                                  .reduce((a, b) => a + b) /
                              data.length),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  List<FlSpot> _getSpots(List<UserRegistrationData> data) {
    return data.asMap().entries.map((entry) {
      return FlSpot(
          entry.key.toDouble(), entry.value.numberOfUsers!.toDouble());
    }).toList();
  }

  double _getMaxYValue(List<UserRegistrationData> data) {
    return data.isNotEmpty
        ? data
            .map((entry) => entry.numberOfUsers!.toDouble())
            .reduce((a, b) => a > b ? a : b)
        : 1.0;
  }

  Widget _buildLineChartInterpretation(
      UserRegistrationData mostRegistrationsDay, double averageRegistrations) {
    if (mostRegistrationsDay.numberOfUsers == 0) {
      return const Text(
        "No user registrations in selected time period.",
        style: TextStyle(
          fontSize: 12,
          color: Colors.white70,
        ),
      );
    }
    if (pastYear) {
      return Text(
        "Most registrations (${mostRegistrationsDay.numberOfUsers}) in past year was ${DateFormat('MMMM, yyyy').format(mostRegistrationsDay.date!)}. Avg: ${averageRegistrations.toStringAsFixed(2)}/month",
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white70,
        ),
      );
    }
    if (pastWeek) {
      return Text(
        "Most registrations (${mostRegistrationsDay.numberOfUsers}) in past week was ${DateFormat('MMMM d, EEEE').format(mostRegistrationsDay.date!)}. Avg: ${averageRegistrations.toStringAsFixed(2)}/day",
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white70,
        ),
      );
    }

    return Text(
      "Most registrations (${mostRegistrationsDay.numberOfUsers}) in past month was ${DateFormat('MMMM d').format(mostRegistrationsDay.date!)}. Avg: ${averageRegistrations.toStringAsFixed(2)}/day",
      style: const TextStyle(
        fontSize: 12,
        color: Colors.white70,
      ),
    );
  }

  Widget buildTotalUsers() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Total registered users:",
            style: TextStyle(fontSize: 14, color: Colors.white70)),
        Text("$totalUsers",
            style: const TextStyle(
                color: Color.fromRGBO(153, 255, 255, 1), fontSize: 20, fontWeight: FontWeight.bold))
      ],
    );
  }

Widget buildFilterButtons() {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
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
          width: 80,
          height: 28,
          gradient: const LinearGradient(
            colors: [
              Color(0xFF6D8BDE),  // Soft sky blue
              Color(0xFF8BB8FF),  // Lighter pastel blue
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: 50,
          child: const Text(
            "Year",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 8),
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
          width: 80,
          height: 28,
          gradient: const LinearGradient(
            colors: [
              Color(0xFF6D8BDE),
              Color(0xFF8BB8FF),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: 50,
          child: const Text(
            "Month",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 8),
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
          width: 80,
          height: 28,
          gradient: const LinearGradient(
            colors: [
              Color(0xFF6D8BDE),
              Color(0xFF8BB8FF),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: 50,
          child: const Text(
            "Week",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}
  Widget _buildSectionToggleButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        width: 280,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutBack,
              alignment: selectedIndex == 0
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                width: 140,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF00B4D8),  // Brighter teal
                      Color(0xFF2A52BE),  // Slightly darker blue
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => selectedIndex = 0);
                    },
                    child: Center(
                      child: Text(
                        'User Registrations',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: selectedIndex == 0
                              ? Colors.white  // Changed to white when active
                              : Colors.grey.shade600,  // Kept gray when inactive
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => selectedIndex = 1);
                    },
                    child: Center(
                      child: Text(
                        'Top 5 Movies',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: selectedIndex == 1
                              ? Colors.white  // Changed to white when active
                              : Colors.grey.shade600,  // Kept gray when inactive
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
Widget _buildPopularMoviesChart() {
  if (popularBioskopinaData.isEmpty) {
    return const Center(
      child: Text(
        "No data",
        style: TextStyle(color: Colors.white70, fontSize: 10),
      ),
    );
  }

  final maxScore = (popularBioskopinaData
          .map((e) => e.score ?? 0)
          .reduce((a, b) => a > b ? a : b)
          .toDouble() * 1.15)
      .roundToDouble();

  return SizedBox(
    height: 374, // Compact height
    child: BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(

            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final movie = popularBioskopinaData[groupIndex];
              return BarTooltipItem(
                '${movie.bioskopinaTitleEN ?? 'Untitled'}\nScore: ${rod.toY}',
                const TextStyle(color: Color.fromRGBO(153, 255, 255, 1), fontSize: 11),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              reservedSize: 22, // Smaller title area
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= popularBioskopinaData.length) {
                  return const SizedBox();
                }

                final title = popularBioskopinaData[index].bioskopinaTitleEN ?? '';
                return Text(
                  title.length > 6 ? '${title.substring(0, 6)}...' : title,
                  style: TextStyle(
                    fontSize: 8, // Smaller font
                    color: Color.fromRGBO(153, 255, 255, 1),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: maxScore > 10 ? (maxScore / 4) : 2,
              reservedSize: 24, // Smaller axis area
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    color: Colors.blue[100],
                    fontSize: 9,
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.blue[900]!.withOpacity(0.2),
            strokeWidth: 0.5,
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: popularBioskopinaData.asMap().entries.map((entry) {
          final score = entry.value.score?.toDouble() ?? 0;
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: score,
                gradient: LinearGradient(
                  colors: [
                    Colors.blueAccent.withOpacity(0.8),
                    Colors.lightBlue[200]!.withOpacity(0.8),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                width: 10, // Slimmer bars
                borderRadius: BorderRadius.circular(3),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: maxScore,
                  color: Colors.blue[900]!.withOpacity(0.1),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    ),
  );
}
Widget _buildMovieList() {
  return ListView.separated(
    padding: EdgeInsets.zero, // Remove default padding
    physics: const ClampingScrollPhysics(),
    itemCount: popularBioskopinaData.take(5).length,
    separatorBuilder: (_, __) => const SizedBox(height: 9),
    itemBuilder: (context, index) {
      final movie = popularBioskopinaData[index];
      return Container(
        decoration: BoxDecoration(
          color: Palette.darkPurple,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(4),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          minVerticalPadding: 0,
          dense: true,
          leading: movie.imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    movie.imageUrl!,
                    width: 60,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  width: 40,
                  height: 60,
                  color: Colors.grey[800],
                  child: const Icon(Icons.movie, color: Colors.grey, size: 20),
                ),
          title: Text(
            movie.bioskopinaTitleEN ?? 'Unknown Title',
            style: const TextStyle(
              color: Palette.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Director: ${movie.director ?? 'Unknown'}',
                style: const TextStyle(color: Colors.grey, fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                movie.genres?.take(2).join(', ') ?? 'Unknown',
                style: const TextStyle(color: Palette.teal, fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey[800]?.withOpacity(0.8) ?? Colors.grey[800]!,
              borderRadius: BorderRadius.circular(90),
              border: Border.all(color: Palette.teal, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              movie.score?.toStringAsFixed(1) ?? 'N/A',
              style: const TextStyle(
                color: Palette.teal,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: Row(
        children: const [
          Icon(Icons.bar_chart, size: 24),
          SizedBox(width: 5),
          Text("Reports", style: TextStyle(fontSize: 18)),
        ],
      ),
      showFloatingActionButton: true,
      floatingActionButtonIcon: const Icon(Icons.picture_as_pdf, size: 36, color: Colors.red),
      floatingButtonOnPressed: _exportPdf,
      floatingButtonTooltip: "Export report as PDF",
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSectionToggleButtons(),
                Expanded(
                  child: IndexedStack(
                    index: selectedIndex,
                    children: [
                      _buildRegistrationChart(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Screenshot(
                          controller: _moviesScreenshotController,
                          child: Column(
                            children: [
                              const Text(
                                'Top 5 Black Wave Movies',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Palette.darkPurple,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.all(16),
                                        child: _buildPopularMoviesChart(),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        decoration: BoxDecoration(

                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.all(16),
                                        child: _buildMovieList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}