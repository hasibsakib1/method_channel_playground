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

  // TASK 4: Error Handling demonstration
  String _status = 'Ready';

  Future<void> _forceError() async {
    String message;
    try {
      // 2. INVOKE METHOD: Calling a method that intentionally fails
      await platform.invokeMethod('forceError');
      message = 'Success! (Should not happen)';
    } on PlatformException catch (e) {
      // 3. CATCH ERROR: We catch the error sent from Native
      message =
          "Caught error:\nCode: ${e.code}\nMessage: ${e.message}\nDetails: ${e.details}";
    } catch (e) {
      // Catching other errors (like the one you caused earlier!)
      message = "Unknown error: $e";
    }

    setState(() {
      _status = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task 4: Error Handling')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _status,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.red),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _forceError,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade100,
              ),
              child: const Text('Force Native Error'),
            ),
          ],
        ),
      ),
    );
  }
}
