
package com.garanti.garantitaxidriver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.PowerManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    private val METHOD_CHANNEL = "com.garanti.driver/channel"
    private  var methodChannel:MethodChannel?=null

    private val METHOD_CHANNEL2 = "com.garanti.driverSound/channel"
    private  var methodChannel2:MethodChannel?=null

    private val METHOD_CHANNEL4 = "com.garanti.driverOld/channel"
    private  var methodChannel4:MethodChannel?=null

    private val METHOD_CHANNEL5 = "com.garanti.driverClearCash/channel"
    private  var methodChannel5:MethodChannel?=null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
       super.configureFlutterEngine(flutterEngine)

        launchMediaPlayerDailog(this,flutterEngine.dartExecutor.binaryMessenger)

        playSound(this,flutterEngine.dartExecutor.binaryMessenger)

        openOld(this,flutterEngine.dartExecutor.binaryMessenger)

        clearCash(this,flutterEngine.dartExecutor.binaryMessenger)
    }

    private fun launchMediaPlayerDailog(context: Context,messenger: BinaryMessenger){
         methodChannel = MethodChannel(messenger,METHOD_CHANNEL)
        methodChannel!!.setMethodCallHandler { call, result ->
            when (call.method) {
                        "openDailog" -> {
                            val packageManager: PackageManager = context.packageManager
                            val intent = packageManager.getLaunchIntentForPackage("com.garanti.garantitaxidriver")
                                intent!!.setPackage(null)
                            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED or  Intent.FLAG_FROM_BACKGROUND
                            context.startActivity(intent)
                        }
                        else -> {
                            result.notImplemented()
                        }
                    }

        }
    }

//    @Suppress("DEPRECATION")
    private  fun  openOld(context: Context, messenger: BinaryMessenger){
        methodChannel4 = MethodChannel(messenger,METHOD_CHANNEL4)
        methodChannel4!!.setMethodCallHandler { call, result ->
            when (call.method) {
                "openDailogOld" -> {
                    val pm = context.getSystemService(POWER_SERVICE) as PowerManager
                    val isScreenOn = pm.isInteractive
                    if (!isScreenOn) {
                        if( Build.VERSION.SDK_INT <= 24 ){
//                          val wl: PowerManager.WakeLock = pm.newWakeLock(PowerManager.FULL_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP, "myApp:GarantiTaxi Driver")
//                            wl.acquire(10000)
                            val wlCpu: PowerManager.WakeLock = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "myApp:Garanti Driver")
                            wlCpu.acquire(10000)
                        }else{
//                         val wl: PowerManager.WakeLock = pm.newWakeLock(PowerManager. PARTIAL_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP, "myApp:GarantiTaxi Driver")
//                            wl.acquire(10000)
                            val wlCpu: PowerManager.WakeLock = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "myApp:Garanti Driver")
                            wlCpu.acquire(10000)
                        }
                    }

            }
                else -> {
                    result.notImplemented()
                }
            }

        }
    }


    private fun playSound(context: Context,messenger: BinaryMessenger){
        methodChannel2 = MethodChannel(messenger,METHOD_CHANNEL2)
        methodChannel2!!.setMethodCallHandler { call, result ->
            when (call.method) {
                "playSound" -> {

                            Intent(this,MyServiceDailog ::class.java).also {intent ->
                                startService(intent)
                            }
                }
                "stopSound" -> {
                    Intent(this,MyServiceDailog ::class.java).also {intent ->
                        stopService(intent)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }

        }
    }


    private fun clearCash(context: Context,messenger: BinaryMessenger){
        methodChannel5 = MethodChannel(messenger,METHOD_CHANNEL5)
        methodChannel5!!.setMethodCallHandler { call, result ->
            when (call.method) {
                "clearCash" -> {
                    context.cacheDir.deleteRecursively()
                }
                else -> {
                    result.notImplemented()
                }
            }

        }
    }



}


