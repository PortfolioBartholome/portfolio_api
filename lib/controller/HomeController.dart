import 'dart:async';

import 'package:aqueduct/aqueduct.dart';
import 'package:portfolio_api/model/Home.dart';

class HomeController extends ResourceController {
  HomeController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getHome() async {
    final homeQuery = Query<Home>(context);

    final home = await homeQuery.fetchOne();

    return home == null ? Response.notFound() : Response.ok(home);
  }
}
