import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("After POST to /homeAdmin, GET /home returns created home", () async {
    final registerResponse = await harness.publicAgent
        .post("/register", body: {"username": "bob@stablekernel.com", "password": "foobaraxegrind12%"});
    final String accessToken = registerResponse.body.as()["access_token"].toString();
    final userAgent = Agent.from(harness.agent)..bearerAuthorization = accessToken;
    await userAgent.post("/homeAdmin", body: {
      "content": "LoremIpsum. DartLang",
      "imagePath": "",
      "specialLink": "www.google.fr",
    });
    final getResponse = await harness.agent.get("/home",);
    expectResponse(getResponse, 200);
  });

  test("After POST to /homeAdmin, GET 401 error status code", () async {
    final postResponse = await harness.agent.post("/homeAdmin", body: {
      "content":"LoremIpsum. DartLang",
      "imagePath": "",
      "specialLink":"www.google.fr",
    });
    expectResponse(postResponse, 401);
  });


  test("After POST to /homeAdmin, GET /home returns 200", () async {
    final registerResponse = await harness.publicAgent
        .post("/register", body: {"username": "bob@stablekernel.com", "password": "foobaraxegrind12%"});
    final String accessToken = registerResponse.body.as()["access_token"].toString();
    final userAgent = Agent.from(harness.agent)..bearerAuthorization = accessToken;
    final postResponse = await userAgent.post("/homeAdmin", body: {
      "content":"LoremIpsum. DartLang",
      "imagePath": "",
      "specialLink":"www.google.fr",
    });
    expectResponse(postResponse, 200);

  });

  test("After POST to /homeAdmin, GET /home returns 200 with correct boody", () async {
    final registerResponse = await harness.publicAgent
        .post("/register", body: {"username": "bob@stablekernel.com", "password": "foobaraxegrind12%"});
    final String accessToken = registerResponse.body.as()["access_token"].toString();
    final userAgent = Agent.from(harness.agent)..bearerAuthorization = accessToken;
    await userAgent.post("/homeAdmin", body: {
      "content":"LoremIpsum. DartLang",
      "imagePath": "",
      "specialLink":"www.google.fr",
    });
    final getResponse = await harness.agent.get("/home");
    expectResponse(getResponse, 200, body : {
      "id": 1,
      "content": "LoremIpsum. DartLang",
      "imagePath": "",
      "specialLink": "www.google.fr",
      "type":"Home"
    });
  });

  test("After POST to /homeAdmin, delete /homeAdmin then GET /home returns 404 not found", () async {
    final registerResponse = await harness.publicAgent
        .post("/register", body: {"username": "bob@stablekernel.com", "password": "foobaraxegrind12%"});
    final String accessToken = registerResponse.body.as()["access_token"].toString();
    final userAgent = Agent.from(harness.agent)..bearerAuthorization = accessToken;
    await userAgent.post("/homeAdmin", body: {
      "content":"LoremIpsum. DartLang",
      "imagePath": "",
      "specialLink":"www.google.fr",
    });
    await userAgent.delete("/homeAdmin");
    final getResponse = await harness.agent.get("/home");
    expectResponse(getResponse, 404);
  });

  test("After POST to /homeAdmin, update /homeAdmin then GET /home returns 200 with new information", () async {
    final registerResponse = await harness.publicAgent
        .post("/register", body: {"username": "bob@stablekernel.com", "password": "foobaraxegrind12%"});
    final String accessToken = registerResponse.body.as()["access_token"].toString();
    final userAgent = Agent.from(harness.agent)..bearerAuthorization = accessToken;
    await userAgent.post("/homeAdmin", body: {
      "content":"LoremIpsum. DartLang",
      "imagePath": "",
      "specialLink":"www.google.fr",
    });
    final updateResponse = await userAgent.put("/homeAdmin",body: {
      "id": 1,
      "content":"LoremIpsum. ErtLang",
      "imagePath": "",
      "specialLink":"www.google.fr",
    });
    expectResponse(updateResponse, 200, body : {
      "id": 1,
      "content": "LoremIpsum. ErtLang",
      "imagePath": "",
      "specialLink": "www.google.fr",
      "type":"Home"
    });
  });

}