import 'package:portfolio_api/model/Element.dart';

import '../portfolio_api.dart';

class Project extends ManagedObject<_Project> implements _Project {}

class _Project extends Element {
  @override
  @primaryKey
  int id;

  @Column(nullable: false)
  String name;

  @override
  @Column(nullable: false)
  String content;

  @Column(nullable: false)
  String language;

  @override
  @Column(nullable: false)
  String specialLink;

  @override
  @Column(nullable: false)
  String imagePath;

  @override
  @Column(nullable: false,defaultValue: "'Project'")
  String type;

  @override
  Map<String, dynamic> asMap() {
    return {
      'id' : id,
      'content': content,
      'specialLink':specialLink,
      'imagePath':imagePath,
      'language': language != null ? language : "",
      'name': name != null ? name : "",
      'type':type
    };
  }

  @override
  void readFromMap(Map<String, dynamic> object) {
    id =  object['id'] as int;
    content = object['content'] as String;
    specialLink = object['specialLink'] as String;
    imagePath = object['imagePath'] as String;
    name = object['name'] != null ? (object['name'] as String) : "";
    language = object['language'] != null ? (object['language'] as String) : "";
    type = "Project";
  }
}