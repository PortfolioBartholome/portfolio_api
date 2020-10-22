import 'package:portfolio_api/model/user.dart';
import 'package:portfolio_api/portfolio_api.dart';
import 'package:aqueduct_test/aqueduct_test.dart';

export 'package:portfolio_api/portfolio_api.dart';
export 'package:aqueduct_test/aqueduct_test.dart';
export 'package:test/test.dart';
export 'package:aqueduct/aqueduct.dart';

class Harness extends TestHarness<PortfolioApiChannel> with TestHarnessAuthMixin<PortfolioApiChannel>, TestHarnessORMMixin {
  @override
  Future onSetUp() async {
    await resetData();
    publicAgent = await addClient("com.bartholome.portfolio");

  }

  @override
  Future onTearDown() async {

  }

  @override
  ManagedContext get context => channel.context;

  @override
  AuthServer get authServer => channel.authServer;

  Agent publicAgent;

  Future<Agent> registerUser(User user, {Agent withClient}) async {
    withClient ??= publicAgent;

    final req = withClient.request("/register")
      ..body = {"username": user.username, "password": user.password};
    await req.post();

    return loginUser(withClient, user.username, user.password);
  }
}
