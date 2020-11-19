import 'dart:async';

import 'package:aqueduct/aqueduct.dart';
import 'package:portfolio_api/model/Knowledge.dart';
import 'package:portfolio_api/model/Project.dart';

class KnowledgeController extends ResourceController {
  KnowledgeController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllKnowledge() async {
    final knowledgeQuery = Query<Knowledge>(context);

    final knowledge = await knowledgeQuery.fetch();

    return Response.ok(knowledge);
  }

  @Operation.get('id')
  Future<Response> getKnowledgeByID(@Bind.path('id') int id) async {
    final knowledgeQuery = Query<Knowledge>(context)
      ..where((h) => h.id).equalTo(id);

    final knowledge = await knowledgeQuery.fetchOne();

    if (knowledge == null) {
      return Response.notFound();
    }
    return Response.ok(knowledge);
  }

}