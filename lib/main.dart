// ToDo App
// import 'dart:html';
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

class _MyHomePageState extends State<MyHomePage> {
  bool _isTicked = true;
  final todos = [
    'Wash Car',
    'Empty Recycling',
    'Pay Car Insurance',
    'Call plumbers',
    'Get quote for office shed',
    'Get haircut',
    'Call family',
    'Watch Mandalorian',
  ];

  void addItem() {
    setState(() {
      todos.add(toDoController.text);
    });
  }

  // toggle todo checkbox
  void toggleToDo() {
    setState(() {
      _isTicked = !_isTicked;
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
    // Generate some dummy list for ListView
    // final todos = List<String>.generate(10, (i) => "ToDo items $i");
    print(todos);

    final todoListView = ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Dismissible(
          key: Key(todo),
          onDismissed: (direction) {
            setState(() {
              todos.removeAt(index);
            });
            // Then show a snackbar.
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text("$todo deleted!")));
          },
          // Show a red background as the item is swiped away.
          background: Container(color: Colors.red),
          child: ListTile(
            leading: IconButton(
                icon: (_isTicked
                    ? Icon(Icons.check_box)
                    : Icon(Icons.check_box_outline_blank)),
                onPressed: () => {print('icon button pressed'), toggleToDo()}),
            // leading: (_isTicked
            //     ? Icon(Icons.check_box)
            //     : Icon(Icons.check_box_outline_blank)),
            title: Text(
              '$todo',
              style: getTextStyle(_isTicked),
            ),
            trailing: Icon(Icons.edit),
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
                    addItem();
                  },
                )
              ],
            ));
  }
}
