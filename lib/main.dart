import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'database_helper.dart';

// Here we are using a global variable. You can use something like
// get_it in a production app.
final dbHelper = DatabaseHelper();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
// initialize the database
  await dbHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFlite Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _idController = TextEditingController();
// homepage layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sqflite'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _insert,
              child: const Text('insert'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _query,
              child: const Text('query'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _update,
              child: const Text('update'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _delete,
              child: const Text('delete'),
            ),
            ElevatedButton(
              onPressed: _searchById,
              child: const Text('searchbyID'),
            ),
            TextField(
              controller: _idController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter ID to Search',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _deleteAllRecords,
              child: const Text('deleteall the records'),
            ),
          ],
        ),
      ),
    );
  }

// Button onPressed methods
  void _insert() async {
// row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: 'Bob',
      DatabaseHelper.columnAge: 23
    };
    final id = await dbHelper.insert(row);
    debugPrint('inserted row id: $id');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    debugPrint('query all rows:');
    for (final row in allRows) {
      debugPrint(row.toString());
    }
  }

  void _update() async {
// row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: 1,
      DatabaseHelper.columnName: 'Mary',
      DatabaseHelper.columnAge: 32
    };
    final rowsAffected = await dbHelper.update(row);
    debugPrint('updated $rowsAffected row(s)');
  }

  void _delete() async {
// Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    debugPrint('deleted $rowsDeleted row(s): row $id');
  }

  void _deleteAllRecords() async {
    final rowsDeleted = await dbHelper.deleteAll();
    debugPrint('Deleted $rowsDeleted records from the database.');
  }

  void _searchById() async {
    String input = _idController.text.trim();
    if (input.isEmpty) {
      debugPrint('Please enter an ID');
      return;
    }

    int? idToSearch = int.tryParse(input);
    if (idToSearch == null) {
      debugPrint('Invalid ID. Please enter a valid number.');
      return;
    }

    final result = await dbHelper.queryById(idToSearch);
    if (result != null) {
      debugPrint('Record found: $result');
    } else {
      debugPrint('No record found with ID $idToSearch');
    }
  }
}
