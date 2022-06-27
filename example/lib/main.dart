import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Vibrate vibration = Vibrate();
  bool _canVibrate = true;
  final Iterable<Duration> pauses = [
    const Duration(milliseconds: 500),
    const Duration(milliseconds: 1000),
    const Duration(milliseconds: 500),
  ];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    bool canVibrate = await vibration.canVibrate;
    setState(() {
      _canVibrate = canVibrate;
      _canVibrate ? debugPrint('This device can vibrate') : debugPrint('This device cannot vibrate');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Haptic Feedback Example')),
        body: Center(
          child: ListView(children: [
            ListTile(
              title: Text('Vibrate. CanVibrate? $_canVibrate'),
              leading: const Icon(Icons.vibration, color: Colors.teal),
              onTap: () async {
                bool result = await vibration.loop(frequency: 38, amplitude: 1);
                print('got result: $result');
              },
            ),
            ListTile(
              title: Text('Cancel'),
              leading: const Icon(Icons.vibration, color: Colors.teal),
              onTap: () {
                vibration.stopVibration();
              },
            ),
          ]),
        ),
      ),
    );
  }
}
