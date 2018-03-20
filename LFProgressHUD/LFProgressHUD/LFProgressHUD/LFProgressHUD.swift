//
//  LFProgressHUD.swift
//  LFProgressHUD
//
//  Created by ios开发 on 2017/8/10.
//  Copyright © 2017年 ios开发. All rights reserved.
//

import UIKit


enum LFProgressHUDType {
    case gif
    case image
    case message
    case progress
    case activityIndicator
}
typealias HUDType = LFProgressHUDType


//MARK:- LFProgressHUD
class LFProgressHUD: UIView {

    // 全局中间变量
    fileprivate var hudType:HUDType!
    fileprivate var status:String?
    fileprivate var image:UIImage?
    fileprivate var gifUrl:URL?
    fileprivate var gifSize:CGFloat?
    fileprivate var progress:CGFloat?
    fileprivate var isShow:Bool = false
    
    
    fileprivate lazy var infoImage:UIImage? = Config.bundleImage(.info)?.withRenderingMode(.alwaysTemplate)
    fileprivate lazy var successImage: UIImage? = Config.bundleImage(.success)?.withRenderingMode(.alwaysTemplate)
    fileprivate lazy var errorImage: UIImage? = Config.bundleImage(.error)?.withRenderingMode(.alwaysTemplate)
    
    
    
    //MARK: - UI 
    fileprivate lazy var screenView:UIView = {
        let screenView = UIView()
        screenView.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight)
        screenView.mask?.alpha = 0.3
        screenView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        screenView.alpha = 0.3
        screenView.backgroundColor = Config.maskBackgroundColor
        return screenView
    }()
    
    
    fileprivate lazy var contentView:UIView = {
       let view = UIView()
        view.layer.masksToBounds = true
        view.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
        view.layer.cornerRadius = Config.cornerRadius
        //毛玻璃效果
        if Config.effectStyle == .none {
            view.backgroundColor = Config.backgroundColor
        }else {
            view.backgroundColor = .clear
        }
        view.alpha = 0.0
        return view
    }()
    
    fileprivate lazy var contentBlurView:UIVisualEffectView = {
        var blurEffectStyle:UIBlurEffectStyle!
        switch Config.effectStyle {
        case .extraLight:
            blurEffectStyle = .extraLight
        case .light:
            blurEffectStyle = .light
        default:
            blurEffectStyle = .dark
        }
        let blurEffect = UIBlurEffect(style: blurEffectStyle)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
        blurEffectView.alpha = Config.effectAlpha
        return blurEffectView
    }()
    
    
    fileprivate lazy var gifView:LFGifView = LFGifView()
    
    fileprivate lazy var imageView:UIImageView = {
        $0.contentMode = .scaleToFill
        $0.tintColor = Config.foregroundColor
        return $0

    }(UIImageView())
    
    fileprivate lazy var progressView:LFProgressView = {
        $0.progressColor = Config.foregroundColor
        $0.backgroundColor = .clear
        return $0

    }(LFProgressView(frame: CGRect(x: 0, y: 0, width: 85, height: 85)))
    
    
    fileprivate var activityIndicatorView: UIView {
        get {
            return Config.animationStyle == AnimationStyle.circle ? self.circleHUDView : self.systemHUDView
        }
    }
    
    fileprivate lazy var systemHUDView:UIActivityIndicatorView = {
        $0.activityIndicatorViewStyle = .whiteLarge
        $0.color = Config.foregroundColor
        $0.sizeToFit()
        $0.startAnimating()
        return $0
    }(UIActivityIndicatorView())
    
    fileprivate lazy var circleHUDView:UIView = {
        let lineWidth:CGFloat = 3.0
        let lineMargin:CGFloat = lineWidth / 2.0
        let arcCenter = CGPoint(x: $0.width / 2 - lineMargin, y: $0.height / 2 - lineMargin)
        let smoothedPath = UIBezierPath(arcCenter: arcCenter, radius: $0.width / 2 - lineWidth, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        let layer = CAShapeLayer()
        layer.contentsScale = UIScreen.main.scale
        layer.frame = CGRect(x: lineMargin, y: lineMargin, width: arcCenter.x * 2, height: arcCenter.y * 2)
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = Config.foregroundColor.cgColor
        layer.lineWidth = 3
        layer.lineCap = kCALineCapRound
        layer.lineJoin = kCALineJoinBevel
        layer.path = smoothedPath.cgPath
        
        layer.mask = CALayer()
        layer.mask?.contents = Config.bundleImage(.mask)?.cgImage
        layer.mask?.frame = layer.bounds
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = (Double.pi * 2)
        animation.duration = 1
        animation.isRemovedOnCompletion = false
        animation.repeatCount = Float(Int.max)
        animation.autoreverses = false
        layer.add(animation, forKey: "rotate")
        
        $0.layer.addSublayer(layer)

        return $0
    }(UIView(frame: CGRect(x: 0, y: 0, width: 65, height: 65)))
    
    
    fileprivate lazy var statusLabel: UILabel = {
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = Config.font
        $0.textColor = Config.foregroundColor
        return $0
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(LFProgressHUD.observerDismiss(notification:)), name: Config.LFNSNotificationDismiss, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Config.LFNSNotificationDismiss, object: nil)
    }
    
}

//MARK: - 实例计算属性
extension LFProgressHUD {
    fileprivate var screenWidth: CGFloat {
        get {
            return UIScreen.main.bounds.size.width
        }
    }
    
    fileprivate var screenHeight: CGFloat {
        get {
            return UIScreen.main.bounds.size.height
        }
    }
    
    
    fileprivate var maxContentViewWidth:CGFloat {
        get {
            return self.screenWidth - Config.margin * 2
        }
    }
    
    fileprivate var maxContentViewChildWidth:CGFloat {
        get {
            return self.screenWidth - Config.margin * 4
        }
    }
    
}


extension LFProgressHUD {
    //显示
    fileprivate func show(hudType:HUDType,status:String? = nil,image:UIImage? = nil,isAutoDismiss:Bool? = nil,maskStyle:MaskStype? = nil,imageType:ImageType? = nil,gifUrl:URL? = nil,gifSize:CGFloat? = nil,progress:CGFloat? = nil) {
        DispatchQueue.main.async {
            self.hudType = hudType
            self.status = status == "" ? nil :status
            self.image = image
            self.gifUrl = gifUrl
            self.gifSize = gifSize
            self.progress = progress ?? 0
            
            if let imgType = imageType {
                switch imgType {
                case .info:
                    self.image = self.infoImage
                case .error :
                    self.image = self.errorImage
                case .success:
                    self.image = self.successImage
                default:
                    break
                }
            }
            
            if self.hudType == .progress {
                if let progressValue = self.progress {
                    self.progressView.progress = Double(progressValue)
                }
                if self.restorationIdentifier != Config.restorationIdentifier {
                    self.updateView(maskStyle: maskStyle)
                }
            }else {
                self.updateView(maskStyle: maskStyle)
            }
            self.updateFrame(maskStyle: maskStyle)
            if let autoDismiss = isAutoDismiss {
                if autoDismiss {
                    self.autoDismiss(delay: Config.autoDismissDelay)
                }
            }
        }
    }
    
    //更新视图
    fileprivate func updateView(maskStyle:MaskStype?) {
        self.restorationIdentifier = Config.restorationIdentifier
        LFProgressHUD.frontWindow?.addSubview(self)
        if (maskStyle ?? Config.maskStyle) == .visible {
            self.addSubview(self.screenView)
        }
        self.addSubview(self.contentView)
        
        if Config.effectStyle != .none {
            self.contentView.addSubview(self.contentBlurView)
        }
        
        self.contentView.addSubview(self.statusLabel)
        
        
        switch self.hudType! {
        case .gif:
            if let url = self.gifUrl {
                self.gifView.frame.size = CGSize(width: self.gifSize ?? 100, height: self.gifSize ?? 100)
                self.gifView.showGIFImage(gifUrl: url)
                self.contentView.addSubview(self.gifView)
            }
            break
        case .image:
            self.contentView.addSubview(self.imageView)
            break
        case .progress:
            self.contentView.addSubview(self.progressView)
            break
        case .activityIndicator:
            self.contentView.addSubview(self.activityIndicatorView)
        default: break
        }
    }
    
    //更新视图大小坐标
    /// 更新视图大小坐标
    fileprivate func updateFrame(maskStyle: MaskStype?) {
        if self.hudType! == .gif {
            if self.gifView.width > self.maxContentViewChildWidth {
                self.gifView.frame.size = CGSize(width: self.maxContentViewChildWidth, height: self.maxContentViewChildWidth)
            }
        }
        if self.hudType! == .image {
            self.imageView.image = self.image
            self.imageView.sizeToFit()
            // 如果图片尺寸超过限定最大尺寸，将图片尺寸修改为限定最大尺寸
            if self.imageView.width > self.maxContentViewChildWidth {
                self.imageView.frame.size = CGSize(width: self.maxContentViewChildWidth, height: self.maxContentViewChildWidth)
            }
        }
        
        if let text = self.status {
            self.statusLabel.isHidden = false
            self.statusLabel.text = text
            self.statusLabel.frame.size = text.size(font: Config.font, size: CGSize(width: self.maxContentViewChildWidth, height: 400))
            self.statusLabel.sizeToFit()
        } else {
            self.statusLabel.frame.size = CGSize.zero
            self.statusLabel.isHidden = true
        }
        
        self.contentView.frame.size = {
            var width: CGFloat = 0
            switch self.hudType! {
            case .gif:
                width = (self.statusLabel.isHidden ? self.gifView.width : (self.gifView.width > self.statusLabel.width ? self.gifView.width : self.statusLabel.width)) + Config.margin * 2
            case .image:
                width = (self.statusLabel.isHidden ? self.imageView.width : (self.imageView.width > self.statusLabel.width ? self.imageView.width : self.statusLabel.width)) + Config.margin * 2
            case .message:
                width = self.statusLabel.width + Config.margin * 2
            case .progress:
                width = (self.statusLabel.isHidden ? self.progressView.width : (self.progressView.width > self.statusLabel.width ? self.progressView.width : self.statusLabel.width)) + Config.margin * 2
            case .activityIndicator:
                width = (self.statusLabel.isHidden ? self.activityIndicatorView.width : (self.activityIndicatorView.width > self.statusLabel.width ? self.activityIndicatorView.width : self.statusLabel.width)) + Config.margin * 2
            }
            
            var height: CGFloat = 0
            switch self.hudType! {
            case .gif:
                height = (self.statusLabel.isHidden ? self.gifView.height : (self.gifView.height + Config.margin + self.statusLabel.height)) + Config.margin * 2
            case .image:
                height = (self.statusLabel.isHidden ? self.imageView.height : (self.imageView.height + Config.margin + self.statusLabel.height)) + Config.margin * 2
            case .message:
                height = self.statusLabel.height + Config.margin * 2
            case .progress:
                height = (self.statusLabel.isHidden ? self.progressView.height : (self.progressView.height + Config.margin + self.statusLabel.height)) + Config.margin * 2
            case .activityIndicator:
                height = (self.statusLabel.isHidden ? self.activityIndicatorView.height : (self.activityIndicatorView.height + Config.margin + self.statusLabel.height)) + Config.margin * 2
            }
            
            return CGSize(width: width, height: height)
        }()
        
        self.contentBlurView.frame = CGRect(x: 0, y: 0, width: self.contentView.width, height: self.contentView.height)
        switch self.hudType! {
        case .gif:
            self.gifView.frame.origin = {
                let x = (self.contentView.width - self.gifView.width) / 2
                let y = Config.margin
                return CGPoint(x: x, y: y)
            }()
            self.statusLabel.frame.origin = {
                let x = (self.contentView.width - self.statusLabel.width) / 2
                let y = self.gifView.y + self.gifView.height + Config.margin
                return CGPoint(x: x, y: y)
            }()
        case .image:
            self.imageView.frame.origin = {
                let x = (self.contentView.width - self.imageView.width) / 2
                let y = Config.margin
                return CGPoint(x: x, y: y)
            }()
            self.statusLabel.frame.origin = {
                let x = (self.contentView.width - self.statusLabel.width) / 2
                let y = self.imageView.y + self.imageView.height + Config.margin
                return CGPoint(x: x, y: y)
            }()
        case .message:
            self.statusLabel.frame.origin = {
                let x = (self.contentView.width - self.statusLabel.width) / 2
                let y = Config.margin
                return CGPoint(x: x, y: y)
            }()
        case .progress:
            self.progressView.frame.origin = {
                let x = (self.contentView.width - self.progressView.width) / 2
                let y = Config.margin
                return CGPoint(x: x, y: y)
            }()
            self.statusLabel.frame.origin = {
                let x = (self.contentView.width - self.statusLabel.width) / 2
                let y = self.progressView.y + self.progressView.height + Config.margin
                return CGPoint(x: x, y: y)
            }()
        case .activityIndicator:
            self.activityIndicatorView.frame.origin = {
                let x = (self.contentView.width - self.activityIndicatorView.width) / 2
                let y = Config.margin
                return CGPoint(x: x, y: y)
            }()
            self.statusLabel.frame.origin = {
                let x = (self.contentView.width - self.statusLabel.width) / 2
                let y = self.activityIndicatorView.y + self.activityIndicatorView.height + Config.margin
                return CGPoint(x: x, y: y)
            }()
        }
        
        let x = (self.screenWidth - self.contentView.width) / 2
        let y = (self.screenHeight - self.contentView.height) / 2
        if (maskStyle ?? Config.maskStyle) == .hide {
            self.frame = CGRect(x: x, y: y, width: self.contentView.width, height: self.contentView.height)
            self.contentView.frame.origin = CGPoint(x: 0, y: 0)
        } else {
            self.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight)
            self.contentView.frame.origin = CGPoint(x: x, y: y)
        }
        
        if !self.isShow {
            self.animationShow(contentFrame: self.contentView.frame)
        }
    }

    /// 动画显示
    func animationShow(contentFrame: CGRect) {
        self.isShow = true
        switch Config.animationShowStyle {
        case .fade:
            self.contentView.alpha = 0
        case .zoom:
            self.contentView.alpha = 1
            self.contentView.frame = CGRect(x: self.screenWidth / 2, y: contentFrame.origin.y, width: 0, height: contentFrame.size.height)
        case .flyInto:
            self.contentView.alpha = 1
            self.contentView.frame = CGRect(x: contentFrame.origin.x, y: 0 - contentFrame.size.height, width: contentFrame.size.width, height: contentFrame.size.height)
            break
        }
        UIView.animate(withDuration: 0.3, animations: {
            switch Config.animationShowStyle {
            case .fade:
                self.contentView.alpha = 1
            case .zoom:
                self.contentView.frame = contentFrame
            case .flyInto:
                self.contentView.frame = contentFrame
                break
            }
        })
    }

    //通知移除
    @objc fileprivate func observerDismiss(notification:Notification) {
        if let userinfo = notification.userInfo {
            let delay = userinfo["delay"] as! Double
            self.autoDismiss(delay: delay)
        }else {
            self.isShow = false
            self.removeFromSuperview()
        }
    }
    
    
    /// 自动移除
    fileprivate func autoDismiss(delay: Double) {
        let a = Int(delay * 1000 * 1000)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .microseconds(a), execute: {
            DispatchQueue.main.async {
                self.animationDsmiss()
            }
        })
    }
    
    //移除动画
    func animationDsmiss() {
        UIView.animate(withDuration: 0.3, animations: { 
            
            switch Config.animationShowStyle {
            case .fade:
                self.contentView.alpha = 0
            case .zoom:
                self.contentView.frame = CGRect(x: self.screenWidth / 2, y: self.contentView.y, width: 0, height: self.contentView.height)
            case .flyInto:
                self.contentView.frame = CGRect(x: self.contentView.x, y: 0 - self.contentView.height, width: self.contentView.width, height: self.contentView.height)
            }
            
        }) { (finished) in
            self.isShow = false
            self.removeFromSuperview()
        }
    }
}


extension LFProgressHUD {
    fileprivate static var frontWindow:UIWindow? {
        get {
            let window = UIApplication.shared.windows.reversed().first(where: {
                $0.screen == UIScreen.main &&
                    !$0.isHidden && $0.alpha > 0 &&
                    $0.windowLevel == UIWindowLevelNormal
            })
            return window
        }
    }
    static var shared:LFProgressHUD {
        get {
            return LFProgressHUD(frame: UIScreen.main.bounds)
        }
    }
}




//MARK:- 类方法
extension LFProgressHUD {
    //MARK: 显示gif加载
    public static func showGif(gifUrl: URL?, gifSize: CGFloat?) {
        LFProgressHUD.showGif(status: nil, gifUrl: gifUrl, gifSize: gifSize)
    }
    public static func showGif(status: String?, gifUrl: URL?, gifSize: CGFloat?) {
        LFProgressHUD.showGif(status: status, gifUrl: gifUrl, gifSize: gifSize, maskStyle: nil)
    }
    public static func showGif(status: String?, gifUrl: URL?, gifSize: CGFloat?, maskStyle: LFProgressHUDMaskStyle?) {
        shared.show(hudType: .gif, status: status, maskStyle: maskStyle, gifUrl: gifUrl, gifSize: gifSize)
    }
    
    //MARK: 显示图片
    public static func showImage(_ image: UIImage?) {
        LFProgressHUD.showImage(image: image, status: nil)
    }
    public static func showImage(image: UIImage?, status: String?) {
        LFProgressHUD.showImage(image: image, status: status, maskStyle: nil)
    }
    public static func showImage(image: UIImage?, status: String?, maskStyle: LFProgressHUDMaskStyle?) {
        shared.show(hudType: .image, status: status, image: image, isAutoDismiss: true, maskStyle: maskStyle)
    }
    
    //MARK: 显示消息
    public static func showMessage(_ message: String?) {
        LFProgressHUD.showMessage(message: message, maskStyle: nil)
    }
    public static func showMessage(message: String?, maskStyle: LFProgressHUDMaskStyle?) {
        shared.show(hudType: .message, status: message, isAutoDismiss: true, maskStyle: maskStyle)
    }
    
    //MARK: 显示进度
    public static func showProgress(_ progress: CGFloat?) {
        LFProgressHUD.showProgress(progress, status: nil)
    }
    public static func showProgress(_ progress: CGFloat?, status: String?) {
        LFProgressHUD.showProgress(progress: progress, status: status, maskStyle: nil)
    }
    public static func showProgress(progress: CGFloat?, status: String?, maskStyle: LFProgressHUDMaskStyle?) {
        var isShowProgressView = false
        for subview in (LFProgressHUD.frontWindow?.subviews)! {
            if subview.isKind(of: LFProgressHUD.self) && subview.restorationIdentifier == Config.restorationIdentifier {
                let progressHUD = subview as! LFProgressHUD
                if progressHUD.hudType == .progress {
                    progressHUD.show(hudType: .progress, status: status, maskStyle: maskStyle, progress: progress)
                    isShowProgressView = true
                } else {
                    progressHUD.removeFromSuperview()
                }
            }
        }
        if !isShowProgressView {
            shared.show(hudType: .progress, status: status, maskStyle: maskStyle, progress: progress)
        }
    }
    
    //MARK: 显示加载
    public static func show() {
        LFProgressHUD.show(nil)
    }
    public static func show(_ status: String?) {
        LFProgressHUD.show(status: status, maskStyle: nil)
    }
    public static func show(status: String?, maskStyle: LFProgressHUDMaskStyle?) {
        shared.show(hudType: .activityIndicator, status: status, maskStyle: maskStyle)
    }
    
    
    //显示普通信息
    //MARK: 显示普通信息
    public static func showInfo(_ status: String?) {
        LFProgressHUD.showInfo(status: status, maskStyle: nil)
    }
    public static func showInfo(status: String?, maskStyle: LFProgressHUDMaskStyle?) {
        shared.show(hudType: .image, status: status, isAutoDismiss: true, maskStyle: maskStyle, imageType: .info)
    }
    
    //MARK: 显示成功信息
    public static func showSuccess(_ status: String?) {
        LFProgressHUD.showSuccess(status: status, maskStyle: nil)
    }
    public static func showSuccess(status: String?, maskStyle: LFProgressHUDMaskStyle?) {
        shared.show(hudType: .image, status: status, isAutoDismiss: true, maskStyle: maskStyle, imageType: .success)
    }
    
    //MARK: 显示失败信息
    public static func showError(_ status: String?) {
        LFProgressHUD.showError(status: status, maskStyle: nil)
    }
    public static func showError(status: String?, maskStyle: LFProgressHUDMaskStyle?) {
        shared.show(hudType: .image, status: status, isAutoDismiss: true, maskStyle: maskStyle, imageType: .error)
    }
    
    @available(swift, deprecated: 3.0, message: "请使用 dismiss 方法")
    public static func hide(delay: Double? = nil) {
        LFProgressHUD.dismiss(delay)
    }
    //MARK: 移除
    public static func dismiss(_ delay: Double? = nil) {
        NotificationCenter.default.post(name: Config.LFNSNotificationDismiss, object: nil, userInfo: ["delay" : delay ?? 0])
    }
    
    //MARK: 设置遮罩样式，默认值：.visible
    public static func setMaskStyle (_ maskStyle: LFProgressHUDMaskStyle) {
        Config.maskStyle = maskStyle
    }
    
    //MARK: 设置动画显示/隐藏样式，默认值：.fade
    public static func setAnimationShowStyle (_ animationShowStyle: AnimationShowStyle) {
        Config.animationShowStyle = animationShowStyle
    }
    
    //MARK: 设置遮罩背景色，默认值：.black
    public static func setMaskBackgroundColor(_ color: UIColor) {
        Config.effectStyle = .none
        Config.maskBackgroundColor = color
    }
    
    //MARK: 设置前景色，默认值：.white（前景色在设置 effectStyle 值时会自动适配，如果要使用自定义前景色，在调用 setEffectStyle 方法后调用 setForegroundColor 方法即可）
    public static func setForegroundColor(_ color: UIColor) {
        Config.foregroundColor = color
    }
    //MARK: 设置 HUD 毛玻璃效果（与 backgroundColor 互斥，如果设置毛玻璃效果不是.none，则根据样式自动设置前景色），默认值：.dark
    public static func setEffectStyle(_ hudEffectStyle: LFProgressHUDEffectStyle) {
        Config.effectStyle = hudEffectStyle
        if hudEffectStyle == .light || hudEffectStyle == .extraLight {
            Config.foregroundColor = .black
        } else if hudEffectStyle == .dark {
            Config.foregroundColor = .white
        }
    }
    //MARK: 设置 HUD 毛玻璃透明度，默认值：1
    public static func setEffectAlpha(_ effectAlpha: CGFloat) {
        Config.effectAlpha = effectAlpha
    }
    //MARK: 设置 HUD 背景色（与 effectStyle 互斥，如果设置背景色，effectStyle = .none），默认值：UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.8)
    public static func setBackgroundColor(_ color: UIColor) {
        Config.backgroundColor = color
        Config.effectStyle = .none
    }
    
    //MARK: 设置字体，默认值：UIFont.boldSystemFont(ofSize: 15)
    public static func setFont(_ font: UIFont) {
        Config.font = font
    }
    
    //MARK: 设置圆角，默认值：6
    public static func setCornerRadius(_ cornerRadius: CGFloat) {
        Config.cornerRadius = cornerRadius
    }
    
    //MARK: 设置加载动画样式动画样式，默认值：circle
    public static func setAnimationStyle(_ animationStyle: LFProgressHUDAnimationStyle) {
        Config.animationStyle  = animationStyle
    }
    
    //MARK: 设置自动隐藏延时秒数，默认值：2
    public static func setAutoDismissDelay(_ autoDismissDelay: Double) {
        Config.autoDismissDelay = autoDismissDelay
    }
}




extension String {
    func size(font: UIFont, size: CGSize) -> CGSize {
        let attribute = [ NSFontAttributeName: font ]
        let conten = NSString(string: self)
        return conten.boundingRect(with: CGSize(width: size.width, height: size.height), options: .usesLineFragmentOrigin, attributes: attribute, context: nil).size
    }

}



