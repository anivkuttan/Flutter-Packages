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
        child: BlocConsumer<ListBloc, ListState>(
          listener: ((context, state) {}),
          builder: (context, state) {
            if (state is InitialState) {
              return const Center(
                child: Text('Add Your Contacts...'),
              );
            } else if (state is DataLoaedState) {
              if (state.displayList.isEmpty) {
                return const Center(
                  child: Text('List Empty\nplease Add Contacts...'),
                );
              } else {
                return ListView.builder(
                    itemCount: state.allList.length,
                    itemBuilder: (context, index) {
                      final person = state.allList[index];
                      return ListTile(
                        title: Text(person.name),
                        subtitle: Text('${person.age}'),
                        trailing: IconButton(
                          onPressed: () {
                            context.read<ListBloc>().add(DeleteEvent(deletedPerson: person, index: index));
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      );
                    });
              }
            } else {
              return const CircularProgressIndicator();
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
  Person copyWith(String? name, int? age) {
    return Person(name: name ?? this.name, age: age ?? this.age);
  }

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
              ),
            )
          ],
        ),
      ),
    );
  }
}

abstract class ListState extends Equatable {
  final List<Person> allList;
  const ListState({required this.allList});
}

class ErrorState extends ListState {
  final String errorMessage;
  const ErrorState({required this.errorMessage}) : super(allList: const []);

  @override
  List<Object?> get props => [errorMessage];
}

class InitialState extends ListState {
  final String initialMessage;
  const InitialState({required this.initialMessage}) : super(allList: const []);
  @override
  List<Object?> get props => [initialMessage];
}

class DataLoaedState extends ListState {
  final List<Person> displayList;
  const DataLoaedState({required this.displayList}) : super(allList: displayList);
  @override
  List<Object?> get props => [displayList];
}

abstract class ListEvent {}

class AddEvent extends ListEvent {
  Person newPerson;
  AddEvent({required this.newPerson}) : super();
}

class DeleteEvent extends ListEvent {
  Person deletedPerson;
  int index;
  DeleteEvent({required this.deletedPerson, required this.index}) : super();
}

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(const InitialState(initialMessage: 'Empty List')) {
    on<AddEvent>(
      (event, emit) {
        final state = this.state;
        emit(
          DataLoaedState(
            displayList: List.from(state.allList)..add(event.newPerson),
          ),
        );
      },
    );
    on<DeleteEvent>((event, emit) {
      final state = this.state;
      emit(
        DataLoaedState(
          displayList: List.from(state.allList)..removeAt(event.index),
        ),
      );
    });
  }
}
 //  / emit(DataLoaedState(displayList:));
        // final state = this.state;
        // emit(
        //   ListState(
        //     allList:
        //         //  state.allList..add(event.newPerson),<==its not work
        //         List.from(state.allList)..add(event.newPerson),
        //   ),
        // );
