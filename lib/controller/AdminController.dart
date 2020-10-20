import 'package:portfolio_api/model/Project.dart';

import '../portfolio_api.dart';

class AdminController extends ResourceController{
  AdminController(this.context);

  final ManagedContext context;

  @Operation.delete('id')
  Future<Response> removeProject(@Bind.path('id') int id) async {
    final projectQuery = Query<Project>(context)
      ..where((h) => h.id).equalTo(id);

    final int project = await projectQuery.delete();

    if (project == 0) {
      return Response.notFound();
    }
    return Response.accepted();
  }

  @Operation.post()
  Future<Response> createProject(@Bind.body(ignore: ["id"]) Project inputProject) async {
    final query = Query<Project>(context)
      ..values = inputProject;

    final insertedProject = await query.insert();

    return Response.ok(insertedProject);
  }
}