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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        selectedIndex: widget.selectedIndex,
        showNavBar: true,
        showHelpIcon: true,
        title: "Wave",
        showFloatingActionButton: true,
        floatingButtonOnPressed: () {
          _showStarForm();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text("Group movie in individual Stars",
                        style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 5),
                    Icon(Icons.auto_awesome, size: 24),
                  ],
                ),
              ),
              WaveCards(
                selectedIndex: widget.selectedIndex,
              ),
            ],
          ),
        ));
  }

  _showStarForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const StarForm();
      },
    );
  }
}