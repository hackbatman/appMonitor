import 'package:app_mntr_bt/database/Json_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final databaseName = "user_appBT.db";


  String users =
      "create table users (userId INTEGER PRIMARY KEY AUTOINCREMENT, userName TEXT UNIQUE, userPassword TEXT)";


  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(users);
    });
  }


  Future<bool> login(Users user) async {
    final Database db = await initDB();

    // I forgot the password to check
    var result = await db.rawQuery(
        "select * from users where userName = '${user.userName}' AND userPassword = '${user.userPassword}'");
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //Sign up
  Future<int> signup(Users user) async {
    final Database db = await initDB();

    return db.insert('users', user.toMap());
  }
   Future<void> updatePassword(String userName, String newPassword) async {
    final Database db = await initDB();
    await db.update(
      'users',
      {'userPassword': newPassword},
      where: 'userName = ?',
      whereArgs: [userName],
    );
  }

  Future<Map<String, dynamic>?> getUser(String username) async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty ? result.first : null;
  }

}



