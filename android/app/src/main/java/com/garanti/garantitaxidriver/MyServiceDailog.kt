package com.garanti.garantitaxidriver
import android.app.Service
import android.content.Intent
import android.media.MediaPlayer
import android.os.IBinder
import android.os.PowerManager


class MyServiceDailog : Service() {
private var mMediaPlayer: MediaPlayer? = null
    override fun onBind(intent: Intent): IBinder {
        TODO("Return the communication channel to the service.")
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

//        val pm = this.getSystemService(POWER_SERVICE) as PowerManager
//        val isScreenOn = pm.isInteractive
//        if (!isScreenOn) {
//            val wl: PowerManager.WakeLock = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP or PowerManager.ON_AFTER_RELEASE or PowerManager.SCREEN_DIM_WAKE_LOCK, "myApp:MyLock")
//            wl.acquire(10000)
//            val wlCpu: PowerManager.WakeLock = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "myApp:mycpuMyCpuLock")
//            wlCpu.acquire(10000)
//        }

        if (mMediaPlayer == null) {
            mMediaPlayer = MediaPlayer.create(this, R.raw.new_order1)
            mMediaPlayer!!.isLooping = true
            mMediaPlayer!!.start()
        } else mMediaPlayer!!.start()
       return START_STICKY
    }

    override fun onDestroy() {
        if (mMediaPlayer != null) {
            mMediaPlayer!!.stop()
            mMediaPlayer!!.release()
            mMediaPlayer = null
        }
    }
}
