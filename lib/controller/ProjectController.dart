import 'dart:async';

import 'package:aqueduct/aqueduct.dart';
import 'package:portfolio_api/model/Project.dart';

class ProjectController extends ResourceController {
  ProjectController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllProjects() async {
    final projectQuery = Query<Project>(context);

    final projects = await projectQuery.fetch();

    return Response.ok(projects);
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