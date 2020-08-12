//
//  KFHelper.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/14.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import Kingfisher

class KFHelper {
    
    private static let cache = ImageCache.default
    private static let downloader = ImageDownloader.default
    private static var imgFailure: UIImage? = nil
    
    public static func initApp() {
        // cache
        // cache.memoryStorage.config.totalCostLimit = 0 // 默认总内存1/4
        cache.memoryStorage.config.countLimit = 30 // 内存缓存个数
        cache.memoryStorage.config.expiration = .seconds(600) // 默认10分钟
        cache.diskStorage.config.sizeLimit = UInt(ResHelper.getMaxCacheSize()) // 总存储的一半
        cache.diskStorage.config.expiration = .days(100) // 100天的过期
        // downloader
        downloader.sessionConfiguration = URLSessionConfiguration.default
        downloader.downloadTimeout = 600 // 十分钟超时
        // failure
        let label = ViewHelper.getLabelGreySmall(width: ScreenUtils.getScreenWidth() / 3, height: ScreenUtils.getScreenHeight() / 3,
                                                 text: StringUtils.getString("image_load_fail"), lines: 0, align: .center)
        imgFailure = ViewUtils.getImageByView(label)
    }
    
    // 清除内存，内部已经做过处理了，这里就不处理了
    public static func clearMemoryCaches() {
        cache.clearMemoryCache()
    }
    
    // 清除磁盘
    public static func clearDiskCaches() {
        cache.clearMemoryCache()
        cache.cleanExpiredMemoryCache()
        cache.cleanExpiredDiskCache()
        cache.clearDiskCache()
    }
    
    public static func getImgByOssKey(ossKey: String?, success: ((String, Image) -> ())? = nil, failure: ((String) -> ())? = nil) {
        if StringUtils.isEmpty(ossKey) {
            failure?(ossKey ?? "")
            return
        }
        cache.retrieveImageInDiskCache(forKey: ossKey!) { result in
            if result.isSuccess {
                if let img = result.value {
                    if img != nil {
                        success?(ossKey ?? "", img!)
                        return
                    }
                }
            }
            failure?(ossKey ?? "")
        }
    }
    
    // 加载图片
    public static func setImgUrl(iv: UIImageView?, objKey: String?, resize: Bool = true) {
        if iv == nil {
            return
        }
        if StringUtils.isEmpty(objKey) {
            iv?.image = imgFailure
            return
        }
        // 不异步会卡
        AppDelegate.runOnMainAsync {
            // 获取url
            let url = OssHelper.getUrl(objKey: objKey)
            if StringUtils.isEmpty(url) {
                iv?.image = imgFailure
                return
            }
            // options 参数
            var options: KingfisherOptionsInfo = [KingfisherOptionsInfoItem](arrayLiteral:
                .targetCache(cache), // 缓存策略
                .downloader(downloader), // 下载策略
                .keepCurrentImageWhileLoading, // 重复加载时，之前图片会保留
                .backgroundDecode, // 后台编解码 gif不能用
                .cacheSerializer(DefaultCacheSerializer.default), // 序列化存储
                .waitForCache, // 等缓存操作完再回调completionHandler
                .transition(.fade(0.3)), // 过渡动画(只限网络图)
                .forceTransition, // 强制过渡动画
                .preloadAllAnimationData, // gif预加载，不能resize
                .onFailureImage(imgFailure) // 失败占位图
            )
            // procress 调整大小，缩小内存占用
            if resize {
                let referenceSize = CGSize(width: iv!.frame.width * 2, height: iv!.frame.height * 2)
                let processor: ImageProcessor = ResizingImageProcessor(referenceSize: referenceSize, mode: .aspectFit)
                options.append(.processor(processor)) // 处理策略(数据->图片)
                options.append(.cacheOriginalImage) // 只缓存原图，配合processor使用
            }
            // imageModifier 图片修改，不会修改缓存
            let imageModifier = AnyImageModifier(modify: { (img) -> Image in
                let (needFix, imgFix) = ViewUtils.fixImageOrientation(img)
                if needFix {
                    return imgFix
                } else {
                    return img
                }
            })
            options.append(.imageModifier(imageModifier)) // 摆正角度
            // 开始下载
            iv!.kf.setImage(with: ImageResource(downloadURL: URL(string: url)!, cacheKey: objKey!),
                            placeholder: nil,
                            options: options,
                            progressBlock: { (i1, i2) in
                                // 下载进度回调
                                if let indicator = iv?.kf.indicator as? KFURLIndicator {
                                    let progress = Int(Float(i1) / Float(i2) * 100)
                                    indicator.setProgress(progress)
                                }
            },
                            completionHandler: { result in
                                switch result {
                                case .success(let result):
                                    LogUtils.d(tag: "KFHelper", method: "setImgUrl", result.cacheType)
                                    break
                                case .failure(let error):
                                    // 失败
                                    if error.errorCode != 5002 {
                                        LogUtils.w(tag: "KFHelper", method: "setImgUrl", error.errorCode, error.failureReason as Any, error.localizedDescription)
                                        // 刷新oss
                                        ApiHelper.ossInfoUpdate()
                                    }
                                    break
                                }
            })
        }
    }
    
    // 加载头像
    public static func setImgAvatarUrl(iv: UIImageView?, objKey: String?, user: User? = nil, uid: Int64? = nil) {
        if iv == nil {
            return
        }
        // 不异步会卡
        AppDelegate.runOnMainAsync {
            // 获取url
            let url = OssHelper.getUrl(objKey: objKey)
            if StringUtils.isEmpty(objKey) || StringUtils.isEmpty(url) {
                var sexImg: String = ""
                if user != nil {
                    sexImg = UserHelper.getSexAvatarNamed(user: user)
                } else if uid != nil {
                    let me = UDHelper.getMe()
                    let ta = UDHelper.getTa()
                    if me?.id == uid {
                        sexImg = UserHelper.getSexAvatarNamed(user: me)
                    } else if ta?.id == uid {
                        sexImg = UserHelper.getSexAvatarNamed(user: ta)
                    }
                }
                if StringUtils.isEmpty(sexImg) {
                    sexImg = UserHelper.getSexAvatarNamed(user: nil)
                }
                iv?.image = UIImage(named: sexImg)
                return
            }
            // options 参数
            var options: KingfisherOptionsInfo = [KingfisherOptionsInfoItem](arrayLiteral:
                .targetCache(cache), // 缓存策略
                .downloader(downloader), // 下载策略
                .keepCurrentImageWhileLoading, // 重复加载时，之前图片会保留
                .backgroundDecode, // 后台编解码
                .cacheSerializer(DefaultCacheSerializer.default), // 序列化存储
                .waitForCache, // 等缓存操作完再回调completionHandler
                .transition(.fade(0.3)), // 过渡动画(只限网络图)
                .forceTransition, // 强制过渡动画
                .onlyLoadFirstFrame, // gif只要第一帧
                .onFailureImage(iv?.image) // 失败占位图
            )
            // procress 调整大小，缩小内存占用
            let processor = DefaultImageProcessor.default.append(another: ResizingImageProcessor(referenceSize: CGSize(width: iv!.frame.width * 3, height: iv!.frame.height * 3), mode: .aspectFit))
            options.append(.processor(processor)) // 处理策略(数据->图片)
            options.append(.cacheOriginalImage) // 只缓存原图，配合processor使用
            // 开始下载
            iv?.kf.setImage(with: ImageResource(downloadURL: URL(string: url)!, cacheKey: objKey!),
                            placeholder: nil,
                            options: options,
                            progressBlock: nil,
                            completionHandler: { result in
                                switch result {
                                case .success(let result):
                                    LogUtils.d(tag: "KFHelper", method: "setImgUrl", result.cacheType)
                                    break
                                case .failure(let error):
                                    // 失败
                                    if error.errorCode != 5002 {
                                        LogUtils.w(tag: "KFHelper", method: "setImgAvatarUrl", error.errorCode, error.failureReason as Any, error.localizedDescription)
                                        // 刷新oss
                                        ApiHelper.ossInfoUpdate()
                                    }
                                    break
                                }
            })
        }
    }
    
}

struct KFURLIndicator: Indicator {
    var view: IndicatorView = UIView()
    let pv: OProgressView = OProgressView()
    
    init(size: CGSize? = nil) {
        if size == nil {
            pv.frame.size = CGSize(width: ScreenUtils.widthFit(50), height: ScreenUtils.widthFit(50))
        } else {
            pv.frame.size = size!
        }
        let lineWidth = pv.frame.width / 10
        pv.setLineWidth(lineWidth > 0 ? lineWidth : 1)
        pv.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        pv.backgroundColor = ColorHelper.getTrans()
        // view
        view.backgroundColor = ColorHelper.getTrans()
        view.addSubview(pv)
    }
    
    func startAnimatingView() {
        view.isHidden = false
    }
    
    func stopAnimatingView() {
        view.isHidden = true
    }
    
    func setProgress(_ pro: Int) {
        pv.setProgress(pro, animated: true)
    }
    
}

@IBDesignable class OProgressView: UIView {
    
    struct Constant {
        // 进度条宽度
        static var lineWidth: CGFloat = ScreenUtils.widthFit(5)
        // 进度槽颜色
        static let trackColor = ColorHelper.getImgGrey()
        // 进度条颜色
        static let progressColoar = ThemeHelper.getColorPrimary()
    }
    
    // 进度槽
    let trackLayer = CAShapeLayer()
    // 进度条
    let progressLayer = CAShapeLayer()
    // 进度条路径（整个圆圈）
    let path = UIBezierPath()
    
    // 当前进度
    @IBInspectable var progress: Int = 0 {
        didSet {
            if progress > 100 {
                progress = 100
            } else if progress < 0 {
                progress = 0
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        // 获取整个进度条圆圈路径
        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                    radius: bounds.size.width / 2 - Constant.lineWidth,
                    startAngle: angleToRadian(-90), endAngle: angleToRadian(270), clockwise: true)
        
        // 绘制进度槽
        trackLayer.frame = bounds
        trackLayer.fillColor = ColorHelper.getTrans().cgColor
        trackLayer.strokeColor = Constant.trackColor.cgColor
        trackLayer.lineWidth = Constant.lineWidth
        trackLayer.path = path.cgPath
        layer.addSublayer(trackLayer)
        
        // 绘制进度条
        progressLayer.frame = bounds
        progressLayer.fillColor = ColorHelper.getTrans().cgColor
        progressLayer.strokeColor = Constant.progressColoar.cgColor
        progressLayer.lineWidth = Constant.lineWidth
        progressLayer.path = path.cgPath
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = CGFloat(progress) / 100.0
        layer.addSublayer(progressLayer)
    }
    
    func setLineWidth(_ width: CGFloat) {
        Constant.lineWidth = width
    }
    
    // 设置进度（可以设置是否播放动画）
    func setProgress(_ pro: Int, animated anim: Bool) {
        setProgress(pro, animated: anim, withDuration: 0.55)
    }
    
    // 设置进度（可以设置是否播放动画，以及动画时间）
    func setProgress(_ pro: Int, animated anim: Bool, withDuration duration: Double) {
        progress = pro
        //进度条动画
        CATransaction.begin()
        CATransaction.setDisableActions(!anim)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut))
        CATransaction.setAnimationDuration(duration)
        progressLayer.strokeEnd = CGFloat(progress) / 100.0
        CATransaction.commit()
    }
    
    // 将角度转为弧度
    fileprivate func angleToRadian(_ angle: Double) -> CGFloat {
        return CGFloat(angle / Double(180.0) * Double.pi)
    }
}
