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

  // TASK 6: Detailed Battery Info
  String _batteryInfo = 'No info yet';

  Future<void> _getDetailedBatteryInfo() async {
    String message;
    try {
      // 2. INVOKE METHOD: Ask for a Map of data
      final Map<dynamic, dynamic> result = await platform.invokeMethod(
        'getBatteryInfo',
      );

      final int level = result['level'];
      final bool isCharging = result['isCharging'];
      final String status = result['status'];

      message = 'Level: $level%\nCharging: $isCharging\nStatus: $status';
    } on PlatformException catch (e) {
      message = "Failed to get info: '${e.message}'.";
    }

    setState(() {
      _batteryInfo = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task 6: Detailed Battery Info')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _batteryInfo,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getDetailedBatteryInfo,
              child: const Text('Get Detailed Info'),
            ),
          ],
        ),
      ),
    );
  }
}
