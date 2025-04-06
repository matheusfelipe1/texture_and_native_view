//
//  NativeVideoView.swift
//  Runner
//
//  Created by Matheus Felipe on 05/04/25.
//

import UIKit
import AVKit

class NativeVideoView: NSObject, FlutterPlatformView {
    private var player: AVPlayer?
    private var playerView: PlayerContainerView

    init(arguments args: Any?) {
        self.playerView = PlayerContainerView()
        super.init()
        startVideo(arguments: args)
    }
    
    private func startVideo(arguments args: Any?) {
        guard let args = args as? [String: Any],
              let path = args["path"] as? String else { return }

        let url = URL(fileURLWithPath: path)
        self.player = AVPlayer(url: url)

        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        self.playerView.layer.addSublayer(playerLayer)
        self.playerView.playerLayer = playerLayer

        player?.play()
    }

    func view() -> UIView {
        return playerView
    }

    deinit {
        player?.pause()
    }
}

class PlayerContainerView: UIView {
    var playerLayer: AVPlayerLayer?

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
}

