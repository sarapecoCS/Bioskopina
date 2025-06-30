import '../providers/base_provider.dart';

import '../models/role.dart';

class RoleProvider extends BaseProvider<Role> {
  RoleProvider() : super("Role");

  @override
  Role fromJson(data) {
    return Role.fromJson(data);
  }
}
