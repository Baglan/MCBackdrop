//
//  ImageBackdrop.swift
//  Phonographer
//
//  Created by Baglan on 24/10/2016.
//  Copyright © 2016 Mobile Creators. All rights reserved.
//

import Foundation
import UIKit

extension MCBackdropView {
    class ImageBackdrop: MCBackdropView {
        let imageView: UIImageView
        
        var image: UIImage? {
            didSet {
                imageView.image = image
            }
        }
        
        override init(frame: CGRect) {
            imageView = UIImageView()
            
            super.init(frame: frame)
            
            imageView.contentMode = .scaleAspectFill
            addSubview(imageView)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            imageView.frame = bounds
        }
    }
}


