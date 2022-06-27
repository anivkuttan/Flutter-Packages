import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? image;
  Future pickImage(ImageSource source) async {
    try {
      var imagePath = await ImagePicker().pickImage(source: source);
      if (imagePath == null) return;
      setState(() {
        image = File(imagePath.path);
      });
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ImagePicker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            image != null ? ClipOval(child: Image.file(image!)) : const FlutterLogo(size: 120),
            ElevatedButton(
              child: const Text('From Galary'),
              onPressed: () {
                pickImage(ImageSource.gallery);
              },
            ),
            ElevatedButton(
              onPressed: () {
                pickImage(ImageSource.camera);
              },
              child: const Text('From Camera'),
            ),
          ],
        ),
      ),
    );
  }
}
