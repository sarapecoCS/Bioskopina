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

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late MovieProvider _movieProvider;
  List<PopularBioskopinaData> popularBioskopinaData = [];
  bool isLoading = true;
  bool includeTopBioskopinaInPdf = true;
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    _movieProvider = context.read<MovieProvider>();
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

  Future<void> _exportPdf() async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    ui.Image? chartImage = await _screenshotController.captureAsUiImage(pixelRatio: pixelRatio);
    if (chartImage == null) return;

    ByteData? byteData = await chartImage.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;

    Uint8List chartBytes = byteData.buffer.asUint8List();

    final ByteData logoData = await rootBundle.load("assets/images/logoFilled.png");
    final Uint8List logoBytes = logoData.buffer.asUint8List();

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Image(pw.MemoryImage(logoBytes), width: 80),
                  pw.SizedBox(width: 20),
                  pw.Text(
                    'Top 5 Black Wave Movies Report',
                    style: pw.TextStyle(fontSize: 22, color: PdfColor.fromHex("#0C0B1E")),
                  ),
                ],
              ),
              pw.Divider(),
              if (includeTopBioskopinaInPdf)
                pw.Image(pw.MemoryImage(chartBytes), width: 500),
              pw.SizedBox(height: 10),
              if (includeTopBioskopinaInPdf)
                pw.Text(
                  'Top 5 Black Wave Movies',
                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                ),
            ],
          );
        },
      ),
    );

    final filePath = await FilePicker.platform.saveFile(
      dialogTitle: "Save PDF Report",
      fileName: 'Top_Black_Wave_Movies_Report_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (filePath != null) {
      final file = File(filePath);
      if (!filePath.endsWith('.pdf')) {
        await File('$filePath.pdf').writeAsBytes(await pdf.save());
      } else {
        await file.writeAsBytes(await pdf.save());
      }
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: const Text('Success'),
            content: const Text('PDF saved successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('Ok', style: TextStyle(color: Colors.white),),

              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: Row(
        children: const [
          Icon(Icons.bar_chart, size: 28),
          SizedBox(width: 5),
          Text("Reports"),
        ],
      ),
      showFloatingActionButton: true,
      floatingActionButtonIcon: const Icon(Icons.picture_as_pdf, size: 48, color: Colors.red),
      floatingButtonOnPressed: () {
        showDialog(
          context: context,
          builder: (ctx) {
            return Dialog(
              backgroundColor: Palette.darkPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Select data to include in report',
                        style: TextStyle(color: Palette.lightPurple, fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 20),
                      CheckboxListTile(
                        activeColor: Palette.lightPurple,
                        title: const Text(
                          'Top 5 Black Wave Movies',
                          style: TextStyle(color: Palette.lightPurple),
                        ),
                        value: includeTopBioskopinaInPdf,
                        onChanged: (val) {
                          setState(() {
                            includeTopBioskopinaInPdf = val ?? true;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      GradientButton(
                        width: 100,
                        height: 35,
                        borderRadius: 30,
                        gradient: Palette.buttonGradient,
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          _exportPdf();
                        },
                        child: const Text(
                          'Export PDF',
                          style: TextStyle(color: Palette.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      floatingButtonTooltip: "Export top movies report as PDF",
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Left Section: The chart
                  Expanded(
                    child: Screenshot(
                      controller: _screenshotController,
                      child: _buildPopularMoviesChart(),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Right Section: The movie list
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildMovieList(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
Widget _buildPopularMoviesChart() {
  if (popularBioskopinaData.isEmpty) {
    return const Center(child: Text("No data available"));
  }

  final maxScore = popularBioskopinaData
          .map((e) => e.score ?? 0)
          .fold<double>(0, (previousValue, element) => element > previousValue ? element.toDouble() : previousValue) +
      1;

  return SizedBox(
    height: 300,
    child: BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround, // Balanced space for bars
        maxY: maxScore,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index < 0 || index >= popularBioskopinaData.length) return const SizedBox();

                final title = popularBioskopinaData[index].bioskopinaTitleEN ?? '';

                // Reduce font size for long titles
                double fontSize = title.length > 20 ? 8.0 : 10.0;

                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: fontSize,
                        color: const Color(0xFFF07FFF),
                        fontWeight: FontWeight.normal, // Ensure normal font weight
                        overflow: TextOverflow.ellipsis,  // Allow truncation with ellipsis
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
              interval: 1,
              reservedSize: 60,  // Adjusted space to avoid overlap
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                // Adjust left title position to avoid cutting off titles
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(popularBioskopinaData.length, (index) {
          final movie = popularBioskopinaData[index];
          final score = movie.score?.toDouble() ?? 0;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: score,
                color: Palette.teal,
                width: 18,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
            showingTooltipIndicators: [0],
          );
        }),
      ),
    ),
  );
}




  Widget _buildMovieList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: popularBioskopinaData.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final movie = popularBioskopinaData[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Palette.darkPurple,
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            leading: movie.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      movie.imageUrl!,
                      width: 60,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  )
                : null,
            title: Text(
              movie.bioskopinaTitleEN ?? 'Unknown Title',
              style: const TextStyle(color: Palette.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Director: ${movie.director ?? 'Unknown'}',
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[900], // dark gray background
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                movie.score?.toStringAsFixed(1) ?? 'N/A',
                style: const TextStyle(
                  color: Palette.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

