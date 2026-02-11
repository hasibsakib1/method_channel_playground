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

  String _nativeMessage = 'No data from native yet';
  final TextEditingController _controller = TextEditingController();

  Future<void> _getNativeData() async {
    String message;
    try {
      final String result = await platform.invokeMethod('getGreeting', {
        'name': _controller.text.isEmpty ? 'Anonymous' : _controller.text,
      });
      message = result;
    } on PlatformException catch (e) {
      message = "Failed to get native data: '${e.message}'.";
    }

    setState(() {
      _nativeMessage = message;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task 2: Sending Arguments')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text(_nativeMessage, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getNativeData,
              child: const Text('Get Greeting'),
            ),
          ],
        ),
      ),
    );
  }
}
