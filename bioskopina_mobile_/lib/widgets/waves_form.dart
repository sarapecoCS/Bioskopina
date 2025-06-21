import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/search_result.dart';
import '../providers/bioskopina_list_provider.dart';
import '../providers/list_provider.dart';
import '../utils/util.dart';
import '../widgets/gradient_button.dart';
import '../models/bioskopina.dart';
import '../models/bioskopina_list.dart';
import '../models/list.dart';
import '../utils/colors.dart';
import 'circular_progress_indicator.dart';
import 'form_builder_filter_chip.dart';

class WavesForm extends StatefulWidget {
  final Bioskopina bioskopina;
  const WavesForm({super.key, required this.bioskopina});

  @override
  State<WavesForm> createState() => _WavesFormState();
}

class _WavesFormState extends State<WavesForm> {
  late final ListtProvider _listtProvider;
  late Future<SearchResult<Listt>> _listtFuture;
  late final BioskopinaListProvider _bioskopinaListProvider;
  late Future<SearchResult<BioskopinaList>> _bioskopinaListFuture;
  final _constellationFormKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    _listtProvider = context.read<ListtProvider>();
    _listtFuture = _listtProvider.get(filter: {"UserId": "${LoggedUser.user!.id}"});

    _bioskopinaListProvider = context.read<BioskopinaListProvider>();
    _bioskopinaListFuture = _bioskopinaListProvider.get(filter: {"MovieId": "${widget.bioskopina.id}"});

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
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                        text: 'Add ',
                        style: TextStyle(color: Palette.lightPurple)),
                    TextSpan(
                      text: '${widget.bioskopina.titleEn}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Palette.rose),
                    ),
                    const TextSpan(
                        text: ' to selected Stars:',
                        style: TextStyle(color: Palette.lightPurple)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FutureBuilder<SearchResult<Listt>>(
                  future: _listtFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const MyProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      var stars = snapshot.data!.result;
                      return FormBuilder(
                        key: _constellationFormKey,
                        child: FutureBuilder<SearchResult<BioskopinaList>>(
                            future: _bioskopinaListFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const MyProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                var selectedStars = snapshot.data!.result;
                                return MyFormBuilderFilterChip(
                                  labelText: "Your Stars",
                                  name: 'stars',
                                  fontSize: 20,
                                  options: [
                                    ...stars.map(
                                      (star) => FormBuilderChipOption(
                                        value: star.id.toString(),
                                        child: Text(star.name!,
                                            style: const TextStyle(
                                                color: Palette.midnightPurple)),
                                      ),
                                    ),
                                  ],
                                  initialValue: selectedStars
                                      .where((bioskopinaList) => stars.any(
                                          (listItem) =>
                                              listItem.id == bioskopinaList.listId))
                                      .map((bioskopinaList) =>
                                          bioskopinaList.listId.toString())
                                      .toList(),
                                );
                              }
                            }),
                      );
                    }
                  }),
              const SizedBox(height: 30),
              GradientButton(
                  onPressed: () async {
                    try {
                      _constellationFormKey.currentState?.saveAndValidate();

                      var selectedStars = (_constellationFormKey
                                  .currentState?.value['stars'] as List?)
                              ?.whereType<String>()
                              .toList() ?? [];

                      List<BioskopinaList> bioskopinaListInsert = [];

                      if (selectedStars.isNotEmpty) {
                        for (var listId in selectedStars) {
                          bioskopinaListInsert.add(BioskopinaList(
                              null, int.parse(listId), widget.bioskopina.id, null));
                        }
                      }

                      await _bioskopinaListProvider.updateMovieLists(
                          widget.bioskopina.id!, bioskopinaListInsert);

                      if (context.mounted) {
                        showInfoDialog(
                            context,
                            const Icon(Icons.task_alt,
                                color: Palette.lightPurple, size: 50),
                            const Text(
                              "Saved successfully!",
                              textAlign: TextAlign.center,
                            ));
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