package com.garanti.driver

import android.content.Intent
import android.media.MediaPlayer
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    private val channel = "com.garanti.driver/channel"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,channel)
                .setMethodCallHandler { call, result ->
                    if(call.method=="openDailog"){
                        Intent(this,MyServiceDailog ::class.java).also {intent ->
                            startService(intent)
                        }
                    }else if(call.method=="closeDailog"){
                        Intent(this,MyServiceDailog ::class.java).also {intent ->
                            stopService(intent)
                        }
                    }else{
                        result.notImplemented()
                    }
                }
    }
}
