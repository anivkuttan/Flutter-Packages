import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  //  using Any Actions before runApp method 
  // check everything
  WidgetsFlutterBinding.ensureInitialized();
//initialsing hive
  await Hive.initFlutter();
  // opening Hive dateBase(Box) 
  await Hive.openBox<String>('Student');
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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<String> studentBox;
  List<String> item = [];
  final nameController = TextEditingController();
  final idController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // make opend Box available for this page 
    studentBox = Hive.box<String>('Student');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: const Color.fromARGB(255, 169, 236, 81),
                //value Lisnable Builder for update when value changes happens
                child: ValueListenableBuilder(
                  valueListenable: studentBox.listenable(),
                  builder: (context, Box<String> student, _) {
                    return ListView.builder(
                      itemCount: studentBox.keys.length,
                      itemBuilder: (context, i) {
                        // to get the box keys and convert to list then access through index 
                        final key = student.keys.toList()[i];
                        final value = student.values.toList()[i];

                        return ListTile(
                          title: Text(key),
                          subtitle: Text(value),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  child: const Text('Add'),
                  onPressed: () {
                    showBottom(context);
                  },
                ),
                ElevatedButton(
                  child: const Text('update'),
                  onPressed: () {
                    // update method also acting like put method
                    // using same key to update the value
                  },
                ),
                ElevatedButton(
                  child: const Text('delete'),
                  onPressed: () {
                    // clear the dataBase delete all
                    studentBox.clear();
                  },
                ),
              ],
            ),//hrhghd
          ],
        ),
      ),
    );
  }

  void showBottom(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextField(
                  controller: idController,
                  decoration: const InputDecoration(
                    hintText: 'Id',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () {
                  final key = idController.text;
                  final value = nameController.text;
                  // add to database using put method
                  // Hive also have Hive.add('Value');
                  // add method auto key value like list
                  studentBox.put(key, value);
                  // clear the controller for next add event
                  idController.clear();
                  nameController.clear();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
