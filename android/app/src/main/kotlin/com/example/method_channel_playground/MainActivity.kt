package com.example.method_channel_playground

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.playground/channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            
            // TASK 3: Compute Sum
            if (call.method == "computeSum") {
                val a = call.argument<Int>("a")
                val b = call.argument<Int>("b")
                
                if (a != null && b != null) {
                    val sum = a + b
                    // Returning an Int. MethodChannel handles the type conversion.
                    result.success(sum)
                } else {
                    result.error("INVALID_ARGS", "Numbers are null", null)
                }
            } else if (call.method == "getGreeting") {
                val name = call.argument<String>("name")
                
                if (name != null) {
                    val message = "Hello, $name from Android!"
                    result.success(message)
                } else {
                    result.error("INVALID_ARGUMENT", "Name is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
