import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../models/bioskopina.dart';
import '../models/genre_bioskopina.dart';
import '../models/genre.dart';

import '../providers/bioskopina_provider.dart';
import '../providers/genre_bioskopina_provider.dart';
import '../providers/genre_provider.dart';
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
  late GenreMovieProvider _genreBioskopinaProvider;
  late GenreProvider _genreProviderAll;

  List<Genre> _allGenres = [];
  List<Genre> _selectedGenres = [];
  bool _loadingGenres = true;

  String imageUrlValue = "";
  String titleValue = "";

  bool get isEditing => widget.movie != null;

  @override
  void initState() {
    super.initState();

    _bioskopinaProvider = context.read<MovieProvider>();
    _genreBioskopinaProvider = context.read<GenreMovieProvider>();
    _genreProviderAll = context.read<GenreProvider>();

    imageUrlValue = widget.movie?.imageUrl ?? "";
    titleValue = widget.movie?.titleEn ?? "";

    _loadGenres();
  }

  Future<void> _loadGenres() async {
    try {
      _allGenres = await _genreProviderAll.fetchAll();

      if (widget.movie != null) {
        _selectedGenres = widget.movie!.genreMovies
            .map((gb) => gb.genre)
            .whereType<Genre>()
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
      backgroundColor: error ? Colors.red : Colors.green[600],
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

Future<void> _showSuccessDialog(String message) async {
  await showDialog(
    context: context,
    barrierDismissible: true, // user can tap outside to close
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.task_alt_rounded, color: Color.fromRGBO(102, 204, 204, 1), size: 64),
              const SizedBox(height: 16),
              Text(
                message, // display the passed message
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}


  Future<void> _saveMovieData() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;

      if (!isEditing && _selectedGenres.isEmpty) {
        _showSnackbar("Please select at least one genre.", error: true);
        return;
      }

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
        titleEn: formData['titleEn'] ?? "",
        synopsis: formData['synopsis'] ?? "",
        director: formData['director'] ?? "",
        score: double.tryParse(formData['score'] ?? "0") ?? 0,
        genreMovies: genreBioskopinaList,
        runtime: int.tryParse(formData['runtime'] ?? "0") ?? 0,
        yearRelease: int.tryParse(formData['yearRelease'] ?? "0") ?? 0,
        imageUrl: formData['imageUrl'] ?? "",
        trailerUrl: formData['trailerUrl'] ?? "",
      );

      try {
        if (newMovie.id == 0) {
          await _bioskopinaProvider.addMovie(newMovie);
          await _showSuccessDialog("Movie added successfully!");
        } else {
          await _bioskopinaProvider.updateMovie(newMovie);
          await _showSuccessDialog("Movie edited successfully!");
        }
        Navigator.of(context).pop(true);
      } catch (e) {
        _showSnackbar("Failed to save: $e", error: true);
      }
    } else {
      _showSnackbar("Validation failed.", error: true);
    }
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
          selectedColor:  Color.fromRGBO(102, 204, 204, 1),
          checkmarkColor: Colors.white,
          backgroundColor: Colors.grey.shade300,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                if (!_selectedGenres.any((g) => g.id == genre.id)) {
                  _selectedGenres.add(genre);
                }
              } else {
                _selectedGenres.removeWhere((g) => g.id == genre.id);
              }
            });
          },
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      showBackArrow: true,
      titleWidget: Text(isEditing ? "Edit Bioskopina" : "Add Bioskopina"),
      floatingButtonOnPressed: _saveMovieData,
      showFloatingActionButton: true,
      floatingActionButtonIcon: const Icon(
        Icons.save,
        size: 32,
        color: Palette.lightPurple,
      ),
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPoster(),
                    const SizedBox(height: 24),
                    _buildForm(context),
                  ],
                );
              } else {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 220,
                        minWidth: 150,
                      ),
                      child: _buildPoster(),
                    ),
                    const SizedBox(width: 24),
                    Expanded(child: _buildForm(context)),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPoster() {
    return Container(
      height: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(4, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: imageUrlValue.isNotEmpty
            ? Image.network(
                imageUrlValue,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/placeholder.png', fit: BoxFit.cover);
                },
              )
            : Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      initialValue: {
        'titleEn': widget.movie?.titleEn ?? "",
        'synopsis': widget.movie?.synopsis ?? "",
        'director': widget.movie?.director ?? "",
        'runtime': widget.movie?.runtime.toString() ?? "",
        'yearRelease': widget.movie?.yearRelease.toString() ?? "",
        'score': widget.movie?.score.toString() ?? "0",
        'imageUrl': widget.movie?.imageUrl ?? "",
        'trailerUrl': widget.movie?.trailerUrl ?? "",
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleValue,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          MyFormBuilderTextField(
            name: 'titleEn',
            labelText: 'Title',
            onChanged: (val) => setState(() => titleValue = val ?? ""),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.maxLength(200),
            ]),
          ),
          const SizedBox(height: 16),
          MyFormBuilderTextField(
            name: 'synopsis',
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
          Row(
            children: [
              Expanded(
                child: MyFormBuilderTextField(
                  name: 'runtime',
                  labelText: 'Duration (minutes)',
                  keyboardType: TextInputType.number,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.numeric(),
                    FormBuilderValidators.min(1),
                  ]),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: MyFormBuilderTextField(
                  name: 'yearRelease',
                  labelText: 'Year',
                  keyboardType: TextInputType.number,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.numeric(),
                    FormBuilderValidators.min(1900),
                    FormBuilderValidators.max(DateTime.now().year),
                  ]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          MyFormBuilderTextField(
            name: 'score',
            labelText: 'This value is system-generated and cannot be modified',
            enabled: false,
            keyboardType: TextInputType.number,
             disabledStyle: TextStyle(color: Colors.grey.shade600),

          ),
          const SizedBox(height: 16),
          MyFormBuilderTextField(
            name: 'imageUrl',
            labelText: 'Image URL',
            keyboardType: TextInputType.url,
            onChanged: (val) => setState(() => imageUrlValue = val ?? ""),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.url(),
            ]),
          ),
          const SizedBox(height: 16),
          MyFormBuilderTextField(
            name: 'trailerUrl',
            labelText: 'Trailer URL',
            keyboardType: TextInputType.url,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.url(),
            ]),
          ),
          const SizedBox(height: 16),
          if (!isEditing) ...[
            const Text(
              "Genres",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildGenreSelector(),
            if (_selectedGenres.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Please select at least one genre.",
                  style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                ),
              ),
          ],
        ],
      ),
    );
  }
}