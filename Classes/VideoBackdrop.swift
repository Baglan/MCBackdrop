//
//  VideoBackdrop.swift
//  TheFilmPhotographyApp
//
//  Created by Baglan on 28/12/2016.
//  Copyright © 2016 Mobile Creators. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension MCBackdropView {
    class VideoBackdrop: MCBackdropView {
        var player: AVPlayer?
        var playerLayer: AVPlayerLayer?
        let imageView = UIImageView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            addSubview(imageView)
            imageView.contentMode = .scaleAspectFill
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var image: UIImage? {
            set {
                imageView.image = newValue
            }
            get {
                return imageView.image
            }
        }
        
        var video: AVAsset?
        
        func setupVideo() {
            guard let video = video else { return }
            player = AVPlayer(playerItem: AVPlayerItem(asset: video))
            player?.actionAtItemEnd = .pause
            playerLayer = AVPlayerLayer(player: player)
            
            guard let playerLayer = playerLayer else { return }
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            playerLayer.frame = bounds
            imageView.layer.addSublayer(playerLayer)
        }
        
        override func willAppear() {
            // Only set up video at this stage if there is no image
            if image == nil {
                setupVideo()
            }
        }
        
        override func hasStopped() {
            // Player might have been setup in willAppear; check for it
            if player == nil {
                setupVideo()
            }
            player?.play()
        }
        
        override func didDisappear() {
            player?.pause()
            playerLayer?.removeFromSuperlayer()
            playerLayer = nil
            player = nil
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            imageView.frame = bounds
            playerLayer?.frame = imageView.layer.bounds
        }
    }
}
