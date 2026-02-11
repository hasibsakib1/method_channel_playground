import 'dart:async';
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
  static const eventChannel = EventChannel('com.example.playground/events');
  StreamSubscription? _timerSubscription;
  static const randomChannel = EventChannel('com.example.playground/random');
  StreamSubscription? _randomSubscription;

  // TASK 11: Network Monitor
  bool?
  _isNetworkAvailable; // null = unknown, true = connected, false = disconnected
  static const networkChannel = EventChannel('com.example.playground/network');
  StreamSubscription? _networkSubscription;

  @override
  void initState() {
    super.initState();
    // Optional: Start monitoring immediately?
    // Let's stick to buttons for manual control as per the pattern.
  }

  Future<void> _checkNetwork() async {
    try {
      final bool result = await platform.invokeMethod('isNetworkAvailable');
      setState(() {
        _isNetworkAvailable = result;
        _log.insert(
          0,
          '[Network] Check: ${result ? "Connected" : "No Internet"}',
        );
      });
    } on PlatformException catch (e) {
      setState(() {
        _log.insert(0, '[Network] Check Failed: ${e.message}');
      });
    }
  }

  void _toggleNetworkMonitor(bool enable) {
    if (enable) {
      if (_networkSubscription != null) return;
      setState(() {
        _log.insert(0, '[Network] Monitoring started...');
      });
      _networkSubscription = networkChannel.receiveBroadcastStream().listen(
        (dynamic event) {
          // event is "Connected" or "Disconnected" String from Native
          setState(() {
            _isNetworkAvailable = (event == "Connected");
            _log.insert(0, '[Network Stream] $event');
          });
        },
        onError: (dynamic error) {
          setState(() {
            _log.insert(0, '[Network Stream Error] ${error.message}');
          });
        },
      );
    } else {
      if (_networkSubscription != null) {
        _networkSubscription!.cancel();
        _networkSubscription = null;
        setState(() {
          _log.insert(0, '[Network] Monitoring stopped.');
        });
      }
    }
  }

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

  void _startTimer() {
    if (_timerSubscription != null) return;

    setState(() {
      _log.insert(0, '[EventChannel] Listening to stream...');
    });

    _timerSubscription = eventChannel.receiveBroadcastStream().listen(
      (dynamic event) {
        setState(() {
          _log.insert(0, '[Stream] $event');
        });
      },
      onError: (dynamic error) {
        setState(() {
          _log.insert(0, '[Stream Error] ${error.message}');
        });
      },
      cancelOnError: false,
    );
  }

  void _stopTimer() {
    if (_timerSubscription != null) {
      _timerSubscription!.cancel();
      _timerSubscription = null;
      setState(() {
        _log.insert(0, '[EventChannel] Stream cancelled.');
      });
    }
  }

  void _startRandom() {
    if (_randomSubscription != null) return;

    setState(() {
      _log.insert(0, '[Random] Listening to stream...');
    });

    // pass Map as argument
    _randomSubscription = randomChannel
        .receiveBroadcastStream({'min': 500, 'max': 1000})
        .listen(
          (dynamic event) {
            setState(() {
              _log.insert(0, '[Random] $event');
            });
          },
          onError: (dynamic error) {
            setState(() {
              _log.insert(0, '[Random Error] ${error.message}');
            });
          },
          cancelOnError: false,
        );
  }

  void _stopRandom() {
    if (_randomSubscription != null) {
      _randomSubscription!.cancel();
      _randomSubscription = null;
      setState(() {
        _log.insert(0, '[Random] Stream cancelled.');
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _startTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade100,
                      ),
                      child: const Text('Start Stream'),
                    ),
                    ElevatedButton(
                      onPressed: _stopTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade100,
                      ),
                      child: const Text('Stop Stream'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _startRandom,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade100,
                      ),
                      child: const Text('Start Random'),
                    ),
                    ElevatedButton(
                      onPressed: _stopRandom,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade100,
                      ),
                      child: const Text('Stop Random'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                const Text(
                  "Task 11: Network Monitor",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Icon(
                  _isNetworkAvailable == true ? Icons.wifi : Icons.wifi_off,
                  size: 50,
                  color: _isNetworkAvailable == true
                      ? Colors.green
                      : (_isNetworkAvailable == false
                            ? Colors.red
                            : Colors.grey),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _checkNetwork,
                      child: const Text('Check Status'),
                    ),
                    Switch(
                      value: _networkSubscription != null,
                      onChanged: _toggleNetworkMonitor,
                    ),
                    const Text("Monitor"),
                  ],
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
