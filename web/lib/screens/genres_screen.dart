import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/genre.dart';
import '../models/search_result.dart';
import '../providers/genre_provider.dart';
import '../utils/util.dart';
import '../widgets/circular_progress_indicator.dart';
import '../widgets/form_builder_text_field.dart';
import '../widgets/gradient_button.dart';
import '../widgets/master_screen.dart';
import '../utils/colors.dart';
import 'dart:convert';
import 'dart:typed_data';

Uint8List imageFromBase64String(String base64String) {
  return base64Decode(base64String);
}

class GenresScreen extends StatefulWidget {
  const GenresScreen({super.key});

  @override
  State<GenresScreen> createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  final _genreFormKey = GlobalKey<FormBuilderState>();
  late GenreProvider _genreProvider;
  late Future<SearchResult<Genre>> _genreFuture;
  final FocusNode _focusNode = FocusNode();
  int? genreId;

  @override
  void initState() {
    _genreProvider = context.read<GenreProvider>();
    _genreFuture = _genreProvider.get(filter: {"SortAlphabetically": "true"});

    context.read<GenreProvider>().addListener(() {
      _reloadGenresList();
    });

    super.initState();
  }

  void _reloadGenresList() {
    if (mounted) {
      setState(() {
        _genreFuture =
            _genreProvider.get(filter: {"SortAlphabetically": "true"});
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: const Text("Genres"),
      showBackArrow: true,
      child: Stack(
        children: [
          _buildGenresForm(context),
        ],
      ),
    );
  }

  Widget _buildGenresForm(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Palette.lightPurple.withOpacity(0.2)),
              color: Palette.darkPurple,
            ),
            padding: const EdgeInsets.all(16.0),
            width: 500.0,
            height: 550.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                FormBuilder(
                  key: _genreFormKey,
                  child: FutureBuilder<SearchResult<Genre>>(
                    future: _genreFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const MyProgressIndicator(); // Loading state
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}'); // Error state
                      } else {
                        var genreList = snapshot.data!.result;

                        return Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (genreId != null)
                                        ? IconButton(
                                            onPressed: () {
                                              if (mounted) {
                                                setState(() {
                                                  genreId = null;
                                                  _genreFormKey.currentState
                                                      ?.fields["name"]
                                                      ?.didChange("");
                                                });
                                              }
                                            },
                                            icon:
                                                const Icon(Icons.clear_rounded))
                                        : Container(),
                                    MyFormBuilderTextField(
                                        name: "name",
                                        labelText: "Genre name",
                                        fillColor: Palette.textFieldPurple
                                            .withOpacity(0.3),
                                        width: 300,
                                        height: 50,
                                        borderRadius: 50,
                                        focusNode: _focusNode,
                                        validator: (val) {
                                          if (val == null ||
                                              val == "" ||
                                              val.isEmpty ||
                                              val.trim().isEmpty) {
                                            return "This field cannot be empty";
                                          } else if (val.length > 25) {
                                            return "Genre can contain 25 characters max.";
                                          }
                                          return null;
                                        }),
                                    const SizedBox(width: 5),
                                    GradientButton(
                                        onPressed: () {
                                          (genreId == null)
                                              ? _addGenre(context)
                                              : _saveGenre(context);
                                        },
                                        width: 80,
                                        height: 30,
                                        borderRadius: 50,
                                        gradient: Palette.buttonGradient,
                                        child: (genreId == null)
                                            ? const Text("Add",
                                                style: TextStyle(
                                                    color: Palette.white,
                                                    fontWeight:
                                                        FontWeight.w500))
                                            : const Text("Save",
                                                style: TextStyle(
                                                    color: Palette.white,
                                                    fontWeight:
                                                        FontWeight.w500))),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Wrap(
                                      children: _buildGenres(genreList),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGenres(List<Genre> genreList) {
    return List.generate(
      genreList.length,
      (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              //width: 100,
              height: 35,
              padding: const EdgeInsets.all(5.4),
              decoration: BoxDecoration(
                  color: Palette.textFieldPurple.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(50)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${genreList[index].name}",
                      style: const TextStyle(fontSize: 15)),
                  _buildPopupMenu(genreList[index]),
                ],
              )),
        );
      },
    );
  }

  Future<void> _addGenre(BuildContext context) async {
    try {
      if (_genreFormKey.currentState?.saveAndValidate() == true) {
        var request = Map.from(_genreFormKey.currentState!.value);
        await _genreProvider.insert(request);

        if (context.mounted) {
          showInfoDialog(
              context,
              const Icon(Icons.task_alt, color: Palette.lightPurple, size: 50),
              const Text(
                "Added successfully!",
                textAlign: TextAlign.center,
              ));
        }
      }
    } on Exception catch (e) {
      if (context.mounted) {
        showErrorDialog(context, e);
      }
    }
  }

  Future<void> _saveGenre(BuildContext context) async {
    try {
      if (_genreFormKey.currentState?.saveAndValidate() == true) {
        var request = Map.from(_genreFormKey.currentState!.value);
        await _genreProvider.update(genreId!, request: request);

        if (context.mounted) {
          showInfoDialog(
              context,
              const Icon(Icons.task_alt, color: Palette.lightPurple, size: 50),
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
  }

  Widget _buildPopupMenu(Genre genre) {
    return PopupMenuButton<String>(
      tooltip: "Actions",
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Palette.lightPurple.withOpacity(0.3)),
      ),
      icon: const Icon(Icons.more_vert_rounded),
      splashRadius: 1,
      padding: EdgeInsets.zero,
      color: const Color.fromRGBO(50, 48, 90, 1),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            hoverColor: Palette.lightPurple.withOpacity(0.1),
            leading: Icon(
              Icons.edit,
              size: 24,
              color: Colors.yellow,
            ),

            title: const Text('Edit',
                style: TextStyle(color: Palette.lightPurple)),
            onTap: () {
              if (mounted) {
                setState(() {
                  genreId = genre.id;
                  _genreFormKey.currentState?.fields["name"]
                      ?.didChange(genre.name);
                });
              }
            },
          ),
        ),
        PopupMenuItem<String>(
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            hoverColor: Palette.lightRed.withOpacity(0.1),
            leading: Icon(
              Icons.delete, // Built-in Flutter trash icon
              size: 24,
              color: Colors.red,
            ),
            title:
                const Text('Delete', style: TextStyle(color: Palette.lightRed)),
            onTap: () {
              Navigator.pop(context);
              showConfirmationDialog(
                  context,
                  const Icon(Icons.warning_rounded,
                      color: Palette.lightRed, size: 55),
                  const SizedBox(
                    width: 300,
                    child: Text(
                      "Are you sure you want to delete this genre?",
                      textAlign: TextAlign.center,
                    ),
                  ), () async {
                _genreProvider.delete(genre.id!);
              });
            },
          ),
        ),
      ],
    );
  }
}
