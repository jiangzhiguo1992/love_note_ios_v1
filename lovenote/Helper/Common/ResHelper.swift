//
//  ResHelper.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/1.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation

class ResHelper {
    
    public static func getMaxCacheSize() -> Int64 {
        var maxSize = FileUtils.getFileSystemSize(path: FileUtils.getResDocuments()) / 2
        if maxSize <= 0 {
            maxSize = FileUtils.SIZE_GB * 10
        }
        return maxSize
    }
    
    public static func getCacheSize() -> Int64 {
        // sys + kf
        let sysSize = FileUtils.getCachesSize()
        // ktv
        let ktvSize = PlayerHelper.getCacheSize()
        return sysSize + ktvSize
    }
    
    public static func clearCache() {
        // sys
        FileUtils.clearCaches()
        // kf
        KFHelper.clearDiskCaches()
        // ktv
        PlayerHelper.clearCache()
    }
    
    public static func getKFCachePath() {
        // 会自动放在 cache目录里
    }
    
    public static func getKTVCachePath() {
        // 需要对缓存拥有强控制权，已提供完整的缓存操作 API，没必要依赖系统策略。？？？？
        // https://github.com/ChangbaDevs/KTVHTTPCache/issues/74
    }
    
}
