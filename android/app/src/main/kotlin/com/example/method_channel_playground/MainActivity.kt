package com.example.method_channel_playground

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.playground/channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            
            // TASK 5: Get Battery Level
            if (call.method == "getBatteryLevel") {
                val batteryLevel = getBatteryLevel()
                if (batteryLevel != -1) {
                   result.success(batteryLevel)
                } else {
                   result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            } else if (call.method == "forceError") {
                // 3. SEND ERROR: Send an error back to Flutter.
                // ARG 1: Error Code (String) - used to identify the error type.
                // ARG 2: Error Message (String) - human readable description.
                // ARG 3: Error Details (Any?) - extra data (Map, String, etc).
                result.error("INTENTIONAL_ERROR", "This is a test error message.", mapOf("error" to "error", "code" to "101", "details" to "Here are some extra details."))
            } else if (call.method == "computeSum") {
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

    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }
        return batteryLevel
    }
}
