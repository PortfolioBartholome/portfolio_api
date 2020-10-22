import 'package:aqueduct/managed_auth.dart';
import 'package:portfolio_api/controller/AdminController.dart';
import 'package:portfolio_api/controller/ProjectController.dart';
import 'package:portfolio_api/controller/RegisterController.dart';
import 'package:portfolio_api/portfolio_api.dart';

import 'model/user.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class PortfolioApiChannel extends ApplicationChannel {
  AuthServer authServer;
  ManagedContext context;
  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {
    logger.onRecord.listen(
            (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
    final config = PortfolioConfig(options.configurationFilePath);
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
        config.database.username,
        config.database.password,
        config.database.host,
        config.database.port,
        config.database.databaseName);
    context = ManagedContext(dataModel,persistentStore);
    final delegate = ManagedAuthDelegate<User>(context,tokenLimit: 20);
    authServer = AuthServer(delegate);
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();

    // Set up auth token route- this grants and refresh tokens
    router.route("/auth/token").link(() => AuthController(authServer));

    // Set up auth code route- this grants temporary access codes that can be exchanged for token
    router.route("/auth/code").link(() =>  AuthCodeController(authServer));

    // Set up protected route
    router
        .route("/projectAdmin/[:id]")
        .link(() => Authorizer.bearer(authServer))
        .link(() => AdminController(context));

    router
        .route("/project/[:id]")
        .link(() => ProjectController(context));

    router
        .route("/register")
        .link(() => Authorizer.basic(authServer))
        .link(() => RegisterController(context, authServer));

    return router;
  }
}

class PortfolioConfig extends Configuration {
  PortfolioConfig(String path) : super.fromFile(File(path));

  DatabaseConfiguration database;
}
