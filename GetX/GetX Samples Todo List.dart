import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}


class HomePage extends StatelessWidget {
  // To inizilazing controller to acess
  final DataController controller = Get.put(DataController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GetX Demo'),
        actions: [
          IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {
                Get.to(() => Favorite());
              }),
          IconButton(
              icon: Icon(Icons.archive),
              onPressed: () {
                Get.to(() => Archive());
              })
        ],
      ),
      body: Center(
        child: Obx(
          () {
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              itemCount: controller.items.length,
              itemBuilder: (context, indext) {
                return Dismissible(
                  key: UniqueKey(),
                  background: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(Icons.favorite),
                    ),
                  ),
                  secondaryBackground: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.archive,
                      ),
                    ),
                  ),
                  onDismissed: (DismissDirection direction) {
                    // To controll the direction of dissmissed
                    // on right (Start to end) item go to achive
                    // on left (end to Start) item go to favorite
                    var removedItem = controller.items[indext];
                    controller.items.removeAt(indext);
                    if (direction == DismissDirection.endToStart) {
                      controller.archivedItems.add(removedItem);
                    } else if (direction == DismissDirection.startToEnd) {
                      controller.favoriteItems.add(removedItem);
                    }
                  },
                  child: Card(
                    elevation: 10,
                    child: SizedBox(
                      height: 50,
                      child: ListTile(
                        title: Text(controller.items[indext].productName),
                        onTap: () {
                          Get.to(() => EntryScreen(indext: indext));
                        },
                      ),
                    ),
                  ),
                ); //card
              },
            ); //listView buider
          },
        ), //box
      ), //center
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Get.to(() => EntryScreen());
        },
      ),
    );
  }
}

class EntryScreen extends StatelessWidget {
  final DataController controller = Get.find<DataController>();
  final int indext;
  EntryScreen({this.indext});

  @override
  Widget build(BuildContext context) {
    String text = '';
    if (this.indext != null) {
      text = controller.items[this.indext].productName;
    }
    final TextEditingController textController =
        TextEditingController(text: text);

    return Scaffold(
      appBar: AppBar(
        title: Text('Entry Page'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: textController,
                autofocus: true,
                maxLines: 99,
                decoration: InputDecoration(
                    hintText: 'alkc',
                    hintStyle: TextStyle(fontSize: 30, color: Colors.grey[300]),
                    border: InputBorder.none),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          onPressed: () {
            if (this.indext != null) {
              var editing = controller.items[this.indext];
              editing.productName = textController.text;
              controller.items[this.indext] = editing;
            } else {
              Product product = Product(productName: textController.text);
              controller.items.add(product);
            }
            Get.back();
          }),
    );
  }
}

class Favorite extends StatelessWidget {
  final DataController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite'),
        actions: [
          Icon(Icons.favorite),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: controller.deleteFavoriteItems,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () {
            return controller.favoriteItems.length == 0
                ? Center(
                    child: Text(
                      'Empty List',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: controller.favoriteItems.length,
                    itemBuilder: (context, indext) {
                      return Card(
                        elevation: 10,
                        child: ListTile(
                          title: Text(
                              '${controller.favoriteItems[indext].productName}'),
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}

class Archive extends StatelessWidget {
  final DataController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Archive'),
        actions: [
          Icon(Icons.archive),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: controller.deleteAchivedItem,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () {
            return controller.archivedItems.length == 0
                ? Center(
                    child: Text(
                      'Empty List',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: controller.archivedItems.length,
                    itemBuilder: (context, indext) {
                      return Card(
                        elevation: 10,
                        child: ListTile(
                          title: Text(
                              '${controller.archivedItems[indext].productName}'),
                        ),
                      );
                    });
          },
        ),
      ),
    );
  }
}

class Product {
  String productName;
  Product({this.productName});
}

class DataController extends GetxController {
  var items = <Product>[
    Product(productName: 'Ink Pen'),
    Product(productName: 'Scale'),
    Product(productName: 'Black Pen'),
    Product(productName: 'Pencil'),
    Product(productName: 'Rubber'),
  ].obs;
  var favoriteItems = <Product>[].obs;
  var archivedItems = <Product>[].obs;

  void deleteAchivedItem() {
    archivedItems.clear();
  }

  void deleteFavoriteItems() {
    favoriteItems.clear();
  }
}
