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
        let player: AVPlayer
        let playerLayer: AVPlayerLayer
        let imageView: UIImageView
        
        override init(frame: CGRect) {
            player = AVPlayer()
            playerLayer = AVPlayerLayer(player: player)
            imageView = UIImageView()
            
            super.init(frame: frame)
            
            addSubview(imageView)
            
            playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            imageView.layer.addSublayer(playerLayer)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var image: UIImage? {
            didSet {
                imageView.image = image
            }
        }
        
        var video: AVAsset? {
            didSet {
                guard let video = video else { return }
                player.replaceCurrentItem(with: AVPlayerItem(asset: video))
            }
        }
        
        override func hasStopped() {
            player.play()
        }
        
        override func didDisappear() {
            player.pause()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            imageView.frame = bounds
            playerLayer.frame = bounds
        }
    }
}
