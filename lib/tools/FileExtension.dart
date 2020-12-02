import 'package:path/path.dart' as p;

class FileExtension {

  FileExtension(this.tokens);
  final List<String> tokens;

  String getExtension(){
    String fileName;
    for (var i = 0; i < tokens.length; i++) {
      if (tokens[i].contains('filename')) {
        fileName = tokens[i]
            .substring(tokens[i].indexOf("=") + 2, tokens[i].length - 1);
      }
    }
    return p.extension(fileName);
  }


}