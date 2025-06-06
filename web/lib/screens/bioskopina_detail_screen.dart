import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../providers/genre_bioskopina_provider.dart';
import '../providers/bioskopina_provider.dart';
import '../providers/genre_provider.dart';
import '../models/bioskopina.dart';
import '../models/genre.dart';
import '../models/search_result.dart';
import '../utils/colors.dart';
import '../widgets/form_builder_text_field.dart';
import '../widgets/master_screen.dart';

class BioskopinaDetailScreen extends StatefulWidget {
  final Bioskopina? movie;

  const BioskopinaDetailScreen({super.key, this.movie});

  @override
  State<BioskopinaDetailScreen> createState() => _BioskopinaDetailScreenState();
}

class _BioskopinaDetailScreenState extends State<BioskopinaDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late MovieProvider _bioskopinaProvider;
  late GenreProvider _genreProvider;
  late GenreMovieProvider _genrebioskopinaProvider;
  late Future<SearchResult<Genre>> _genreFuture;

  late String imageUrlValue;
  late String titleValue;

  final List<FocusNode> _focusNodes = List.generate(10, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    imageUrlValue = widget.movie?.imageUrl ?? "";
    titleValue = widget.movie?.titleEn ?? "";

    _bioskopinaProvider = context.read<MovieProvider>();
    _genreProvider = context.read<GenreProvider>();
    _genrebioskopinaProvider = context.read<GenreMovieProvider>();
    _genreFuture = _genreProvider.get(filter: {"SortAlphabetically": "true"});
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _showElegantSnackbar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green[600],
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _saveMovieData() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      var formData = _formKey.currentState!.value;
      _showElegantSnackbar("Saved successfully!");
      // TODO: Add save logic
    } else {
      _showElegantSnackbar("Validation failed.");
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
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 4)),
              ],
            ),
            child: imageUrlValue.isNotEmpty
                ? Image.network(imageUrlValue, fit: BoxFit.cover)
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

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      floatingButtonOnPressed: _saveMovieData,
      showFloatingActionButton: true,
      floatingActionButtonIcon: const Icon(Icons.save, size: 48, color: Palette.lightPurple),
      showBackArrow: true,
      titleWidget: const Text(""),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: FormBuilder(
          key: _formKey,
          initialValue: {
            'title': widget.movie?.titleEn ?? "",
            'description': widget.movie?.synopsis ?? "",
            'duration': widget.movie?.duration?.toString() ?? "",
            'imageUrl': widget.movie?.imageUrl ?? "",
            'trailerUrl': widget.movie?.trailerUrl ?? "",
            'rating': widget.movie?.score?.toString() ?? "0.0",
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageWithTitle(),
              const SizedBox(height: 24),
              MyFormBuilderTextField(
                name: "title",
                labelText: "Title",
                focusNode: _focusNodes[0],
                onChanged: (val) => setState(() => titleValue = val ?? ""),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.maxLength(200),
                ]),
              ),
              const SizedBox(height: 16),
              MyFormBuilderTextField(
                name: "description",
                labelText: "Description",
                focusNode: _focusNodes[1],
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),
              MyFormBuilderTextField(
                name: "imageUrl",
                labelText: "Image URL",
                focusNode: _focusNodes[2],
                onChanged: (val) => setState(() => imageUrlValue = val ?? ""),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _saveMovieData,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text("Save Movie"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.lightPurple,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

