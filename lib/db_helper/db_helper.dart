
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../modal_class/notes.dart';


class DatabaseHelper {

  static const NameOfDatabase = "note";
  static const table = "note_table";
  static const version = 4;
  static Database  databases;
  static DatabaseHelper  databaseHelper;

  static String
      id = 'id' ,
      title = 'title' ,
      description = 'description',
      date = 'date' ,
      color = 'color' ,
      priority = 'priority' ;

  DatabaseHelper(Database database) {
    databases = database ;
  }

  static Future<DatabaseHelper> getInstance() async {
    if (databaseHelper == null) {
      databaseHelper = DatabaseHelper(
        await database());
    }
    return  Future.value(databaseHelper);
  }


  static Future<Database> database() async {
    // open
    var DatabasesPath = join(await getDatabasesPath(), NameOfDatabase);
    var database = await  openDatabase(DatabasesPath, version: version , onCreate: (db, version) {
      db.execute('CREATE TABLE $table($id INTEGER PRIMARY KEY AUTOINCREMENT , $title TEXT, ''$description TEXT, $priority INTEGER, $color INTEGER,$date TEXT)');},
        onUpgrade: (db, oldVersion, newVersion) {});

    return Future.value(database);
  }


  Future<int> insert_note(Note note) async {
    Database database = await databases;
    return await database.insert(table,
        note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<int> update_note(Note note)  async{
    Database database = await databases;
    return await database.update(table, note.toMap(),
        where: '$id = ?',
        whereArgs: [note.id],
        // conflictAlgorithm: ConflictAlgorithm.replace
    );
  }


  Future<List<Map<String, dynamic>>> list_of_notes() async {
    Database database = await databases;
    return await database.query(table, orderBy: '$priority ASC');
  }


  Future<List<Note>> all_note() async {
    var note = await list_of_notes();
    int count = note.length;
    List<Note> list = [];
    for (int i = 0; i < count; i++) {
      list.add(Note.fromNote(note[i]));}
    return list;


  }



  Future<int> delete_note(Note note)  async{
    Database database = await databases;
    return await database.delete(table,
        where: '$id = ?',
        whereArgs: [note.id]
    );
  }

  void close(){
    databases?.close();
  }


}