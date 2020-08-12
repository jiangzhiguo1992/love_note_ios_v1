//
// Created by 蒋治国 on 2018-12-16.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation
import AliyunOSSiOS

class OssHelper {
    
    private static let FILE_TYPE_TXT = 0
    private static let FILE_TYPE_IMAGE = 1
    private static let FILE_TYPE_AUDIO = 2
    private static let FILE_TYPE_VIDEO = 3
    
    private static var ossClient: OSSClient?
    private static var timer: Timer?
    private static var isFirst = true
    
    // 刷新ossClient
    public static func refreshOssClient() {
        let ossInfo = UDHelper.getOssInfo()
        if StringUtils.isEmpty(ossInfo.accessKeyId) || StringUtils.isEmpty(ossInfo.accessKeySecret) {
            return
        }
        let expireTime = DateUtils.getStr(ossInfo.stsExpireTime, DateUtils.FORMAT_LINE_M_D_H_M)
        LogUtils.i(tag: "OssHelper", method: "refreshOssClient", "sts将在 " + expireTime + " 过期")
        // oss信息 也可用OSSFederationCredentialProvider来实现动态更新
        let credentialProvider = OSSStsTokenCredentialProvider(accessKeyId: ossInfo.accessKeyId, secretKeyId: ossInfo.accessKeySecret, securityToken: ossInfo.securityToken)
        // oss配置
        let conf = OSSClientConfiguration()
        conf.timeoutIntervalForRequest = 60 // 网络请求的超时时间
        conf.timeoutIntervalForResource = 600 // 允许资源传输的最长时间
        conf.maxConcurrentRequestCount = 10 // 最大并发请求数
        conf.maxRetryCount = 5 // 网络请求遇到异常失败后的重试次数
        // oss客户端
        ossClient = OSSClient(endpoint: ossInfo.domain, credentialProvider: credentialProvider, clientConfiguration: conf)
    }
    
    public static func getOssClient() -> OSSClient? {
        if ossClient == nil {
            refreshOssClient()
        }
        return ossClient
    }
    
    public static func getUrl(objKey: String?) -> String {
        if StringUtils.isEmpty(objKey) {
            LogUtils.w(tag: "OssHelper", method: "getUrl", "objKey == null")
            return ""
        }
        let ossInfo = UDHelper.getOssInfo()
        let task = getOssClient()?.presignConstrainURL(withBucketName: ossInfo.bucket, withObjectKey: objKey!, withExpirationInterval: TimeInterval(ossInfo.urlExpireSec))
        if ((task?.error) != nil) {
            LogUtils.e(tag: "OssHelper", method: "getUrl", task?.error as Any)
            // 刷新oss
            ApiHelper.ossInfoUpdate()
            return ""
        }
        let url: String = (task?.result as? String) ?? ""
        //        LogUtils.d(tag: "OssHelper", method: "getUrl", url)
        return url
    }
    
    /**
     * *****************************************刷新任务*****************************************
     */
    public static func startRefreshTimer(app: Bool = false) {
        // 是否第一次启动
        if app && isFirst {
            return
        } else {
            isFirst = false
        }
        // 先停止，避免重复
        stopRefreshTimer()
        // 创建任务，会先执行一次
        let interval = UDHelper.getOssInfo().ossRefreshSec
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: true, block: { (_) in
            LogUtils.i(tag: "OssHelper", method: "startRefreshTimer", "将在" + String(interval) + "秒后刷新OssInfo")
            // 刷新ossInfo
            ApiHelper.ossInfoUpdate()
        })
        // 立刻启动
        timer?.fire()
    }
    
    public static func stopRefreshTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /**
     * *****************************************通用方法*****************************************
     */
    // 创建oss文件名 给后台看的，所以用CST时区
    private static func createOssKey(ossDir: String, data: Data?, type: Int) -> String {
        let uuid = StringUtils.getUUID(len: 8)
        var ext = FileUtils.getExtensionByData(data: data)
        if !StringUtils.isEmpty(ext) {
            ext = "." + ext
        }
        if StringUtils.isEmpty(ext) || ext.count <= 1 {
            switch (type) {
            case FILE_TYPE_TXT:
                ext = ".txt"
                break
            case FILE_TYPE_IMAGE:
                ext = ".jpeg"
                break
            case FILE_TYPE_AUDIO:
                ext = ".mp3"
                break
            case FILE_TYPE_VIDEO:
                ext = ".mp4"
                break
            default:
                break
            }
        }
        return ossDir + DateUtils.getCurrentStr(DateUtils.FORMAT_CHINA_Y_M_D__H_M_S_S) + "-" + uuid + ext
    }
    
    /**
     * *****************************************单文件下载*****************************************
     */
    // 下载任务 前台
    public static func downloadFileInForeground(ossKey: String?,
                                                success: ((_ data: Data?, _ ossKey: String) -> Void)? = nil,
                                                failure: ((_ errMsg: String?, _ ossKey: String) -> Void)? = nil) {
        // progress
        let alert = AlertHelper.getProgress(title: StringUtils.getString("are_download"), msg: nil, cancelHandler: nil)
        // request
        let request = downloadFile(ossKey: ossKey, toast: { (msg) in
            ToastUtils.show(msg)
        }, start: {
            AlertHelper.show(alert)
        }, progress: { (writeSize, totalSize) in
            AppDelegate.runOnMainAsync {
                if alert.isShowing {
                    alert.progress = Float(writeSize) / Float(totalSize)
                }
            }
        }, end: {
            AlertHelper.diss(alert)
        }, success: success, failure: failure)
        // cancel
        alert.cancelHandler = { (_) in
            request?.cancel()
        }
    }
    
    // 下载任务 后台
    public static func downloadFileInBackground(ossKey: String?, toast: Bool = false,
                                                success: ((_ data: Data?, _ ossKey: String) -> Void)? = nil,
                                                failure: ((_ errMsg: String?, _ ossKey: String) -> Void)? = nil) {
        _ = downloadFile(ossKey: ossKey, toast: { (msg) in
            if toast {
                ToastUtils.show(msg)
            }
        }, start: nil, progress: nil, end: nil, success: success, failure: failure)
    }
    
    // 任务下载 base
    public static func downloadFile(ossKey: String?,
                                    toast: ((_ msg: String?) -> Void)? = nil,
                                    start: (() -> Void)? = nil,
                                    progress: ((_ writeSize: Int64, _ totalSize: Int64) -> Void)? = nil,
                                    end: (() -> Void)? = nil,
                                    success: ((_ data: Data, _ ossKey: String) -> Void)? = nil,
                                    failure: ((_ errMsg: String?, _ ossKey: String) -> Void)? = nil) -> OSSGetObjectRequest? {
        // ossKey
        if StringUtils.isEmpty(ossKey) {
            LogUtils.w(tag: "OssHelper", method: "downloadFile", "ossKey == nil")
            let msg = StringUtils.getString("access_resource_path_no_exists")
            toast?(msg)
            AppDelegate.runOnMainAsync {
                failure?(msg, ossKey ?? "")
            }
            return nil
        }
        
        // 构造上传请求
        let get = OSSGetObjectRequest()
        get.bucketName = UDHelper.getOssInfo().bucket
        get.objectKey = ossKey!
        // 异步下载时设置进度回调
        get.downloadProgress = { (bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) in
            LogUtils.d(tag: "OssHelper", method: "downloadFile", "\(bytesWritten), \(totalBytesWritten), \(totalBytesExpectedToWrite)")
            progress?(totalBytesWritten, totalBytesExpectedToWrite)
        }
        // client
        let client = getOssClient()
        if client == nil {
            LogUtils.w(tag: "OssHelper", method: "downloadFile", "client == nil")
            let msg = StringUtils.getString("download_fail_tell_we_this_bug")
            toast?(msg)
            AppDelegate.runOnMainAsync {
                failure?(msg, ossKey!)
            }
            return nil
        }
        // 开始上传
        start?()
        LogUtils.w(tag: "OssHelper", method: "downloadFile", "ossKey == " + ossKey!)
        let task = client!.getObject(get)
        task.continue({ (task) -> AnyObject? in
            if ((task.error) == nil) {
                // 上传成功
                LogUtils.w(tag: "OssHelper", method: "downloadFile", "onSuccess: ossKey == " + ossKey!)
                end?()
                
                let result = task.result as! OSSGetObjectResult
                AppDelegate.runOnMainAsync {
                    success?(result.downloadedData, ossKey!)
                }
            } else {
                // 上传失败
                LogUtils.w(tag: "OssHelper", method: "downloadFile", "onFailure: ossKey == " + ossKey!)
                ApiHelper.ossInfoUpdate()
                end?()
                let msg = task.error?.localizedDescription
                toast?(msg)
                AppDelegate.runOnMainAsync {
                    failure?(msg, ossKey!)
                }
            }
            return nil
        })
        return get
    }
    
    /**
     * *****************************************单文件上传*****************************************
     */
    // 上传任务 后缀名 + 前台
    public static func uploadFileInForegroundWithName(ossDirPath: String?, data: Data?, type: Int,
                                                      success: ((_ data: Data?, _ ossKey: String) -> Void)? = nil,
                                                      failure: ((_ data: Data?, _ errMsg: String?) -> Void)? = nil) {
        // ossDirPath
        if StringUtils.isEmpty(ossDirPath) {
            LogUtils.w(tag: "OssHelper", method: "uploadFileInForegroundWithName", "ossDirPath == nil")
            let msg = StringUtils.getString("access_resource_path_no_exists")
            ToastUtils.show(msg)
            AppDelegate.runOnMainAsync {
                failure?(data, msg)
            }
            return
        }
        // objectKey
        let objectKey = createOssKey(ossDir: ossDirPath!, data: data, type: type)
        // 开始时上传
        uploadFileInForeground(data: data, ossKey: objectKey, success: success, failure: failure)
    }
    
    // 上传任务 前台
    public static func uploadFileInForeground(data: Data?, ossKey: String?,
                                              success: ((_ data: Data?, _ ossKey: String) -> Void)? = nil,
                                              failure: ((_ data: Data?, _ errMsg: String?) -> Void)? = nil) {
        // progress
        let alert = AlertHelper.getProgress(title: StringUtils.getString("are_upload"), msg: nil, cancelHandler: nil)
        // request
        let request = uploadFile(data: data, ossKey: ossKey, toast: { (msg) in
            ToastUtils.show(msg)
        }, start: {
            AlertHelper.show(alert)
        }, progress: { (writeSize, totalSize) in
            AppDelegate.runOnMainAsync {
                if alert.isShowing {
                    alert.progress = Float(writeSize) / Float(totalSize)
                }
            }
        }, end: {
            AlertHelper.diss(alert)
        }, success: success, failure: failure)
        // calcel
        alert.cancelHandler = { (_) in
            request?.cancel()
        }
    }
    
    // 上传任务 后台
    public static func uploadFileInBackground(data: Data?, ossKey: String?, toast: Bool = false,
                                              success: ((_ data: Data?, _ ossKey: String) -> Void)? = nil,
                                              failure: ((_ data: Data?, _ errMsg: String?) -> Void)? = nil) {
        _ = uploadFile(data: data, ossKey: ossKey, toast: { (msg) in
            if toast {
                ToastUtils.show(msg)
            }
        }, start: nil, progress: nil, end: nil, success: success, failure: failure)
    }
    
    // 任务上传 base
    public static func uploadFile(data: Data?, ossKey: String?,
                                  toast: ((_ msg: String?) -> Void)? = nil,
                                  start: (() -> Void)? = nil,
                                  progress: ((_ writeSize: Int64, _ totalSize: Int64) -> Void)? = nil,
                                  end: (() -> Void)? = nil,
                                  success: ((_ data: Data?, _ ossKey: String) -> Void)? = nil,
                                  failure: ((_ data: Data?, _ errMsg: String?) -> Void)? = nil) -> OSSPutObjectRequest? {
        // data
        if data == nil || data!.count <= 0 {
            LogUtils.w(tag: "OssHelper", method: "uploadFile", "data == nil")
            let msg = StringUtils.getString("upload_file_no_exists")
            toast?(msg)
            AppDelegate.runOnMainAsync {
                failure?(data, msg)
            }
            return nil
        }
        // ossKey
        if StringUtils.isEmpty(ossKey) {
            LogUtils.w(tag: "OssHelper", method: "uploadFile", "ossKey == nil")
            let msg = StringUtils.getString("access_resource_path_no_exists")
            toast?(msg)
            AppDelegate.runOnMainAsync {
                failure?(data, msg)
            }
            return nil
        }
        // 构造上传请求
        let put = OSSPutObjectRequest()
        put.bucketName = UDHelper.getOssInfo().bucket
        put.objectKey = ossKey!
        put.uploadingData = data!
        // 异步上传时设置进度回调
        put.uploadProgress = { (bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) in
            LogUtils.d(tag: "OssHelper", method: "uploadFile", "\(bytesWritten), \(totalBytesWritten), \(totalBytesExpectedToWrite)")
            progress?(totalBytesWritten, totalBytesExpectedToWrite)
        }
        // client
        let client = getOssClient()
        if client == nil {
            LogUtils.w(tag: "OssHelper", method: "uploadFile", "client == nil")
            let msg = StringUtils.getString("upload_fail_tell_we_this_bug")
            toast?(msg)
            AppDelegate.runOnMainAsync {
                failure?(data, msg)
            }
            return nil
        }
        // 开始上传
        start?()
        LogUtils.w(tag: "OssHelper", method: "uploadFile", "ossKey == " + ossKey!)
        let task = client!.putObject(put)
        task.continue({ (task) -> AnyObject? in
            if ((task.error) == nil) {
                // 上传成功
                LogUtils.w(tag: "OssHelper", method: "uploadFile", "onSuccess: ossKey == " + ossKey!)
                end?()
                AppDelegate.runOnMainAsync {
                    success?(data, ossKey!)
                }
            } else {
                // 上传失败
                LogUtils.w(tag: "OssHelper", method: "uploadFile", "onFailure: ossKey == " + ossKey!)
                ApiHelper.ossInfoUpdate()
                end?()
                let msg = task.error?.localizedDescription
                toast?(msg)
                AppDelegate.runOnMainAsync {
                    failure?(data, msg)
                }
            }
            return nil
        })
        return put
    }
    
    /**
     * *****************************************多文件上传*****************************************
     */
    // 上传任务 后缀名 + 前台
    public static func uploadFilesInForegroundWithName(ossDirPath: String?, dataList: [Data]?, type: Int, canMiss: Bool,
                                                       success: ((_ dataList: [Data]?, _ ossKeyList: [String], _ successList: [String]) -> Void)? = nil,
                                                       failure: ((_ index: Int, _ dataList: [Data]?, _ errMsg: String?) -> Void)? = nil) {
        // ossDirPath
        if StringUtils.isEmpty(ossDirPath) {
            LogUtils.w(tag: "OssHelper", method: "uploadFilesInForegroundWithName", "ossDirPath == nil")
            let msg = StringUtils.getString("access_resource_path_no_exists")
            ToastUtils.show(msg)
            AppDelegate.runOnMainAsync {
                failure?(0, dataList, msg)
            }
            return
        }
        // ossKeyList
        var ossKeyList = [String]()
        if dataList != nil && dataList!.count > 0 {
            for data in dataList! {
                if data.count <= 0 {
                    ossKeyList.append("")
                    continue
                }
                ossKeyList.append(createOssKey(ossDir: ossDirPath!, data: data, type: type))
            }
        }
        // 开始时上传
        uploadFilesInForeground(dataList: dataList, ossKeyList: ossKeyList, canMiss: canMiss, success: success, failure: failure)
    }
    
    // 上传多任务 前台
    public static func uploadFilesInForeground(dataList: [Data]?, ossKeyList: [String]?, canMiss: Bool,
                                               success: ((_ dataList: [Data]?, _ ossKeyList: [String], _ successList: [String]) -> Void)? = nil,
                                               failure: ((_ index: Int, _ dataList: [Data]?, _ errMsg: String?) -> Void)? = nil) {
        // progress
        let alert = AlertHelper.getProgress(title: StringUtils.getString("are_upload"), msg: nil, cancelHandler: nil)
        // request
        let request = uploadFiles(dataList: dataList, ossKeyList: ossKeyList, index: 0, canMiss: canMiss, successList: [String](), toast: { (index, msg) in
            ToastUtils.show(msg)
        }, start: { (index) in
            if index <= 0 {
                AlertHelper.show(alert)
            }
            //            alert.setProgress(0, progressLabelText: StringUtils.getString("are_upload_space_holder_holder", arguments: [(index + 1), (dataList?.count ?? 0)]))
        }, progress: { (index, writeSize, totalSize) in
            AppDelegate.runOnMainAsync {
                if alert.isShowing {
                    alert.progress = Float(writeSize) / Float(totalSize)
                }
            }
        }, end: { (index) in
            AlertHelper.diss(alert)
        }, success: success, failure: failure)
        // calcel
        alert.cancelHandler = { (_) in
            request?.cancel()
        }
    }
    
    // 上传多任务 后台
    public static func uploadFilesInBackground(dataList: [Data]?, ossKeyList: [String]?,
                                               canMiss: Bool, toast: Bool = false,
                                               success: ((_ dataList: [Data]?, _ ossKeyList: [String], _ successList: [String]) -> Void)? = nil,
                                               failure: ((_ index: Int, _ dataList: [Data]?, _ errMsg: String?) -> Void)? = nil) {
        _ = uploadFiles(dataList: dataList, ossKeyList: ossKeyList, index: 0, canMiss: canMiss, successList: [String](), toast: { (index, msg) in
            if toast {
                ToastUtils.show(msg)
            }
        }, start: nil, progress: nil, end: nil, success: success, failure: failure)
    }
    
    // 上传多任务 base
    public static func uploadFiles(dataList: [Data]?, ossKeyList: [String]?,
                                   index: Int, canMiss: Bool, successList: [String]?,
                                   toast: ((_ index: Int, _ msg: String?) -> Void)? = nil,
                                   start: ((_ index: Int) -> Void)? = nil,
                                   progress: ((_ index: Int, _ writeSize: Int64, _ totalSize: Int64) -> Void)? = nil,
                                   end: ((_ index: Int) -> Void)? = nil,
                                   success: ((_ dataList: [Data]?, _ ossKeyList: [String], _ successList: [String]) -> Void)? = nil,
                                   failure: ((_ index: Int, _ dataList: [Data]?, _ errMsg: String?) -> Void)? = nil) -> OSSPutObjectRequest? {
        // dataList
        if dataList == nil || dataList!.count <= 0 || dataList!.count <= index {
            LogUtils.w(tag: "OssHelper", method: "uploadFiles", "index == \(index) <---> dataList.count = \(dataList == nil ? 0 : dataList!.count)")
            let msg = StringUtils.getString("not_found_upload_file")
            toast?(index, msg)
            end?(index)
            if canMiss && successList != nil && successList!.count > 0 {
                AppDelegate.runOnMainAsync {
                    success?(dataList, ossKeyList ?? [String](), successList!)
                }
            } else {
                AppDelegate.runOnMainAsync {
                    failure?(index, dataList, msg)
                }
            }
            return nil
        }
        // ossKeyList
        if ossKeyList == nil || ossKeyList!.count <= 0 || ossKeyList!.count <= index {
            LogUtils.w(tag: "OssHelper", method: "uploadFiles", "index == \(index) <---> ossKeyList.count = \(ossKeyList == nil ? 0 : ossKeyList!.count)")
            let msg = StringUtils.getString("not_found_upload_file")
            toast?(index, msg)
            end?(index)
            if canMiss && successList != nil && successList!.count > 0 {
                AppDelegate.runOnMainAsync {
                    success?(dataList, ossKeyList ?? [String](), successList!)
                }
            } else {
                AppDelegate.runOnMainAsync {
                    failure?(index, dataList, msg)
                }
            }
            return nil
        }
        // data
        let data = dataList![index]
        if data.count <= 0 {
            LogUtils.w(tag: "OssHelper", method: "uploadFiles", "index == \(index) <---> data == nil")
            let msg = StringUtils.getString("upload_file_no_exists")
            toast?(index, msg)
            if canMiss && index < dataList!.count - 1 {
                // 继续上传
                return uploadFiles(dataList: dataList, ossKeyList: ossKeyList, index: index + 1, canMiss: canMiss, successList: successList,
                                   toast: toast, start: start, progress: progress, end: end, success: success, failure: failure)
            }
            end?(index)
            if canMiss && successList != nil && successList!.count > 0 {
                AppDelegate.runOnMainAsync {
                    success?(dataList, ossKeyList ?? [String](), successList!)
                }
            } else {
                AppDelegate.runOnMainAsync {
                    failure?(index, dataList, msg)
                }
            }
            return nil
        }
        // ossKey
        let ossKey = ossKeyList![index]
        if StringUtils.isEmpty(ossKey) {
            LogUtils.w(tag: "OssHelper", method: "uploadFiles", "index == \(index) <---> ossKey == nil")
            let msg = StringUtils.getString("access_resource_path_no_exists")
            toast?(index, msg)
            if canMiss && index < dataList!.count - 1 {
                // 继续上传
                return uploadFiles(dataList: dataList, ossKeyList: ossKeyList, index: index + 1, canMiss: canMiss, successList: successList,
                                   toast: toast, start: start, progress: progress, end: end, success: success, failure: failure)
            }
            end?(index)
            if canMiss && successList != nil && successList!.count > 0 {
                AppDelegate.runOnMainAsync {
                    success?(dataList, ossKeyList ?? [String](), successList!)
                }
            } else {
                AppDelegate.runOnMainAsync {
                    failure?(index, dataList, msg)
                }
            }
            return nil
        }
        // 构造上传请求
        let put = OSSPutObjectRequest()
        put.bucketName = UDHelper.getOssInfo().bucket
        put.objectKey = ossKey
        put.uploadingData = data
        // 异步上传时设置进度回调
        put.uploadProgress = { (bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) in
            LogUtils.d(tag: "OssHelper", method: "uploadFiles", "\(index), \(bytesWritten), \(totalBytesWritten), \(totalBytesExpectedToWrite)")
            progress?(index, totalBytesWritten, totalBytesExpectedToWrite)
        }
        // client
        let client = getOssClient()
        if client == nil {
            LogUtils.w(tag: "OssHelper", method: "uploadFiles", "client == nil")
            let msg = StringUtils.getString("upload_fail_tell_we_this_bug")
            toast?(index, msg)
            end?(index)
            if canMiss && successList != nil && successList!.count > 0 {
                AppDelegate.runOnMainAsync {
                    success?(dataList, ossKeyList ?? [String](), successList!)
                }
            } else {
                AppDelegate.runOnMainAsync {
                    failure?(index, dataList, msg)
                }
            }
            return nil
        }
        // 开始上传
        start?(index)
        LogUtils.w(tag: "OssHelper", method: "uploadFiles", "\(index) <---> ossKey == \(ossKey)")
        let task = client!.putObject(put)
        task.continue({ (task) -> AnyObject? in
            if ((task.error) == nil) {
                // 上传成功
                LogUtils.w(tag: "OssHelper", method: "uploadFiles", "onSuccess: index == \(index) <---> ossKey == " + ossKey)
                var newSuccessList = [String]()
                newSuccessList += successList ?? [String]()
                newSuccessList.append(ossKey)
                if index < dataList!.count - 1 {
                    // 继续上传
                    _ = uploadFiles(dataList: dataList, ossKeyList: ossKeyList, index: index + 1, canMiss: canMiss, successList: newSuccessList,
                                    toast: toast, start: start, progress: progress, end: end, success: success, failure: failure)
                } else {
                    end?(index)
                    AppDelegate.runOnMainAsync {
                        success?(dataList, ossKeyList ?? [String](), newSuccessList)
                    }
                }
            } else {
                // 上传失败
                LogUtils.w(tag: "OssHelper", method: "uploadFile", "onFailure: index == \(index) <---> ossKey == " + ossKey)
                ApiHelper.ossInfoUpdate()
                let msg = task.error?.localizedDescription
                toast?(index, msg)
                
                
                if canMiss && index < dataList!.count - 1 {
                    // 继续上传
                    return uploadFiles(dataList: dataList, ossKeyList: ossKeyList, index: index + 1, canMiss: canMiss, successList: successList,
                                       toast: toast, start: start, progress: progress, end: end, success: success, failure: failure)
                }
                end?(index)
                if canMiss && successList != nil && successList!.count > 0 {
                    AppDelegate.runOnMainAsync {
                        success?(dataList, ossKeyList ?? [String](), successList!)
                    }
                } else {
                    AppDelegate.runOnMainAsync {
                        failure?(index, dataList, msg)
                    }
                }
                end?(index)
                if canMiss && successList != nil && successList!.count > 0 {
                    AppDelegate.runOnMainAsync {
                        success?(dataList, ossKeyList ?? [String](), successList!)
                    }
                } else {
                    AppDelegate.runOnMainAsync {
                        failure?(index, dataList, msg)
                    }
                }
            }
            return nil
        })
        return put
    }
    
    /**
     * *****************************************具体上传*****************************************
     */
    // 意见 (压缩)
    public static func uploadSuggest(data: Data?,
                                     success: ((_ data: Data?, _ ossKey: String) -> Void)? = nil,
                                     failure: ((_ data: Data?, _ errMsg: String?) -> Void)? = nil) {
        let ossDirPath = UDHelper.getOssInfo().pathSuggest
        uploadFileInForegroundWithName(ossDirPath: ossDirPath, data: data, type: FILE_TYPE_IMAGE, success: success, failure: failure)
    }
    
    // 头像 (压缩)
    public static func uploadAvatar(data: Data?,
                                    success: ((_ data: Data?, _ ossKey: String) -> Void)? = nil,
                                    failure: ((_ data: Data?, _ errMsg: String?) -> Void)? = nil) {
        let ossDirPath = UDHelper.getOssInfo().pathCoupleAvatar
        uploadFileInForegroundWithName(ossDirPath: ossDirPath, data: data, type: FILE_TYPE_IMAGE, success: success, failure: failure)
    }
    
    // 墙纸 (限制)
    public static func uploadWall(data: Data?,
                                  success: ((_ data: Data?, _ ossKey: String) -> Void)? = nil,
                                  failure: ((_ data: Data?, _ errMsg: String?) -> Void)? = nil) {
        let maxSize = UDHelper.getVipLimit().wallPaperSize
        if data != nil && data!.count >= maxSize {
            let sizeShow = FileUtils.getSizeFormat(size: maxSize)
            let limitShow = StringUtils.getString("file_too_large_cant_over_holder", arguments: [sizeShow])
            ToastUtils.show(limitShow)
            failure?(data, limitShow)
            // vip跳转
            MoreVipVC.pushVC()
            return
        }
        let ossDirPath = UDHelper.getOssInfo().pathCoupleWall
        uploadFileInForegroundWithName(ossDirPath: ossDirPath, data: data, type: FILE_TYPE_IMAGE, success: success, failure: failure)
    }
    
    // 音频 (限制)
    public static func uploadAudio(data: Data?,
                                   success: ((_ data: Data?, _ ossKey: String) -> Void)? = nil,
                                   failure: ((_ data: Data?, _ errMsg: String?) -> Void)? = nil) {
        let maxSize = UDHelper.getVipLimit().audioSize
        if data != nil && data!.count >= maxSize {
            let sizeShow = FileUtils.getSizeFormat(size: maxSize)
            let limitShow = StringUtils.getString("file_too_large_cant_over_holder", arguments: [sizeShow])
            ToastUtils.show(limitShow)
            failure?(data, limitShow)
            // vip跳转
            MoreVipVC.pushVC()
            return
        }
        let ossDirPath = UDHelper.getOssInfo().pathNoteAudio
        uploadFileInForegroundWithName(ossDirPath: ossDirPath, data: data, type: FILE_TYPE_AUDIO, success: success, failure: failure)
    }
    
    // 视频封面 (压缩)
    public static func uploadVideoThumb(data: Data?,
                                        success: ((_ data: Data?, _ ossKey: String) -> Void)? = nil,
                                        failure: ((_ data: Data?, _ errMsg: String?) -> Void)? = nil) {
        let ossDirPath = UDHelper.getOssInfo().pathNoteVideoThumb
        uploadFileInForegroundWithName(ossDirPath: ossDirPath, data: data, type: FILE_TYPE_IMAGE, success: success, failure: failure)
    }
    
    // 视频 (限制)
    public static func uploadVideo(data: Data?,
                                   success: ((_ data: Data?, _ ossKey: String) -> Void)? = nil,
                                   failure: ((_ data: Data?, _ errMsg: String?) -> Void)? = nil) {
        let maxSize = UDHelper.getVipLimit().videoSize
        if data != nil && data!.count >= maxSize {
            let sizeShow = FileUtils.getSizeFormat(size: maxSize)
            let limitShow = StringUtils.getString("file_too_large_cant_over_holder", arguments: [sizeShow])
            ToastUtils.show(limitShow)
            failure?(data, limitShow)
            // vip跳转
            MoreVipVC.pushVC()
            return
        }
        let ossDirPath = UDHelper.getOssInfo().pathNoteVideo
        uploadFileInForegroundWithName(ossDirPath: ossDirPath, data: data, type: FILE_TYPE_VIDEO, success: success, failure: failure)
    }
    
    // 相册 (压缩)
    public static func uploadAlbum(data: Data?,
                                   success: ((_ data: Data?, _ ossKey: String) -> Void)? = nil,
                                   failure: ((_ data: Data?, _ errMsg: String?) -> Void)? = nil) {
        let ossDirPath = UDHelper.getOssInfo().pathNoteAlbum
        uploadFileInForegroundWithName(ossDirPath: ossDirPath, data: data, type: FILE_TYPE_IMAGE, success: success, failure: failure)
    }
    
    // 照片 (压缩/限制)
    public static func uploadPicture(dataList: [Data]?,
                                     success: ((_ dataList: [Data]?, _ ossKeyList: [String], _ successList: [String]) -> Void)? = nil,
                                     failure: ((_ index: Int, _ dataList: [Data]?, _ errMsg: String?) -> Void)? = nil) {
        if UDHelper.getVipLimit().pictureOriginal {
            // 原图(检查大小)
            let maxSize = UDHelper.getVipLimit().pictureSize
            var overLimit = 0
            if dataList != nil && dataList!.count > 0 {
                for (index, data) in dataList!.enumerated() {
                    if data.count >= maxSize {
                        overLimit = index + 1
                        break
                    }
                }
                if overLimit > 0 {
                    let sizeShow = FileUtils.getSizeFormat(size: maxSize)
                    let limitShow = StringUtils.getString("index_holder_file_too_large_cant_over_holder", arguments: [overLimit, sizeShow])
                    ToastUtils.show(limitShow)
                    failure?(0, dataList, limitShow)
                    // vip跳转
                    MoreVipVC.pushVC()
                    return
                }
            }
        }
        let ossDirPath = UDHelper.getOssInfo().pathNotePicture
        uploadFilesInForegroundWithName(ossDirPath: ossDirPath, dataList: dataList, type: FILE_TYPE_IMAGE, canMiss: true, success: success, failure: failure)
    }
    
    // 耳语 (压缩)
    public static func uploadWhisper(data: Data?,
                                     success: ((_ data: Data?, _ ossKey: String) -> Void)? = nil,
                                     failure: ((_ data: Data?, _ errMsg: String?) -> Void)? = nil) {
        let ossDirPath = UDHelper.getOssInfo().pathNoteWhisper
        uploadFileInForegroundWithName(ossDirPath: ossDirPath, data: data, type: FILE_TYPE_IMAGE, success: success, failure: failure)
    }
    
    // 日记 (限制)
    public static func uploadDiary(dataList: [Data]?,
                                   success: ((_ dataList: [Data]?, _ ossKeyList: [String], _ successList: [String]) -> Void)? = nil,
                                   failure: ((_ index: Int, _ dataList: [Data]?, _ errMsg: String?) -> Void)? = nil) {
        let maxSize = UDHelper.getVipLimit().diaryImageSize
        var overLimit = false
        if dataList != nil && dataList!.count > 0 {
            for data in dataList! {
                if data.count >= maxSize {
                    overLimit = true
                    break
                }
            }
            if overLimit {
                let sizeShow = FileUtils.getSizeFormat(size: maxSize)
                let limitShow = StringUtils.getString("file_too_large_cant_over_holder", arguments: [sizeShow])
                ToastUtils.show(limitShow)
                failure?(0, dataList, limitShow)
                // vip跳转
                MoreVipVC.pushVC()
                return
            }
        }
        let ossDirPath = UDHelper.getOssInfo().pathNoteDiary
        uploadFilesInForegroundWithName(ossDirPath: ossDirPath, dataList: dataList, type: FILE_TYPE_IMAGE, canMiss: false, success: success, failure: failure)
    }
    
    // 礼物 (压缩)
    public static func uploadGift(dataList: [Data]?,
                                  success: ((_ dataList: [Data]?, _ ossKeyList: [String], _ successList: [String]) -> Void)? = nil,
                                  failure: ((_ index: Int, _ dataList: [Data]?, _ errMsg: String?) -> Void)? = nil) {
        let ossDirPath = UDHelper.getOssInfo().pathNoteGift
        uploadFilesInForegroundWithName(ossDirPath: ossDirPath, dataList: dataList, type: FILE_TYPE_IMAGE, canMiss: false, success: success, failure: failure)
    }
    
    // 电影 (压缩)
    public static func uploadMovie(dataList: [Data]?,
                                   success: ((_ dataList: [Data]?, _ ossKeyList: [String], _ successList: [String]) -> Void)? = nil,
                                   failure: ((_ index: Int, _ dataList: [Data]?, _ errMsg: String?) -> Void)? = nil) {
        let ossDirPath = UDHelper.getOssInfo().pathNoteMovie
        uploadFilesInForegroundWithName(ossDirPath: ossDirPath, dataList: dataList, type: FILE_TYPE_IMAGE, canMiss: false, success: success, failure: failure)
    }
    
    // 美食 (压缩)
    public static func uploadFood(dataList: [Data]?,
                                  success: ((_ dataList: [Data]?, _ ossKeyList: [String], _ successList: [String]) -> Void)? = nil,
                                  failure: ((_ index: Int, _ dataList: [Data]?, _ errMsg: String?) -> Void)? = nil) {
        let ossDirPath = UDHelper.getOssInfo().pathNoteFood
        uploadFilesInForegroundWithName(ossDirPath: ossDirPath, dataList: dataList, type: FILE_TYPE_IMAGE, canMiss: false, success: success, failure: failure)
    }
    
    // 帖子 (压缩)
    public static func uploadTopicPost(dataList: [Data]?,
                                       success: ((_ dataList: [Data]?, _ ossKeyList: [String], _ successList: [String]) -> Void)? = nil,
                                       failure: ((_ index: Int, _ dataList: [Data]?, _ errMsg: String?) -> Void)? = nil) {
        let ossDirPath = UDHelper.getOssInfo().pathTopicPost
        uploadFilesInForegroundWithName(ossDirPath: ossDirPath, dataList: dataList, type: FILE_TYPE_IMAGE, canMiss: false, success: success, failure: failure)
    }
    
    // 作品 (压缩)
    public static func uploadMoreMatch(data: Data?,
                                       success: ((_ data: Data?, _ ossKey: String) -> Void)? = nil,
                                       failure: ((_ data: Data?, _ errMsg: String?) -> Void)? = nil) {
        let ossDirPath = UDHelper.getOssInfo().pathMoreMatch
        uploadFileInForegroundWithName(ossDirPath: ossDirPath, data: data, type: FILE_TYPE_IMAGE, success: success, failure: failure)
    }
    
}
