import 'dart:async';

import 'package:aqueduct/aqueduct.dart';
import 'package:portfolio_api/model/Project.dart';

class GlobalController extends ResourceController {
  GlobalController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllProjectsAndAboutMeAndCV({@Bind.query('name') String name}) async {
    final projectQuery = Query<Project>(context);
    if (name != null) {
      projectQuery.where((h) => h.name).contains(name, caseSensitive: false);
    }
    final projects = await projectQuery.fetch();

    return Response.ok(projects);
  }

  @Operation.post()
  Future<Response> createProject(@Bind.body(ignore: ["id"]) Project inputProject) async {
    final query = Query<Project>(context)
      ..values = inputProject;

    final insertedProject = await query.insert();

    return Response.ok(insertedProject);
  }
  @Operation.get('id')
  Future<Response> getProjectByID(@Bind.path('id') int id) async {
    final projectQuery = Query<Project>(context)
      ..where((h) => h.id).equalTo(id);

    final project = await projectQuery.fetchOne();

    if (project == null) {
      return Response.notFound();
    }
    return Response.ok(project);
  }
}