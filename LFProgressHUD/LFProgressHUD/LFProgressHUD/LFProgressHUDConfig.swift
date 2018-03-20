//
//  LFProgressHUDConfig.swift
//  LFProgressHUD
//
//  Created by ios开发 on 2017/8/10.
//  Copyright © 2017年 ios开发. All rights reserved.
//

import UIKit


enum LFProgressHUDMaskStyle {
    //隐藏
    case hide
    //显示
    case visible
}

enum LFProgressHUdAnimationShowStyle {
    //淡入 淡出
    case fade
    //缩放
    case zoom
    //飞入
    case flyInto
}

//毛玻璃的样式
enum LFProgressHUDEffectStyle {
    case none
    //高亮
    case extraLight
    //亮
    case light
    //暗
    case dark
}

//加载动画样式
enum LFProgressHUDAnimationStyle {
    //圆圈
    case circle
    //系统样式(菊花)
    case system
}

//情景图片显示类型
enum LFProgressHUDImageType {
    case mask
    case info
    case error
    case success
}
typealias ImageType = LFProgressHUDImageType
typealias AnimationShowStyle = LFProgressHUdAnimationShowStyle
typealias MaskStype = LFProgressHUDMaskStyle
typealias HUDEffectStyle = LFProgressHUDEffectStyle
typealias AnimationStyle = LFProgressHUDAnimationStyle



final class LFProgressHUDConfig {
   
    
    static let margin: CGFloat = 20.0
    static var maskStyle:MaskStype = .visible
    static var animationShowStyle:AnimationShowStyle = .fade
    static var maskBackgroundColor: UIColor = .black
    static var foregroundColor: UIColor = .white
    //毛玻璃样式
    static var effectStyle:HUDEffectStyle = .dark
    static var effectAlpha:CGFloat = 1
    static var backgroundColor: UIColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.8)
    static var font: UIFont = UIFont.boldSystemFont(ofSize: 15)
    static var cornerRadius: CGFloat = 6
    static var animationStyle:AnimationStyle = .circle
    
    static var autoDismissDelay:Double = 1.5
    
    static let restorationIdentifier:String = "LFProgressHUD"
    static let LFNSNotificationDismiss = NSNotification.Name(rawValue:"LFNSNotificationDismiss")
    
    static func bundleImage(_ imageType:ImageType) ->UIImage? {
        var imageName:String!
        switch imageType {
        case .mask:
            imageName = "angle-mask"
        case .info:
            imageName = "info"
        case .error:
            imageName = "error"
        case .success:
            imageName = "success"
        }
        return UIImage(named: imageName)
    }
    
}


typealias Config = LFProgressHUDConfig

