import '../portfolio_api.dart';

class Project extends ManagedObject<_Project> implements _Project {}

class _Project {
  @primaryKey
  int id;

  @Column(nullable: false)
  String name;

  @Column(nullable: false)
  String content;

  @Column(nullable: false)
  String language;

  @Column(nullable: false)
  String specialLink;

  @Column(nullable: false)
  String imagePath;
}