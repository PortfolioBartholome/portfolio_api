import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration7 extends Migration { 
  @override
  Future upgrade() async {
   		database.alterColumn("_Project", "name", (c) {c.isUnique = false;});
		database.alterColumn("_Project", "content", (c) {c.isUnique = false;});
		database.alterColumn("_Project", "language", (c) {c.isUnique = false;});
		database.alterColumn("_Project", "specialLink", (c) {c.isUnique = false;});
		database.alterColumn("_Project", "projectType", (c) {c.isUnique = false;});
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    