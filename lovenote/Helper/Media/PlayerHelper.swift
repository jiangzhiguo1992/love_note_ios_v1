//
//  PlayerHelper.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/1.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import AVKit
import KTVHTTPCache

class PlayerHelper {
    
    public static func initApp() {
        do {
            // 开启代理，全局启动一次即可，把手机当成httpServer
            try KTVHTTPCache.proxyStart()
        } catch {
            
        }
        KTVHTTPCache.logSetConsoleLogEnable(AppUtils.getInfoBool(key: "IS_DEBUG")) // 控制台日志功能
        KTVHTTPCache.logSetRecordLogEnable(false) // 关闭本地日志功能
        KTVHTTPCache.cacheSetMaxCacheLength(ResHelper.getMaxCacheSize()) // 最大缓存
        KTVHTTPCache.downloadSetTimeoutInterval(600) // 下载超时
        // KTVHTTPCache.downloadSetAcceptableContentTypes(<#T##acceptableContentTypes: [String]!##[String]!#>) // 支持的content-type
        // KTVHTTPCache.downloadSetAdditionalHeaders(<#T##additionalHeaders: [String : String]!##[String : String]!#>)
        // KTVHTTPCache.downloadSetWhitelistHeaderKeys(<#T##whitelistHeaderKeys: [String]!##[String]!#>)
    }
    
    public static func clearCache() {
        KTVHTTPCache.cacheDeleteAllCaches()
    }
    
    public static func getCacheSize() -> Int64 {
        return KTVHTTPCache.cacheTotalCacheLength()
    }
    
    public static func getPlayer(ossKey: String?) -> AVPlayer{
        // 获取url
        let url = OssHelper.getUrl(objKey: ossKey)
        // 设置缓存key
        KTVHTTPCache.encodeSetURLConverter { (originalUrl) -> URL? in
            return URL(string: ossKey ?? "")
        }
        // 获取代理url
        let urlCache = KTVHTTPCache.proxyURL(withOriginalURL: URL(string: url)!)
        // AVPlayer
        let asset = AVAsset(url: urlCache!)
        let palyerItem = AVPlayerItem(asset: asset)
        return AVPlayer(playerItem: palyerItem)
    }
    
    public static func play(player: AVPlayer?) {
        player?.play()
    }
    
    public static func pause(player: AVPlayer?) {
        player?.pause()
    }
    
}
