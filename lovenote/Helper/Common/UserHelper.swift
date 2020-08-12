//
// Created by 蒋治国 on 2018/12/4.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation

class UserHelper {
    
    public static func isEmpty(user: User?) -> Bool {
        return (user == nil || user!.id == 0)
    }
    
    public static func isEmpty(couple: Couple?) -> Bool {
        return (couple == nil || couple!.id == 0 || couple!.creatorId == 0 || couple!.inviteeId == 0)
    }
    
    // ID
    public static func getMyId(user: User?) -> Int64 {
        if isEmpty(user: user) {
            return 0
        }
        return user!.id
    }
    
    public static func getTaId(user: User?) -> Int64 {
        if isEmpty(user: user) {
            return 0
        }
        return getTaId(couple: user!.couple, mid: user!.id)
    }
    
    public static func getTaId(couple: Couple?, mid: Int64) -> Int64 {
        if isEmpty(couple: couple) {
            return 0
        }
        if mid == couple!.creatorId {
            return couple!.inviteeId
        }
        return couple!.creatorId;
    }
    
    // sexAvatar
    public static func getSexAvatarNamed(user: User?) -> String {
        if isEmpty(user: user) {
            return "ic_account_circle_grey_48dp"
        }
        if user!.sex == User.SEX_BOY {
            return "img_boy_circle"
        } else if user!.sex == User.SEX_GIRL {
            return "img_girl_circle"
        }
        return "ic_account_circle_grey_48dp"
    }
    
    // 昵称
    public static func getMyName(user: User?) -> String {
        if isEmpty(user: user) {
            return StringUtils.getString("now_null_nickname")
        }
        return getName(user: user, uid: user!.id)
    }
    
    public static func getTaName(user: User?) -> String {
        if isEmpty(user: user) {
            return StringUtils.getString("now_null_nickname")
        }
        return getName(user: user, uid: getTaId(user: user))
    }
    
    public static func getName(user: User?, uid: Int64) -> String {
        if isEmpty(user: user) {
            return StringUtils.getString("now_null_nickname")
        }
        return getName(couple: user!.couple, uid: uid)
    }
    
    public static func getName(couple: Couple?, uid: Int64, empty: Bool = false) -> String {
        var emptyName = ""
        if !empty {
            emptyName = StringUtils.getString("now_null_nickname")
        }
        if isEmpty(couple: couple) {
            return emptyName
        }
        if uid == couple!.creatorId {
            let creatorName: String = couple!.creatorName
            return StringUtils.isEmpty(creatorName) ? emptyName : creatorName
        }
        let inviteeName: String = couple!.inviteeName
        return StringUtils.isEmpty(inviteeName) ? emptyName : inviteeName
    }
    
    // 头像
    public static func getMyAvatar(user: User?) -> String {
        if isEmpty(user: user) {
            return ""
        }
        return getAvatar(user: user, uid: user!.id)
    }
    
    public static func getTaAvatar(user: User?) -> String {
        if isEmpty(user: user) {
            return ""
        }
        return getAvatar(user: user, uid: getTaId(user: user))
    }
    
    public static func getAvatar(user: User?, uid: Int64) -> String {
        if isEmpty(user: user) {
            return ""
        }
        return getAvatar(couple: user!.couple, uid: uid)
    }
    
    public static func getAvatar(couple: Couple?, uid: Int64) -> String {
        if isEmpty(couple: couple) {
            return ""
        }
        if uid == couple!.creatorId {
            return couple!.creatorAvatar
        }
        return couple!.inviteeAvatar
    }
    
    // couple
    public static func isCoupleBreak(couple: Couple?) -> Bool {
        if isEmpty(couple: couple) {
            return true
        }
        if couple!.state == nil {
            return true
        }
        let state = couple!.state!.state
        if state == CoupleState.STATUS_INVITE || state == CoupleState.STATUS_INVITE_CANCEL || state == CoupleState.STATUS_INVITE_REJECT || state == CoupleState.STATUS_BREAK_ACCEPT {
            return true
        } else if state == CoupleState.STATUS_BREAK {
            return !isCoupleBreaking(couple: couple)
        } else {
            return state != CoupleState.STATUS_TOGETHER
        }
    }
    
    public static func isCoupleBreaking(couple: Couple?) -> Bool {
        if isEmpty(couple: couple) {
            return true
        }
        if couple!.state == nil {
            return true
        }
        let state = couple!.state!.state
        if state == CoupleState.STATUS_BREAK {
            return getCoupleBreakCountDown(couple: couple) > 0
        }
        return false
    }
    
    public static func getCoupleBreakCountDown(couple: Couple?) -> Int64 {
        if isEmpty(couple: couple) {
            return -1
        }
        if couple!.state == nil {
            return -1
        }
        let breakAt = couple!.state!.createAt + UDHelper.getLimit().coupleBreakSec;
        let currentAt = DateUtils.getCurrentInt64()
        let countDown = breakAt - currentAt;
        return countDown > 0 ? countDown : -1
    }
    
    public static func getCoupleTogetherDay(couple: Couple?) -> Int {
        if isEmpty(couple: couple) {
            return 1
        }
        let togetherAt = couple!.togetherAt > 0 ? couple!.togetherAt : DateUtils.getCurrentInt64()
        return Int(DateUtils.getCurrentInt64() - togetherAt) / 60 / 60 / 24
    }
    
}
