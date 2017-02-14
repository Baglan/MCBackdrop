//
//  RepeatingViewBackdrop.swift
//  Phonographer
//
//  Created by Baglan on 24/10/2016.
//  Copyright © 2016 Mobile Creators. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension MCBackdropView {
    class RepeatingVideoBackdrop: MCBackdropView {
        var player: AVQueuePlayer?
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
            player = AVQueuePlayer()
            playerLayer = AVPlayerLayer(player: player)
            
            if let playerLayer = playerLayer {
                playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                imageView.layer.addSublayer(playerLayer)
                playerLayer.frame = imageView.layer.bounds
            }
            
            guard let video = video else { return }
            player?.insert(AVPlayerItem(asset: video), after: nil)
            player?.insert(AVPlayerItem(asset: video), after: nil)
            
            startObserving()
        }
        
        override func hasStopped() {
            player?.play()
        }
        
        override func didDisappear() {
            stopObserving()
            
            player?.pause()
            playerLayer?.removeFromSuperlayer()
            playerLayer = nil
            player = nil
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            imageView.frame = bounds
            playerLayer?.frame = bounds
        }
        
        // MARK: - Observing
        fileprivate var isObserving = false
        func startObserving() {
            if !isObserving {
                player?.addObserver(self, forKeyPath: "currentItem", options: NSKeyValueObservingOptions.old, context: nil)
                isObserving = true
            }
        }
        
        func stopObserving() {
            if isObserving {
                player?.removeObserver(self, forKeyPath: "currentItem")
                isObserving = false
            }
        }
        
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if let change = change, let oldItem = change[NSKeyValueChangeKey.oldKey] as? AVPlayerItem {
                stopObserving()
                oldItem.seek(to: kCMTimeZero)
                player?.insert(oldItem, after: nil)
                startObserving()
            }
        }
        
        // MARK: - Deinit
        
        deinit {
            stopObserving()
            player?.pause()
        }
    }
}
