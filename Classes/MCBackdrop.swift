//
//  BackdropManager.swift
//  Phonographer
//
//  Created by Baglan on 20/10/2016.
//  Copyright © 2016 Mobile Creators. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class MCBackdropView: UIView {
    func willAppear() {
    }
    
    func didDisappear() {
    }
    
    func hasStopped() {
        
    }
}

class MCBackdropItem: MCViewport.ViewItem {
    var backdrops = [String:MCBackdropView]()
    var pages = [(x: Int, y: Int, backdrop: String)]()
    
    override func newView() -> UIView {
        let view = UIImageView()
        view.clipsToBounds = true
        return view
    }
    
    var page: (x: CGFloat, y: CGFloat) {
        get {
            guard let viewport = viewport else { return (x: 0, y: 0) }
            return (
                x: viewport.contentOffset.x / viewport.bounds.width,
                y: viewport.contentOffset.y / viewport.bounds.height
            )
        }
    }
    
    let risingZPosition: CGFloat = 2
    let waningZPosition: CGFloat = 1
    
    var currentBackdrops = Set<MCBackdropView>()
    
    override func update() {
        super.update()
        
        guard
            let viewport = viewport,
            let view = view,
            pages.count > 0
        else { return }
        
        let currentPage = page
        
        let xRange = Int(floor(currentPage.x))...Int(ceil(currentPage.x))
        let yRange = Int(floor(currentPage.y))...Int(ceil(currentPage.y))

        let closest = pages.filter { (item: (x: Int, y: Int, backdrop: String)) -> Bool in
            return xRange.contains(item.x) && yRange.contains(item.y)
        }
        
        guard closest.count > 0 else { return }
        
        let candidates = closest.sorted { (a: (x: Int, y: Int, backdrop: String), b: (x: Int, y: Int, backdrop: String)) -> Bool in
            let offsetA = (CGFloat(a.x) - currentPage.x) + (CGFloat(a.y) - currentPage.y)
            let offsetB = (CGFloat(b.x) - currentPage.x) + (CGFloat(b.y) - currentPage.y)
            return offsetA > offsetB
        }
        
        // Make sure views for both exist
        guard candidates.count > 0 else { return }
        
        let risingKey = candidates.first!.backdrop
        let waningKey = candidates.last!.backdrop
        
        guard
            let risingBackdrop = backdrops[risingKey],
            let waningBackdrop = backdrops[waningKey]
        else { return }
        
        let visibleBackdrops = Set<MCBackdropView>([risingBackdrop, waningBackdrop])
        
        let appearingBackdrops = visibleBackdrops.subtracting(currentBackdrops)
        let disappearingBackdrops = currentBackdrops.subtracting(visibleBackdrops)
        
        for backdrop in appearingBackdrops {
            if backdrop.superview != view {
                view.addSubview(backdrop)
            }
            
            backdrop.willAppear()
            backdrop.isHidden = false
        }
        
        for backdrop in disappearingBackdrops {
            backdrop.isHidden = true
            backdrop.didDisappear()
        }
        
        // Opacities
        if risingKey != waningKey {
            risingBackdrop.alpha = max(currentPage.x.truncatingRemainder(dividingBy: 1), currentPage.y.truncatingRemainder(dividingBy: 1))
            risingBackdrop.layer.zPosition = risingZPosition
        }
        
        waningBackdrop.alpha = 1
        waningBackdrop.layer.zPosition = waningZPosition
        
        currentBackdrops = visibleBackdrops
        
        if viewport.hasStopped {
            for backdrop in currentBackdrops {
                backdrop.hasStopped()
            }
        }
    }
}


