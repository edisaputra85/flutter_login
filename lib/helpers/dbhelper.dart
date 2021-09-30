import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import '../models/user.dart';
import '../models/profile.dart';

class DbHelper {
  static DbHelper _dbHelper;
  static Database _database;

  DbHelper._createObject();

  //konstruktor dengan factory,hanya akan membuat objek jika objek belum tersedia
  factory DbHelper() {
    if (_dbHelper == null) _dbHelper = DbHelper._createObject();
    return _dbHelper;
  }

  //method untuk membuat database dan return objek database yang telah dibuat
  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';
    //perintah untuk hapus database: await deleteDatabase(path);

    //method openDatabase akan create sebuah database dan menyimpannya pada path
    var notesDatabase = openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  //method call back _createDb
  void _createDb(Database db, int version) async {
    await db.execute(
        "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT,username TEXT NOT NULL UNIQUE,password TEXT NOT NULL,email TEXT NOT NULL UNIQUE)");
    await db.execute(
        "CREATE TABLE profiles (id INTEGER PRIMARY KEY AUTOINCREMENT,id_user INTEGER NOT NULL, fullname TEXT,phone TEXT,address TEXT)");
  }

  //method untuk mengecek apakah DB sudah ada? kalau belum create DB
  Future<Database> getDatabase() async {
    if (_database == null) _database = await initDb();
    return _database;
  }

  //Create record
  Future<int> insert(User object) async {
    Database db = await this.getDatabase();
    int count = await db.insert('users', object.toMap());
    return count;
  }

  //Create record
  Future<int> insertProfile(Profile object) async {
    Database db = await this.getDatabase();
    int count = await db.insert('profiles', object.toMap());
    return count;
  }

  //Read
  Future<List<Map<String, dynamic>>> select(
      String username, String password) async {
    Database db = await this.getDatabase();
    var mapList = await db.query('users',
        where: "username='$username' AND password='$password'");
    return mapList;
  }

  //Read
  Future<List<Map<String, dynamic>>> selectProfile(int idUser) async {
    Database db = await this.getDatabase();
    var mapList = await db.query('profiles', where: "id_user='$idUser'");
    return mapList;
  }

  //delete
  Future<int> delete(int id) async {
    Database db = await this.getDatabase();
    int count = await db.delete('users', where: "id =?", whereArgs: [id]);
    return count;
  }

  Future<int> deleteAll() async {
    Database db = await this.getDatabase();
    int count = await db.delete('users');
    return count;
  }

  Future<int> updateProfile(Profile object) async {
    Map<String, dynamic> map = object.toMap();
    int idUser = map['id_user'];
    String fullname = map['fullname'];
    String phone = map['phone'];
    String address = map['address'];
    Database db = await this.getDatabase();
    int count = await db.rawUpdate(
        'UPDATE PROFILES SET fullname = ?, phone = ? , address=? WHERE id_user = ?',
        ['$fullname', '$phone', '$address', '$idUser']);
    return count;
  }
}
