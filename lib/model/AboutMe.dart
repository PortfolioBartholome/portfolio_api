import '../portfolio_api.dart';

class AboutMe extends ManagedObject<_AboutMe> implements _AboutMe {}

class _AboutMe {
  @primaryKey
  int id;

  @Column(nullable: false)
  String content;

  @Column(nullable: false)
  String specialLink;

  @Column(nullable: false)
  String imagePath;
}