package com.example.texture_and_native_view

import io.flutter.embedding.android.FlutterActivity
//import com.example.texture_and_native_view.Texture.TextureView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.graphics.SurfaceTexture
import com.example.texture_and_native_view.Texture.TextureView
import com.example.texture_and_native_view.nativeview.NativeViewFactory

import io.flutter.view.TextureRegistry


class MainActivity: FlutterActivity() {
    private lateinit var channel: MethodChannel
    private val getTextureId = "getTextureId"
    private val closeTextureView = "closeTextureView"
    private var textureHandler: TextureView? = null
    private val channelName = "com.example.texture_and_native_view"

    private val nativeViewFactoryName = "com.example.native_view_factory_name"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(nativeViewFactoryName,
                NativeViewFactory(flutterEngine.dartExecutor.binaryMessenger)
            )

        channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        )

        channel.setMethodCallHandler { call, result ->
            when(call.method) {
                getTextureId -> {
                    val path = call.argument<String>("path") ?: return@setMethodCallHandler result.error("INVALID_PATH", "Path is null", null)
                    textureHandler = TextureView(flutterEngine.renderer, result, path)
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

