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
            
            if (call.method == "getGreeting") {
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
