//
//  LFGifView.swift
//  LFProgressHUD
//
//  Created by ios开发 on 2017/8/10.
//  Copyright © 2017年 ios开发. All rights reserved.
//

import UIKit
import ImageIO

// MARK: -GifView
class LFGifView: UIView {

    private var gifUrl: URL!
    private var images: Array<CGImage> = []
    private var delays: Array<NSNumber> = []
    private var totalDelay: Float = 0

    
    func showGIFImage(gifUrl:URL) {
        self.gifUrl = gifUrl
        
    }
    
    private func creatKeyFrame() {
        
        guard let source = CGImageSourceCreateWithURL(self.gifUrl as CFURL, nil) else {
            return
        }
        
        let count = CGImageSourceGetCount(source)
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as NSDictionary!
            let gifProperties = cfProperties?[String(kCGImagePropertyGIFDictionary)] as! NSDictionary!
            let delay = gifProperties![String(kCGImagePropertyGIFUnclampedDelayTime)] as! NSNumber
            delays.append(delay)
            totalDelay += delay.floatValue
            
            let imageWitdh = cfProperties?[String(kCGImagePropertyPixelWidth)] as! NSNumber
            let imageHeight = cfProperties?[String(kCGImagePropertyPixelHeight)] as! NSNumber
            if imageWitdh.floatValue / imageHeight.floatValue != Float(width / height) {
                self.fitScale(imageWitdh: CGFloat(imageWitdh.floatValue), imageHeight: CGFloat(imageHeight.floatValue))
            }
        }
        
        self.showAnimation()
    }

    private func fitScale(imageWitdh: CGFloat, imageHeight: CGFloat) {
        var newWidth:CGFloat
        var newHeight:CGFloat
        if imageWitdh/imageHeight > width/height {
            newWidth = width
            newHeight = width / (imageWitdh / imageHeight)
        } else {
            newWidth = height / (imageHeight / imageWitdh)
            newHeight = height
        }
        let point = self.center
        self.frame.size = CGSize(width: newWidth, height: newHeight)
        self.center = point
    }
    
    private func showAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "contents")
        var current:Float = 0
        var timeKeys:Array<NSNumber> = []
        for delay in self.delays {
            timeKeys.append(NSNumber(value: current / self.totalDelay))
            current += delay.floatValue
        }
        animation.keyTimes = timeKeys
        animation.values = images
        animation.repeatCount = HUGE
        animation.duration = TimeInterval(totalDelay)
        animation.isRemovedOnCompletion = false
        self.layer.add(animation, forKey: "LFGifView")
        
    }
    
}


extension UIView {
    var width:CGFloat {
        get {
            return self.frame.size.width
        }
    }
    
    var height:CGFloat {
        get {
            return self.frame.size.height
        }
    }
    
    
    
    var x:CGFloat {
        get {
            return self.frame.origin.x
        }
    }
    
    var y:CGFloat {
        get {
            return self.frame.origin.y
        }
    }
    
}

