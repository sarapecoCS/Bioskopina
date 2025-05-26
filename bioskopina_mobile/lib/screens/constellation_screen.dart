import 'package:flutter/material.dart';


import '../widgets/constellation_cards.dart';
import '../widgets/master_screen.dart';
import '../widgets/star_form.dart';

class ConstellationScreen extends StatefulWidget {
  final int selectedIndex;
  const ConstellationScreen({super.key, required this.selectedIndex});

  @override
  State<ConstellationScreen> createState() => _ConstellationScreenState();
}

class _ConstellationScreenState extends State<ConstellationScreen> {
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
        title: "Constellation",
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
                    const Text("Group Anime in individual Stars",
                        style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 5),
                    Icon(Icons.auto_awesome, size: 24),
                  ],
                ),
              ),
              ConstellationCards(
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
