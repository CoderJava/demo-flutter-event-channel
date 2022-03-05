package com.example.flutter_event_channel

import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import java.util.*

class MainActivity : FlutterActivity() {
    private val channel = "timerEventChannel"
    private lateinit var timer: Timer
    private var eventSink: EventChannel.EventSink? = null
    private var counter = 0

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                stopTimer()
            }
        })
        startTimer()
    }

    private fun startTimer() {
        timer = Timer()
        timer.scheduleAtFixedRate(object : TimerTask() {
            override fun run() {
                this@MainActivity.runOnUiThread {
                    counter += 1
                    eventSink?.success(counter)
                    Log.d("TAG", "counter: $counter")
                }
            }
        }, 0, 1000)
    }

    private fun stopTimer() {
        timer.cancel()
    }
}
