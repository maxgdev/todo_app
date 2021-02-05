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
  int id;
  String toDoDetails;
  bool checked;
  ToDoItem(this.id, this.toDoDetails, this.checked);
}

// ToDoItem  area ---------------------------
class _MyHomePageState extends State<MyHomePage> {
  bool _isTicked = true;
  final toDoList = [];
  // final todos = [
  //   'Wash Car',
  //   'Empty Recycling',
  //   'Pay Car Insurance',
  //   'Call plumbers',
  //   'Get quote for office shed',
  //   'Get haircut',
  //   'Call family',
  //   'Watch Mandalorian',
  // ];

  // final todoObjects = [
  //   {0, 'Wash Car', false},
  //   {1, 'Empty Recycling', false},
  //   {2, 'Pay Car Insurance', false},
  //   {3, 'Call plumbers', false},
  //   {4, 'Get quote for office shed', false},
  //   {5, 'Get haircut', false},
  //   {6, 'Call family', false},
  //   {7, 'Watch Mandalorian', false},
  // ];

  // toggle todo checkbox
  void toggleToDo(checked) {
    setState(() {
      checked = !checked;
      print(checked);
    });
  }

  void addtoDoItem() {
    setState(() {
      toDoList.add(toDoController);
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
Wash car

    final todoListView = ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: toDoList.length,
      itemBuilder: (context, index) {
        final todo = toDoList[index];
        return Dismissible(
          key: Key(todo.id.toString()),
          onDismissed: (direction) {
            setState(() {
              toDoList.removeAt(index);
            });
            // Then show a snackbar.
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text("${todo.id} deleted!")));
          },
          // Show a red background as the item is swiped away.
          background: Container(color: Colors.red),
          child: ListTile(
            leading: IconButton(
                icon: (todo.checked
                    ? Icon(Icons.check_box)
                    : Icon(Icons.check_box_outline_blank)),
                onPressed: () =>
                    {print('icon button pressed'), toggleToDo(todo.checked)}),
            // leading: (_isTicked
            //     ? Icon(Icons.check_box)
            //     : Icon(Icons.check_box_outline_blank)),
            title: Text(
              '${todo.toDoDetails}',
              style: getTextStyle(_isTicked),
            ),
            trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => {print('Edit icon button pressed')}),
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