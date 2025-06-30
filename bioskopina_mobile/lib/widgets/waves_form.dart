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
  bool _isSaving = false;
  bool _initializationError = false;

  @override
  void initState() {
    super.initState();
    _initializeProviders();
  }

  void _initializeProviders() {
    try {
      if (!mounted) return;

      _listtProvider = context.read<ListtProvider>();
      _bioskopinaListProvider = context.read<BioskopinaListProvider>();

      final userId = LoggedUser.user?.id;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      _listtFuture = _listtProvider.get(filter: {"UserId": userId.toString()});
      _bioskopinaListFuture = _bioskopinaListProvider.get(
        filter: {"MovieId": widget.bioskopina.id?.toString() ?? ''}
      );
    } catch (e) {
      debugPrint('Initialization error: $e');
      _initializationError = true;
      _listtFuture = Future.error(e);
      _bioskopinaListFuture = Future.error(e);
    }
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
              _buildTitle(),
              const SizedBox(height: 20),
              _initializationError
                  ? _buildErrorWidget('Initialization failed. Please try again.')
                  : _buildFormContent(),
              const SizedBox(height: 30),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(
            text: 'Toggle ',
            style: TextStyle(color: Palette.lightPurple),
          ),
          TextSpan(
            text: widget.bioskopina.titleEn ?? 'Movie',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Palette.rose,
            ),
          ),
          const TextSpan(
            text: ' to selected watchlist:',
            style: TextStyle(color: Palette.lightPurple),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContent() {
    return FutureBuilder<SearchResult<Listt>>(
      future: _listtFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyProgressIndicator();
        }

        if (snapshot.hasError) {
          return _buildErrorWidget('Failed to load stars: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.result.isEmpty) {
          return _buildErrorWidget('No stars available');
        }

        final stars = snapshot.data!.result;
        return FormBuilder(
          key: _constellationFormKey,
          child: FutureBuilder<SearchResult<BioskopinaList>>(
            future: _bioskopinaListFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const MyProgressIndicator();
              }

              if (snapshot.hasError) {
                return _buildErrorWidget('Failed to load selections: ${snapshot.error}');
              }

              final selectedStars = snapshot.hasData
                  ? snapshot.data!.result
                  : <BioskopinaList>[];

              return MyFormBuilderFilterChip(
                labelText: "Your watchlists",
                name: 'stars',
                fontSize: 20,
                options: stars.map((star) => FormBuilderChipOption(
                  value: star.id?.toString() ?? '',
                  child: Text(
                    star.name ?? 'Unnamed watchlist',
                    style: const TextStyle(color: Palette.midnightPurple),
                  ),
                )).toList(),
                initialValue: selectedStars
                    .map((e) => e.listId?.toString())
                    .whereType<String>()
                    .toList(),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSaveButton() {
    if (_isSaving) {
      return const MyProgressIndicator();
    }

    return GradientButton(
      onPressed: _handleSave,
      width: 60,
      height: 30,
      borderRadius: 50,
      gradient: Palette.buttonGradient,
      child: const Text(
        "Save",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Palette.white,
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!mounted || _isSaving) return;

    setState(() => _isSaving = true);

    try {
      if (_constellationFormKey.currentState?.saveAndValidate() ?? false) {
        final formData = _constellationFormKey.currentState?.value;
        final selectedStars = (formData?['stars'] as List?)?.whereType<String>().toList() ?? [];

        final bioskopinaListInsert = selectedStars
            .map((listId) => BioskopinaList(
                  null,
                  int.tryParse(listId) ?? 0,
                  widget.bioskopina.id ?? 0,
                  null,
                ))
            .toList();

        await _bioskopinaListProvider.updateMovieLists(
          widget.bioskopina.id ?? 0,
          bioskopinaListInsert,
        );

        if (mounted) {
          Navigator.of(context).pop(true);
          showSuccessDialog(context, 'Saved successfully!');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select at least one watchlist')),
          );
        }
      }
    } catch (e) {
      debugPrint('Save error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}