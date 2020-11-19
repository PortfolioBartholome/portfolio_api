import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("After POST to /project, GET /project/:id returns created Project", () async {
    final registerResponse = await harness.publicAgent
        .post("/register", body: {"username": "bob@stablekernel.com", "password": "foobaraxegrind12%"});
    final String accessToken = registerResponse.body.as()["access_token"].toString();
    final userAgent = Agent.from(harness.agent)..bearerAuthorization = accessToken;
    await userAgent.post("/projectAdmin", body: {
      "name" : "BetsBi",
      "content": "LoremIpsum. DartLang",
      "imagePath": "",
      "language" : "Dart",
      "specialLink": "www.google.fr",
    });
    final getResponse = await harness.agent.get("/project/1",);
    expectResponse(getResponse, 200);
  });
}