import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("After POST to /projectAdmin, /homeAdmin, /knowledgeAdmin, /aboutMeAdmin, GET /global returns 200", () async {
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
    await userAgent.post("/knowledgeAdmin", body: {
      "name" : "Flutter",
      "content": "LoremIpsum. DartLang",
      "imagePath": "",
      "language" : "Dart",
      "specialLink": "www.google.fr",
    });
    await userAgent.post("/homeAdmin", body: {
      "content":"Voila voila",
      "imagePath": "",
      "specialLink":"www.google.fr",
    });
    await userAgent.post("/aboutMeAdmin", body: {
      "content": "LoremIpsum. DartLang",
      "imagePath": "",
      "specialLink": "www.google.fr",
    });
    final getResponse = await harness.agent.get("/global",);
    print(getResponse.body);
    expectResponse(getResponse, 200);
  });
}