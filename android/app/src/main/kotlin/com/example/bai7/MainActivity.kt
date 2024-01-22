package com.example.bai7

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val METHOD_CHANNEL_NAME = "com.example.bai7/method"
    private val EVENT_CHANNEL_NAME = "com.example.bai7/event"

    private lateinit var sensorManager: SensorManager

    private var methodChannel: MethodChannel?=null
    private var eventChannel: EventChannel?=null
    private var pressureStreamHandler : StreamHandler?=null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        //Set up channel
        setUpChannels(this, flutterEngine.dartExecutor.binaryMessenger)

    }

    override fun onDestroy() {
        methodChannel!!.setMethodCallHandler(null)
        eventChannel!!.setStreamHandler(null)
        super.onDestroy()
    }

    private fun setUpChannels(context: Context, messenger: BinaryMessenger) {
        sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager

        methodChannel = MethodChannel(messenger, METHOD_CHANNEL_NAME)
        methodChannel!!.setMethodCallHandler { call, result ->
            if (call.method == "isSensorAvailable") {
                result.success(sensorManager.getSensorList(Sensor.TYPE_PRESSURE).isNotEmpty())
            }
            else {
                result.notImplemented()
            }
        }

        eventChannel = EventChannel(messenger, EVENT_CHANNEL_NAME)
        pressureStreamHandler = StreamHandler(sensorManager, Sensor.TYPE_PRESSURE)
        eventChannel!!.setStreamHandler(pressureStreamHandler)
    }
}
