import 'package:portfolio_api/model/Home.dart';

import '../portfolio_api.dart';

class HomeAdminController extends ResourceController{
  HomeAdminController(this.context);

  final ManagedContext context;

  @Operation.delete()
  Future<Response> removeHome() async {
    final homeQuery = Query<Home>(context)
      ..where((h) => h.id).equalTo(1);

    final int home = await homeQuery.delete();

    if (home == 0) {
      return Response.notFound();
    }
    return Response.accepted();
  }

  @Operation.post()
  Future<Response> createHome(@Bind.body(ignore: ["id"]) Home inputHome) async {
    final query = Query<Home>(context)
      ..values = inputHome;

    final insertedHome = await query.insert();

    return Response.ok(insertedHome);
  }

  @Operation.put()
  Future<Response> updateHome(@Bind.body() Home home) async {
    final query = Query<Home>(context)
      ..values.specialLink = home.specialLink
      ..values.imagePath = home.imagePath
      ..values.content = home.content
      ..where((u) => u.id).equalTo(home.id);
    final homeUpdated = await query.updateOne();

    if (homeUpdated == null) {
      return Response.notFound();
    }
    return Response.ok(homeUpdated);
  }



}