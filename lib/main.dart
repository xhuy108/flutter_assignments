import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const methodChannel = MethodChannel('com.example.bai7/method');
  static const eventChannel = EventChannel('com.example.bai7/event');

  String isSensorAvailable = 'Unknown';
  double pressureReading = 0.0;
  late StreamSubscription pressureStreamSubscription;

  Future<void> checkAvailability() async {
    try {
      final bool result = await methodChannel.invokeMethod('isSensorAvailable');
      setState(() {
        isSensorAvailable = result ? 'Available' : 'Not available';
      });
    } on PlatformException catch (e) {
      setState(() {
        isSensorAvailable = 'Failed to check: ${e.message}';
      });
    }
  }

  void _startReading() {
    pressureStreamSubscription =
        eventChannel.receiveBroadcastStream().listen((dynamic event) {
      setState(() {
        pressureReading = event as double;
      });
    }, onError: (dynamic error) {
      setState(() {
        pressureReading = 0.0;
      });
    });
  }

  void _stopReading() {
    setState(() {
      pressureReading = 0.0;
    });
    pressureStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sensor availability: $isSensorAvailable',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            ElevatedButton(
              onPressed: () => checkAvailability(),
              child: Text(
                'Check availability',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 20),
            if (pressureReading != 0)
              Text(
                'Pressure reading: $pressureReading',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            if (isSensorAvailable == 'Available' && pressureReading == 0)
              ElevatedButton(
                onPressed: () => _startReading(),
                child: Text(
                  'Start reading',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            if (pressureReading != 0)
              ElevatedButton(
                onPressed: () => _stopReading(),
                child: Text(
                  'Stop reading',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
