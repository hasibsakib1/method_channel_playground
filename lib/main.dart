import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MaterialApp(home: MethodChannelPage()));
}

class MethodChannelPage extends StatefulWidget {
  const MethodChannelPage({super.key});

  @override
  State<MethodChannelPage> createState() => _MethodChannelPageState();
}

class _MethodChannelPageState extends State<MethodChannelPage> {
  static const platform = MethodChannel('com.example.playground/channel');

  // TASK 5: Battery Level
  String _batteryLevel = 'Unknown battery level.';

  Future<void> _getBatteryLevel() async {
    String message;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      message = 'Battery level at $result%.';
    } on PlatformException catch (e) {
      message = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task 5: Battery Level')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _batteryLevel,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getBatteryLevel,
              child: const Text('Get Battery Level'),
            ),
          ],
        ),
      ),
    );
  }
}
