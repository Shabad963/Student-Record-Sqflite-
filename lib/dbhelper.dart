

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:student_record/student.dart';

class DatabaseHelper{

  static final _databaseName = 'studentdb.db';
  static final _databasseVersion = 1;

  static final table = 'students_table';

  static final columnId = 'id';
  static final columnName = 'name';
  static final columnLocation = 'location';
  static final columnContact = 'contact';

DatabaseHelper._privateConstructor();
static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

static Database? _database;
Future<Database> get database async {
  if(_database != null )return _database!;
  _database = await initDatabase();
  return _database!;
  }

  initDatabase() async {
  String path = join(await getDatabasesPath(), _databaseName);
  return await openDatabase(path,
  version: _databasseVersion,
  onCreate: _onCreate);
}

Future _onCreate(Database db, int version) async {
  await db.execute('''
  CREATE TABLE $table (
  $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
  $columnName TEXT NOT NULL,
  $columnLocation TEXT NOT NULL,
  $columnContact INTEGER NOT NULL
  )
  ''');
}


Future<int> insert(Student student) async {
  Database db =await instance.database;
  return await db.insert(table, {'name': student.name, 'location': student.location, 'contact': student.contact});
}


Future<List<Map<String, dynamic>>> queryAllRows() async{
  Database db = await instance.database;
  return await db.query(table);
}

Future<List<Map<String, dynamic>>> queryRows(name) async {
  Database db = await instance.database;
  return await db.query(table, where: "$columnName LIKE '%$name%'");
}

Future<int?> queryRowCount() async {
  Database db = await instance.database;
  return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
}

Future<int> update(Student student) async {
  Database db = await instance.database;
  int id = student.toMap()['id'];
  return await db.update(table, student.toMap(), where: '$columnId = ?', whereArgs: [id]);
}

Future<int> delete(int id) async {
  Database db = await instance.database;
  return await db.delete(table, where:  '$columnId = ?', whereArgs: [id]);
}
}