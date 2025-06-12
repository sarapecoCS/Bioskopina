import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:glass/glass.dart';
import 'package:provider/provider.dart';

import '../models/qa_category.dart';
import '../providers/qa_category_provider.dart';
import '../providers/qa_provider.dart';
import '../widgets/form_builder_text_field.dart';
import '../widgets/question_cards.dart';
import '../models/qa.dart';
import '../models/search_result.dart';
import '../utils/colors.dart';
import '../utils/util.dart';
import '../widgets/circular_progress_indicator.dart';
import '../widgets/gradient_button.dart';

class MyQuestionsScreen extends StatefulWidget {
  const MyQuestionsScreen({super.key});

  @override
  State<MyQuestionsScreen> createState() => _MyQuestionsScreenState();
}

class _MyQuestionsScreenState extends State<MyQuestionsScreen> {
  final _questionFormKey = GlobalKey<FormBuilderState>();
  late final QAcategoryProvider _qAcategoryProvider;
  late final QAProvider _qAProvider;
  late Future<SearchResult<QAcategory>> _qAcategoryFuture;
  String? category = "1";
  final FocusNode _focusNode = FocusNode();

  int page = 0;
  int pageSize = 10;

  final Map<String, dynamic> _filter = {
    "UserId": "${LoggedUser.user!.id}",
    "NewestFirst": "true",
    "CategoryIncluded": "true",
  };

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _qAcategoryProvider = context.read<QAcategoryProvider>();
    _qAcategoryFuture = _qAcategoryProvider.get();
    _qAProvider = context.read<QAProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTop(),
        const Padding(
          padding: EdgeInsets.only(
            left: 20,
            bottom: 10,
            top: 40,
          ),
          child: Text("You've asked previously.."),
        ),
        _buildBottom(),
      ],
    );
  }

  Expanded _buildBottom() {
    return Expanded(
      child: QuestionCards(
        fetchQA: fetchQA,
        fetchPage: fetchPage,
        filter: _filter,
        page: page,
        pageSize: pageSize,
      ),
    );
  }

  Widget _buildTop() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Have a question? We're here to help!",
                  style: TextStyle(fontSize: 16),
                ),

              ],
            ),
          ),
          FormBuilder(
            key: _questionFormKey,
            child: Column(
              children: [
                Container(
                  constraints: const BoxConstraints(maxHeight: 120),
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: MyFormBuilderTextField(
                    name: "question",
                    errorHeight: 1,
                    minLines: 5,
                    fillColor: Palette.textFieldPurple.withOpacity(0.45),
                    maxLines: null,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.multiline,
                    borderRadius: 18,
                    errorBorderRadius: 18,
                    focusNode: _focusNode,
                    contentPadding:
                        const EdgeInsets.only(left: 16, right: 16, top: 28),
                    validator: (val) {
                      if (val == null ||
                          val.isEmpty ||
                          isEmptyOrWhiteSpace(val)) {
                        return "This field cannot be empty.";
                      } else if (LoggedUser.user!.userRoles!.any(
                        (element) =>
                            element.roleId == 2 &&
                            element.canAskQuestions == false,
                      )) {
                        return "You don't have permission to ask questions.";
                      } else if (val.isNotEmpty && !isValidReviewText(val)) {
                        return "Some special characters are not allowed.";
                      } else if (val.isNotEmpty && val.length > 200) {
                        return "Character limit exceeded: ${val.length}/200";
                      }
                      return null;
                    },
                  ).asGlass(
                    blurX: 6,
                    blurY: 6,
                    clipBorderRadius: BorderRadius.circular(18),
                    tintColor: Palette.textFieldPurple,
                  ),
                ),
                const SizedBox(height: 10),
                FutureBuilder<SearchResult<QAcategory>>(
                    future: _qAcategoryFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const MyProgressIndicator(
                          width: 24,
                          height: 24,
                          strokeWidth: 2,
                        ); // Loading state
                      } else if (snapshot.hasError) {
                        return Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ); // Error state
                      } else {
                        // Data loaded successfully
                        var qaCategoryList = snapshot.data!.result;

                        return Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Palette.textFieldPurple.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: DropdownButton<String>(
                              isDense: true,
                              underline: Container(),
                              icon: const Icon(Icons.arrow_drop_down_rounded,
                                  color: Palette.lightPurple),
                              value: category,
                              borderRadius: BorderRadius.circular(15),
                              dropdownColor: Palette.popupMenu,
                              items: qaCategoryList
                                  .map(
                                    (qaCategory) => DropdownMenuItem(
                                      value: "${qaCategory.id}",
                                      child: Center(
                                          child: Text(
                                        "${qaCategory.name}",
                                        style: const TextStyle(fontSize: 15),
                                      )),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  category = val;
                                });
                              }),
                        ).asGlass(
                          blurX: 6,
                          blurY: 6,
                          tintColor: Palette.buttonRed,
                          clipBorderRadius: BorderRadius.circular(60),
                        );
                      }
                    }),
              ],
            ),
          ),
          const SizedBox(height: 10),
          GradientButton(
            onPressed: () async {
              if (_questionFormKey.currentState?.saveAndValidate() == true) {
                String? question =
                    _questionFormKey.currentState?.fields["question"]?.value;

                QA qa = QA(
                    userId: LoggedUser.user!.id,
                    categoryId: int.parse(category!),
                    question: question,
                    answer: "",
                    displayed: true);

                try {
                  await _qAProvider.insert(qa);

                  if (mounted) {
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
                  if (mounted) {
                    showErrorDialog(context, e);
                  }
                }
              }
            },
            width: 90,
            height: 30,
            borderRadius: 50,
            gradient: Palette.buttonGradient,
            child: const Text(
              "Submit",
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Palette.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<SearchResult<QA>> fetchQA() {
    return _qAProvider.get(filter: {
      ..._filter,
      "Page": "$page",
      "PageSize": "$pageSize",
    });
  }

  Future<SearchResult<QA>> fetchPage(Map<String, dynamic> filter) {
    return _qAProvider.get(filter: filter);
  }
}
