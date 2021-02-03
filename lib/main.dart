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
      todos.add('Added new todo onPressed');
    });
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
                .showSnackBar(SnackBar(content: Text("$todo dismissed")));
          },
          // Show a red background as the item is swiped away.
          background: Container(color: Colors.red),
          child: ListTile(
            leading: Icon(Icons.check_box_outline_blank),
            title: Text('$todo'),
            trailing: Icon(Icons.edit),
          ),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: todoListView,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addItem,
        tooltip: 'Add ToDo',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
