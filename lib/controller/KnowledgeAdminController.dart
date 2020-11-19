import 'package:portfolio_api/model/Knowledge.dart';
import 'package:portfolio_api/model/Project.dart';

import '../portfolio_api.dart';

class KnowledgeAdminController extends ResourceController{
  KnowledgeAdminController(this.context);

  final ManagedContext context;

  @Operation.delete('id')
  Future<Response> removeKnowledge(@Bind.path('id') int id) async {
    final knowledgeQuery = Query<Knowledge>(context)
      ..where((h) => h.id).equalTo(id);

    final int knowledge = await knowledgeQuery.delete();

    if (knowledge == 0) {
      return Response.notFound();
    }
    return Response.accepted();
  }

  @Operation.post()
  Future<Response> createKnowledge(@Bind.body(ignore: ["id"]) Knowledge knowledge) async {
    final query = Query<Knowledge>(context)
      ..values = knowledge;

    final insertedKnowledge = await query.insert();

    return Response.ok(insertedKnowledge);
  }

  @Operation.put()
  Future<Response> updateKnowledge(@Bind.body() Knowledge knowledge) async {
    final query = Query<Knowledge>(context)
      ..values.name = knowledge.name
      ..values.specialLink = knowledge.specialLink
      ..values.content = knowledge.content
      ..values.language = knowledge.language
      ..where((u) => u.id).equalTo(knowledge.id);
    final knowledgeUpdated = await query.updateOne();

    if (knowledgeUpdated == null) {
      return Response.notFound();
    }
    return Response.ok(knowledgeUpdated);
  }



}