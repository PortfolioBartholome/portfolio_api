import 'package:http_server/http_server.dart';
import 'package:mime/mime.dart';
import 'package:portfolio_api/model/Project.dart';

import '../portfolio_api.dart';

class ProjectAdminController extends ResourceController{
  ProjectAdminController(this.context){
    acceptedContentTypes = [ContentType("multipart", "form-data"),ContentType("application", "json")];
  }

  final ManagedContext context;

  @Operation.delete('id')
  Future<Response> removeProject(@Bind.path('id') int id) async {
    final projectQuery = Query<Project>(context)
      ..where((h) => h.id).equalTo(id);

    final int project = await projectQuery.delete();

    if (project == 0) {
      return Response.notFound();
    }
    return Response.accepted();
  }

  @Operation.post()
  Future<Response> createProject(@Bind.body(ignore: ["id"]) Project inputProject) async {
    final query = Query<Project>(context)
      ..values = inputProject;

    final insertedProject = await query.insert();

    return Response.ok(insertedProject);
  }

  @Operation.put()
  Future<Response> updateProject(@Bind.body() Project project) async {
    final query = Query<Project>(context)
      ..values.name = project.name
      ..values.specialLink = project.specialLink
      ..values.content = project.content
      ..values.language = project.language
      ..where((u) => u.id).equalTo(project.id);
    final projectUpdated = await query.updateOne();

    if (projectUpdated == null) {
      return Response.notFound();
    }
    return Response.ok(projectUpdated);
  }

  @Operation.put('id')
  Future<Response> updateImage(@Bind.path('id') int id) async {
    final transformer = MimeMultipartTransformer(request.raw.headers.contentType.parameters["boundary"]);
    final bodyStream = Stream.fromIterable([await request.body.decode<List<int>>()]);
    final parts = await transformer.bind(bodyStream).toList();

    for (var part in parts) {
      final HttpMultipartFormData multipart = HttpMultipartFormData.parse(part);

      final content = multipart.cast<List<int>>();

      final filePath = "data/${DateTime.now().millisecondsSinceEpoch}.jpg";

      final query = Query<Project>(context)
        ..values.imagePath = filePath
        ..where((u) => u.id).equalTo(id);

      await query.updateOne();

      final IOSink sink = File(filePath).openWrite();
      await content.forEach(sink.add);
      await sink.flush();
      await sink.close();
    }

    return Response.ok({});
  }


}