import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../models/bioskopina.dart';
import '../models/genre_bioskopina.dart';
import '../models/genre.dart';

import '../providers/bioskopina_provider.dart';
import '../providers/genre_provider.dart';
import '../providers/genre_bioskopina_provider.dart';
import '../utils/colors.dart';
import '../widgets/master_screen.dart';
import '../widgets/form_builder_text_field.dart';

class BioskopinaDetailScreen extends StatefulWidget {
  final Bioskopina? movie;

  const BioskopinaDetailScreen({Key? key, this.movie}) : super(key: key);

  @override
  _BioskopinaDetailScreenState createState() => _BioskopinaDetailScreenState();
}

class _BioskopinaDetailScreenState extends State<BioskopinaDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  late MovieProvider _bioskopinaProvider;
  late GenreProvider _genreProvider;

  String imageUrlValue = "";
  String titleValue = "";
  List<Genre> _allGenres = [];
  List<Genre> _selectedGenres = [];

  bool _loadingGenres = true; // Show loader until genres are loaded

  @override
  void initState() {
    super.initState();

    _bioskopinaProvider = context.read<MovieProvider>();
    _genreProvider = context.read<GenreProvider>();

    imageUrlValue = widget.movie?.imageUrl ?? "";
    titleValue = widget.movie?.titleEn ?? "";

    _loadGenres();
  }

  Future<void> _loadGenres() async {
    try {
      _allGenres = await _genreProvider.fetchAllGenres();

      if (widget.movie != null) {
        _selectedGenres = widget.movie!.genreMovies
            .map((gb) => gb.genre)
            .whereType<Genre>() // filter out null genres
            .toList();
      }
    } catch (e) {
      print("Error loading genres: $e");
    } finally {
      if (mounted) {
        setState(() {
          _loadingGenres = false;
        });
      }
    }
  }

  void _showSnackbar(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: error ? Colors.black : Colors.green[600],  // Black background for success
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _saveMovieData() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;

      if (_selectedGenres.isEmpty) {
        _showSnackbar("Please select at least one genre.", error: true);
        return;
      }

      // Map selected genres to GenreBioskopina objects
      List<GenreBioskopina> genreBioskopinaList = _selectedGenres.map((genre) {
        return GenreBioskopina(
          null,
          genre.id,
          widget.movie?.id ?? 0,
          null,
          genre,
        );
      }).toList();

      final newMovie = Bioskopina(
        id: widget.movie?.id ?? 0,
        titleEn: formData['title'] ?? "",

        synopsis: formData['description'] ?? "",
        director: formData['director'] ?? "",
        score: double.tryParse(formData['score'] ?? "0") ?? 0,
        genreMovies: genreBioskopinaList,
        runtime: int.tryParse(formData['duration'] ?? "0") ?? 0,
        yearRelease: int.tryParse(formData['yearRelease'] ?? "0") ?? 0,

        imageUrl: formData['imageUrl'] ?? "",
        trailerUrl: formData['trailerUrl'] ?? "",
      );

      try {
        if (newMovie.id == 0) {
          await _bioskopinaProvider.addMovie(newMovie);
        } else {
          await _bioskopinaProvider.updateMovie(newMovie);
        }
        _showSnackbar(widget.movie == null ? "Movie added successfully!" : "Movie edited successfully!");
        Navigator.of(context).pop();
      } catch (e) {
        _showSnackbar("Failed to save: $e", error: true);
      }
    } else {
      _showSnackbar("Validation failed.", error: true);
    }
  }

  Widget _buildImageWithTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 100,
            height: 140,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 4))
              ],
            ),
            child: imageUrlValue.isNotEmpty
                ? Image.network(imageUrlValue, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/images/placeholder.png', fit: BoxFit.cover);
                  })
                : Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            titleValue,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildGenreSelector() {
    if (_loadingGenres) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_allGenres.isEmpty) {
      return const Text("No genres available");
    }

    return Wrap(
      spacing: 8,
      children: _allGenres.map((genre) {
        final isSelected = _selectedGenres.any((g) => g.id == genre.id);
        return FilterChip(
          label: Text(genre.name ?? 'Unknown'),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedGenres.add(genre);
              } else {
                _selectedGenres.removeWhere((g) => g.id == genre.id);
              }
            });
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      showBackArrow: true,
      titleWidget: const Text("Edit Bioskopina"),
      floatingButtonOnPressed: _saveMovieData,
      showFloatingActionButton: true,
      floatingActionButtonIcon: const Icon(Icons.save, size: 32, color: Palette.lightPurple),
      child: Scrollbar(
        thumbVisibility: true, // Always show the scrollbar
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageWithTitle(),
              const SizedBox(height: 24),
              FormBuilder(
                key: _formKey,
                initialValue: {
                  'title': widget.movie?.titleEn ?? "",
                  'description': widget.movie?.synopsis ?? "",
                  'director': widget.movie?.director ?? "",
                  'duration': widget.movie?.runtime.toString() ?? "",
                  'yearRelease': widget.movie?.yearRelease.toString() ?? "",

                  'score': widget.movie?.score.toString() ?? "0",
                  'imageUrl': widget.movie?.imageUrl ?? "",
                  'trailerUrl': widget.movie?.trailerUrl ?? "",
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyFormBuilderTextField(
                      name: 'title',
                      labelText: 'Title',
                      onChanged: (val) => setState(() => titleValue = val ?? ""),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.maxLength(200),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    MyFormBuilderTextField(
                      name: 'description',
                      labelText: 'Description',
                      maxLines: 4,
                      validator: FormBuilderValidators.required(),
                    ),
                    const SizedBox(height: 16),
                    MyFormBuilderTextField(
                      name: 'director',
                      labelText: 'Director',
                      validator: FormBuilderValidators.required(),
                    ),
                    const SizedBox(height: 16),
                    MyFormBuilderTextField(
                      name: 'duration',
                      labelText: 'Duration (min)',
                      keyboardType: TextInputType.number,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.integer(),
                        FormBuilderValidators.min(1),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    MyFormBuilderTextField(
                      name: 'yearRelease',
                      labelText: 'Year of Release',
                      keyboardType: TextInputType.number,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.integer(),
                        FormBuilderValidators.min(1900),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    _buildGenreSelector(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

