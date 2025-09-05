package com.zenscape_ar_tourism.app

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import android.os.Bundle
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.example.zenscape_ar_tourism.ARService

class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "zenscape_ar_service"
    private var arService: ARService? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        val messenger = flutterEngine.dartExecutor.binaryMessenger
        val channel = MethodChannel(messenger, CHANNEL)
        val service = ARService(this)
        service.setChannel(channel)
        channel.setMethodCallHandler(service)
        arService = service
    }
}