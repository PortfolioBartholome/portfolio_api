import 'package:http_server/http_server.dart';
import 'package:mime/mime.dart';
import 'package:portfolio_api/model/AboutMe.dart';
import 'package:portfolio_api/tools/FileExtension.dart';

import '../portfolio_api.dart';

class AboutMeAdminController extends ResourceController {
  AboutMeAdminController(this.context) {
    acceptedContentTypes = [
      ContentType("multipart", "form-data"),
      ContentType("application", "json")
    ];
  }

  final ManagedContext context;

  @Operation.delete()
  Future<Response> removeAboutMe() async {
    final aboutMeQuery = Query<AboutMe>(context)..where((h) => h.id).equalTo(1);

    final int aboutMe = await aboutMeQuery.delete();

    return aboutMe == 0 ? Response.notFound() : Response.accepted();
  }

  @Operation.post()
  Future<Response> createAboutMe(
      @Bind.body(ignore: ["id"]) AboutMe inputAboutMe) async {
    final query = Query<AboutMe>(context)..values = inputAboutMe;

    final insertedAboutMe = await query.insert();

    return insertedAboutMe == null
        ? Response.badRequest()
        : Response.ok(insertedAboutMe);
  }

  @Operation.put()
  Future<Response> updateHome(@Bind.body() AboutMe aboutMe) async {
    final query = Query<AboutMe>(context)
      ..values.specialLink = aboutMe.specialLink
      ..values.imagePath = aboutMe.imagePath
      ..values.content = aboutMe.content
      ..where((u) => u.id).equalTo(aboutMe.id);
    final aboutMeUpdated = await query.updateOne();

    if (aboutMeUpdated == null) {
      return Response.notFound();
    }
    return Response.ok(aboutMeUpdated);
  }

  @Operation.put('id')
  Future<Response> updateImage(@Bind.path('id') int id) async {
    final transformer = MimeMultipartTransformer(
        request.raw.headers.contentType.parameters["boundary"]);
    final bodyStream =
        Stream.fromIterable([await request.body.decode<List<int>>()]);
    final parts = await transformer.bind(bodyStream).toList();
    AboutMe aboutMe;
    for (var part in parts) {
      final HttpMultipartFormData multipart = HttpMultipartFormData.parse(part);
      final FileExtension fileExtension =
          FileExtension(part.headers['content-disposition'].split(";"));
      final String extension = fileExtension.getExtension();
      final content = multipart.cast<List<int>>();

      final now = DateTime.now().millisecondsSinceEpoch;

      final fileRegisteredPath = "public/${now}$extension";

      final fileSecretPath = "files/${now}$extension";

      final query = Query<AboutMe>(context)
        ..values.imagePath = fileSecretPath
        ..where((u) => u.id).equalTo(id);

      aboutMe = await query.updateOne();

      final IOSink sink = File(fileRegisteredPath).openWrite();
      await content.forEach(sink.add);
      await sink.flush();
      await sink.close();
    }
    return aboutMe == null ? Response.badRequest() : Response.ok(aboutMe);
  }
}
