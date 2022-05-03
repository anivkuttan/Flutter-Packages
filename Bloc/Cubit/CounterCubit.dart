import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (context) => CounterCubit(),
      child:const MaterialApp(
        home: HomePage(),
        debugShowCheckedModeBanner: false,
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
        title: const Text('AppBar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This Meny TIME you Clicked This Button'),
            const SizedBox(height: 30),
            BlocBuilder<CounterCubit, int>(
              builder: (context, state) {
                return Text(state.toString());
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<CounterCubit>().increment();
          // BlocProvider.of<CounterCubit>(context).increment();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}


class CounterCubit extends Cubit<int> {
  CounterCubit() : super(1);
  void increment() {
   var i= state +1;
    emit(i);
  }

  void decrement() {
  var j=  state -1;
   return emit(j);
  }
}
