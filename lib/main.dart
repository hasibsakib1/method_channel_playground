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

  // TASK 3: Two controllers for numbers
  final TextEditingController _num1Controller = TextEditingController();
  final TextEditingController _num2Controller = TextEditingController();

  String _nativeResult = 'Result: -';

  Future<void> _computeSum() async {
    String message;
    try {
      final int num1 = int.tryParse(_num1Controller.text) ?? 0;
      final int num2 = int.tryParse(_num2Controller.text) ?? 0;

      // 2. INVOKE METHOD: Sending integers
      // Note: We expect an 'int' back, not a String!
      final int sum = await platform.invokeMethod('computeSum', {
        'a': num1,
        'b': num2,
      });
      message = 'Result: $sum';
    } on PlatformException catch (e) {
      message = "Error: '${e.message}'.";
    }

    setState(() {
      _nativeResult = message;
    });
  }

  @override
  void dispose() {
    _num1Controller.dispose();
    _num2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task 3: Compute Sum (Native)')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _num1Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Number A'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _num2Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Number B'),
            ),
            const SizedBox(height: 20),
            Text(
              _nativeResult,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _computeSum,
              child: const Text('Compute Sum on Native'),
            ),
          ],
        ),
      ),
    );
  }
}
