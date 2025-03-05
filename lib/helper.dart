import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;
  late Database _db;
  // this opens the database (and creates it if it doesn't exist)
  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Folders (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      time TIMESTAMP
      );

      CREATE TABLE Cards (
      id INTEGER PRIMARY KEY,
      name TEXT,
      suit TEXT,
      image TEXT,
      folder_id INTEGER,
      FOREIGN KEY (folder_id) REFERENCES Folders(id)
      );

      INSERT INTO Folders (id, name, time) VALUES
      (1, 'Hearts', CURRENT_TIMESTAMP),
      (2, 'Spades', CURRENT_TIMESTAMP),
      (3, 'Clubs', CURRENT_TIMESTAMP),
      (4, 'Diamonds', CURRENT_TIMESTAMP);

      INSERT INTO Cards (name, suit, image, folder_id) VALUES
      ('Ace', 'Hearts', 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fc/01_of_hearts_A.svg/800px-01_of_hearts_A.svg.png', 1),
      ('2', 'Hearts', 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/02_of_hearts.svg/800px-02_of_hearts.svg.png', 1),
      ('3', 'Hearts', 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fc/03_of_hearts.svg/800px-03_of_hearts.svg.png', 1),
      ('4', 'Spades', 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7a/04_of_spades.svg/800px-04_of_spades.svg.png', 2),
      ('5', 'Spades', 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/16/05_of_spades.svg/800px-05_of_spades.svg.png', 2),
      ('6', 'Spades', 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/06_of_spades.svg/800px-06_of_spades.svg.png', 2),
      ('7', 'Clubs', 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/07_of_clubs.svg/800px-07_of_clubs.svg.png', 3),
      ('8', 'Clubs', 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/08_of_clubs.svg/800px-08_of_clubs.svg.png', 3),
      ('9', 'Clubs', 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/09_of_clubs.svg/800px-09_of_clubs.svg.png', 3),
      ('10', 'Diamond', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/10_of_diamonds_-_David_Bellot.svg/232px-10_of_diamonds_-_David_Bellot.svg.png', 4),
      ('Jack', 'Diamond', 'https://upload.wikimedia.org/wikipedia/commons/a/aa/Poker-sm-234-Jd.png', 4),
      ('Queen', 'Diamond', 'https://upload.wikimedia.org/wikipedia/commons/7/70/Poker-sm-233-Qd.png', 4),
      ('King', 'Diamond', 'https://upload.wikimedia.org/wikipedia/commons/d/d0/Poker-sm-232-Kd.png', 4);
      ''');
  }

// Helper methods
// Inserts a row in the database where each key in the
//Map is a column name
// and the value is the column value. The return value
//is the id of the
// inserted row.
  Future<int> insert(String table, Map<String, dynamic> row) async {
    return await _db.insert(table, row);
  }

// All of the rows are returned as a list of maps, where each map is
// a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    return await _db.query(table);
  }

// All of the methods (insert, query, update, delete) can also be done using
// raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount(String table) async {
    final results = await _db.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(results) ?? 0;
  }

// We are assuming here that the id column in the map is set. The other
// column values will be used to update the row.
  Future<int> update(String table, Map<String, dynamic> row) async {
    int id = row['id'];
    return await _db.update(
      table,
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// Deletes the row specified by the id. The number of affected rows is
// returned. This should be 1 as long as the row exists.
  Future<int> delete(String table, int id) async {
    return await _db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
