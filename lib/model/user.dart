import 'package:aqueduct/managed_auth.dart';
import 'package:portfolio_api/model/Project.dart';


import '../portfolio_api.dart';

class User extends ManagedObject<_User>
    implements _User, ManagedAuthResourceOwner<_User> {
  @Serialize(input: true, output: false)
  String password;
}

class _User extends ResourceOwnerTableDefinition {

  ManagedSet<Project> projects;
}
