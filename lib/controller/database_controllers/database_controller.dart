import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'RequestTable.dart';

class DataBaseServices{
  Database? _database;
  Future<Database?> get database async{
    if(_database != null) return _database;

    _database = await _initialize();
    return _database;
  }
  Future<String> get  fullPath async{
    const name = 'vieu.db';
    final directory = await getApplicationDocumentsDirectory();
    return join(directory.path,name);
  }
  Future<Database> _initialize() async{
    final path = await fullPath;
    return await openDatabase(path,version: 1,onCreate: _onCreate,singleInstance: true);
  }
  Future<void> _onCreate(Database database,int version)async{
    await RequestTable().createTable(database);
  }
}