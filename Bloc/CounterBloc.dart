import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CounterBloc>(
      create: (context) => CounterBloc(),
      child: const MaterialApp(
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('We Are Hear : Build Called');
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You Pushed This meney times',
              style: TextStyle(fontSize: 20),
            ),
            BlocBuilder<CounterBloc, CounterState>(
              builder: (context, state) {
                log('We Are Hear : Bloc Builder Called');
                return Text(
                  "${state.counter}",
                  style: const TextStyle(fontSize: 30),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
          onPressed: () {
            context.read<CounterBloc>().add(CounterIncrement());
          },
          child: const Icon(Icons.add),
        ),
        const SizedBox(width: 20),
        FloatingActionButton(
          onPressed: () {
            BlocProvider.of<CounterBloc>(context).add(CounterDecrement());
          },
          child: const Icon(Icons.remove),
        )
      ]),
    );
  }
}
//----------------------------------------------------------------

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  // to set initialState count on super constator
  CounterBloc() : super(InitialCounter()) {
    on<CounterIncrement>((event, emit) {
      // emit function like state state
      // heare we manuplating counter value adding or removing
      return emit(CounterState(counter: state.counter + 10));
    });

    on<CounterDecrement>((event, emit) {
      return emit(CounterState(counter: state.counter - 5));
    });
  }
}

//-------------------------------------------------

@immutable
abstract class CounterEvent {}

// to create like enumes

class CounterIncrement extends CounterEvent {}

class CounterDecrement extends CounterEvent {}

//-----------------------------------------------------

// hear we creating counter value
class CounterState {
  final int counter;

  CounterState({required this.counter});
}

class InitialCounter extends CounterState {
  InitialCounter() : super(counter: 0);
}
