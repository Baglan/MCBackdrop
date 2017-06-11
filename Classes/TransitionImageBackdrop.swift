//
//  TransitionImageBackdrop.swift
//  Phonographer
//
//  Created by Baglan on 24/10/2016.
//  Copyright © 2016 Mobile Creators. All rights reserved.
//

import Foundation
import UIKit

extension MCBackdropView {
    class TransitionImageBackdrop: MCBackdropView {
        let currentImageView: UIImageView
        let oldImageView: UIImageView
        
        let transitionDuration: TimeInterval = 0.2
        
        var image: UIImage? {
            didSet {
                if let oldImage = currentImageView.image, oldImage != image {
                    oldImageView.image = oldImage
                    oldImageView.alpha = 1
                    
                    UIView.animate(
                        withDuration: transitionDuration,
                        delay: 0,
                        options: UIViewAnimationOptions(rawValue: 0),
                        animations: { [unowned self] _ in
                            self.oldImageView.alpha = 0
                        },
                        completion: nil
                    )
                }
                
                currentImageView.image = image
            }
        }
        
        override init(frame: CGRect) {
            currentImageView = UIImageView()
            oldImageView = UIImageView()
            
            super.init(frame: frame)
            
            currentImageView.contentMode = .scaleAspectFill
            oldImageView.contentMode = .scaleAspectFill
            
            addSubview(currentImageView)
            addSubview(oldImageView)
            
            oldImageView.alpha = 0
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            currentImageView.frame = bounds
            oldImageView.frame = bounds
        }
    }
}
