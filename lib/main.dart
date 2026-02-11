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

  // TASK 6: All-in-One Dashboard
  final List<String> _log = [];

  Future<void> _invoke(String taskName, Function action) async {
    setState(() {
      _log.insert(0, '[$taskName] Running...');
    });

    try {
      final result = await action();
      setState(() {
        _log.insert(0, '[$taskName] Result: $result');
      });
    } catch (e) {
      setState(() {
        _log.insert(0, '[$taskName] Error: $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task 6: Multi-Method Dashboard')),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                ElevatedButton(
                  onPressed: () => _invoke('Greeting', () async {
                    return await platform.invokeMethod('getGreeting', {
                      'name': 'Flutter Dev',
                    });
                  }),
                  child: const Text('Task 2: Get Greeting (Name: Flutter Dev)'),
                ),
                ElevatedButton(
                  onPressed: () => _invoke('Sum', () async {
                    return await platform.invokeMethod('computeSum', {
                      'a': 10,
                      'b': 20,
                    });
                  }),
                  child: const Text('Task 3: Compute Sum (10 + 20)'),
                ),
                ElevatedButton(
                  onPressed: () => _invoke('Force Error', () async {
                    await platform.invokeMethod('forceError');
                  }),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade100,
                  ),
                  child: const Text('Task 4: Force Error'),
                ),
                ElevatedButton(
                  onPressed: () => _invoke('Battery Level', () async {
                    return await platform.invokeMethod('getBatteryLevel');
                  }),
                  child: const Text('Task 5a: Get Battery Level'),
                ),
                ElevatedButton(
                  onPressed: () => _invoke('Battery Info', () async {
                    final Map result = await platform.invokeMethod(
                      'getBatteryInfo',
                    );
                    // Formatting map for readable log
                    return result.toString();
                  }),
                  child: const Text('Task 5b: Get Detailed Info'),
                ),
                ElevatedButton(
                  onPressed: () => _invoke('Heavy Task', () async {
                    return await platform.invokeMethod('heavyTask');
                  }),
                  child: const Text('Task 7: Heavy Task (Async)'),
                ),
              ],
            ),
          ),
          const Divider(thickness: 2),
          const Text(
            "Activity Log",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey.shade200,
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: _log.length,
                itemBuilder: (context, index) => Text(
                  _log[index],
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
