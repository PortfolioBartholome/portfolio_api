import 'dart:async';

import 'package:aqueduct/aqueduct.dart';
import 'package:portfolio_api/model/AboutMe.dart';

class AboutMeController extends ResourceController {
  AboutMeController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAboutMe() async {
    final aboutMeQuery = Query<AboutMe>(context);

    final aboutMe = await aboutMeQuery.fetchOne();

    if(aboutMe == null)
      return Response.notFound();
    else
      return Response.ok(aboutMe);
  }


}