import 'package:portfolio_api/portfolio_api.dart';

abstract class Element extends Serializable {
  int id;

  String content;

  String specialLink;

  String imagePath;

}

