//
//  BrowserHelper.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/19.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import MWPhotoBrowser

class BrowserHelper {
    
    public static func goBrowserImage(view: UIView?, index: Int = 0,
                                      ossKeyList: [String]? = nil, dataList: [Data]? = nil,
                                      filePathList: [String]? = nil, imageList: [UIImage]? = nil) {
        if let vc = ViewUtils.getSuperVC(view: view) as? (BaseVC & MWPhotoBrowserDelegate) {
            goBrowserImage(delegate: vc, index: index, ossKeyList: ossKeyList, dataList: dataList, filePathList: filePathList, imageList: imageList)
        }
    }
    
    public static func goBrowserImage(delegate: BaseVC & MWPhotoBrowserDelegate, index: Int = 0,
                                      ossKeyList: [String]? = nil, dataList: [Data]? = nil,
                                      filePathList: [String]? = nil, imageList: [UIImage]? = nil) {
        
        let browser = MWPhotoBrowser(delegate: delegate)
        if browser == nil {
            return
        }
        // 开始获取数据
        getPhotos(ossKeyList: ossKeyList, dataList: dataList, filePathList: filePathList, imageList: imageList,
                  complete: { photos in
                    if photos.count <= index {
                        return
                    }
                    // 主线程异步
                    AppDelegate.runOnMainAsync {
                        delegate.photos = photos
                        
                        browser?.setCurrentPhotoIndex(UInt(index))
                        
                        browser?.zoomPhotosToFill = true
                        browser?.enableGrid = true
                        browser?.startOnGrid = false
                        browser?.autoPlayOnAppear = false
                        
                        browser?.displayActionButton = true
                        browser?.displayNavArrows = true
                        browser?.displaySelectionButtons = false
                        browser?.alwaysShowControls = false
                        
                        RootVC.get().pushNext(browser!)
                    }
        })
    }
    
    private static func getPhotos(ossKeyList: [String]? = nil, dataList: [Data]? = nil,
                                  filePathList: [String]? = nil, imageList: [UIImage]? = nil, complete: @escaping (([MWPhoto]) -> ())) {
        // ossKeyList 先弄这个异步
        let keys = ossKeyList == nil ? [String]() : ossKeyList!
        getPhotosByOssKey(ossKeyList: keys, photos: [MWPhoto](), index: 0) { (_, ps) in
            var photos = ps
            // dataList
            if dataList != nil && dataList!.count > 0 {
                for data in dataList! {
                    let photo = MWPhoto(image: UIImage(data: data))
                    if photo == nil {
                        continue
                    }
                    photos.append(photo!)
                }
            }
            // iamgeList
            if imageList != nil && imageList!.count > 0 {
                for image in imageList! {
                    let photo = MWPhoto(image: image)
                    if photo == nil {
                        continue
                    }
                    photos.append(photo!)
                }
            }
            // filePathList
            if filePathList != nil && filePathList!.count > 0 {
                for filePath in filePathList! {
                    let photo = MWPhoto(url: URL(fileURLWithPath: filePath))
                    if photo == nil {
                        continue
                    }
                    photos.append(photo!)
                }
            }
            // 最后回调
            complete(photos)
        }
    }
    
    private static func getPhotosByOssKey(ossKeyList: [String], photos: [MWPhoto], index: Int, complete: @escaping (([String], [MWPhoto]) -> ())) {
        if index >= ossKeyList.count {
            // 结束
            complete(ossKeyList, photos)
            return
        }
        let ossKey = ossKeyList[index]
        if StringUtils.isEmpty(ossKey) {
            // 继续递归
            getPhotosByOssKey(ossKeyList: ossKeyList, photos: photos, index: index + 1, complete: complete)
            return
        }
        var ps = photos
        // 开始判断是有有缓存
        KFHelper.getImgByOssKey(ossKey: ossKey, success: { (_, img) in
            if img.kf.gifRepresentation() != nil {
                // gif，直接加载网络图
                let url = OssHelper.getUrl(objKey: ossKey)
                if !StringUtils.isEmpty(url) {
                    let photo = MWPhoto(url: URL(string: url))
                    if photo != nil {
                        ps.append(photo!)
                    }
                    // 继续递归
                    getPhotosByOssKey(ossKeyList: ossKeyList, photos: ps, index: index + 1, complete: complete)
                    return
                }
            }
            // 本地数据
            let photo = MWPhoto(image: img)
            if photo != nil {
                ps.append(photo!)
            }
            // 继续递归
            getPhotosByOssKey(ossKeyList: ossKeyList, photos: ps, index: index + 1, complete: complete)
        }) { (key) in
            let url = OssHelper.getUrl(objKey: ossKey)
            if !StringUtils.isEmpty(url) {
                let photo = MWPhoto(url: URL(string: url))
                if photo != nil {
                    ps.append(photo!)
                }
                // 继续递归
                getPhotosByOssKey(ossKeyList: ossKeyList, photos: ps, index: index + 1, complete: complete)
            }
        }
    }
    
}
