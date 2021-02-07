import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void sqfDb() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  
  // Open the database and store the reference.
  final Future<Database> database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'todo_database.db'),
    // When the database is first created, create a table to store todos.
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE mytodo(id INTEGER PRIMARY KEY, details TEXT, checked INTEGER, editable INTEGER)",
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  /* 
  https://stackoverflow.com/questions/843780/store-boolean-value-in-sqlite
  You could simplify the above equations using the following:

    Boolean flag2 = (intValue==1)?true:false;
    
    boolean flag = sqlInt != 0;
    
    If the int representation (sqlInt) of the boolean is 0 (false), 
    the boolean (flag) will be false, otherwise it will be true.
  */

  // [C]RUD
  Future<void> insertToDo(ToDo todo) async {
    // Get a reference to the database.
    final Database db = await database;

    // Insert the ToDo into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      'mytodo',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // C[R]UD
  Future<List<ToDo>> todos() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The ToDos.
    final List<Map<String, dynamic>> maps = await db.query('mytodo');

    // Convert the List<Map<String, dynamic> into a List<ToDo>.
    return List.generate(maps.length, (i) {
      return ToDo(
        id: maps[i]['id'],
        details: maps[i]['details'],
        checked: maps[i]['checked'],
        editable: maps[i]['editable'],
      );
    });
  }

  // CR[U]D
  Future<void> updateToDo(ToDo todo) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given ToDo.
    await db.update(
      'mytodo',
      todo.toMap(),
      // Ensure that the ToDo has a matching id.
      where: "id = ?",
      // Pass the ToDo's id as a whereArg to prevent SQL injection.
      whereArgs: [todo.id],
    );
  }

  // CRU[D]
  Future<void> deleteToDo(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the ToDo from the database.
    await db.delete(
      'mytodo',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the ToDo's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
  // Insert todo1 entry
  var todo1 = ToDo(
    id: 0,
    details: 'Paint en-suite bathroom',
    checked: 0,
    editable: 0,
  );

  // Insert a dog into the database.
  await insertToDo(todo1);

  // Insert todo1 entry
  var todo2 = ToDo(
    id: 1,
    details: 'Re-new Insurance quote',
    checked: 0,
    editable: 0,
  );

  // Insert a dog into the database.
  await insertToDo(todo2);


  // Print the list of todos (only Fido for now).
  print(await todos());

  // Update chedked status to 1 - true.
  todo1 = ToDo(
    id: todo1.id,
    details: todo1.details,
    checked: 1,
    editable: 0,
  );
  await updateToDo(todo1);

  // Print Fido's updated information.
  print(await todos());

  // Delete Fido from the database.
  await deleteToDo(todo1.id);

  // Print the list of todos (empty).
  print(await todos());
}

// ------------ToDo Class---------------
class ToDo {
  final int id;
  final String details;
  final int checked;
  final int editable;

  ToDo({this.id, this.details, this.checked, this.editable});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'details': details,
      'checked': checked,
      'editable': editable,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'ToDo{id: $id, details: $details, checked: $checked, editable: $editable}';
  }
}
// ------------ToDo Class---------------

void dummyTest() {
  print("This is a function from dummy.dart file");
  
}
