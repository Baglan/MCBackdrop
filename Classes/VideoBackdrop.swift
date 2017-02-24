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
        let imageView: UIImageView
        
        override init(frame: CGRect) {
            imageView = UIImageView()
            super.init(frame: frame)
            addSubview(imageView)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var image: UIImage? {
            didSet {
                imageView.image = image
            }
        }
        
        var video: AVAsset?
        
        override func willAppear() {
            super.willAppear()
            
            guard let video = video else { return }
            player = AVPlayer(playerItem: AVPlayerItem(asset: video))
            player?.actionAtItemEnd = .pause
            playerLayer = AVPlayerLayer(player: player)
            
            guard let playerLayer = playerLayer else { return }
            playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            imageView.layer.addSublayer(playerLayer)
            playerLayer.frame = imageView.layer.bounds
        }
        
        override func hasStopped() {
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
