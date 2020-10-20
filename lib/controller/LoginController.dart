import '../portfolio_api.dart';

class LoginController extends ResourceController {
  LoginController(this.context, this.authServer);

  final ManagedContext context;
  final AuthServer authServer;

  @Operation.get()
  Future<Response> login(@Bind.body() String username, @Bind.body() String password) async {
    // Check for required parameters before we spend time hashing
    if (username == null || password == null) {
      return Response.badRequest(
          body: {"error": "username and password required."});
    }

    const clientID = "org.hasenbalg.zeiterfassung";
    const body = "username=bob&password=password&grant_type=password";
  }
}