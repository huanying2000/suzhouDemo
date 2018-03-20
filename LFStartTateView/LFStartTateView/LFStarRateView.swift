//
//  LFStarRateView.swift
//  LFStartTateView
//
//  Created by ios开发 on 2017/8/21.
//  Copyright © 2017年 ios开发. All rights reserved.
//

import UIKit

enum RateStyle:NSInteger {
    case WholeStar
    case HalfStar
    case IncompleteStar
}

protocol LFStarRateViewDelegate:NSObjectProtocol {
    func getTheScore(starView:LFStarRateView,currentScore:CGFloat)
}

typealias FinishedBlock = (_ currentScore:CGFloat) ->()

class LFStarRateView: UIView {

    var isAnimation = false //是否有动画 默认为NO
    var rateStyle:RateStyle = .WholeStar //默认是整星评论
    weak var delegate:LFStarRateViewDelegate?
    
    //打分后的星星
    fileprivate lazy var foregroundStarView:UIView = {
        let foreView = self.createStarViewWith(imageName: "b27_icon_star_yellow")
        return foreView
    }()
    
    //背景图 灰色星星
    fileprivate lazy var backgroundStarView:UIView = {
        let backView = self.createStarViewWith(imageName: "b27_icon_star_gray")
        return backView
    }()
    //星星的个数 默认是五
    var numberOfStars:NSInteger
        = 5
    var currentScore:CGFloat = 0.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    var completeBlock:FinishedBlock?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    convenience init(frame: CGRect,numOfStars:NSInteger,currentScore:CGFloat,isAnimation:Bool,completion:@escaping FinishedBlock) {
        self.init(frame: frame)
        
        self.numberOfStars = numOfStars
        self.currentScore = currentScore
        self.isAnimation = isAnimation
        self.completeBlock = completion
        self .createStarView()
        
    }
    
    
    
    private func createStarView() {
        //如果当前有分数 先创建一些分数
        self.foregroundStarView.frame = CGRect(x: 0, y: 0, width: self.bounds.width * (self.currentScore / CGFloat(self.numberOfStars)), height: self.bounds.size.height)
        self.addSubview(self.backgroundStarView)
        self.addSubview(self.foregroundStarView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapClick(tap:)))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
    }
    
    //创建View
    private func createStarViewWith(imageName:String) -> UIView {
        let view = UIView(frame: self.bounds)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.clear
        for i in 0..<self.numberOfStars {
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.frame = CGRect(x: CGFloat(i) * self.bounds.size.width / CGFloat(self.numberOfStars), y: 0, width: self.bounds.size.width / CGFloat(self.numberOfStars), height: self.bounds.size.height)
            imageView.contentMode = .scaleAspectFit
            view.addSubview(imageView)
        }
        return view
    }
    
    
    @objc fileprivate func tapClick(tap:UITapGestureRecognizer) {
        //获取用户点击的点
        let tapPoint = tap.location(in: self)
        let offSet = tapPoint.x
        let realStartScore = offSet / (self.bounds.size.width / CGFloat(numberOfStars))
        switch rateStyle {
        case .WholeStar:
            //ceil 函数 求不小于给定实数的最小整数
            self.currentScore = ceil(realStartScore)
            if self.completeBlock != nil {
                self.completeBlock!(self.currentScore)
            }
        case .HalfStar:
            self.currentScore = round(realStartScore > realStartScore ? ceil(realStartScore):(ceil(realStartScore - 0.5)))
        default:
            self.currentScore = realStartScore
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let animationTimeInterval = self.isAnimation ? 0.2 : 0
        UIView.animate(withDuration: animationTimeInterval) { [weak self] in
            self?.foregroundStarView.frame = CGRect(x: 0, y: 0, width: (self?.bounds.width)! * ((self?.currentScore)! / CGFloat((self?.numberOfStars)!)), height: (self?.bounds.height)!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
