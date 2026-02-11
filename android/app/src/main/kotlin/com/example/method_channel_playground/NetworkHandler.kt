package com.example.method_channel_playground

import android.content.Context
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class NetworkHandler(private val context: Context) : EventChannel.StreamHandler {

    private val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
    private var eventSink: EventChannel.EventSink? = null

    // MethodChannel Handler
    fun onMethodCall(call: MethodCall, result: MethodChannel.Result): Boolean {
        if (call.method == "isNetworkAvailable") {
            val isAvailable = isNetworkAvailable()
            result.success(isAvailable)
            return true
        }
        return false
    }

    // EventChannel Handler
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        startMonitoring()
    }

    override fun onCancel(arguments: Any?) {
        stopMonitoring()
        eventSink = null
    }

    private fun isNetworkAvailable(): Boolean {
        val network = connectivityManager.activeNetwork ?: return false
        val capabilities = connectivityManager.getNetworkCapabilities(network) ?: return false
        return capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
    }

    private val networkCallback = object : ConnectivityManager.NetworkCallback() {
        override fun onAvailable(network: Network) {
            runOnUiThread { eventSink?.success("Connected: ${network.toString()}") }
        }

        override fun onLost(network: Network) {
            runOnUiThread { eventSink?.success("Disconnected: ${network.toString()}") }
        }

        override fun onUnavailable() {
            runOnUiThread { eventSink?.success("Unavailable") }
        }
    }

    private fun startMonitoring() {
        // We use registerDefaultNetworkCallback for simpler "Device has internet?" logic
        // But for specific capabilities (WiFi/Cell), request is okay.
        // Let's stick to request but make sure we target INTERNET.
        val request = NetworkRequest.Builder()
            .addCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
            .build()
        connectivityManager.registerNetworkCallback(request, networkCallback)
    }

    private fun stopMonitoring() {
        try {
            connectivityManager.unregisterNetworkCallback(networkCallback)
        } catch (e: Exception) {
            // Already unregistered or not registered
        }
    }

    private fun runOnUiThread(action: () -> Unit) {
        Handler(Looper.getMainLooper()).post(action)
    }
}
