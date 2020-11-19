import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("After POST to /aboutMeAdmin, GET /aboutMe returns created home", () async {
    final registerResponse = await harness.publicAgent
        .post("/register", body: {"username": "bob@stablekernel.com", "password": "foobaraxegrind12%"});
    final String accessToken = registerResponse.body.as()["access_token"].toString();
    final userAgent = Agent.from(harness.agent)..bearerAuthorization = accessToken;
    await userAgent.post("/aboutMeAdmin", body: {
      "content": "LoremIpsum. DartLang",
      "imagePath": "",
      "specialLink": "www.google.fr",
    });
    final getResponse = await harness.agent.get("/aboutMe",);
    expectResponse(getResponse, 200);
  });

  test("After POST to /aboutMeAdmin, GET 401 error status code", () async {
    final postResponse = await harness.agent.post("/aboutMeAdmin", body: {
      "content":"LoremIpsum. DartLang",
      "imagePath": "",
      "specialLink":"www.google.fr",
    });
    expectResponse(postResponse, 401);
  });


  test("After POST to /aboutMeAdmin, GET /aboutMe returns 200", () async {
    final registerResponse = await harness.publicAgent
        .post("/register", body: {"username": "bob@stablekernel.com", "password": "foobaraxegrind12%"});
    final String accessToken = registerResponse.body.as()["access_token"].toString();
    final userAgent = Agent.from(harness.agent)..bearerAuthorization = accessToken;
    final postResponse = await userAgent.post("/aboutMeAdmin", body: {
      "content":"LoremIpsum. DartLang",
      "imagePath": "",
      "specialLink":"www.google.fr",
    });
    expectResponse(postResponse, 200);

  });

  test("After POST to /aboutMeAdmin, GET /aboutMe returns 200 with correct boody", () async {
    final registerResponse = await harness.publicAgent
        .post("/register", body: {"username": "bob@stablekernel.com", "password": "foobaraxegrind12%"});
    final String accessToken = registerResponse.body.as()["access_token"].toString();
    final userAgent = Agent.from(harness.agent)..bearerAuthorization = accessToken;
    await userAgent.post("/aboutMeAdmin", body: {
      "content":"LoremIpsum. DartLang",
      "imagePath": "",
      "specialLink":"www.google.fr",
    });
    final getResponse = await harness.agent.get("/aboutMe");
    expectResponse(getResponse, 200, body : {
      "id": 1,
      "content": "LoremIpsum. DartLang",
      "imagePath": "",
      "specialLink": "www.google.fr",
    });
  });

  test("After POST to /aboutMeAdmin, delete /aboutMeAdmin then GET /aboutMe returns 404 not found", () async {
    final registerResponse = await harness.publicAgent
        .post("/register", body: {"username": "bob@stablekernel.com", "password": "foobaraxegrind12%"});
    final String accessToken = registerResponse.body.as()["access_token"].toString();
    final userAgent = Agent.from(harness.agent)..bearerAuthorization = accessToken;
    await userAgent.post("/aboutMeAdmin", body: {
      "content":"LoremIpsum. DartLang",
      "imagePath": "",
      "specialLink":"www.google.fr",
    });
    await userAgent.delete("/aboutMeAdmin");
    final getResponse = await harness.agent.get("/aboutMe");
    expectResponse(getResponse, 404);
  });

  test("After POST to /aboutMeAdmin, update /aboutMeAdmin then GET /aboutMe returns 200 with new information", () async {
    final registerResponse = await harness.publicAgent
        .post("/register", body: {"username": "bob@stablekernel.com", "password": "foobaraxegrind12%"});
    final String accessToken = registerResponse.body.as()["access_token"].toString();
    final userAgent = Agent.from(harness.agent)..bearerAuthorization = accessToken;
    await userAgent.post("/aboutMeAdmin", body: {
      "content":"LoremIpsum. DartLang",
      "imagePath": "",
      "specialLink":"www.google.fr",
    });
    final updateResponse = await userAgent.put("/aboutMeAdmin",body: {
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
    });
  });

}