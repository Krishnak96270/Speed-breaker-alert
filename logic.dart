
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static Database? _db;

  static Future<Database> get db async {
    _db ??= await openDatabase(
      join(await getDatabasesPath(), 'sb.db'),
      version: 1,
      onCreate: (db, v) async {
        await db.execute(
            "CREATE TABLE points(id INTEGER PRIMARY KEY, lat REAL, lon REAL, time TEXT)");
      },
    );
    return _db!;
  }

  static Future insert(double lat, double lon) async {
    final d = await db;
    await d.insert("points", {
      "lat": lat,
      "lon": lon,
      "time": DateTime.now().toString()
    });
  }

  static Future<List<Map>> getAll() async {
    final d = await db;
    return d.query("points");
  }
}
