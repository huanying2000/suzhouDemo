//
//  LFProgressView.swift
//  LFProgressHUD
//
//  Created by ios开发 on 2017/8/10.
//  Copyright © 2017年 ios开发. All rights reserved.
//

import UIKit
//MARK: - 进度
class LFProgressView: UIView {

    var progressColor:UIColor?
    var progressFont:UIFont?
    private var _progress:Double = 0
    private var textLabel:UILabel!
    
    var progress:Double {
        get {
            return _progress
        }
        
        set {
            self._progress = newValue
            self.setNeedsDisplay()
            self.setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textLabel = UILabel()
        self.addSubview(self.textLabel)
        self.textLabel.textAlignment = .center
        self.textLabel.font = self.progressFont ?? Config.font
        self.textLabel.textColor = self.progressColor ?? Config.foregroundColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel.text = "\(Int(self.progress * 100))%"
        self.textLabel.sizeToFit()
        self.textLabel.frame.origin = CGPoint(x: (self.width - self.textLabel.width) / 2, y: (self.height - self.textLabel.height) / 2)
    }
    
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        let arcCenter = CGPoint(x: self.width / 2, y: self.height / 2)
        let radius = arcCenter.x - 2
        let startAngle = -(Double.pi / 2)
        let endAngle = startAngle + Double.pi * 2 * self.progress
        let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
        ctx?.setLineWidth(4)
        self.progressColor?.setStroke()
        ctx?.addPath(path.cgPath)
        ctx?.strokePath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    

}
