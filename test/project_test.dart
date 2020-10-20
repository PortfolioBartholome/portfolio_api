import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("After POST to /project, GET /project/:id returns created project", () async {

    final postResponse = await harness.agent.post("/project", body: {
      "name":"Test",
      "content":"LoremIpsum. DartLang",
      "language": "Flutter",
      "specialLink":"www.google.fr",
      "projectType":"project"
    });
    expectResponse(postResponse, 200);

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
}
