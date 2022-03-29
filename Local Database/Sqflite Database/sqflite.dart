
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class Person {
  int? id;
  final String name;
  final String age;

  Person({this.id, required this.name, required this.age});

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
        id: map[DatabaseService.idOfColumn],
        name: map[DatabaseService.nameOfColumn],
        age: map[DatabaseService.ageOfColumn]);
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseService.idOfColumn: id,
      DatabaseService.nameOfColumn: name,
      DatabaseService.ageOfColumn: age,
    };
  }

  @override
  String toString() {
    return 'Person(id:$id ,name:$name, age:$age)';
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DatabaseService db;
  late TextEditingController namecontroller;
  late TextEditingController agecontroller;
  late List<Person> data;
  @override
  void initState() {
    super.initState();
    db = DatabaseService.instance;
    namecontroller = TextEditingController();
    agecontroller = TextEditingController();
    // data = db.featchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sql curd'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextField(
                controller: namecontroller,
                decoration: const InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextField(
                controller: agecontroller,
                decoration: const InputDecoration(
                  hintText: 'age',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox.square(
              child: ElevatedButton(
                child: const Text('Add'),
                onPressed: () async {
                  var person = Person(
                      name: namecontroller.text, age: agecontroller.text);
                  db.insertData(person);
                  setState(() {});
                },
              ),
            ),SizedBox.square(
              child: ElevatedButton(
                child: const Text('Delete Tabel'),
                onPressed: () async {
                 db.deleteDatatabel();
                 setState(() {
                   
                 });
                },
              ),
            ),
            Expanded(
              child: Center(
                child: FutureBuilder<List<Person>>(
                  future: db.featchData(),
                  // initialData: InitialData,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else {
                      data = snapshot.data;

                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, i) {
                            return ListTile(
                              title: Text(data[i].name),
                              subtitle: Text(data[i].age),
                            );
                          });
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DatabaseService {
  late List<Person> items;
  StreamController<List<Person>> personStreemController =
      StreamController.broadcast();
  static const databaseName = 'person.db';
  static const tabelName = 'PersonTabel';
  static const nameOfColumn = 'Name';
  static const ageOfColumn = 'Age';
  static const idOfColumn = '_id';

  DatabaseService._internal();

  static final instance = DatabaseService._internal();
  factory DatabaseService() {
    return instance;
  }

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    return await initDatabase();
  }

  initDatabase() async {
    String filePath = join(await getDatabasesPath(), databaseName);
    return await openDatabase(filePath, version: 1, onCreate: _onCreate);
  }

  _onCreate(Database db, i) {
    return db.execute('''
  CREATE TABLE $tabelName ($idOfColumn INTEGER PRIMARY KEY, $nameOfColumn TEXT, $ageOfColumn Text)
''');
  }

  Future insertData(Person person) async {
    Database db = await instance.database;
    person.id = await db.insert(tabelName, person.toMap());
    print('WE ARE HEARE ' + person.toString());
  }

  Future<List<Person>> featchData() async {
    var db = await database;
    List<Map<String, dynamic>> map = await db.query(tabelName);
    List<Person> list = map.map(
      (e) {
        return Person.fromMap(e);
      },
    ).toList();

    print('WE ARE HEAR ON FEATCH FUNCTION $list');
    return list;
  }

  Future<int> deleteDatatabel() async {
    Database db = await instance.database;

    var delete = db.delete(tabelName);
    return delete;
  }
}
