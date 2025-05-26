import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/qa.dart';
import '../models/search_result.dart';
import '../providers/qa_provider.dart';
import '../utils/util.dart';
import '../widgets/question_cards.dart';

class AskedByOthersScreen extends StatefulWidget {
  const AskedByOthersScreen({super.key});

  @override
  State<AskedByOthersScreen> createState() => _AskedByOthersScreenState();
}

class _AskedByOthersScreenState extends State<AskedByOthersScreen> {
  late final QAProvider _qAProvider;

  int page = 0;
  int pageSize = 10;

  final Map<String, dynamic> _filter = {
    "UserId": "${LoggedUser.user!.id}",
    "NewestFirst": "true",
    "CategoryIncluded": "true",
    "AskedByOthers": "true",
    "AnsweredOnly": "true",
    "DisplayedOnly": "true",
  };

  @override
  void initState() {
    _qAProvider = context.read<QAProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: QuestionCards(
        fetchQA: fetchQA,
        fetchPage: fetchPage,
        filter: _filter,
        page: page,
        pageSize: pageSize,
        showPopupIcon: false,
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
