import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/bioskopina_watchlist.dart';
import '../providers/bioskopina_watchlist_provider.dart';
import '../providers/rating_provider.dart';
import '../providers/watchlist_provider.dart';
import '../utils/util.dart';
import '../widgets/form_builder_datetime_picker.dart';
import '../widgets/form_builder_text_field.dart';
import '../widgets/numeric_step_button.dart';
import '../widgets/separator.dart';
import '../models/bioskopina.dart';
import '../models/rating.dart';
import '../models/watchlist.dart';
import '../utils/colors.dart';
import 'circular_progress_indicator.dart';
import 'form_builder_choice_chip.dart';
import 'gradient_button.dart';

class CinemaForm extends StatefulWidget {
  final Bioskopina bioskopina;
  final int? watchlistId;
  final BioskopinaWatchlist? bioskopinaWatchlist;

  CinemaForm({
    super.key,
    required this.bioskopina,
    this.watchlistId,
    this.bioskopinaWatchlist,
  });

  @override
  State<CinemaForm> createState() => _CinemaFormState();
}

class _CinemaFormState extends State<CinemaForm> {
  final _cinemaFormKey = GlobalKey<FormBuilderState>();
  late final BioskopinaWatchlistProvider _bioskopinaWatchlistProvider;
  late final RatingProvider _ratingProvider;
  late final WatchlistProvider _watchlistProvider;
  late Future<Map<String, dynamic>> _initialValueFuture;

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _bioskopinaWatchlistProvider = context.read<BioskopinaWatchlistProvider>();
    _ratingProvider = context.read<RatingProvider>();
    _watchlistProvider = context.read<WatchlistProvider>();

    _initialValueFuture = setInitialValue();
    super.initState();
  }

  Future<Map<String, dynamic>> setInitialValue() async {
    var rating = await _ratingProvider.get(filter: {
      "UserId": "${LoggedUser.user!.id}",
      "BioskopinaId": "${widget.bioskopina.id}"
    });

    return {
      "ratingValue":
          (rating.result.isNotEmpty) ? rating.result.first.ratingValue : null,
      "reviewText":
          (rating.result.isNotEmpty) ? rating.result.first.reviewText : "",
    };
  }

  @override
  Widget build(BuildContext context) {
    return _buildRatingForm(context);
  }

  Dialog _buildRatingForm(BuildContext context) {
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
        child: FormBuilder(
          key: _cinemaFormKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "${widget.bioskopina.titleEn}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Palette.stardust),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Text(
                      "Rate this movie",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                MyFormBuilderChoiceChip(
                  focusNode: _focusNode1,
                  name: "ratingValue",
                  selectedColor: Palette.lightYellow,
                  options: const [
                    FormBuilderChipOption(
                        value: 10,
                        child: Text("10",
                            style: TextStyle(color: Palette.darkPurple))),
                    FormBuilderChipOption(
                        value: 9,
                        child: Text("9",
                            style: TextStyle(color: Palette.darkPurple))),
                    FormBuilderChipOption(
                        value: 8,
                        child: Text("8",
                            style: TextStyle(color: Palette.darkPurple))),
                    FormBuilderChipOption(
                        value: 7,
                        child: Text("7",
                            style: TextStyle(color: Palette.darkPurple))),
                    FormBuilderChipOption(
                        value: 6,
                        child: Text("6",
                            style: TextStyle(color: Palette.darkPurple))),
                    FormBuilderChipOption(
                        value: 5,
                        child: Text("5",
                            style: TextStyle(color: Palette.darkPurple))),
                    FormBuilderChipOption(
                        value: 4,
                        child: Text("4",
                            style: TextStyle(color: Palette.darkPurple))),
                    FormBuilderChipOption(
                        value: 3,
                        child: Text("3",
                            style: TextStyle(color: Palette.darkPurple))),
                    FormBuilderChipOption(
                        value: 2,
                        child: Text("2",
                            style: TextStyle(color: Palette.darkPurple))),
                    FormBuilderChipOption(
                        value: 1,
                        child: Text("1",
                            style: TextStyle(color: Palette.darkPurple))),
                  ],
                  onChanged: (val) {
                    _cinemaFormKey.currentState?.saveAndValidate();
                  },
                ),
                const SizedBox(height: 10),
                MyFormBuilderTextField(
                  focusNode: _focusNode2,
                  name: "reviewText",
                  labelText: "Review (optional)",
                  fillColor: Palette.textFieldPurple.withOpacity(0.5),
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.center,
                  paddingBottom: 10,
                  keyboardType: TextInputType.multiline,
                  borderRadius: 20,
                  errorBorderRadius: 20,
                  contentPadding:
                      const EdgeInsets.only(left: 10, right: 10, top: 25),
                  errorHeight: 1,
                  validator: (val) {
                    if (val != null && val.isNotEmpty && !isValidReviewText(val)) {
                      return "Some special characters are not allowed.";
                    } else if (LoggedUser.user!.userRoles!.any(
                      (element) =>
                          element.roleId == 2 &&
                          element.canReview == false &&
                          val != null &&
                          val.isNotEmpty,
                    )) {
                      return "Not permitted to leave review.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                GradientButton(
                  onPressed: () async {
                    _cinemaFormKey.currentState?.saveAndValidate();

                    if (_cinemaFormKey.currentState?.saveAndValidate() == true) {
                      try {
                        dynamic ratingValue = _cinemaFormKey
                            .currentState!.fields["ratingValue"]?.value;

                        if (ratingValue != null) {
                          var existingRating = await _ratingProvider.get(filter: {
                            "UserId": "${LoggedUser.user!.id}",
                            "BioskopinaId": "${widget.bioskopina.id}"
                          });

                          if (existingRating.count == 0) {
                            // Insert new rating
                            Rating rating = Rating(
                              null,
                              LoggedUser.user!.id,
                              widget.bioskopina.id,
                              ratingValue,
                              _cinemaFormKey.currentState!.fields["reviewText"]?.value ?? "",
                              DateTime.now(),
                              null,
                              null
                            );
                            await _ratingProvider.insert(rating);
                          } else {
                            // Update existing rating
                            var ratingToUpdate = existingRating.result[0];
                            ratingToUpdate.ratingValue = ratingValue;
                            ratingToUpdate.reviewText =
                                _cinemaFormKey.currentState!.fields["reviewText"]?.value ?? "";

                            await _ratingProvider.update(
                              ratingToUpdate.id!,
                              request: ratingToUpdate
                            );
                          }

                          if (context.mounted) {
                            Navigator.of(context).pop();
                            showInfoDialog(
                                context,
                                const Icon(Icons.task_alt,
                                    color: Palette.lightPurple, size: 50),
                                const Text(
                                  "Rating saved!",
                                  textAlign: TextAlign.center,
                                ));
                          }
                        } else {
                          if (context.mounted) {
                            showInfoDialog(
                                context,
                                const Icon(Icons.error,
                                    color: Colors.red, size: 50),
                                const Text(
                                  "Please select a rating",
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
                  },
                  borderRadius: 50,
                  height: 30,
                  width: 120,
                  paddingTop: 20,
                  gradient: Palette.buttonGradient,
                  child: const Text(
                    "Submit Rating",
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Palette.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}