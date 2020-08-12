//
// Created by 蒋治国 on 2018-12-16.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class ApiHelper {
    
    // user登录类型
    public static let LOG_PWD: Int = 1
    public static let LOG_VER: Int = 2
    // user修改类型
    public static let MODIFY_FORGET: Int = 11
    public static let MODIFY_PASSWORD: Int = 12
    public static let MODIFY_PHONE: Int = 13
    public static let MODIFY_INFO: Int = 14
    // cp修改类型
    public static let COUPLE_UPDATE_GOOD: Int = 1
    public static let COUPLE_UPDATE_BAD: Int = 2
    public static let COUPLE_UPDATE_INFO: Int = 3
    // comment order类型
    public static let LIST_COMMENT_ORDER_POINT: Int = 0
    public static let LIST_COMMENT_ORDER_TIME: Int = 1
    public static let LIST_COMMENT_ORDER_TYPE: [Int] = [LIST_COMMENT_ORDER_POINT, LIST_COMMENT_ORDER_TIME]
    public static let LIST_COMMENT_ORDER_SHOW: [String] = [StringUtils.getString("point"), StringUtils.getString("time")]
    // note search类型
    public static let LIST_NOTE_WHO_CP: Int = 0
    public static let LIST_NOTE_WHO_MY: Int = 1
    public static let LIST_NOTE_WHO_TA: Int = 2
    public static let LIST_NOTE_WHO_TYPE: [Int] = [LIST_NOTE_WHO_CP, LIST_NOTE_WHO_MY, LIST_NOTE_WHO_TA]
    public static let LIST_NOTE_WHO_SHOW: [String] = [StringUtils.getString("we_de"), StringUtils.getString("me_de"), StringUtils.getString("ta_de")]
    // topic search类型
    public static let LIST_TOPIC_TYPE_ALL: Int = 0
    public static let LIST_TOPIC_TYPE_OFFICIAL: Int = 1
    public static let LIST_TOPIC_TYPE_WELL: Int = 2
    public static let LIST_TOPIC_TYPE_TYPE: [Int] = [LIST_TOPIC_TYPE_ALL, LIST_TOPIC_TYPE_OFFICIAL, LIST_TOPIC_TYPE_WELL]
    public static let LIST_TOPIC_TYPE_SHOW: [String] = [StringUtils.getString("all"), StringUtils.getString("official"), StringUtils.getString("well")]
    // match search类型
    public static let LIST_MATCH_ORDER_COIN: Int = 0
    public static let LIST_MATCH_ORDER_POINT: Int = 1
    public static let LIST_MATCH_ORDER_NEW: Int = 2
    public static let LIST_MATCH_ORDER_TYPE: [Int] = [LIST_MATCH_ORDER_COIN, LIST_MATCH_ORDER_POINT, LIST_MATCH_ORDER_NEW]
    public static let LIST_MATCH_ORDER_SHOW: [String] = [StringUtils.getString("coin_board"), StringUtils.getString("point_board"), StringUtils.getString("new_board")]
    
    public static func getEntryBody() -> Entry {
        let entry = Entry()
        entry.deviceId = DeviceUtils.getDeviceID()
        entry.deviceName = DeviceUtils.getDeviceName()
        entry.market = "apple"
        entry.language = DeviceUtils.getDeviceLanguage()
        entry.platform = "ios"
        entry.osVersion = DeviceUtils.getOSVersion()
        entry.appVersion = Int(AppUtils.getBuildVersion()) ?? 0
        return entry
    }
    
    public static func getSmsLoginBody(phone: String?) -> Sms {
        let sms = Sms()
        sms.sendType = Sms.TYPE_LOGIN
        sms.phone = phone ?? ""
        return sms
    }
    
    public static func getSmsRegisterBody(phone: String?) -> Sms {
        let sms = Sms()
        sms.sendType = Sms.TYPE_REGISTER
        sms.phone = phone ?? ""
        return sms
    }
    
    public static func getSmsForgetBody(phone: String?) -> Sms {
        let sms = Sms()
        sms.sendType = Sms.TYPE_FORGET
        sms.phone = phone ?? ""
        return sms
    }
    
    public static func getSmsPhoneBody(phone: String?) -> Sms {
        let sms = Sms()
        sms.sendType = Sms.TYPE_PHONE
        sms.phone = phone ?? ""
        return sms
    }
    
    public static func getSmsLockBody(phone: String?) -> Sms {
        let sms = Sms()
        sms.sendType = Sms.TYPE_LOCK
        sms.phone = phone ?? ""
        return sms
    }
    
    public static func getUserBody(phone: String?, pwd: String?) -> User {
        let user = User()
        if !StringUtils.isEmpty(phone) {
            user.phone = phone!
        }
        if !StringUtils.isEmpty(pwd) {
            user.password = EncryptUtils.md5String(pwd!).uppercased()
        }
        return user
    }
    
    public static func getLockBody(pwd: String?) -> Lock {
        let lock = Lock()
        if !StringUtils.isEmpty(pwd) {
            lock.password = EncryptUtils.md5String(pwd!).uppercased()
        }
        return lock
    }
    
    public static func getPostCommentTextBody(pid: Int64, tcid: Int64, content: String) -> PostComment {
        let comment = PostComment()
        comment.postId = pid
        comment.toCommentId = tcid
        comment.kind = PostComment.KIND_TEXT
        comment.contentText = content
        return comment
    }
    
    public static func getPostCommentJabBody(pid: Int64, tcid: Int64) -> PostComment {
        let comment = PostComment()
        comment.postId = pid
        comment.toCommentId = tcid
        comment.kind = PostComment.KIND_JAB
        comment.contentText = ""
        return comment
    }
    
    public static func postEntry() {
        let start = DateUtils.getCurrentInt64()
        let body = getEntryBody()
        _ = Api.request(.entryPush(entry: body.toJSON()), loading: true, success: { (code, msg, data) in
            onEntryFinish(startTime: start, totalWait: 0, code: code, data: data)
        })
    }
    
    public static func onEntryFinish(startTime: Int64, totalWait: Int, code: Int, data: ApiData?) {
        if data == nil {
            return
        }
        // me
        UDHelper.setMe(data?.user)
        // commonConst
        UDHelper.setCommonConst(data?.commonConst)
        // modelShow
        UDHelper.setModelShow(data?.modelShow)
        // limit
        UDHelper.setLimit(data?.limit)
        // vipLimit
        UDHelper.setVipLimit(data?.vipLimit)
        // ossInfo
        UDHelper.setOssInfo(data?.ossInfo)
        OssHelper.refreshOssClient()
        OssHelper.startRefreshTimer()
        // pushInfo
        UDHelper.setPushInfo(data?.pushInfo)
        PushHelper.registerAPNS()
        // adInfo
        UDHelper.setAdInfo(data?.adInfo)
        // commonCount
        UDHelper.setCommonCount(data?.commonCount)
        // version apple不要
        // dely
        let between = Int(DateUtils.getCurrentInt64() - startTime)
        if between >= totalWait {
            // 间隔时间太大
            HomeVC.pushVC()
        } else {
            // 间隔时间太小
            AppDelegate.getQueueMain().asyncAfter(deadline: DispatchTime.now() + .seconds(totalWait - between)) {
                HomeVC.pushVC()
            }
        }
    }
    
    // 更新oss信息
    public static func ossInfoUpdate() {
        if UserHelper.isEmpty(user: UDHelper.getMe()) {
            return
        }
        _ = Api.request(.ossGet, success: { (_, _, data) in
            LogUtils.i(tag: "ApiHelper", method: "ossInfoUpdate", "oss更新成功")
            // 刷新ossInfo
            UDHelper.setOssInfo(data.ossInfo)
            // 刷新ossClient
            OssHelper.refreshOssClient()
        }, failure: { (_, _, _) in
            AppDelegate.getQueueGlobal().asyncAfter(deadline: DispatchTime.now() + .seconds(60)) {
                LogUtils.w(tag: "ApiHelper", method: "ossInfoUpdate", "oss更新失败")
                ossInfoUpdate() // 重复更新
            }
        })
    }
    
}
