import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("Can create user", () async {
    final response = await harness.publicAgent
        .post("/register", body: {"username": "bob@stablekernel.com", "password": "foobaraxegrind12%"});

    expect(response, hasResponse(200, body: partial({"access_token": hasLength(greaterThan(0))})));
  });

  test("After POST to /project, GET 401 error status code", () async {
    final postResponse = await harness.agent.post("/projectAdmin", body: {
      "name":"Test",
      "content":"LoremIpsum. DartLang",
      "language": "Flutter",
      "imagePath": "",
      "specialLink":"www.google.fr",
    });
    expectResponse(postResponse, 401);
  });


  test("After POST to /project, GET /project/:id returns 200", () async {
    final registerResponse = await harness.publicAgent
        .post("/register", body: {"username": "bob@stablekernel.com", "password": "foobaraxegrind12%"});
    final String accessToken = registerResponse.body.as()["access_token"].toString();
    final userAgent = Agent.from(harness.agent)..bearerAuthorization = accessToken;
    final postResponse = await userAgent.post("/projectAdmin", body: {
      "name":"Test",
      "content":"LoremIpsum. DartLang",
      "language": "Flutter",
      "imagePath": "",
      "specialLink":"www.google.fr",
    });
    expectResponse(postResponse, 200);

  });

  test("After POST to /project, GET /project/:id returns 200 with correct boody", () async {
    final registerResponse = await harness.publicAgent
        .post("/register", body: {"username": "bob@stablekernel.com", "password": "foobaraxegrind12%"});
    final String accessToken = registerResponse.body.as()["access_token"].toString();
    final userAgent = Agent.from(harness.agent)..bearerAuthorization = accessToken;
    final postResponse = await userAgent.post("/projectAdmin", body: {
      "name":"Test",
      "content":"LoremIpsum. DartLang",
      "language": "Flutter",
      "imagePath": "",
      "specialLink":"www.google.fr",
    });
    final projectId = postResponse.body.as<Map>()["id"];
    final getResponse = await harness.agent.get("/project/$projectId");
    expectResponse(getResponse, 200, body : {
      "id": 1,
      "name": "Test",
      "content": "LoremIpsum. DartLang",
      "language": "Flutter",
      "imagePath": "",
      "specialLink": "www.google.fr",
      "type":"Project"
    });
  });

  test("After POST to /project, delete t/project then GET /project/:id returns 404 not found", () async {
    final registerResponse = await harness.publicAgent
        .post("/register", body: {"username": "bob@stablekernel.com", "password": "foobaraxegrind12%"});
    final String accessToken = registerResponse.body.as()["access_token"].toString();
    final userAgent = Agent.from(harness.agent)..bearerAuthorization = accessToken;
    final postResponse = await userAgent.post("/projectAdmin", body: {
      "name":"Test",
      "content":"LoremIpsum. DartLang",
      "language": "Flutter",
      "imagePath": "",
      "specialLink":"www.google.fr",
    });
    final projectId = postResponse.body.as<Map>()["id"];
    await userAgent.delete("/projectAdmin/$projectId");
    final getResponse = await harness.agent.get("/project/$projectId");
    expectResponse(getResponse, 404);
  });

  test("After POST to /project, update /project then GET /project/:id returns 200 with new information", () async {
    final registerResponse = await harness.publicAgent
        .post("/register", body: {"username": "bob@stablekernel.com", "password": "foobaraxegrind12%"});
    final String accessToken = registerResponse.body.as()["access_token"].toString();
    final userAgent = Agent.from(harness.agent)..bearerAuthorization = accessToken;
    await userAgent.post("/projectAdmin", body: {
      "name":"Test",
      "content":"LoremIpsum. DartLang",
      "language": "Flutter",
      "imagePath": "",
      "specialLink":"www.google.fr",
    });
    final updateResponse = await userAgent.put("/projectAdmin",body: {
      "id": 1,
      "name":"Test2",
      "content":"LoremIpsum. DartLang",
      "language": "Flutter",
      "imagePath": "",
      "specialLink":"www.google.fr",
    });
    expectResponse(updateResponse, 200, body : {
      "id": 1,
      "name": "Test2",
      "content": "LoremIpsum. DartLang",
      "language": "Flutter",
      "imagePath": "",
      "specialLink": "www.google.fr",
      "type":"Project"
    });
  });


}
