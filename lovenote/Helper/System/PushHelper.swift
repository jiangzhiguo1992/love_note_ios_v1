//
//  PushHelper.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/3.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import CloudPushSDK

class PushHelper {
    
    // 阿里推送初始化
    public static func initAliPush(app: AppDelegate, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // 代理通知
        UNUserNotificationCenter.current().delegate = (app as UNUserNotificationCenterDelegate)
        // 调试开关
        if AppUtils.getInfoBool(key: "IS_DEBUG") {
            CloudPushSDK.turnOnDebug()
        }
        // pushInfo
        let pushInfo = UDHelper.getPushInfo()
        let appKey = pushInfo.aliAppKey
        let appSecret = pushInfo.aliAppSecret
        if StringUtils.isEmpty(appKey) || StringUtils.isEmpty(appSecret) {
            return
        }
        // 开始初始化SDK
        CloudPushSDK.asyncInit(appKey, appSecret: appSecret) { (result) in
            if (result?.success ?? false) {
                LogUtils.i(tag: "PushHelper", method: "initAliPush", "阿里推送初始化 - 成功 ", CloudPushSDK.getDeviceId() ?? "")
                // 初始化角标数
                PushHelper.syncBadgeNum(0)
                // 点击通知将App从关闭状态启动时，将通知打开回执上报
                CloudPushSDK.sendNotificationAck(launchOptions)
            } else {
                LogUtils.e(tag: "PushHelper", method: "initAliPush", "阿里推送初始化 - 失败 ", (result?.error ?? "no_err"))
            }
        }
    }
    
    // 向APNs注册，获取deviceToken用于推送
    public static func registerAPNS() {
        // 请求推送权限
        let options = UNAuthorizationOptions(arrayLiteral: .alert, .sound, .badge)
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (accepted, error) in
            if accepted {
                LogUtils.i(tag: "PushHelper", method: "registerAPNS", "注册苹果推送 - 成功")
                // 开始请求token，在回调方法中获取token
                AppDelegate.runOnMainAsync {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                // 绑定相关
                checkAccountBind()
                checkTagBind()
            } else {
                LogUtils.e(tag: "PushHelper", method: "registerAPNS", "注册苹果推送 - 失败：用户拒绝推送")
            }
        }
    }
    
    // 绑定账号
    public static func checkAccountBind() {
        if UDHelper.getSettingsNoticeSocial() {
            bindAccount()
        } else {
            unBindAccount()
        }
    }
    
    public static func bindAccount() {
        let me = UDHelper.getMe()
        if me == nil || me?.id == 0 {
            return
        }
        CloudPushSDK.bindAccount(String(me!.id)) { (result) in
            if (result?.success ?? false) {
                LogUtils.i(tag: "PushHelper", method: "checkAccountBind", "阿里推送 绑定账号 - 成功：", String(me!.id))
            } else {
                LogUtils.e(tag: "PushHelper", method: "checkAccountBind", "阿里推送 绑定账号 - 失败：", result?.error ?? "no_err")
            }
        }
    }
    
    public static func unBindAccount() {
        CloudPushSDK.unbindAccount { (result) in
            if (result?.success ?? false) {
                LogUtils.i(tag: "PushHelper", method: "checkAccountBind", "阿里推送 解绑account - 成功：")
            } else {
                LogUtils.e(tag: "PushHelper", method: "checkAccountBind", "阿里推送 解绑account - 失败：", result?.error ?? "no_err")
            }
        }
    }
    
    // 绑定Tag
    public static func checkTagBind() {
        if UDHelper.getSettingsNoticeSystem() {
            bindTag(tag: "lovenote_notice_system")
        } else {
            unBindTag(tag: "lovenote_notice_system")
        }
    }
    
    public static func bindTag(tag: String) {
        CloudPushSDK.bindTag(1, withTags: [tag], withAlias: tag) { (result) in
            if (result?.success ?? false) {
                LogUtils.i(tag: "PushHelper", method: "checkAccountBind", "阿里推送 绑定tag - 成功：", tag)
            } else {
                LogUtils.e(tag: "PushHelper", method: "checkAccountBind", "阿里推送 绑定tag - 失败：", result?.error ?? "no_err")
            }
        }
    }
    
    public static func unBindTag(tag: String) {
        CloudPushSDK.unbindTag(1, withTags: [tag], withAlias: tag) { (result) in
            if (result?.success ?? false) {
                LogUtils.i(tag: "PushHelper", method: "checkAccountBind", "阿里推送 绑定tag - 成功：", tag)
            } else {
                LogUtils.e(tag: "PushHelper", method: "checkAccountBind", "阿里推送 绑定tag - 失败：", result?.error ?? "no_err")
            }
        }
    }
    
    // 同步角标数
    public static func syncBadgeNum(_ badgeNum: UInt) {
        AppDelegate.runOnMainAsync {
            // 设置本地角标数为0
            UIApplication.shared.applicationIconBadgeNumber = Int(badgeNum)
            // 同步角标数到服务端
            CloudPushSDK.syncBadgeNum(badgeNum) { (result) in
                if (result?.success ?? false) {
                    LogUtils.i(tag: "PushHelper", method: "syncBadgeNum", "阿里推送 同步角标 - 成功：", badgeNum)
                } else {
                    LogUtils.e(tag: "PushHelper", method: "syncBadgeNum", "阿里推送 同步角标 - 失败：", result?.error ?? "no_err")
                }
            }
        }
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // token回调成功
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        LogUtils.i(tag: "PushHelper", method: "didFailToRegisterForRemoteNotificationsWithError", "token回调 - 成功")
        // 阿里推送注册token
        CloudPushSDK.registerDevice(deviceToken) { (result) in
            if (result?.success ?? false) {
                LogUtils.i(tag: "PushHelper", method: "registerAliPush", "阿里推送注册token - 成功：", CloudPushSDK.getApnsDeviceToken() ?? "")
            } else {
                LogUtils.e(tag: "PushHelper", method: "registerAliPush", "阿里推送注册token - 失败：", result?.error ?? "no_err")
            }
        }
    }
    
    // token回调失败
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        LogUtils.e(tag: "PushHelper", method: "didFailToRegisterForRemoteNotificationsWithError", "token回调 - 失败：", error.localizedDescription)
    }
    
    // App处于前台时收到通知(iOS 10+)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        LogUtils.i(tag: "PushHelper", method: "userNotificationCenter", "收到通知 前台")
        // completionHandler([]) // 通知不弹出
        completionHandler([.alert, .badge, .sound]) // 通知弹出，且带有声音、内容和角标
    }
    
    // 触发通知动作时回调，比如点击、删除通知和点击自定义action(iOS 10+)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userAction = response.actionIdentifier
        // 打开通知
        if userAction == UNNotificationDefaultActionIdentifier {
            LogUtils.i(tag: "PushHelper", method: "userNotificationCenter", "打开通知")
            // 处理iOS 10通知，并上报通知打开回执
            handleiOS10Notification(response.notification)
        }
        // 关闭通知
        if userAction == UNNotificationDismissActionIdentifier {
            LogUtils.i(tag: "PushHelper", method: "userNotificationCenter", "关闭通知")
        }
        // 执行处理方法
        completionHandler()
    }
    
    // 处理iOS 10通知(iOS 10+)
    func handleiOS10Notification(_ notification: UNNotification) {
        // 清除角标数
        PushHelper.syncBadgeNum(0)
        // 获取通知内容
        let content: UNNotificationContent = notification.request.content
        let userInfo = content.userInfo
        if let json = userInfo as? [String: Any] {
            LogUtils.i(tag: "PushHelper", method: "handleiOS10Notification", "阿里推送 自定义参数：", json)
            // 获取自定义实体类
            let pushExtra = PushExtra(JSON: json)
            if pushExtra == nil {
                return
            }
            let contentType = pushExtra!.contentType
            let contentId = pushExtra!.contentId
            if contentType == PushExtra.TYPE_APP || contentType <= 0 {
                return
            }
            // 以上都是打开app
            switch (contentType) {
            case PushExtra.TYPE_SUGGEST: // 意见反馈
                SuggestDetailVC.pushVC(sid: contentId)
                break;
            case PushExtra.TYPE_COUPLE_INFO: // 信息
                CoupleInfoVC.pushVC()
                break;
            case PushExtra.TYPE_COUPLE_WALL: // 墙纸
                CoupleWallPaperVC.pushVC()
                break;
            case PushExtra.TYPE_COUPLE_PLACE: // 地址
                CouplePlaceVC.pushVC()
                break;
            case PushExtra.TYPE_COUPLE_WEATHER: // 天气
                CoupleWallPaperVC.pushVC()
                break;
            case PushExtra.TYPE_NOTE_LOCK: // 锁
                NoteLockVC.pushVC()
                break;
            case PushExtra.TYPE_NOTE_TRENDS: // 动态
                NoteTrendsListVC.pushVC()
                break;
            case PushExtra.TYPE_NOTE_TOTAL: // 统计
                NoteTotalVC.pushVC()
                break;
            case PushExtra.TYPE_NOTE_MENSES: // 姨妈
                NoteMensesVC.pushVC()
                break;
            case PushExtra.TYPE_NOTE_SHY: // 羞羞
                NoteShyVC.pushVC()
                break;
            case PushExtra.TYPE_NOTE_SLEEP: // 睡眠
                NoteSleepVC.pushVC()
                break;
            case PushExtra.TYPE_NOTE_AUDIO: // 音频
                NoteAudioVC.pushVC()
                break;
            case PushExtra.TYPE_NOTE_VIDEO: // 视频
                NoteVideoVC.pushVC()
                break;
            case PushExtra.TYPE_NOTE_ALBUM: // 相册
                NotePictureVC.pushVC(aid: contentId)
                break
            case PushExtra.TYPE_NOTE_PICTURE: // 照片
                NotePictureVC.pushVC(aid: contentId)
                break;
            case PushExtra.TYPE_NOTE_SOUVENIR: // 纪念日
                NoteSouvenirDetailDoneVC.pushVC(sid: contentId)
                break;
            case PushExtra.TYPE_NOTE_WISH: // 愿望清单
                NoteSouvenirDetailWishVC.pushVC(sid: contentId)
                break;
            case PushExtra.TYPE_NOTE_WORD: // 留言
                NoteWordVC.pushVC()
                break;
            case PushExtra.TYPE_NOTE_AWARD: // 打卡
                NoteAwardVC.pushVC()
                break;
            case PushExtra.TYPE_NOTE_AWARD_RULE: // 约定
                NoteAwardRuleVC.pushVC()
                break;
            case PushExtra.TYPE_NOTE_DIARY: // 日记
                NoteDiaryDetailVC.pushVC(did: contentId)
                break;
            case PushExtra.TYPE_NOTE_DREAM: // 梦境
                NoteDreamVC.pushVC()
                break;
            case PushExtra.TYPE_NOTE_ANGRY: // 生气
                NoteAngryDetailVC.pushVC(aid: contentId)
                break;
            case PushExtra.TYPE_NOTE_GIFT: // 礼物
                NoteGiftVC.pushVC()
                break;
            case PushExtra.TYPE_NOTE_PROMISE: // 承诺
                NotePromiseDetailVC.pushVC(pid: contentId)
                break
            case PushExtra.TYPE_NOTE_PROMISE_BREAK: // 承诺违背
                NotePromiseDetailVC.pushVC(pid: contentId)
                break;
            case PushExtra.TYPE_NOTE_TRAVEL: // 游记
                NoteTravelDetailVC.pushVC(tid: contentId)
                break;
            case PushExtra.TYPE_NOTE_MOVIE: // 电影
                NoteMovieVC.pushVC()
                break;
            case PushExtra.TYPE_NOTE_FOOD: // 美食
                NoteFoodVC.pushVC()
                break;
            case PushExtra.TYPE_TOPIC_MINE: // 话题我的
                TopicPostMineVC.pushVC()
                break;
            case PushExtra.TYPE_TOPIC_COLLECT: // 话题收藏
                TopicPostMineVC.pushVC()
                break;
            case PushExtra.TYPE_TOPIC_MESSAGE: // 话题消息
                TopicMessageVC.pushVC()
                break;
            case PushExtra.TYPE_TOPIC_POST: // 帖子
                TopicPostDetailVC.pushVC(pid: contentId)
                break;
            case PushExtra.TYPE_TOPIC_COMMENT: // 评论
                TopicPostCommentDetailVC.pushVC(pcid: contentId)
                break;
            default:
                break
            }
        }
        // 通知打开回执上报
        CloudPushSDK.sendNotificationAck(userInfo)
    }
    
}
