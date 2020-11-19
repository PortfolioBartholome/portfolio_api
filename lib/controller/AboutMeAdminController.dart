import 'package:portfolio_api/model/AboutMe.dart';

import '../portfolio_api.dart';

class AboutMeAdminController extends ResourceController{
  AboutMeAdminController(this.context);

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



}