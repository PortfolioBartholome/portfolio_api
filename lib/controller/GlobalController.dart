import 'dart:async';

import 'package:aqueduct/aqueduct.dart';
import 'package:portfolio_api/model/AboutMe.dart';
import 'package:portfolio_api/model/Element.dart';
import 'package:portfolio_api/model/Home.dart';
import 'package:portfolio_api/model/Knowledge.dart';
import 'package:portfolio_api/model/Project.dart';

class GlobalController extends ResourceController {
  GlobalController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllEverything() async {
    final projectQuery = Query<Project>(context);
    final homeQuery = Query<Home>(context);
    final knowledgeQuery = Query<Knowledge>(context);
    final aboutMeQuery = Query<AboutMe>(context);
    final projects = await projectQuery.fetch();
    final home = await homeQuery.fetch();
    final knowledge = await knowledgeQuery.fetch();
    final aboutMe = await aboutMeQuery.fetch();
    final List<Element> elements = [];
    elements.addAll(projects);
    elements.addAll(home);
    elements.addAll(aboutMe);
    elements.addAll(knowledge);
    return Response.ok(elements);
  }

}