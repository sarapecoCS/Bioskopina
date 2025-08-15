import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../providers/list_provider.dart';
import '../utils/util.dart';
import '../widgets/form_builder_text_field.dart';
import '../widgets/gradient_button.dart';
import '../models/list.dart';
import '../utils/colors.dart';

class StarForm extends StatefulWidget {
  final String? initialValue;
  final int? listId;
  const StarForm({super.key, this.initialValue, this.listId});

  @override
  State<StarForm> createState() => _StarFormState();
}

class _StarFormState extends State<StarForm> {
  late ListtProvider _listtProvider;
  final _starFormKey = GlobalKey<FormBuilderState>();
  bool _isSaving = false;

  @override
  void initState() {
    _listtProvider = context.read<ListtProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    double textFieldWidth = screenSize.width * 0.6;

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
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 24.0),
                  child: (widget.initialValue == null)
                      ? const Text("Name your watchlist:",
                          style: TextStyle(fontSize: 16))
                      : const Text("Rename your watchlist:",
                          style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 15),
                FormBuilder(
                  key: _starFormKey,
                  child: MyFormBuilderTextField(
                    name: "name",
                    initialValue: widget.initialValue,
                    fillColor: Palette.textFieldPurple.withOpacity(0.5),
                    width: textFieldWidth,
                    borderRadius: 50,
                    validator: (val) {
                      if (val != null && val != "" && !isValidReviewText(val)) {
                        return "Illegal characters.";
                      } else if (val == null || isEmptyOrWhiteSpace(val)) {
                        return "This field cannot be empty.";
                      } else if (val != "" && val.length > 15) {
                        return "Character limit exceeded: ${val.length}/15";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 15),
                _isSaving
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Palette.lightPurple),
                      )
                    : GradientButton(
                        onPressed: _handleSave,
                        width: 60,
                        height: 30,
                        borderRadius: 50,
                        gradient: Palette.buttonGradient,
                        child: (widget.initialValue == null)
                            ? const Text("Add",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Palette.white))
                            : const Text("Save",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Palette.white)),
                      ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Palette.lightPurple,
                  size: 24,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      if (_starFormKey.currentState?.saveAndValidate() == true) {
        if (widget.initialValue == null) {
          // Creating new list
          await _listtProvider.insert(Listt(
            null,
            LoggedUser.user!.id,
            _starFormKey.currentState?.fields["name"]?.value,
            DateTime.now(),
          ));

          if (context.mounted) {
            Navigator.of(context).pop();
            showInfoDialog(
              context,
              const Icon(Icons.task_alt, color: Palette.lightPurple, size: 50),
              const Text(
                "Watchlist created successfully!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Palette.white),
              ),
            );
          }
        } else if (widget.listId != null) {
          // Updating existing list
          Map<String, dynamic> list = {
            "name": _starFormKey.currentState?.fields["name"]?.value
          };
          await _listtProvider.update(widget.listId!, request: list);

          if (context.mounted) {
            Navigator.of(context).pop();
            showInfoDialog(
              context,
              const Icon(Icons.task_alt, color: Palette.lightPurple, size: 50),
              const Text(
                "Watchlist updated successfully!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Palette.white),
              ),
            );
          }
        }
      }
    } on Exception catch (e) {
      if (context.mounted) {
        showErrorDialog(context, e);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}