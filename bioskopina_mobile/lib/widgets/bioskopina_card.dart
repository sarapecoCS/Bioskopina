import 'package:flutter/material.dart';
import '../models/bioskopina.dart';
import '../screens/bioskopina_detail_screen.dart';

class BioskopinaCard extends StatelessWidget {
  final Bioskopina bioskopina;
  final int selectedIndex;

  const BioskopinaCard({
    Key? key,
    required this.bioskopina,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.44;
    double cardHeight = MediaQuery.of(context).size.height * 0.3;

    return Container(
      width: cardWidth,
      height: cardHeight,
      margin: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.purple.withOpacity(0.3)),
        color: Colors.deepPurple.shade900,
      ),
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BioskopinaDetailScreen(bioskopina: bioskopina,selectedIndex: selectedIndex),
                ));
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: bioskopina.imageUrl != null
                    ? Image.network(
                  bioskopina.imageUrl!,
                  width: cardWidth,
                  height: cardHeight * 0.85,
                  fit: BoxFit.cover,
                )
                    : Container(
                  width: cardWidth,
                  height: cardHeight * 0.85,
                  color: Colors.black12,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              bioskopina.titleEn ?? "Without title",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
