package com.example.texture_and_native_view

import io.flutter.embedding.android.FlutterActivity
//import com.example.texture_and_native_view.TextureView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.graphics.SurfaceTexture

import io.flutter.view.TextureRegistry


class MainActivity: FlutterActivity() {
    private lateinit var channel: MethodChannel
    private val channelName = "com.example.texture_and_native_view"
    private val getTextureId = "getTextureId"
    private val closeTextureView = "closeTextureView"
    private var textureHandler: TextureView? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        )

        channel.setMethodCallHandler { call, result ->
            when(call.method) {
                getTextureId -> {
                    val path = call.argument<String>("path") ?: return@setMethodCallHandler result.error("INVALID_PATH", "Path is null", null)

                    textureHandler = TextureView(flutterEngine.renderer)
                    val textureId = textureHandler!!.createTexture(path)

                    result.success(textureId)
                }
                closeTextureView -> {
                    textureHandler?.dispose()
                    textureHandler = null
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}

