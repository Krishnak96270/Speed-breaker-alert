import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await openDatabase(
      join(await getDatabasesPath(), 'sb.db'),
      onCreate: (db, v) async {
        await db.execute("CREATE TABLE points(id INTEGER PRIMARY KEY, latitude REAL, longitude REAL, timestamp TEXT)");
      },
      version: 1,
    );
    return _db!;
  }

  static Future insert(double lat, double lon) async {
    final d = await db;
    await d.insert("points", {
      "latitude": lat,
      "longitude": lon,
      "timestamp": DateTime.now().toString()
    });
  }
}
