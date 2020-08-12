//
//  PickerHelper.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/17.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import TZImagePickerController
import PhotoTweaks

class PickerHelper {
    
    private static let imgMaxLength = 200000 // 200KB
    
    // 检查权限
    public static func isPickerEnable() -> Bool {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == PHAuthorizationStatus.restricted || authStatus == PHAuthorizationStatus.denied {
            return false
        }
        return true
    }
    
    public static func selectVideo(target: UIViewController?, maxCount: Int = 1, complete: ((Data?, Int, Data?) -> Void)? = nil) {
        // 初始化
        let pickerVC = TZImagePickerController(maxImagesCount: maxCount, columnNumber: 3, delegate: nil)
        
        pickerVC?.allowPickingImage = false // 图片
        pickerVC?.allowPickingGif = false // gif
        pickerVC?.allowTakePicture = false // 拍照
        pickerVC?.allowCameraLocation = false // 拍照位置
        
        pickerVC?.allowPickingOriginalPhoto = false // 允许原图
        pickerVC?.notScaleImage = true // 允许改变输出大小
        
        pickerVC?.allowPickingVideo = true // 视频
        pickerVC?.allowTakeVideo = true // 录制
        pickerVC?.allowPickingMultipleVideo = false // 混选
        
        pickerVC?.onlyReturnAsset = false // 代理模式
        pickerVC?.timeout = 60 // 超时
        pickerVC?.allowPreview = true // 预览
        pickerVC?.showPhotoCannotSelectLayer = true // 数量限制蒙版
        pickerVC?.showSelectedIndex = true // 显示序号
        pickerVC?.autoDismiss = true // 隐藏
        
        // video回调方法
        pickerVC?.didFinishPickingVideoHandle = { (cover: UIImage?, assest: PHAsset?) -> Void in
            let indicator = AlertHelper.showIndicator(canCancel: false, cancelHandler: nil)
            // 封面
            var quality: CGFloat = CGFloat(0.9)
            var dataCover = cover?.jpegData(compressionQuality: quality)
            while dataCover != nil && dataCover!.count > imgMaxLength && quality > 0.001 {
                LogUtils.d(tag: "PickerHelper", method: "selectVideo", "压缩大小 --> " + String(dataCover!.count))
                quality = quality / 2
                dataCover = cover?.jpegData(compressionQuality: quality)
            }
            // 视频
            if assest == nil {
                AppDelegate.runOnMainAsync {
                    AlertHelper.diss(indicator)
                    complete?(dataCover, 0, nil)
                }
                return
            }
            let options = PHVideoRequestOptions()
            options.version = .current
            options.deliveryMode = .automatic
            // options.isNetworkAccessAllowed = true
            PHImageManager.default().requestPlayerItem(forVideo: assest!, options: options, resultHandler: { (playerItem, _) in
                if let avUrl = playerItem?.asset as? AVURLAsset {
                    do {
                        let dataVideo = try Data(contentsOf: avUrl.url)
                        AppDelegate.runOnMainAsync {
                            AlertHelper.diss(indicator)
                            complete?(dataCover!, Int(avUrl.duration.seconds), dataVideo)
                        }
                    } catch {
                        AppDelegate.runOnMainAsync {
                            AlertHelper.diss(indicator)
                            complete?(dataCover, 0, nil)
                        }
                    }
                } else {
                    AppDelegate.runOnMainAsync {
                        AlertHelper.diss(indicator)
                        complete?(dataCover, 0, nil)
                    }
                }
            })
        }
        // 开始展示
        if pickerVC == nil {
            return
        }
        AppDelegate.runOnMainAsync {
            target?.present(pickerVC!, animated: true)
        }
    }
    
    public static func selectImage(target: UIViewController?, maxCount: Int = 1, gif: Bool = true, compress: Bool = true, crop: Bool = false, complete: (([Data]) -> Void)? = nil) {
        // 初始化
        let pickerVC = TZImagePickerController(maxImagesCount: maxCount, columnNumber: 4, delegate: nil)
        
        pickerVC?.allowPickingImage = true // 图片
        pickerVC?.allowPickingGif = gif // gif
        pickerVC?.allowTakePicture = true // 拍照
        pickerVC?.allowCameraLocation = false // 拍照位置
        
        pickerVC?.allowPickingOriginalPhoto = !compress // 允许原图
        pickerVC?.notScaleImage = true // 允许改变输出大小
        
        pickerVC?.allowPickingVideo = false // 视频
        pickerVC?.allowTakeVideo = false // 录制
        pickerVC?.allowPickingMultipleVideo = false // 混选
        
        pickerVC?.onlyReturnAsset = false // 代理模式
        pickerVC?.timeout = 20 // 超时
        pickerVC?.allowPreview = true // 预览
        pickerVC?.showPhotoCannotSelectLayer = true // 数量限制蒙版
        pickerVC?.showSelectedIndex = true // 显示序号
        pickerVC?.autoDismiss = true // 隐藏
        
        // img回调方法
        pickerVC?.didFinishPickingPhotosHandle = { (photos: [UIImage]?, assets: [Any]?, isSelectOriginalPhoto: Bool) -> Void in
            var datas: [Data] = []
            let indicator = AlertHelper.showIndicator(canCancel: false, cancelHandler: nil)
            if compress || !isSelectOriginalPhoto {
                // 压缩
                if photos != nil && photos!.count > 0 {
                    for photo in photos! {
                        var quality: CGFloat = CGFloat(0.9)
                        var data = photo.jpegData(compressionQuality: quality)
                        while data != nil && data!.count > imgMaxLength && quality > 0.001 {
                            LogUtils.d(tag: "PickerHelper", method: "selectImage", "压缩大小 --> " + String(data!.count))
                            quality = quality / 2
                            data = photo.jpegData(compressionQuality: quality)
                        }
                        if data != nil {
                            datas.append(data!)
                        }
                    }
                }
                // 获取到所有图片
                AlertHelper.diss(indicator)
                onSelectComplete(target: target, datas: datas, crop: crop, complete: complete)
            } else {
                // 原图
                if assets != nil && assets!.count > 0 {
                    var endCount = 0
                    for asset in assets! {
                        if let phasset = asset as? PHAsset {
                            TZImageManager.default()!.getOriginalPhotoData(with: phasset, completion: { (data, dict, b) in
                                if data != nil {
                                    datas.append(data!)
                                }
                                endCount += 1
                                if endCount >= (assets?.count ?? 0) {
                                    // 获取到所有图片
                                    AlertHelper.diss(indicator)
                                    onSelectComplete(target: target, datas: datas, crop: crop, complete: complete)
                                }
                            })
                        } else {
                            endCount += 1
                        }
                    }
                }
            }
        }
        // gif回调方法
        pickerVC?.didFinishPickingGifImageHandle = { (animatedImage: UIImage?, sourceAssets: Any?) -> Void in
            if let assets = sourceAssets as? PHAsset {
                PHImageManager.default().requestImageData(for: assets, options: nil, resultHandler: { (data, _, _, _) in
                    if data == nil {
                        ToastUtils.show(StringUtils.getString("file_no_exits"))
                        return
                    }
                    AppDelegate.runOnMainAsync {
                        complete?([data!])
                    }
                })
            } else {
                ToastUtils.show(StringUtils.getString("file_no_exits"))
            }
        }
        // 开始展示
        if pickerVC == nil {
            return
        }
        AppDelegate.runOnMainAsync {
            target?.present(pickerVC!, animated: true)
        }
    }
    
    private static func onSelectComplete(target: UIViewController?, datas: [Data], crop: Bool, complete: (([Data]) -> Void)? = nil) {
        if datas.count <= 0 {
            ToastUtils.show(StringUtils.getString("file_no_exits"))
            return
        }
        if crop {
            // 裁剪，只能裁剪第一个
            let cropVC = getCropVC(target: target, data: datas[0])
            if cropVC != nil {
                AppDelegate.runOnMainAsync {
                    RootVC.get().pushNext(cropVC!)
                }
            } else {
                AppDelegate.runOnMainAsync {
                    complete?(datas)
                }
            }
        } else {
            // 返回
            AppDelegate.runOnMainAsync {
                complete?(datas)
            }
        }
    }
    
    // 裁剪vc
    private static func getCropVC(target: UIViewController?, data: Data) -> PhotoTweaksViewController? {
        let cropVC = PhotoTweaksViewController(image: UIImage(data: data))
        cropVC?.delegate = (target as! PhotoTweaksViewControllerDelegate)
        cropVC?.autoSaveToLibray = false
        //        cropVC?.title = ""
        cropVC?.sliderTintColor = ThemeHelper.getColorPrimary()
        cropVC?.resetButtonTitleColor = ThemeHelper.getColorPrimary()
        cropVC?.saveButtonTitleColor = ThemeHelper.getColorDark()
        cropVC?.cancelButtonTitleColor = ThemeHelper.getColorAccent()
        return cropVC
    }
    
}
