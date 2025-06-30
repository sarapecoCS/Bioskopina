import 'package:flutter/material.dart';
import '../models/bioskopina.dart';
import '../screens/bioskopina_detail_screen.dart';
import 'waves_form.dart';
import 'cinema_form.dart';

class BioskopinaCard extends StatefulWidget {
  final Bioskopina bioskopina;
  final int selectedIndex;

  const BioskopinaCard({
    Key? key,
    required this.bioskopina,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  State<BioskopinaCard> createState() => _BioskopinaCardState();
}

class _BioskopinaCardState extends State<BioskopinaCard>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late int _watchlistId;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );

    _scaleAnimation = _controller.drive(Tween(begin: 1.0, end: 0.95));
    _watchlistId = 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.reverse();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.forward();
  }

  void _onTapCancel() {
    _controller.forward();
  }

  void _showWavesForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WavesForm(
          bioskopina: widget.bioskopina,
        );
      },
    );
  }

  void _showCinemaForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CinemaForm(
          bioskopina: widget.bioskopina,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.44;
    double cardHeight = MediaQuery.of(context).size.height * 0.3;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color.fromRGBO(120, 170, 220, 0.5),
            width: 1.2,
          ),
          color: const Color.fromRGBO(20, 20, 20, 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.9),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: (details) {
                _onTapUp(details);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BioskopinaDetailScreen(
                    bioskopina: widget.bioskopina,
                    selectedIndex: widget.selectedIndex,
                  ),
                ));
              },
              onTapCancel: _onTapCancel,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    widget.bioskopina.imageUrl != null
                        ? Image.network(
                            widget.bioskopina.imageUrl!,
                            width: cardWidth,
                            height: cardHeight,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: cardWidth,
                            height: cardHeight,
                            color: Colors.black12,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 40,
                            ),
                          ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: cardHeight * 0.6,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Color.fromARGB(180, 0, 0, 0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          widget.bioskopina.titleEn ?? "No Title",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            shadows: [
                              Shadow(
                                blurRadius: 8,
                                color: Colors.black87,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => _showCinemaForm(context),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.star_rate_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showWavesForm(context),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.playlist_add_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}