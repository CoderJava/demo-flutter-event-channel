import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

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
  final eventChannel = const EventChannel('timerEventChannel');
  final valueNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    eventChannel.receiveBroadcastStream().listen((event) {
      if (event is int) {
        valueNotifier.value = event;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Channel'),
      ),
      body: Center(
        child: ValueListenableBuilder<int>(
          valueListenable: valueNotifier,
          builder: (BuildContext context, int value, Widget? child) {
            return Text(
              '$value',
              style: Theme.of(context).textTheme.headline6,
            );
          },
        ),
      ),
    );
  }
}
