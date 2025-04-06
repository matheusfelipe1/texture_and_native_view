package com.example.texture_and_native_view.nativeview

import android.content.Context
import android.view.View
import android.view.ViewGroup
import android.widget.VideoView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class NativeViewFactory(
    private val messenger: BinaryMessenger
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(
        context: Context?,
        viewId: Int,
        args: Any?
    ): PlatformView {
        requireNotNull(context) { "Contexto não pode ser nulo." }

        val arguments = args as? Map<*, *> ?: throw IllegalArgumentException("Argumentos inválidos")
        val videoPath = arguments["path"] as? String
            ?: throw IllegalArgumentException("Caminho do vídeo ('path') é obrigatório")

        return NativeVideoView(context, videoPath)
    }
}

class NativeVideoView(
    context: Context,
    private val videoPath: String
) : PlatformView {

    private val videoView: VideoView = StretchVideoView(context).apply {
        layoutParams = ViewGroup.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT
        )
        setVideoPath(videoPath)
        start()
    }

    override fun getView(): View = videoView

    override fun dispose() {
        videoView.stopPlayback()
    }
}


class StretchVideoView(context: Context) : VideoView(context) {
    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        val width = MeasureSpec.getSize(widthMeasureSpec)
        val height = MeasureSpec.getSize(heightMeasureSpec)
        setMeasuredDimension(width, height)
    }
}
