//
//  FileUtils.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/21.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation

class FileUtils {

    public static let SIZE_B: Int64 = 1
    public static let SIZE_KB: Int64 = SIZE_B * 1024
    public static let SIZE_MB: Int64 = SIZE_KB * 1024
    public static let SIZE_GB: Int64 = SIZE_MB * 1024

    /*
     **********************************************文件路径********************************************
     */
    // 应用数据，会被iTunes备份，也就是版本升级也保留
    public static func getResDocuments() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if paths.count <= 0 {
            return ""
        }
        return paths[0]
    }

    // 缓存文件，退出不删除
    public static func getResCaches() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        if paths.count <= 0 {
            return ""
        }
        return paths[0]
    }

    // 临时文件，退出删除
    public static func getResTmp() -> String {
        return NSTemporaryDirectory()
    }

    /*
     **********************************************文件删除********************************************
     */
    // 清除缓存
    public static func clearCaches() {
        // 获取Caches目录路径和目录下所有文件
        let cachePath = getResCaches()
        if StringUtils.isEmpty(cachePath) {
            return
        }
        let files = FileManager.default.subpaths(atPath: cachePath)
        if files == nil || files!.count <= 0 {
            return
        }
        // 枚举出所有文件，并删除
        for file in files! {
            let path = cachePath + "(/\(file))"
            _ = deleteFile(path: path)
        }
    }

    // 删除单个文件
    public static func deleteFile(path: String?) -> Bool {
        if StringUtils.isEmpty(path) {
            return true
        }
        let manager = FileManager.default
        if !manager.fileExists(atPath: path!) {
            return true
        }
        do {
            try manager.removeItem(atPath: path!)
            return true
        } catch {
            LogUtils.w(tag: "FileUtils", method: "deleteFile", error.localizedDescription)
            return false
        }
    }

    /*
     **********************************************文件大小********************************************
     */
    // 计算缓存大小
    public static func getCachesSize() -> Int64 {
        // 获取Caches目录路径和目录下所有文件
        let cachePath = getResCaches()
        if StringUtils.isEmpty(cachePath) {
            return 0
        }
        let files = FileManager.default.subpaths(atPath: cachePath)
        if files == nil || files!.count <= 0 {
            return 0
        }
        // 枚举出所有文件，计算文件大小
        var folderSize: Int64 = 0
        for file in files! {
            // 路径拼接
            let path = cachePath + ("/\(file)")
            // 计算缓存大小
            folderSize += getFileSize(path: path)
        }
        return folderSize
    }

    // 计算单个文件大小
    public static func getFileSize(path: String?) -> Int64 {
        if StringUtils.isEmpty(path) {
            return 0
        }
        let manager = FileManager.default
        if !manager.fileExists(atPath: path!) {
            return 0
        }
        do {
            let attr = try manager.attributesOfItem(atPath: path!)
            let size = attr[FileAttributeKey.size] as! Int64
            return size
        } catch {
            LogUtils.w(tag: "FileUtils", method: "getFileSize", error.localizedDescription)
            return 0
        }
    }

    // 计算单个系统文件大小
    public static func getFileSystemSize(path: String?) -> Int64 {
        if StringUtils.isEmpty(path) {
            return 0
        }
        let manager = FileManager.default
        if !manager.fileExists(atPath: path!) {
            return 0
        }

        let attr = try? manager.attributesOfFileSystem(forPath: path!)
        if attr != nil && attr!.count > 0 {
            return attr![FileAttributeKey.systemSize] as! Int64
        }
        return 0
    }

    // 格式化大小
    public static func getSizeFormat(size: Int64?) -> String {
        if size == nil || size! == 0 {
            return "0B"
        }
        if size! < SIZE_KB {
            return String(format: "%.0fB", arguments: [size!])
        } else if size! < SIZE_MB {
            return String(format: "%.1fKB", arguments: [(Double(size!) / Double(SIZE_KB))])
        } else if size! < SIZE_GB {
            return String(format: "%.1fMB", arguments: [(Double(size!) / Double(SIZE_MB))])
        } else {
            return String(format: "%.1fGB", arguments: [(Double(size!) / Double(SIZE_GB))])
        }
    }

    /*
     **********************************************文件类型********************************************
     */
    // 获取data文件类型
    public static func getExtensionByData(data: Data?) -> String {
        var type: UInt8 = 0
        data?.copyBytes(to: &type, count: 1)
        switch type {
        case 0xFF:
            return "jpeg"
        case 0x89:
            return "png"
        case 0x47:
            return "gif"
        default:
            return ""
        }
    }

}
