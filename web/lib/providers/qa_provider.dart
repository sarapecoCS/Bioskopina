import '../providers/base_provider.dart';

import '../models/qa.dart';

class QAProvider extends BaseProvider<QA> {
  QAProvider() : super("QA");

  @override
  QA fromJson(data) {
    return QA.fromJson(data);
  }
}
