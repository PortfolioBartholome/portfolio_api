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
      "specialLink":"www.google.fr",
      "projectType":"project"
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
      "specialLink":"www.google.fr",
      "projectType":"project"
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
      "specialLink":"www.google.fr",
      "projectType":"project"
    });
    final projectId = postResponse.body.as<Map>()["id"];
    final getResponse = await harness.agent.get("/project/$projectId");
    expectResponse(getResponse, 200, body : {
      "id": 1,
      "name": "Test",
      "content": "LoremIpsum. DartLang",
      "language": "Flutter",
      "specialLink": "www.google.fr",
      "projectType": "project",
      "user": null
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
      "specialLink":"www.google.fr",
      "projectType":"project"
    });
    final projectId = postResponse.body.as<Map>()["id"];
    await userAgent.delete("/projectAdmin/$projectId");
    final getResponse = await harness.agent.get("/project/$projectId");
    expectResponse(getResponse, 404);
  });


}
