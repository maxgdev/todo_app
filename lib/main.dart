// ToDo App
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'ToDo App v1.0.1'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// ToDoItem area ---------------------------
class ToDoItem {
  String toDoDetails;
  bool checked;
  bool editable;
  ToDoItem(this.toDoDetails, this.checked, this.editable);
}

// ToDoItem  area ---------------------------
class _MyHomePageState extends State<MyHomePage> {
  final toDoList = []; // must be 0 at least NOT null
  // bool _editEnabled = false;

  // toggle todo checkbox
  void toggleToDo(todo) {
    setState(() {
      todo.checked = !todo.checked;
      print(todo.checked);
    });
  }

  // toggle editable icon
  void toggleEdit(todo) {
    setState(() {
      todo.editable = !todo.editable;
      print(todo.editable);
    });
  }

  void addtoDoItem() {
    setState(() {
      var newText = toDoController;
      var newToDo = ToDoItem(newText.text, false, false);
      toDoList.add(newToDo);
      // print(newText.text);
      toDoController.text = "";
    });
  }

  // toDoController for text input forms
  final toDoController = TextEditingController();
  // toDoController cleanup
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    toDoController.dispose();
    super.dispose();
  }

  TextStyle getTextStyle(ticked) {
    if (ticked) {
      return TextStyle(
        decoration: TextDecoration.lineThrough,
      );
    } else {
      return TextStyle(
        decoration: TextDecoration.none,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final todoListView = ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: toDoList.length,
      itemBuilder: (context, index) {
        final todo = toDoList[index];
        return Dismissible(
          key: Key(index.toString()),
          onDismissed: (direction) {
            setState(() {
              toDoList.removeAt(index);
            });
            // Then show a snackbar.
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text("${todo.toDoDetails} deleted!")));
          },
          // Show a red background as the item is swiped away.
          background: Container(color: Colors.red[200]),
          child: ListTile(
            leading: IconButton(
                icon: (todo.checked
                    ? Icon(Icons.check_box)
                    : Icon(Icons.check_box_outline_blank)),
                onPressed: () =>
                    {print('icon button pressed'), toggleToDo(todo)}),
            title: TextField(
              enabled: todo.editable,
              decoration: InputDecoration(
                hintText: '${todo.toDoDetails}',
              ),
              style: getTextStyle(todo.checked),
            ),
            trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => {
                      toggleEdit(todo),
                      print(
                          'Edit icon button pressed. Edit enabled: $todo.editable')
                    }),
          ),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: Container(
        child: todoListView,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showMaterialDialog,
        tooltip: 'Add ToDo',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("ToDo Item"),
              content: TextField(
                controller: toDoController,
                autofocus: true,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Enter ToDo item'),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Save'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    addtoDoItem();
                  },
                )
              ],
            ));
  }
}
