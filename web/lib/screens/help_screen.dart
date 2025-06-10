import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../providers/qa_category_provider.dart';
import '../screens/qa_categories_screen.dart';
import '../providers/qa_provider.dart';
import '../widgets/form_builder_dropdown.dart';
import '../widgets/form_builder_text_field.dart';
import '../widgets/gradient_button.dart';
import '../widgets/master_screen.dart';
import '../widgets/pagination_buttons.dart';
import '../widgets/separator.dart';
import '../models/qa.dart';
import '../models/search_result.dart';
import '../utils/colors.dart';
import '../utils/util.dart';
import '../widgets/circular_progress_indicator.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  ScrollController scrollController = ScrollController();
  late QAProvider _qaProvider;
  late Future<SearchResult<QA>> _qaFuture;
  Map<String, dynamic> _initialValue = {};
  int? qaID;
  String? _questionTitle = "";
  final _qAFormKey = GlobalKey<FormBuilderState>();
  final _qAfilterFormKey = GlobalKey<FormBuilderState>();
  final Map<String, dynamic> _selectedQAFilter = {"QAfilter": "All"};
  final TextEditingController _qaController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late final QAcategoryProvider _qaCategoryProvider;

  int page = 0;
  int pageSize = 6;
  int totalItems = 0;
  bool isSearching = false;

  @override
  void initState() {
    _qaProvider = context.read<QAProvider>();
    _qaFuture = _qaProvider.get(filter: {
      "UserIncluded": "true",
      "CategoryIncluded": "true",
      "UnansweredFirst": "true",
      "Page": "$page",
      "PageSize": "$pageSize"
    });

    setTotalItems();

    _initialValue = {
      "answer": "",
      "question": "",
      "displayed": true,
    };

    _qaProvider.addListener(() {
      _reloadQAList();
      setTotalItems();
    });

    _qaCategoryProvider = context.read<QAcategoryProvider>();

    _qaCategoryProvider.addListener(() {
      _reloadQAList();
      setTotalItems();
      _emptySelectedQuestion();
    });

    super.initState();
  }

  void _emptySelectedQuestion() {
    if (mounted) {
      setState(() {
        _initialValue["question"] = "";
        _initialValue["question"] = "";
        qaID = null;
        _questionTitle = "";
        _qAFormKey.currentState?.fields["answer"]?.didChange("");
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void setTotalItems() async {
    var qaResult = await _qaFuture;
    if (mounted) {
      setState(() {
        totalItems = qaResult.count;
      });

      int totalPages = (totalItems / pageSize).ceil();

      // Ensure the page index is within valid range
      if (page >= totalPages && totalPages > 0) {
        setState(() {
          page--;
        });
      }
      _reloadQAList();
    }
  }

  void _reloadQAList() {
    if (mounted) {
      if (_selectedQAFilter["QAfilter"] == "All") {
        setState(() {
          _qaFuture = context.read<QAProvider>().get(filter: {
            "UserIncluded": "true",
            "CategoryIncluded": "true",
            "UnansweredFirst": "true",
            "Page": "$page",
            "PageSize": "$pageSize"
          });
        });
      } else if (_selectedQAFilter["QAfilter"] == "Unanswered") {
        setState(() {
          _qaFuture = context.read<QAProvider>().get(filter: {
            "UserIncluded": "true",
            "CategoryIncluded": "true",
            "NewestFirst": "true",
            "UnansweredOnly": "true",
            "Page": "$page",
            "PageSize": "$pageSize"
          });
        });
      } else if (_selectedQAFilter["QAfilter"] == "Hidden") {
        setState(() {
          _qaFuture = context.read<QAProvider>().get(filter: {
            "UserIncluded": "true",
            "CategoryIncluded": "true",
            "UnansweredFirst": "true",
            "HiddenOnly": "true",
            "Page": "$page",
            "PageSize": "$pageSize"
          });
        });
      } else if (_selectedQAFilter["QAfilter"] == "Displayed") {
        setState(() {
          _qaFuture = context.read<QAProvider>().get(filter: {
            "UserIncluded": "true",
            "CategoryIncluded": "true",
            "UnansweredFirst": "true",
            "DisplayedOnly": "true",
            "Page": "$page",
            "PageSize": "$pageSize"
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        titleWidget: Row(
          children: [
            Icon(
              Icons.help_outline,
              color:Color.fromRGBO(153, 255, 255, 1),
              size: 21,  // Icon size
            ),
            const SizedBox(width: 5),
            const Text("Help"),
          ],
        ),
        showSearch: true,
        onSubmitted: _search,
        controller: _qaController,
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Text(
                        _questionTitle!,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Palette.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, top: 20),
                    child: FormBuilder(
                      key: _qAFormKey,
                      initialValue: _initialValue,
                      child: Container(
                        constraints: const BoxConstraints(
                          minHeight: 200,
                          maxHeight: 400,
                          minWidth: 500,
                          maxWidth: 500,
                        ),
                        child: MyFormBuilderTextField(
                          name: "answer",
                          fillColor: Palette.textFieldPurple.withOpacity(0.3),
                          width: 500,
                          height: 300,
                          borderRadius: 15,
                          minLines: 40,
                          maxLines: 40,
                          focusNode: _focusNode,
                          contentPadding: const EdgeInsets.only(
                            left: 10,
                            top: 30,
                            right: 10,
                          ),
                          borderColor: Palette.lightPurple.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                  GradientButton(
                    paddingLeft: 15,
                    paddingTop: 30,
                    width: 100,
                    height: 30,
                    borderRadius: 50,
                    gradient: Palette.buttonGradient,
                    child: const Text(
                      "Save",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Palette.white),
                    ),
                    onPressed: () async {
                      if (_initialValue["question"] == "") {
                        showInfoDialog(
                            context,
                            const Icon(Icons.info_rounded, size: 60),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                    "To answer a question, you must first select it by clicking on"),
                                const SizedBox(width: 5),
                                Icon(
                                  Icons.edit,  // Built-in Flutter edit icon
                                  color: Colors.purple.withOpacity(0.7),  // Custom color
                                  size: 24,  // Icon size
                                ),
                              ],
                            ));
                      }
                      if (_qAFormKey.currentState?.saveAndValidate() == true) {
                        var tmp = Map.from(_qAFormKey.currentState!.value);
                        var request = {
                          "answer": tmp["answer"].toString(),
                          "question": _initialValue["question"].toString(),
                          "displayed": true,
                        };
                        try {
                          if (qaID != null) {
                            await _qaProvider.update(qaID!, request: request);

                            if (context.mounted) {
                              showInfoDialog(
                                  context,
                                  const Icon(Icons.task_alt,
                                      color: Color.fromRGBO(102, 204, 204, 1), size: 50),
                                  const Text(
                                    "Answered successfully!",
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
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: FutureBuilder<SearchResult<QA>>(
                      future: _qaFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const MyProgressIndicator(); // Loading state
                        } else if (snapshot.hasError) {
                          return Text(
                              'Error: ${snapshot.error}'); // Error state
                        } else {
                          // Data loaded successfully
                          var qaList = snapshot.data!.result;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FormBuilder(
                                    key: _qAfilterFormKey,
                                    initialValue: _selectedQAFilter,
                                    child: MyFormBuilderDropdown(
                                      name: "QAfilter",
                                      width: 130,
                                      height: 50,
                                      borderRadius: 15,
                                      paddingRight: 15,
                                      fillColor: Palette.textFieldPurple
                                          .withOpacity(0.3),
                                      dropdownColor: Palette.dropdownMenu,
                                      onChanged: (filter) {
                                        if (mounted) {
                                          setState(() {
                                            _selectedQAFilter["QAfilter"] =
                                                filter.toString();
                                          });
                                        }

                                        _filterQA(filter!);
                                      },
                                      icon: const Icon(Icons.filter_alt,
                                          color: Palette.lightPurple),
                                      items: const [
                                        DropdownMenuItem(
                                            value: 'All', child: Text('All')),
                                        DropdownMenuItem(
                                            value: 'Unanswered',
                                            child: Text('Unanswered')),
                                        DropdownMenuItem(
                                            value: 'Hidden',
                                            child: Text('Hidden')),
                                        DropdownMenuItem(
                                            value: 'Displayed',
                                            child: Text('Displayed')),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                const QACategoriesScreen()));
                                      },
                                      child: const Text("Manage QA categories",
                                          style: TextStyle(
                                              color: Palette.lightPurple))),
                                ],
                              ),
                              LayoutBuilder(builder: (BuildContext context,
                                  BoxConstraints constraints) {
                                double maxSeparatorWidth =
                                    constraints.maxWidth - 300;
                                return MySeparator(
                                  width: maxSeparatorWidth,
                                  marginVertical: 10,
                                  paddingRight: 25,
                                  borderRadius: 50,
                                  opacity: 0.5,
                                );
                              }),
                              Column(
                                children: [
                                  Wrap(
                                    crossAxisAlignment:
                                    WrapCrossAlignment.start,
                                    alignment: WrapAlignment.start,
                                    children: _buildQACards(qaList),
                                  ),
                                  MyPaginationButtons(
                                      page: page,
                                      pageSize: pageSize,
                                      totalItems: totalItems,
                                      fetchPage: fetchPage),
                                ],
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void _search(String searchText) async {
    if (mounted) {
      setState(() {
        isSearching = true;
      });
    }

    _filterQA(_selectedQAFilter["QAfilter"], searchText: searchText);
  }

  Future<void> fetchPage(int requestedPage) async {
    _filterQA(_selectedQAFilter["QAfilter"], requestedPage: requestedPage);

    if (mounted) {
      setState(() {
        page = requestedPage;
      });
    }
  }

  List<Widget> _buildQACards(List<QA> qaList) {
    return List.generate(
      qaList.length,
          (index) => _buildQACard(qaList[index]),
    );
  }

  Widget _buildQACard(QA qa) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, right: 15),
      child: Container(
        constraints: const BoxConstraints(minHeight: 100, maxHeight: 200),
        width: 450,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: (qa.answer != "") ? Palette.darkPurple : Palette.plumPurple),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(qa.question.toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold)),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 23),
                  child: Container(
                    padding: EdgeInsets.zero,
                    child: Row(
                      children: [
                        IconButton(
                            constraints: const BoxConstraints(
                                maxHeight: 24, maxWidth: 24),
                            alignment: Alignment.topCenter,
                            tooltip: "Add or edit answer",
                            visualDensity: const VisualDensity(
                                horizontal: -4, vertical: -4),
                            padding: EdgeInsets.zero,
                            splashRadius: 0.1,
                            onPressed: () {
                              if (mounted) {
                                setState(() {
                                  _initialValue["question"] =
                                      qa.question.toString();
                                  qaID = qa.id;
                                  _questionTitle = qa.question.toString();
                                  _qAFormKey.currentState!.fields["answer"]!
                                      .didChange(qa.answer.toString());
                                });
                              }
                            },
                    icon: Icon(
                      Icons.edit,
                      color: Palette.lightPurple.withOpacity(0.7),
                      size: 24,
                    )),
                        PopupMenuButton<String>(
                          tooltip: "More actions",
                          offset: const Offset(195, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                                color: Colors.black.withOpacity(0.3)),
                          ),
                          icon: const Icon(Icons.more_vert_rounded),
                          splashRadius: 1,
                          padding: EdgeInsets.zero,
                          color:  Colors.black,
                          itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                visualDensity: const VisualDensity(
                                    horizontal: -4, vertical: -4),
                                hoverColor:
                                Palette.lightPurple.withOpacity(0.1),
                                leading: _buildHideIcon(qa),
                                title: _buildHideTitle(qa),
                                subtitle: _buildHideSubtitle(qa),
                                onTap: () async {
                                  Navigator.pop(context);
                                  await _hideOrShowQA(qa, context);
                                },
                              ),
                            ),
                            PopupMenuItem<String>(

                              child: ListTile(

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                hoverColor: Palette.lightRed.withOpacity(0.1),
                                leading: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 24,
                                ),
                                title: const Text('Delete',
                                    style: TextStyle(color: Palette.lightRed)),
                                subtitle: Text('Delete permanently',
                                    style: TextStyle(
                                        color:
                                        Palette.lightRed.withOpacity(0.5))),
                                onTap: () {
                                  Navigator.pop(context);
                                  showConfirmationDialog(
                                      context,
                                      const Icon(Icons.warning_rounded,
                                          color: Palette.lightRed, size: 55),
                                      const Text(
                                          "Are you sure you want to delete this question?"),
                                          () async {
                                        await _deleteQA(qa, context);
                                      });
                                },

                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person_rounded,
                                size: 19, color: Palette.lightPurple),
                            const SizedBox(width: 5),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 200),
                              child: Text(
                                qa.user!.username.toString(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        GradientButton(
                            contentPaddingLeft: 5,
                            contentPaddingRight: 5,
                            contentPaddingBottom: 1,
                            contentPaddingTop: 0,
                            borderRadius: 50,
                            gradient: Palette.menuGradient,
                            child: Text(
                              qa.category!.name.toString(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Palette.lightPurple,
                                  fontWeight: FontWeight.w500),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                constraints:
                const BoxConstraints(minHeight: 30, maxHeight: 100),
                //height: 100,
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Text(
                    qa.answer.toString(),
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Icon _buildHideIcon(QA qa) {
    if (qa.displayed == true) {
      return const Icon(Icons.visibility_off_outlined,
          color: Palette.lightPurple);
    } else {
      return const Icon(Icons.visibility_outlined, color: Palette.lightPurple);
    }
  }

  Text _buildHideSubtitle(QA qa) {
    if (qa.displayed == true) {
      return Text('Hide question for users',
          style: TextStyle(color: Palette.lightPurple.withOpacity(0.5)));
    } else {
      return Text('Show question to users',
          style: TextStyle(color: Palette.lightPurple.withOpacity(0.5)));
    }
  }

  Text _buildHideTitle(QA qa) {
    if (qa.displayed == true) {
      return const Text('Hide', style: TextStyle(color: Palette.lightPurple));
    } else {
      return const Text('Show', style: TextStyle(color: Palette.lightPurple));
    }
  }

  Future<void> _deleteQA(QA qa, BuildContext context) async {
    try {
      await _qaProvider.delete(qa.id!);
      if (mounted) {
        if (qa.id! == qaID) {
          setState(() {
            qaID = null;
            _questionTitle = "";
            _initialValue["question"] = "";
            _qAFormKey.currentState?.fields["answer"]?.didChange("");
          });
        }
      }

      if (context.mounted) {
        showInfoDialog(
            context,
            const Icon(Icons.task_alt, color: Color.fromRGBO(102, 204, 204, 1), size: 50),
            const Text(
              "Question has been deleted.",
              textAlign: TextAlign.center,
            ));
      }
    } on Exception catch (e) {
      if (context.mounted) {
        showErrorDialog(context, e);
      }
    }
  }

  Future<void> _hideOrShowQA(QA qa, BuildContext context) async {
    if (mounted) {
      setState(() {
        qaID = qa.id;
      });
    }

    var request = {
      "answer": qa.answer.toString(),
      "question": qa.question.toString(),
      "displayed": (qa.displayed == true) ? false : true,
    };

    try {
      if (qaID != null) {
        await _qaProvider.update(qaID!, request: request);

        if (context.mounted) {
          showInfoDialog(
              context,
              const Icon(Icons.task_alt, color:Color.fromRGBO(102, 204, 204, 1), size: 50),
              (qa.displayed == true)
                  ? const Text(
                "Question has been hidden.",
                textAlign: TextAlign.center,
              )
                  : const Text(
                "Question has been shown.",
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

  void _filterQA(String filter,
      {String? searchText, int? requestedPage}) async {
    if (mounted) {
      setState(() {
        page = 0;
      });
    }

    try {
      if (filter == "All") {
        if (mounted) {
          setState(() {
            _qaFuture = _qaProvider.get(filter: {
              "UserIncluded": "true",
              "CategoryIncluded": "true",
              "UnansweredFirst": "true",
              if (isSearching == true) "FTS": _qaController.text,
              "Page": (requestedPage != null) ? "$requestedPage" : "$page",
              "PageSize": "$pageSize"
            });
          });
        }

        var result = await _qaFuture;

        if (mounted) {
          setState(() {
            totalItems = result.count;
          });
        }
      } else if (filter == "Unanswered") {
        if (mounted) {
          setState(() {
            _qaFuture = _qaProvider.get(filter: {
              "UserIncluded": "true",
              "CategoryIncluded": "true",
              "NewestFirst": "true",
              "UnansweredOnly": "true",
              if (isSearching == true) "FTS": _qaController.text,
              "Page": (requestedPage != null) ? "$requestedPage" : "$page",
              "PageSize": "$pageSize"
            });
          });
        }

        var result = await _qaFuture;

        if (mounted) {
          setState(() {
            totalItems = result.count;
          });
        }
      } else if (filter == "Hidden") {
        if (mounted) {
          setState(() {
            _qaFuture = _qaProvider.get(filter: {
              "UserIncluded": "true",
              "CategoryIncluded": "true",
              "UnansweredFirst": "true",
              "HiddenOnly": "true",
              if (isSearching == true) "FTS": _qaController.text,
              "Page": (requestedPage != null) ? "$requestedPage" : "$page",
              "PageSize": "$pageSize"
            });
          });
        }

        var result = await _qaFuture;

        if (mounted) {
          setState(() {
            totalItems = result.count;
          });
        }
      } else if (filter == "Displayed") {
        if (mounted) {
          setState(() {
            _qaFuture = _qaProvider.get(filter: {
              "UserIncluded": "true",
              "CategoryIncluded": "true",
              "UnansweredFirst": "true",
              "DisplayedOnly": "true",
              if (isSearching == true) "FTS": _qaController.text,
              "Page": (requestedPage != null) ? "$requestedPage" : "$page",
              "PageSize": "$pageSize"
            });
          });
        }

        var result = await _qaFuture;

        if (mounted) {
          setState(() {
            totalItems = result.count;
          });
        }
      }
    } on Exception catch (e) {
      if (mounted) {
        showErrorDialog(context, e);
      }
    }
  }
}