//
//  LFFlowView.swift
//  LFFlowView
//
//  Created by ios开发 on 2017/8/21.
//  Copyright © 2017年 ios开发. All rights reserved.
//  流程View

import UIKit

//线宽 
let kLineWidth = 2
//间距
let ksideSpace:CGFloat = 15.0
let kFontSize:CGFloat = 12.0
let kTitleLabelTag = 600



class LFFlowView: UIView {

    fileprivate var betweenSpace:CGFloat = 0 //圆点间距
    fileprivate var totalRoundCount:NSInteger = 5 //圆点个数 默认五个
    fileprivate var roundIndex:NSInteger = 0 //原点高亮坐标
    fileprivate var lineIndex:NSInteger = 0 //直线坐标
    
    //直线初始化坐标
    fileprivate var oriPointX = 0
    fileprivate var roundRadius:CGFloat = 12 //圆半径
    //文字 图形 上下艰巨
    fileprivate var verticalSpace:CGFloat = 0
    
    var titleArray:[String]?
    
    
    func setCurrentRoundIndex(index:NSInteger,lineIndex:NSInteger) {
        self.roundIndex = index
        self.lineIndex = lineIndex
        for i in 0..<self.titleArray!.count {
            let titleLbl:UILabel = (self.viewWithTag(kTitleLabelTag + i) as? UILabel)!
            if i < roundIndex {
                titleLbl.textColor = UIColor.gray
            }else {
                titleLbl.textColor = UIColor.red
            }
        }
        self.setNeedsDisplay()
        
    }
    
    private func createTitleLabel() {
        let highStartLineX:CGFloat = ksideSpace
        for i in 0..<self.titleArray!.count {
            
            let highStartLineY:CGFloat = self.frame.size.height / 3.0 + verticalSpace + roundRadius * 2
            let indexSpace:CGFloat = betweenSpace / 2.0
            
            let pointX = CGPoint(x: highStartLineX + (indexSpace * 2.0 / 3.0) + (CGFloat(i) * indexSpace * 2.0), y: highStartLineY)
            print("\(highStartLineY)   and \(indexSpace)  and  \(pointX)")
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 12))
            label.font = UIFont.systemFont(ofSize: kFontSize)
            label.center = pointX
//            label.backgroundColor = UIColor.blue
            label.textAlignment = .center
            label.textColor =  UIColor.black
            label.text = self.titleArray![i]
            label.tag = kTitleLabelTag + i
            self.addSubview(label)
            
        }
    }
     convenience init(frame: CGRect,titleArr:[String],radius:CGFloat,roundIndex:NSInteger,lineIndex:NSInteger) {
        self.init(frame: frame)
        self.roundIndex = roundIndex
        self.lineIndex = lineIndex
        self.titleArray = titleArr
        self.roundRadius = radius / 2
        self.totalRoundCount = titleArr.count
        let preSpace = (self.frame.size.width - 2 * ksideSpace) / ((CGFloat(totalRoundCount) - 1.0) * 3.0 + 2.0)
        betweenSpace = preSpace * 3.0
        verticalSpace = frame.size.height/3.0 - kFontSize
        self.createTitleLabel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    
    
    //画线和点
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //填充背景色
        UIColor.white.setFill()
        UIRectFill(rect)
        
        let highStartLineX = ksideSpace
        let normalEndLindex = highStartLineX + self.frame.size.width - 2 * ksideSpace
        let highStartLineY = self.frame.size.height / 3.0
        //坐标增加间距
        let indexSpace:CGFloat = betweenSpace / 2.0
        var highEndLineX:CGFloat = 0.0
        if lineIndex == 0 {
            highEndLineX = highStartLineX + (indexSpace * 2.0 / 3.0)
            
        }else if lineIndex == (roundIndex * 2 - 1) {
            highEndLineX = highStartLineX + ((CGFloat(roundIndex) - 1) * 2) * indexSpace + (indexSpace * 2.0 / 3.0)
        }else {
            highEndLineX = highStartLineX + (lineIndex == 0 ? (CGFloat(lineIndex) * indexSpace) : 0) + (indexSpace * 2.0 / 3.0)
        }
        
        if lineIndex != -1 {
            //全是灰线
            let highPath = UIBezierPath()
            highPath.move(to: CGPoint(x: highStartLineX, y: highStartLineY))
            highPath.addLine(to: CGPoint(x: highEndLineX, y: highStartLineY))
            let dashPattern:[CGFloat] = [3,1]
            highPath.setLineDash(dashPattern, count: 1, phase: 1)
            UIColor.gray.set()
            
            highPath.lineWidth = CGFloat(kLineWidth)
            highPath.stroke()
        }
        
        if lineIndex != (self.titleArray!.count * 2 - 1) {
            let normalPath = UIBezierPath()
            normalPath.move(to: CGPoint(x: highEndLineX, y: highStartLineY))
            normalPath.addLine(to: CGPoint(x: normalEndLindex, y: highStartLineY))
            let dashPattern:[CGFloat] = [3,1]
            normalPath.setLineDash(dashPattern, count: 1, phase: 1)
            UIColor.gray.set()
            normalPath.lineWidth = CGFloat(kLineWidth)
            normalPath.stroke()
        }
        
        //画圆
        for i in 0..<self.titleArray!.count {
            let pointX = CGPoint(x: highStartLineX + (indexSpace * 2.0 / 3.0) + CGFloat(i) * (indexSpace * 2), y: highStartLineY)
            let path = UIBezierPath()
            path.addArc(withCenter: pointX, radius: roundRadius, startAngle: 0.0, endAngle: CGFloat(Double.pi*2), clockwise: true)
            if i <= roundIndex {
                UIColor.red.setFill()
                UIColor.red.setStroke()
            }else {
                UIColor.gray.setFill()
                UIColor.gray.setStroke()
            }
            path.stroke()
            path.fill()
        }
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
