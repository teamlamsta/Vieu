import 'package:sqflite/sqflite.dart';

class RequestTable {
  Future<void> createTable(Database database) async {
    print("...");

    const sql = '''CREATE TABLE request(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  patientName TEXT,
  doctorName TEXT,
  createdAt DATETIME,
  comment TEXT,
  reply TEXT,
  attachmentPath TEXT,  
  imagePath TEXT,
  status TEXT
)''';
    await database.execute(sql);
  }
  Future<void> insert(Map<String,dynamic> data,Database database) async {
    await database.insert('request', data);
  }
  Future<List<Map<String,dynamic>>> read(Database database) async {
    return await database.rawQuery('select * from request');

  }
}
