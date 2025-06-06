import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../providers/genre_provider.dart';
import '../providers/preferred_genre_provider.dart';
import '../models/genre.dart';
import '../models/preferred_genre.dart';
import '../models/search_result.dart';
import '../utils/colors.dart';
import '../utils/util.dart';
import 'circular_progress_indicator.dart';
import 'form_builder_filter_chip.dart';
import 'gradient_button.dart';

class PreferredGenresForm extends StatefulWidget {
  const PreferredGenresForm({super.key});

  @override
  State<PreferredGenresForm> createState() => _PreferredGenresFormState();
}

class _PreferredGenresFormState extends State<PreferredGenresForm> {
  final GlobalKey<FormBuilderState> _prefGenresFormKey =
      GlobalKey<FormBuilderState>();

  late final GenreProvider _genreProvider;
  late final Future<SearchResult<Genre>> _genreFuture;
  late final PreferredGenreProvider _preferredGenreProvider;
  late final Future<SearchResult<PreferredGenre>> _preferredGenreFuture;

  @override
  void initState() {
    _genreProvider = context.read<GenreProvider>();
    _preferredGenreProvider = context.read<PreferredGenreProvider>();

    _genreFuture = _genreProvider.get(filter: {"SortAlphabetically": true});
    _preferredGenreFuture = _preferredGenreProvider
        .get(filter: {"UserId": "${LoggedUser.user!.id}"});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(17),
      alignment: Alignment.center,
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Palette.darkPurple,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Palette.lightPurple.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Choose genres you like:",
                  style: TextStyle(fontSize: 17)),
              const SizedBox(height: 20),
              FutureBuilder<SearchResult<Genre>>(
                  future: _genreFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const MyProgressIndicator(); // Loading state
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}'); // Error state
                    } else {
                      // Data loaded successfully
                      var genres = snapshot.data!.result;
                      return FormBuilder(
                        key: _prefGenresFormKey,
                        child: FutureBuilder<SearchResult<PreferredGenre>>(
                            future: _preferredGenreFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const MyProgressIndicator(); // Loading state
                              } else if (snapshot.hasError) {
                                return Text(
                                    'Error: ${snapshot.error}'); // Error state
                              } else {
                                // Data loaded successfully
                                var preferredGenres = snapshot.data!.result;

                                return MyFormBuilderFilterChip(
                                    name: 'prefGenres',
                                    fontSize: 20,
                                    options: [
                                      ...genres.map(
                                        (genre) => FormBuilderChipOption(
                                          value: genre.id.toString(),
                                          child: Text(genre.name!,
                                              style: const TextStyle(
                                                  color:
                                                      Palette.midnightPurple)),
                                        ),
                                      ),
                                    ],
                                    initialValue: preferredGenres
                                        .where((preferredGenre) => genres.any(
                                            (genre) =>
                                                genre.id ==
                                                preferredGenre.genreId))
                                        .map((preferredGenre) =>
                                            preferredGenre.genreId.toString())
                                        .toList(),
                                    validator: (val) {
                                      if (val != null && val.length < 3) {
                                        return "Must choose at least 3 genres.";
                                      }
                                      return null;
                                    });
                              }
                            }),
                      );
                    }
                  }),
              const SizedBox(height: 30),
              GradientButton(
                  onPressed: () async {
                    try {
                      if (_prefGenresFormKey.currentState?.saveAndValidate() ==
                          true) {
                        var preferredGenres = (_prefGenresFormKey
                                    .currentState?.value['prefGenres'] as List?)
                                ?.whereType<String>()
                                .toList() ??
                            [];

                        List<PreferredGenre> prefGenresInsert = [];

                        if (preferredGenres.isNotEmpty) {
                          for (var genreId in preferredGenres) {
                            prefGenresInsert.add(
                              PreferredGenre(
                                  id: null,
                                  genreId: int.parse(genreId),
                                  userId: LoggedUser.user!.id),
                            );
                          }
                        }

                        await _preferredGenreProvider.updatePrefGenresForUser(
                            LoggedUser.user!.id!, prefGenresInsert);

                        if (context.mounted) {
                          Navigator.of(context).pop();

                          showInfoDialog(
                              context,
                              const Icon(Icons.task_alt,
                                  color: Palette.lightPurple, size: 50),
                              const Text(
                                "Saved successfully!",
                                textAlign: TextAlign.center,
                              ));
                        }
                      }
                    } on Exception catch (e) {
                      if (context.mounted) {
                        showErrorDialog(context, e);
                      }
                    }
                  },
                  width: 60,
                  height: 30,
                  borderRadius: 50,
                  gradient: Palette.buttonGradient,
                  child: const Text("Save",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Palette.white)))
            ],
          ),
        ),
      ),
    );
  }
}
