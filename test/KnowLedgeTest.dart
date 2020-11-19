import 'harness/app.dart';

Future main() async {
  final harness = Harness()
    ..install();

  test("After POST to /knowledgeAdmin, GET 401 error status code", () async {
    final postResponse = await harness.agent.post("/knowledgeAdmin", body: {
      "name": "Test",
      "content": "LoremIpsum. DartLang",
      "language": "Flutter",
      "imagePath": "",
      "specialLink": "www.google.fr",
    });
    expectResponse(postResponse, 401);
  });


  test("After POST to /knowledgeAdmin, GET /knowledge/:id returns 200", () async {
    final registerResponse = await harness.publicAgent
        .post("/register", body: {
      "username": "bob@stablekernel.com",
      "password": "foobaraxegrind12%"
    });
    final String accessToken = registerResponse.body.as()["access_token"]
        .toString();
    final userAgent = Agent.from(harness.agent)
      ..bearerAuthorization = accessToken;
    final postResponse = await userAgent.post("/knowledgeAdmin", body: {
      "name": "Test",
      "content": "LoremIpsum. DartLang",
      "language": "Flutter",
      "imagePath": "",
      "specialLink": "www.google.fr",
    });
    expectResponse(postResponse, 200);
  });

  test("After POST to /knowledgeAdmin, GET /knowledge/:id returns 200 with correct boody", () async {
    final registerResponse = await harness.publicAgent
        .post("/register", body: {
      "username": "bob@stablekernel.com",
      "password": "foobaraxegrind12%"
    });
    final String accessToken = registerResponse.body.as()["access_token"]
        .toString();
    final userAgent = Agent.from(harness.agent)
      ..bearerAuthorization = accessToken;
    final postResponse = await userAgent.post("/knowledgeAdmin", body: {
      "name": "Test",
      "content": "LoremIpsum. DartLang",
      "language": "Flutter",
      "imagePath": "",
      "specialLink": "www.google.fr",
    });
    final knowledgeId = postResponse.body.as<Map>()["id"];
    final getResponse = await harness.agent.get("/knowledge/$knowledgeId");
    expectResponse(getResponse, 200, body: {
      "id": 1,
      "name": "Test",
      "content": "LoremIpsum. DartLang",
      "language": "Flutter",
      "imagePath": "",
      "specialLink": "www.google.fr",
    });
  });

  test("After POST to /knowledgeAdmin, delete /knowledgeAdmin then GET /knowledge/:id returns 404 not found", () async {
    final registerResponse = await harness.publicAgent
        .post("/register", body: {
      "username": "bob@stablekernel.com",
      "password": "foobaraxegrind12%"
    });
    final String accessToken = registerResponse.body.as()["access_token"]
        .toString();
    final userAgent = Agent.from(harness.agent)
      ..bearerAuthorization = accessToken;
    final postResponse = await userAgent.post("/knowledgeAdmin", body: {
      "name": "Test",
      "content": "LoremIpsum. DartLang",
      "language": "Flutter",
      "imagePath": "",
      "specialLink": "www.google.fr",
    });
    final knowledgeId = postResponse.body.as<Map>()["id"];
    await userAgent.delete("/knowledgeAdmin/$knowledgeId");
    final getResponse = await harness.agent.get("/knowledge/$knowledgeId");
    expectResponse(getResponse, 404);
  });

  test("After POST to /knowledgeAdmin, update /knowledgeAdmin then GET /knowledge/:id returns 200 with new information", () async {
    final registerResponse = await harness.publicAgent
        .post("/register", body: {
      "username": "bob@stablekernel.com",
      "password": "foobaraxegrind12%"
    });
    final String accessToken = registerResponse.body.as()["access_token"]
        .toString();
    final userAgent = Agent.from(harness.agent)
      ..bearerAuthorization = accessToken;
    await userAgent.post("/knowledgeAdmin", body: {
      "name": "Test",
      "content": "LoremIpsum. DartLang",
      "language": "Flutter",
      "imagePath": "",
      "specialLink": "www.google.fr",
    });
    final updateResponse = await userAgent.put("/knowledgeAdmin", body: {
      "id": 1,
      "name": "Test2",
      "content": "LoremIpsum. DartLang",
      "language": "Flutter",
      "imagePath": "",
      "specialLink": "www.google.fr",
    });
    expectResponse(updateResponse, 200, body: {
      "id": 1,
      "name": "Test2",
      "content": "LoremIpsum. DartLang",
      "language": "Flutter",
      "imagePath": "",
      "specialLink": "www.google.fr",
    });
  });
}