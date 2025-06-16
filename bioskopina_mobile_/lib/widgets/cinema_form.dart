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

// ignore: must_be_immutable
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

  int timesWatched = 1;
  int? _watchlistId;

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();
  final FocusNode _focusNode7 = FocusNode();
  final FocusNode _focusNode8 = FocusNode();
  final FocusNode _focusNode9 = FocusNode();
  final FocusNode _focusNode10 = FocusNode();
  final FocusNode _focusNode11 = FocusNode();
  final FocusNode _focusNode12 = FocusNode();

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _focusNode5.dispose();
    _focusNode6.dispose();
    _focusNode7.dispose();
    _focusNode8.dispose();
    _focusNode9.dispose();
    _focusNode10.dispose();
    _focusNode11.dispose();
    _focusNode12.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _bioskopinaWatchlistProvider = context.read<BioskopinaWatchlistProvider>();
    _ratingProvider = context.read<RatingProvider>();
    _watchlistProvider = context.read<WatchlistProvider>();

    _initialValueFuture = setInitialValue();
    _watchlistId = widget.watchlistId;

    super.initState();
  }

  Future<Map<String, dynamic>> setInitialValue() async {
    var rating = await _ratingProvider.get(filter: {
      "UserId": "${LoggedUser.user!.id}",
      "BioskopinaId": "${widget.bioskopina.id}"
    });

    return {
      "watchStatus": widget.bioskopinaWatchlist?.watchStatus ?? "",
      "ratingValue":
          (rating.result.isNotEmpty) ? rating.result.first.ratingValue : null,
      "reviewText":
          (rating.result.isNotEmpty) ? rating.result.first.reviewText : "",
      "dateStarted": widget.bioskopinaWatchlist?.dateStarted,
      "dateFinished": widget.bioskopinaWatchlist?.dateFinished,
      "timesWatched": 1, // Default value since it's not in the model
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_watchlistId != null && _watchlistId != 0) {
      return _buildAddForm(context);
    } else if (_watchlistId == 0) {
      _addFirstWatchlist();
      return _buildAddForm(context);
    }
    return _buildEditForm(context);
  }

  void _addFirstWatchlist() async {
    var watchlistObj = await _watchlistProvider
        .get(filter: {"UserId": "${LoggedUser.user!.id}"});

    if (watchlistObj.count == 0) {
      Watchlist watchlist =
          Watchlist(null, LoggedUser.user!.id, DateTime.now());
      var usersWatchlist = await _watchlistProvider.insert(watchlist);
      setState(() {
        _watchlistId = usersWatchlist.id!;
      });
    }
  }

  Dialog _buildAddForm(BuildContext context) {
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
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Text(
                      "Watch status",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                MyFormBuilderChoiceChip(
                  focusNode: _focusNode1,
                  name: "watchStatus",
                  onChanged: (val) {
                    _cinemaFormKey.currentState?.saveAndValidate();
                  },
                  options: const [
                    FormBuilderChipOption(
                        value: "Watching",
                        child: Text("Watching",
                            style: TextStyle(color: Palette.darkPurple))),
                    FormBuilderChipOption(
                        value: "Completed",
                        child: Text("Completed",
                            style: TextStyle(color: Palette.darkPurple))),
                    FormBuilderChipOption(
                        value: "On Hold",
                        child: Text("On Hold",
                            style: TextStyle(color: Palette.darkPurple))),
                    FormBuilderChipOption(
                        value: "Dropped",
                        child: Text("Dropped",
                            style: TextStyle(color: Palette.darkPurple))),
                    FormBuilderChipOption(
                        value: "Plan to Watch",
                        child: Text("Plan to Watch",
                            style: TextStyle(color: Palette.darkPurple))),
                  ],
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "You must choose watch status.";
                    }
                    return null;
                  },
                ),
                MySeparator(
                  width: double.infinity,
                  paddingTop: 10,
                  paddingBottom: 10,
                  borderRadius: 50,
                  opacity: 0.5,
                ),
                const Row(
                  children: [
                    Text(
                      "Dates (optional)",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                MyDateTimePicker(
                  focusNode: _focusNode5,
                  name: "dateStarted",
                  formKey: _cinemaFormKey,
                  labelText: "Date started",
                  fillColor: Palette.ratingPurple,
                  width: double.infinity,
                  height: 40,
                  borderRadius: 50,
                ),
                const SizedBox(height: 10),
                MyDateTimePicker(
                  focusNode: _focusNode6,
                  name: "dateFinished",
                  formKey: _cinemaFormKey,
                  labelText: "Date finished",
                  fillColor: Palette.ratingPurple,
                  width: double.infinity,
                  height: 40,
                  borderRadius: 50,
                ),
                MySeparator(
                  width: double.infinity,
                  paddingTop: 10,
                  paddingBottom: 10,
                  borderRadius: 50,
                  opacity: 0.5,
                ),
                const Row(
                  children: [
                    Text(
                      "Score & review (optional)",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                MyFormBuilderChoiceChip(
                  focusNode: _focusNode3,
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
                  focusNode: _focusNode4,
                  name: "reviewText",
                  labelText: "Review",
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
                    } else if (val != null &&
                        val.isNotEmpty &&
                        (_cinemaFormKey.currentState?.fields["ratingValue"]
                                    ?.value ==
                                null ||
                            _cinemaFormKey.currentState?.fields["ratingValue"]
                                    ?.value ==
                                "")) {
                      return "Score must be selected to leave a review.";
                    }
                    return null;
                  },
                ),
                GradientButton(
                  onPressed: () async {
                    _cinemaFormKey.currentState?.saveAndValidate();

                    if (_cinemaFormKey.currentState?.saveAndValidate() == true) {
                      try {
                        Map<String, dynamic> bioskopinaWatchlist = {
                          "movieId": "${widget.bioskopina.id}",
                          "watchlistId": "$_watchlistId",
                          "watchStatus":
                              "${_cinemaFormKey.currentState!.fields["watchStatus"]?.value}",
                          "dateStarted": (_cinemaFormKey.currentState!
                                      .fields["dateStarted"]?.value !=
                                  null)
                              ? (_cinemaFormKey.currentState!
                                      .fields["dateStarted"]?.value as DateTime)
                                  .toIso8601String()
                              : null,
                          "dateFinished": (_cinemaFormKey.currentState!
                                      .fields["dateFinished"]?.value !=
                                  null)
                              ? (_cinemaFormKey.currentState!
                                      .fields["dateFinished"]?.value as DateTime)
                                  .toIso8601String()
                              : null,
                        };

                        dynamic ratingValue = _cinemaFormKey
                            .currentState!.fields["ratingValue"]?.value;

                        if (ratingValue != null) {
                          Map<String, dynamic> rating = {
                            "userId": LoggedUser.user!.id,
                            "bioskopinaId": widget.bioskopina.id,
                            "ratingValue": ratingValue,
                            "reviewText":
                                "${_cinemaFormKey.currentState!.fields["reviewText"]?.value ?? ""}",
                            "dateAdded": DateTime.now().toIso8601String(),
                          };

                          await _ratingProvider.insert(rating);
                        }

                        await _bioskopinaWatchlistProvider.insert(bioskopinaWatchlist);

                        if (context.mounted) {
                          Navigator.of(context).pop();
                          showInfoDialog(
                              context,
                              const Icon(Icons.task_alt,
                                  color: Palette.lightPurple, size: 50),
                              const Text(
                                "Added successfully!",
                                textAlign: TextAlign.center,
                              ));
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
                    "Add to Watchlist",
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

  Widget _buildEditForm(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: _initialValueFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MyProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var initialValue = snapshot.data;

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
                  initialValue: initialValue ?? {},
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
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            Text(
                              "Watch status",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        MyFormBuilderChoiceChip(
                          focusNode: _focusNode7,
                          name: "watchStatus",
                          initialValue: initialValue?["watchStatus"],
                          onChanged: (val) {
                            _cinemaFormKey.currentState?.saveAndValidate();
                          },
                          options: const [
                            FormBuilderChipOption(
                                value: "Watching",
                                child: Text("Watching",
                                    style: TextStyle(color: Palette.darkPurple))),
                            FormBuilderChipOption(
                                value: "Completed",
                                child: Text("Completed",
                                    style: TextStyle(color: Palette.darkPurple))),
                            FormBuilderChipOption(
                                value: "On Hold",
                                child: Text("On Hold",
                                    style: TextStyle(color: Palette.darkPurple))),
                            FormBuilderChipOption(
                                value: "Dropped",
                                child: Text("Dropped",
                                    style: TextStyle(color: Palette.darkPurple))),
                            FormBuilderChipOption(
                                value: "Plan to Watch",
                                child: Text("Plan to Watch",
                                    style: TextStyle(color: Palette.darkPurple))),
                          ],
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "You must choose watch status.";
                            }
                            return null;
                          },
                        ),
                        MySeparator(
                          width: double.infinity,
                          paddingTop: 10,
                          paddingBottom: 10,
                          borderRadius: 50,
                          opacity: 0.5,
                        ),
                        const Row(
                          children: [
                            Text(
                              "Dates (optional)",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        MyDateTimePicker(
                          focusNode: _focusNode11,
                          name: "dateStarted",
                          formKey: _cinemaFormKey,
                          labelText: "Date started",
                          fillColor: Palette.ratingPurple,
                          width: double.infinity,
                          borderRadius: 50,
                          initialValue: widget.bioskopinaWatchlist?.dateStarted,
                        ),
                        const SizedBox(height: 10),
                        MyDateTimePicker(
                          focusNode: _focusNode12,
                          name: "dateFinished",
                          formKey: _cinemaFormKey,
                          labelText: "Date finished",
                          fillColor: Palette.ratingPurple,
                          width: double.infinity,
                          borderRadius: 50,
                          initialValue: widget.bioskopinaWatchlist?.dateFinished,
                        ),
                        MySeparator(
                          width: double.infinity,
                          paddingTop: 10,
                          paddingBottom: 10,
                          borderRadius: 50,
                          opacity: 0.5,
                        ),
                        const Row(
                          children: [
                            Text(
                              "Score & review (optional)",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        MyFormBuilderChoiceChip(
                          focusNode: _focusNode9,
                          name: "ratingValue",
                          initialValue: initialValue?["ratingValue"],
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
                          focusNode: _focusNode10,
                          name: "reviewText",
                          labelText: "Review",
                          fillColor: Palette.textFieldPurple.withOpacity(0.5),
                          maxLines: null,
                          textAlignVertical: TextAlignVertical.center,
                          paddingBottom: 10,
                          keyboardType: TextInputType.multiline,
                          borderRadius: 20,
                          errorBorderRadius: 20,
                          contentPadding: const EdgeInsets.only(
                              left: 10, right: 10, top: 25),
                          validator: (val) {
                            if (val != null &&
                                val.isNotEmpty &&
                                !isValidReviewText(val)) {
                              return "Some special characters are not allowed.";
                            } else if (LoggedUser.user!.userRoles!.any(
                              (element) =>
                                  element.roleId == 2 &&
                                  element.canReview == false &&
                                  val != null &&
                                  val.isNotEmpty,
                            )) {
                              return "Not permitted to leave review.";
                            } else if (val != null &&
                                val.isNotEmpty &&
                                (_cinemaFormKey.currentState
                                            ?.fields["ratingValue"]?.value ==
                                        null ||
                                    _cinemaFormKey.currentState
                                            ?.fields["ratingValue"]?.value ==
                                        "")) {
                              return "Score must be selected to leave a review.";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GradientButton(
                              onPressed: () async {
                                try {
                                  var bioskopinaWatchlist =
                                      await _bioskopinaWatchlistProvider
                                          .get(filter: {
                                    "BioskopinaId": "${widget.bioskopina.id}",
                                    "WatchlistId":
                                        "${widget.bioskopinaWatchlist!.watchlistId}"
                                  });

                                  var rating = await _ratingProvider.get(
                                      filter: {
                                        "UserId": "${LoggedUser.user!.id}",
                                        "BioskopinaId": "${widget.bioskopina.id}"
                                      });

                                  if (bioskopinaWatchlist.count == 1) {
                                    await _bioskopinaWatchlistProvider
                                        .delete(bioskopinaWatchlist.result[0].id!);

                                    if (rating.count == 1) {
                                      await _ratingProvider
                                          .delete(rating.result[0].id!);
                                    }

                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                      showInfoDialog(
                                          context,
                                          const Icon(Icons.task_alt,
                                              color: Palette.lightPurple,
                                              size: 50),
                                          const Text(
                                            "Removed successfully!",
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
                              borderRadius: 50,
                              height: 30,
                              width: 80,
                              paddingTop: 20,
                              gradient: Palette.buttonGradient,
                              child: const Text(
                                "Remove",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Palette.white),
                              ),
                            ),
                            GradientButton(
                              onPressed: () async {
                                _cinemaFormKey.currentState?.saveAndValidate();

                                if (_cinemaFormKey.currentState
                                        ?.saveAndValidate() ==
                                    true) {
                                  try {
                                    var bioskopinaWatchlist =
                                        await _bioskopinaWatchlistProvider
                                            .get(filter: {
                                      "BioskopinaId": "${widget.bioskopina.id}",
                                      "WatchlistId":
                                          "${widget.bioskopinaWatchlist!.watchlistId}"
                                    });

                                    if (bioskopinaWatchlist.count == 1) {
                                      bioskopinaWatchlist.result[0].watchStatus =
                                          _cinemaFormKey.currentState!
                                              .fields["watchStatus"]?.value;
                                      bioskopinaWatchlist.result[0].dateStarted =
                                          _cinemaFormKey.currentState!
                                              .fields["dateStarted"]?.value;
                                      bioskopinaWatchlist.result[0].dateFinished =
                                          _cinemaFormKey.currentState!
                                              .fields["dateFinished"]?.value;

                                      await _bioskopinaWatchlistProvider.update(
                                          bioskopinaWatchlist.result[0].id!,
                                          request: bioskopinaWatchlist.result[0]);
                                    }

                                    var rating = await _ratingProvider.get(
                                        filter: {
                                          "UserId": "${LoggedUser.user!.id}",
                                          "BioskopinaId": "${widget.bioskopina.id}"
                                        });

                                    dynamic ratingValue = _cinemaFormKey
                                        .currentState!.fields["ratingValue"]?.value;

                                    if (rating.count == 0 && ratingValue != null) {
                                      String? reviewText = _cinemaFormKey
                                              .currentState!
                                              .fields["reviewText"]
                                              ?.value ??
                                          "";

                                      Rating rating = Rating(
                                          null,
                                          LoggedUser.user!.id,
                                          widget.bioskopina.id,
                                          ratingValue,
                                          reviewText,
                                          DateTime.now(),
                                          null,
                                          null);

                                      await _ratingProvider.insert(rating);
                                    } else if (rating.count == 1) {
                                      if (ratingValue == null) {
                                        await _ratingProvider
                                            .delete(rating.result[0].id!);
                                      } else {
                                        rating.result[0].ratingValue = ratingValue;
                                        rating.result[0].reviewText =
                                            _cinemaFormKey
                                                    .currentState!
                                                    .fields["reviewText"]
                                                    ?.value ??
                                                "";

                                        await _ratingProvider.update(
                                            rating.result[0].id!,
                                            request: rating.result[0]);
                                      }
                                    }

                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                      showInfoDialog(
                                          context,
                                          const Icon(Icons.task_alt,
                                              color: Palette.lightPurple,
                                              size: 50),
                                          const Text(
                                            "Updated successfully!",
                                            textAlign: TextAlign.center,
                                          ));
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
                              width: 80,
                              paddingTop: 20,
                              gradient: Palette.buttonGradient,
                              child: const Text(
                                "Save",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Palette.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}