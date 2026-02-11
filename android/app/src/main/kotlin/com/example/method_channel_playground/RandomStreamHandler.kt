package com.example.method_channel_playground

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel
import java.util.Timer
import java.util.TimerTask
import java.util.Random

class RandomStreamHandler : EventChannel.StreamHandler {

    private var eventSink: EventChannel.EventSink? = null
    private var timer: Timer? = null
    private val random = Random()

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        
        // 2. GET MAP: Cast arguments to Map
        val args = arguments as? Map<String, Int>
        val min = args?.get("min") ?: 0
        val max = args?.get("max") ?: 100

        timer = Timer()
        // Emit a random number every 2 seconds
        timer?.schedule(object : TimerTask() {
            override fun run() {
                val bound = if (max > min) max - min else 1
                val offset = min
                val randomNumber = random.nextInt(bound) + offset

                Handler(Looper.getMainLooper()).post {
                    eventSink?.success("Random ($min-$max): $randomNumber")
                }
            }
        }, 0, 2000)
    }

    override fun onCancel(arguments: Any?) {
        timer?.cancel()
        timer = null
        eventSink = null
    }
}
