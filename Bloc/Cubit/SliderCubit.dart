import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => SliderCubit(),
        child: const HomePage(),
      ),
      debugShowCheckedModeBanner: false,
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
            BlocBuilder<SliderCubit, double>(
              builder: (context, state) {
                return Text(
                  "${state.round()}",
                  style: const TextStyle(fontSize: 30),
                );
              },
            ),
            BlocBuilder<SliderCubit, double>(
              builder: (context, state) {
                return Slider(
                  min: 0,
                  max: 100,
                  onChanged: (value) {
                    context.read<SliderCubit>().updatedValue(value);
                  },
                  value: state,
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Route route = MaterialPageRoute(
              // bloc provider.value use for push bloc value into next page
              builder: (_) => BlocProvider.value(
                    // value parameter must be old context not new context
                    value: context.read<SliderCubit>(),
                    child: const SecondPage(),
                  ));
          Navigator.push(context, route);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SliderCubit extends Cubit<double> {
  SliderCubit() : super(20.0);

  void updatedValue(double value) {
    double sliderValue = value;
    emit(sliderValue);
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SecondPage'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<SliderCubit, double>(
              builder: (context, state) {
                return Text(
                  "SliderValue: ${state.round()}",
                  style: const TextStyle(fontSize: 30),
                );
              },
            ),
            BlocBuilder<SliderCubit, double>(
              builder: (context, state) {
                return Slider(
                    max: 100,
                    min: 0,
                    value: state,
                    onChanged: (value) {
                      context.read<SliderCubit>().updatedValue(value);
                    });
              },
            )
          ],
        ),
      ),
    );
  }
}
