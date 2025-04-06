package com.example.texture_and_native_view.Texture

import android.graphics.SurfaceTexture
import android.media.MediaPlayer
import android.view.Surface
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.TextureRegistry

class TextureView(
    private val textureRegistry: TextureRegistry,
    private val result: MethodChannel.Result,
    private val videoPath: String
) : SurfaceTexture.OnFrameAvailableListener {

    private lateinit var mediaPlayer: MediaPlayer
    private lateinit var surface: Surface
    private lateinit var surfaceTextureEntry: TextureRegistry.SurfaceTextureEntry

    init {
        createTexture()
    }

    private fun createTexture(): Unit {
        surfaceTextureEntry = textureRegistry.createSurfaceTexture()
        val surfaceTexture = surfaceTextureEntry.surfaceTexture()
        surface = Surface(surfaceTexture)

        mediaPlayer = MediaPlayer()
        mediaPlayer.setSurface(surface)
        mediaPlayer.isLooping = true
        mediaPlayer.setDataSource(videoPath)
        mediaPlayer.setOnPreparedListener { it.start() }
        mediaPlayer.prepareAsync()

        result.success(surfaceTextureEntry.id())
    }

    override fun onFrameAvailable(surfaceTexture: SurfaceTexture?) {

    }

    fun dispose() {
        mediaPlayer.release()
        surface.release()
        surfaceTextureEntry.release()
    }

}