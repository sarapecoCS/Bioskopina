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
import '../widgets/circular_progress_indicator.dart';
import '../widgets/form_builder_datetime_picker.dart';
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

  Widget _buildImage() {
    return imageUrlValue.isNotEmpty
        ? Image.network(imageUrlValue, width: 150, height: 200, fit: BoxFit.cover)
        : Image.asset('assets/images/placeholder.png', width: 150, height: 200, fit: BoxFit.cover);
  }

  Future<void> _saveMovieData() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      var formData = _formKey.currentState!.value;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Saved successfully!")),
      );
      // TODO: Add saving logic here (e.g., API call)
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Validation failed.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      floatingButtonOnPressed: _saveMovieData,
      showFloatingActionButton: true,
      floatingActionButtonIcon: const Icon(Icons.save, size: 48, color: Palette.lightPurple),
      showBackArrow: true,
      titleWidget: Text(
        titleValue,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: FormBuilder(
          key: _formKey,
          initialValue: {
            'title': widget.movie?.titleEn ?? "",
            'description': widget.movie?.synopsis ?? "",
            'duration': widget.movie?.duration?.toString() ?? "",
            'imageUrl': widget.movie?.imageUrl ?? "",
            'trailerUrl': widget.movie?.trailerUrl ?? "",
            'rating': widget.movie?.score?.toString() ?? "0.0"


          },
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: _buildImage(),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      children: [
                        MyFormBuilderTextField(
                          name: "title",
                          labelText: "Title",
                          focusNode: _focusNodes[0],
                          onChanged: (val) {
                            setState(() {
                              titleValue = val ?? "";
                            });
                          },
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.maxLength(200),
                          ]),
                        ),

                        MyFormBuilderTextField(
                          name: "description",
                          labelText: "Description",
                          focusNode: _focusNodes[1],
                          validator: FormBuilderValidators.required(),
                        ),

                        MyFormBuilderTextField(
                          name: "imageUrl",
                          labelText: "Image URL",
                          focusNode: _focusNodes[3],
                          onChanged: (val) {
                            setState(() {
                              imageUrlValue = val ?? "";
                            });
                          },
                        ),

                      ],
                    ),

                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveMovieData,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Palette.lightPurple,
                ),
                child: const Text(
                  "Save Movie",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
