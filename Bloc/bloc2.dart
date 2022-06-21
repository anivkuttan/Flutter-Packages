import 'package:bloc_sample/View/home_page.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloc'),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: 4,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Hello $index'),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Route route = MaterialPageRoute(builder: (context) {
              return const FormPage();
            });
            Navigator.of(context).push(route);
          },
          child: const Icon(Icons.add)),
    );
  }
}

class Person extends Equatable {
  final String name;
  final int age;

  const Person({
    required this.name,
    required this.age,
  });

  @override
  List<Object?> get props => [name, age];
}

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Person'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              const TextField(
                decoration: InputDecoration(
                  label: Text('Name'),
                ),
              ),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(
                  label: Text('Age'),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text('Add Person'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ))
            ],
          ),
        ));
  }
}

abstract class ListState {
  List<Person> itemList;
  ListState({this.itemList = const []});
}

class DataLoaedState extends ListState {}

class AddListState extends ListState {
  List<Person> displayList;
  AddListState({required this.displayList});
}

class ErrorState extends ListState {
  String errorMessage;
  ErrorState({required this.errorMessage});
}

class InitialState extends ListState {}

abstract class ListEvent {}

class AddEvent extends ListEvent {
  Person newPerson;
  AddEvent({required this.newPerson}) : super();
}

// class ListblocBloc extends Bloc<ListblocEvent, ListblocState> {
//   ListblocBloc() : super(InitialList(list: const [])) {
//     on<AddEvent>((event, emit) {

//     });
//   }
// }

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(InitialState()) {
    on<AddEvent>(
      (event, emit) => emit(
        AddListState(
          displayList: state.itemList.add(event.newPerson),
        ),
      ),
    );
  }
}
