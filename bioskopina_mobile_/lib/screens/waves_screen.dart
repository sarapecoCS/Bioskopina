import 'package:flutter/material.dart';
import '../widgets/wave_cards.dart';
import '../widgets/master_screen.dart';
import '../widgets/star_form.dart';

class WaveScreen extends StatefulWidget {
  final int selectedIndex;
  const WaveScreen({super.key, required this.selectedIndex});

  @override
  State<WaveScreen> createState() => _WaveScreenState();
}

class _WaveScreenState extends State<WaveScreen> {
  // Error handling state
  String? _lastError;
  bool _showErrorScreen = false;

  @override
  void initState() {
    super.initState();
    // Set up global error handling
    FlutterError.onError = (details) {
      debugPrint("FLUTTER ERROR: ${details.exception}\n${details.stack}");
      _showError(details.exception.toString());
    };
  }

  void _showError(String message) {
    if (!mounted) return;
    setState(() {
      _lastError = message;
      _showErrorScreen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showErrorScreen) {
      return _buildErrorScreen();
    }

    try {
      return MasterScreenWidget(
        selectedIndex: widget.selectedIndex,
        showNavBar: true,
        showHelpIcon: true,
        title: "Wave",
        showFloatingActionButton: true,
        floatingButtonOnPressed: _safeShowStarForm,
        child: _buildContent(),
      );
    } catch (e, stack) {
      debugPrint("MAIN BUILD ERROR: $e\n$stack");
      return _buildErrorScreen();
    }
  }

  Widget _buildContent() {
    try {
      return SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Group movie in individual Stars",
                      style: TextStyle(fontSize: 16)),
                  SizedBox(width: 5),
                  Icon(Icons.auto_awesome, size: 24),
                ],
              ),
            ),
            _buildSafeWaveCards(),
          ],
        ),
      );
    } catch (e, stack) {
      debugPrint("CONTENT ERROR: $e\n$stack");
      return _buildErrorWidget("Failed to load content");
    }
  }

  Widget _buildSafeWaveCards() {
    try {
      return WaveCards(selectedIndex: widget.selectedIndex);
    } catch (e, stack) {
      debugPrint("WAVECARDS ERROR: $e\n$stack");
      return _buildErrorWidget("Couldn't load movie cards");
    }
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 64),
            const SizedBox(height: 20),
            Text(
              _lastError ?? "Something went wrong",
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => setState(() {
                _showErrorScreen = false;
                _lastError = null;
              }),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.warning_amber, color: Colors.orange, size: 48),
          const SizedBox(height: 16),
          Text(message),
        ],
      ),
    );
  }

  Future<void> _safeShowStarForm() async {
    try {
      await showDialog(
        context: context,
        builder: (context) {
          try {
            return const StarForm();
          } catch (e, stack) {
            debugPrint("STARFORM BUILDER ERROR: $e\n$stack");
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to load form: ${e.toString()}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          }
        },
      );
    } catch (e, stack) {
      debugPrint("DIALOG ERROR: $e\n$stack");
      if (!mounted) return;
      _showError(e.toString());
    }
  }
}