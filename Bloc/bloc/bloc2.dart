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
    return BlocProvider(
      create: (context) => ListBloc(),
      child: const MaterialApp(
        home: HomePage(),
      ),
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
        child: BlocBuilder<ListBloc, ListState>(
          builder: (context, state) {
            if (state is InitialState) {
              return Center(child: Text(state.initialMessage));
            } else {
              return ListView.builder(
                  itemCount: state.allList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(state.allList[index].name),
                      subtitle: Text('${state.allList[index].age}'),
                    );
                  });
            }
          },
        ),
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
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
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
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(
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
                      final name = nameController.text;
                      final age = int.parse(ageController.text);
                      final newPerson = Person(name: name, age: age);
                      context.read<ListBloc>().add(AddEvent(newPerson: newPerson));
                      Navigator.of(context).pop();
                    },
                  ))
            ],
          ),
        ));
  }
}

class ListState {
  List<Person> allList;
  ListState({this.allList = const []});
}

class ErrorState extends ListState {
  String errorMessage;
  ErrorState({required this.errorMessage});
}

class InitialState extends ListState {
  String initialMessage;
  InitialState({required this.initialMessage});
}

abstract class ListEvent {}

class AddEvent extends ListEvent {
  Person newPerson;
  AddEvent({required this.newPerson}) : super();
}

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(InitialState(initialMessage: 'Empty List')) {
    on<AddEvent>((event, emit) {
      final state = this.state;
      emit(
        ListState(
          allList:
              //  state.allList..add(event.newPerson),<==its not work
              List.from(state.allList)..add(event.newPerson),
        ),
      );
    });
  }
}
