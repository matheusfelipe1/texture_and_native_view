//
//  TextureView.swift
//  Runner
//
//  Created by Matheus Felipe on 05/04/25.
//

import UIKit
import AVFoundation

class TextureView: NSObject, FlutterTexture {

    let url: URL
    let result: FlutterResult
    let textureRegistry: FlutterTextureRegistry
    
    private var frameUpdateTimer: Timer?
    private var textureId: Int64!
    private var player: AVPlayer!
    private var playerItemVideoOutput: AVPlayerItemVideoOutput!
    
    init(url: URL, result: @escaping FlutterResult, textureRegistry: FlutterTextureRegistry) {
        self.url = url
        self.result = result
        self.textureRegistry = textureRegistry
        super.init()
        
        setupPlayer()
    }
    
    private func setupPlayer() {
        self.textureId = textureRegistry.register(self)
        self.result(self.textureId)
        
        let asset = AVURLAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        
        playerItemVideoOutput = AVPlayerItemVideoOutput(pixelBufferAttributes: [
            kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)
        ])
        
        item.add(playerItemVideoOutput)
        
        self.player = AVPlayer(playerItem: item)
        self.player.play()
        
        self.frameUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 30.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.textureRegistry.textureFrameAvailable(self.textureId)
        }
    }
    
    func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
        let currentTime = playerItemVideoOutput.itemTime(forHostTime: CACurrentMediaTime())
        if playerItemVideoOutput.hasNewPixelBuffer(forItemTime: currentTime),
            let buffer = playerItemVideoOutput.copyPixelBuffer(forItemTime: currentTime, itemTimeForDisplay: nil) {
            return Unmanaged.passRetained(buffer)
        }
        return nil
    }
    
    deinit {
        frameUpdateTimer?.invalidate()
    }
    
    func stop() {
        self.player?.pause()
        frameUpdateTimer?.invalidate()
    }
}
