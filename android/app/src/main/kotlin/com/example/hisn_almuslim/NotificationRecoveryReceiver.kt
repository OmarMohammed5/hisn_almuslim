package com.example.hisn_almuslim

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import java.util.TimeZone
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

/**
 * Starts a short-lived headless Flutter engine only when Android invalidates
 * time-based schedules while the UI/process is not running.
 *
 * Actual notification delivery remains AlarmManager-owned; this receiver only
 * rebuilds schedules after system events that can invalidate local times.
 */
class NotificationRecoveryReceiver : BroadcastReceiver() {

    companion object {
        private const val CHANNEL = "hisn_almuslim/notification_recovery"
        private const val DONE = "done"
        private const val TIMEOUT_MS = 20_000L
    }

    override fun onReceive(context: Context, intent: Intent) {
        val pendingResult = goAsync()
        val appContext = context.applicationContext

        Thread {
            var engine: FlutterEngine? = null
            var finished = false
            val mainHandler = Handler(Looper.getMainLooper())

            fun finish() {
                if (finished) return
                finished = true
                mainHandler.removeCallbacksAndMessages(null)
                engine?.destroy()
                pendingResult.finish()
            }

            try {
                val loader = FlutterInjector.instance().flutterLoader()
                loader.startInitialization(appContext)
                loader.ensureInitializationComplete(appContext, null)

                engine = FlutterEngine(appContext)

                MethodChannel(
                    engine!!.dartExecutor.binaryMessenger,
                    CHANNEL,
                ).setMethodCallHandler { call, result ->
                    if (call.method == DONE) {
                        result.success(null)
                        finish()
                    } else {
                        result.notImplemented()
                    }
                }

                val entrypoint = DartExecutor.DartEntrypoint(
                    loader.findAppBundlePath(),
                    "notificationRecoveryEntryPoint",
                )

                engine!!.dartExecutor.executeDartEntrypoint(
                    entrypoint,
                    listOf(TimeZone.getDefault().id),
                )

                mainHandler.postDelayed({ finish() }, TIMEOUT_MS)
            } catch (_: Throwable) {
                finish()
            }
        }.start()
    }
}
