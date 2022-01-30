import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Services.init();
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

class Services {
  static late SharedPreferences prefarance;
  static const String _counterKey = 'counterKey';

  static Future<void> init() async {
    prefarance = await SharedPreferences.getInstance();
  }

  static Future<void> saveCounter(int counter) async {
    await prefarance.setInt(_counterKey, counter);
  }

  static int getData() {
    return prefarance.getInt(_counterKey) ?? 0;
  }

  static resetDate() {
    prefarance.clear();
  }
}


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int counter = 0;

  loadData() {
    int _counter = Services.getData();

    counter = _counter;
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShearPrefarance'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            counter++;
          });
          Services.saveCounter(counter);
        },
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              counter.toString(),
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Services.resetDate();
              },
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
