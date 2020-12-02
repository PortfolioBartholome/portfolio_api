import 'package:http_server/http_server.dart';
import 'package:mime/mime.dart';
import 'package:portfolio_api/model/Home.dart';
import 'package:portfolio_api/tools/FileExtension.dart';

import '../portfolio_api.dart';

class HomeAdminController extends ResourceController {
  HomeAdminController(this.context) {
    acceptedContentTypes = [
      ContentType("multipart", "form-data"),
      ContentType("application", "json")
    ];
  }

  final ManagedContext context;

  @Operation.delete()
  Future<Response> removeHome() async {
    final homeQuery = Query<Home>(context)..where((h) => h.id).equalTo(1);

    return await homeQuery.delete() == 0
        ? Response.notFound()
        : Response.accepted();
  }

  @Operation.post()
  Future<Response> createHome(@Bind.body(ignore: ["id"]) Home inputHome) async {
    final query = Query<Home>(context)
      ..values.imagePath = ""
      ..values.specialLink = inputHome.specialLink
      ..values.content = inputHome.content;

    final insertedHome = await query.insert();

    return insertedHome == null
        ? Response.badRequest()
        : Response.ok(insertedHome);
  }

  @Operation.put()
  Future<Response> updateHome(@Bind.body() Home home) async {
    final query = Query<Home>(context)
      ..values.specialLink = home.specialLink
      ..values.content = home.content
      ..where((u) => u.id).equalTo(home.id);
    final homeUpdated = await query.updateOne();

    if (homeUpdated == null) {
      return Response.notFound();
    }
    return Response.ok(homeUpdated);
  }

  @Operation.put('id')
  Future<Response> updateImage(@Bind.path('id') int id) async {
    final transformer = MimeMultipartTransformer(
        request.raw.headers.contentType.parameters["boundary"]);
    final bodyStream =
        Stream.fromIterable([await request.body.decode<List<int>>()]);
    final parts = await transformer.bind(bodyStream).toList();
    Home home;
    for (var part in parts) {
      final HttpMultipartFormData multipart = HttpMultipartFormData.parse(part);
      final FileExtension fileExtension = FileExtension(part.headers['content-disposition'].split(";"));
      final String extension = fileExtension.getExtension();
      final content = multipart.cast<List<int>>();

      final now = DateTime.now().millisecondsSinceEpoch;

      final fileRegisteredPath = "public/${now}$extension";

      final fileSecretPath = "files/${now}$extension";

      final query = Query<Home>(context)
        ..values.imagePath = fileSecretPath
        ..where((u) => u.id).equalTo(id);

      home = await query.updateOne();

      final IOSink sink = File(fileRegisteredPath).openWrite();
      await content.forEach(sink.add);
      await sink.flush();
      await sink.close();
    }
    return home == null ? Response.badRequest() : Response.ok(home);
  }
}
