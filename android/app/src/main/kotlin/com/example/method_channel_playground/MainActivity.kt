package com.example.method_channel_playground

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.playground/channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val batteryHandler = BatteryHandler(applicationContext)
        val utilityHandler = UtilityHandler()
        val timerHandler = TimerStreamHandler()
        val randomHandler = RandomStreamHandler()
        val networkHandler = NetworkHandler(applicationContext)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            
            if (batteryHandler.onMethodCall(call, result)) return@setMethodCallHandler
            if (utilityHandler.onMethodCall(call, result)) return@setMethodCallHandler
            if (networkHandler.onMethodCall(call, result)) return@setMethodCallHandler

            result.notImplemented()
        }

        io.flutter.plugin.common.EventChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.playground/events").setStreamHandler(timerHandler)
        io.flutter.plugin.common.EventChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.playground/random").setStreamHandler(randomHandler)
        io.flutter.plugin.common.EventChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.playground/network").setStreamHandler(networkHandler)
    }
}
