package com.example.hisn_almuslim

import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : AudioServiceActivity() {

    companion object {
        private const val CHANNEL = "hisn_almuslim/config"
    }

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine
    ) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {
                "getYoutubeApiKey" -> {
                    result.success(
                        BuildConfig.YOUTUBE_API_KEY
                    )
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}