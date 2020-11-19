import 'package:http_server/http_server.dart';
import 'package:mime/mime.dart';
import 'package:portfolio_api/model/AboutMe.dart';

import '../portfolio_api.dart';

class AboutMeAdminController extends ResourceController{
  AboutMeAdminController(this.context){
    acceptedContentTypes = [ContentType("multipart", "form-data"),ContentType("application", "json")];
  }

  final ManagedContext context;

  @Operation.delete()
  Future<Response> removeAboutMe() async {
    final aboutMeQuery = Query<AboutMe>(context)
      ..where((h) => h.id).equalTo(1);

    final int aboutMe = await aboutMeQuery.delete();

    if (aboutMe == 0) {
      return Response.notFound();
    }
    return Response.accepted();
  }

  @Operation.post()
  Future<Response> createAboutMe(@Bind.body(ignore: ["id"]) AboutMe inputAboutMe) async {
    final query = Query<AboutMe>(context)
      ..values = inputAboutMe;

    final insertedAboutMe = await query.insert();

    return Response.ok(insertedAboutMe);
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
    final transformer = MimeMultipartTransformer(request.raw.headers.contentType.parameters["boundary"]);
    final bodyStream = Stream.fromIterable([await request.body.decode<List<int>>()]);
    final parts = await transformer.bind(bodyStream).toList();

    for (var part in parts) {
      final HttpMultipartFormData multipart = HttpMultipartFormData.parse(part);

      final content = multipart.cast<List<int>>();

      final filePath = "data/${DateTime.now().millisecondsSinceEpoch}.jpg";

      final query = Query<AboutMe>(context)
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