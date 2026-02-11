package com.example.method_channel_playground

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel
import java.util.Timer
import java.util.TimerTask

class TimerStreamHandler : EventChannel.StreamHandler {

    private var eventSink: EventChannel.EventSink? = null
    private var timer: Timer? = null
    private var counter = 0

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        // 1. Capture the sink. This is how we send data to Flutter.
        eventSink = events
        counter = 0

        // 2. Start a timer to emit events every second
        timer = Timer()
        timer?.schedule(object : TimerTask() {
            override fun run() {
                // Network calls or heavy work can happen here...
                
                // BUT events must be sent on the UI thread!
                Handler(Looper.getMainLooper()).post {
                    counter++
                    eventSink?.success("Tick: $counter")
                }
            }
        }, 0, 1000) // Delay 0, Period 1000ms
    }

    override fun onCancel(arguments: Any?) {
        // 3. Clean up when Flutter stops listening
        timer?.cancel()
        timer = null
        eventSink = null
        println("StreamHandler: Stream cancelled")
    }
}
