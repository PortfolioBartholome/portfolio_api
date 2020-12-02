import 'package:http_server/http_server.dart';
import 'package:mime/mime.dart';
import 'package:portfolio_api/model/Knowledge.dart';
import 'package:portfolio_api/tools/FileExtension.dart';

import '../portfolio_api.dart';

class KnowledgeAdminController extends ResourceController {
  KnowledgeAdminController(this.context) {
    acceptedContentTypes = [
      ContentType("multipart", "form-data"),
      ContentType("application", "json")
    ];
  }

  final ManagedContext context;

  @Operation.delete('id')
  Future<Response> removeKnowledge(@Bind.path('id') int id) async {
    final knowledgeQuery = Query<Knowledge>(context)
      ..where((h) => h.id).equalTo(id);

    final int knowledge = await knowledgeQuery.delete();

    return knowledge == 0 ? Response.notFound() : Response.accepted();
  }

  @Operation.post()
  Future<Response> createKnowledge(
      @Bind.body(ignore: ["id"]) Knowledge knowledge) async {
    final query = Query<Knowledge>(context)..values = knowledge;

    final insertedKnowledge = await query.insert();

    return insertedKnowledge == null
        ? Response.badRequest()
        : Response.ok(insertedKnowledge);
  }

  @Operation.put()
  Future<Response> updateKnowledge(@Bind.body() Knowledge knowledge) async {
    final query = Query<Knowledge>(context)
      ..values.name = knowledge.name
      ..values.specialLink = knowledge.specialLink
      ..values.content = knowledge.content
      ..values.language = knowledge.language
      ..where((u) => u.id).equalTo(knowledge.id);
    final knowledgeUpdated = await query.updateOne();

    if (knowledgeUpdated == null) {
      return Response.notFound();
    }
    return Response.ok(knowledgeUpdated);
  }

  @Operation.put('id')
  Future<Response> updateImage(@Bind.path('id') int id) async {
    final transformer = MimeMultipartTransformer(
        request.raw.headers.contentType.parameters["boundary"]);
    final bodyStream =
        Stream.fromIterable([await request.body.decode<List<int>>()]);
    final parts = await transformer.bind(bodyStream).toList();
    Knowledge knowledge;
    for (var part in parts) {
      final HttpMultipartFormData multipart = HttpMultipartFormData.parse(part);
      final FileExtension fileExtension =
          FileExtension(part.headers['content-disposition'].split(";"));
      final String extension = fileExtension.getExtension();
      final content = multipart.cast<List<int>>();

      final now = DateTime.now().millisecondsSinceEpoch;

      final fileRegisteredPath = "public/${now}$extension";

      final fileSecretPath = "files/${now}$extension";

      final query = Query<Knowledge>(context)
        ..values.imagePath = fileSecretPath
        ..where((u) => u.id).equalTo(id);

      knowledge = await query.updateOne();

      final IOSink sink = File(fileRegisteredPath).openWrite();
      await content.forEach(sink.add);
      await sink.flush();
      await sink.close();
    }
    return knowledge == null ? Response.badRequest() : Response.ok(knowledge);
  }
}
