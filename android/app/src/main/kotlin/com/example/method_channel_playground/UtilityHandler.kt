package com.example.method_channel_playground

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class UtilityHandler {

    fun onMethodCall(call: MethodCall, result: MethodChannel.Result): Boolean {
        when (call.method) {
            "getGreeting" -> {
                val name = call.argument<String>("name") ?: "Guest"
                result.success("Hello $name from Android Native Code!")
                return true
            }
            "computeSum" -> {
                val a = call.argument<Int>("a") ?: 0
                val b = call.argument<Int>("b") ?: 0
                result.success(a + b)
                return true
            }
            "forceError" -> {
                result.error("NATIVE_ERR", "This is an error from Kotlin!", "Error Details Object")
                return true
            }
            "heavyTask" -> {
                Thread {
                    try {
                        Thread.sleep(3000)
                    } catch (e: InterruptedException) {
                        e.printStackTrace()
                    }
                    Handler(Looper.getMainLooper()).post {
                        result.success("Heavy task finished after 3 seconds.")
                    }
                }.start()
                return true
            }
            else -> return false
        }
    }
}
