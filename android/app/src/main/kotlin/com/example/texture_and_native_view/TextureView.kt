package com.example.texture_and_native_view

import android.graphics.SurfaceTexture
import android.media.MediaPlayer
import android.view.Surface
import io.flutter.view.TextureRegistry


class TextureView(
    private val textureRegistry: TextureRegistry
) : SurfaceTexture.OnFrameAvailableListener {

    private lateinit var mediaPlayer: MediaPlayer
    private lateinit var surface: Surface
    private lateinit var surfaceTextureEntry: TextureRegistry.SurfaceTextureEntry

    fun createTexture(videoPath: String): Long {
        surfaceTextureEntry = textureRegistry.createSurfaceTexture()
        val surfaceTexture = surfaceTextureEntry.surfaceTexture()
        surface = Surface(surfaceTexture)

        mediaPlayer = MediaPlayer()
        mediaPlayer.setSurface(surface)
        mediaPlayer.isLooping = true
        mediaPlayer.setDataSource(videoPath)
        mediaPlayer.setOnPreparedListener { it.start() }
        mediaPlayer.prepareAsync()

        return surfaceTextureEntry.id()
    }

    override fun onFrameAvailable(surfaceTexture: SurfaceTexture?) {

    }

    fun dispose() {
        mediaPlayer.release()
        surface.release()
        surfaceTextureEntry.release()
    }

}