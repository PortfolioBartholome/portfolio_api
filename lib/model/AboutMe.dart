import 'package:portfolio_api/model/Element.dart';

import '../portfolio_api.dart';

class AboutMe extends ManagedObject<_AboutMe> implements _AboutMe {}

class _AboutMe extends Element {
  @override
  @primaryKey
  int id;

  @override
  @Column(nullable: false)
  String content;

  @override
  @Column(nullable: false)
  String specialLink;

  @override
  @Column(nullable: false)
  String imagePath;

  @override
  Map<String, dynamic> asMap() {
    return {
      'id' : id,
      'content': content,
      'specialLink':specialLink,
      'imagePath':imagePath,
    };
  }

  @override
  void readFromMap(Map<String, dynamic> object) {
    id =  object['id'] as int;
    content = object['content'] as String;
    specialLink = object['specialLink'] as String;
    imagePath = object['imagePath'] as String;
  }
}