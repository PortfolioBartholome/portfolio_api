import '../portfolio_api.dart';

class Knowledge extends ManagedObject<_Knowledge> implements _Knowledge {}

class _Knowledge {
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