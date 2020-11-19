import '../portfolio_api.dart';

class Home extends ManagedObject<_Home> implements _Home {}

class _Home {
  @primaryKey
  int id;

  @Column(nullable: false)
  String content;

  @Column(nullable: false)
  String specialLink;

  @Column(nullable: false)
  String imagePath;
}