import '../providers/base_provider.dart';

import '../models/qa_category.dart';

class QAcategoryProvider extends BaseProvider<QAcategory> {
  QAcategoryProvider() : super("QAcategory");

  @override
  QAcategory fromJson(data) {
    return QAcategory.fromJson(data);
  }
}
