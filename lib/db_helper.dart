import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'customer_details.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE customer (
            id INTEGER PRIMARY KEY,
            customer_name TEXT,
            customer_number TEXT,
            customer_address TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertData(Map<String, dynamic> data) async {
    Database db = await database;
    return await db.insert('customer', data);
  }

  Future<List<Map<String, dynamic>>> fetchData() async{
    Database db = await database;
    return await db.query('customer');
  }
}
