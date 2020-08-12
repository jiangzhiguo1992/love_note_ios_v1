//
// Created by 蒋治国 on 2018/12/4.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseObj: Mappable {
    // status 一般用不到，都在后台处理
    public static let STATUS_VISIBLE = 0
    public static let STATUS_DELETE = -1
    
    var id: Int64 = 0
    var status: Int = 0
    var updateAt: Int64 = 0
    var createAt: Int64 = 0
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        status <- map["status"]
        updateAt <- map["updateAt"]
        createAt <- map["createAt"]
    }
    
    public func isDelete() -> Bool {
        return status <= BaseObj.STATUS_DELETE
    }
}

class BaseCp: BaseObj {
    var userId: Int64 = 0
    var coupleId: Int64 = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        userId <- map["userId"]
        coupleId <- map["coupleId"]
    }
    
    public func isMine() -> Bool {
        return userId == UDHelper.getMe()?.id
    }
}

class Entry: BaseObj {
    var deviceId: String = ""
    var deviceName: String = ""
    var market: String = "apple"
    var language: String = ""
    var platform: String = "ios"
    var osVersion: String = ""
    var appVersion: Int = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        deviceId <- map["deviceId"]
        deviceName <- map["deviceName"]
        market <- map["market"]
        language <- map["language"]
        platform <- map["platform"]
        osVersion <- map["osVersion"]
        appVersion <- map["appVersion"]
    }
}

class Sms: BaseObj {
    public static let TYPE_REGISTER = 10
    public static let TYPE_LOGIN = 11
    public static let TYPE_FORGET = 12
    public static let TYPE_PHONE = 13
    public static let TYPE_LOCK = 30
    
    var phone: String = ""
    var sendType: Int = 0
    var content: String = ""
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        phone <- map["phone"]
        sendType <- map["sendType"]
        content <- map["content"]
    }
}

class User: BaseObj {
    public static let SEX_GIRL = 1
    public static let SEX_BOY = 2
    
    var phone: String = ""
    var password: String = ""
    var sex: Int = 0
    var birthday: Int64 = 0
    var userToken: String = ""
    var couple: Couple?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        phone <- map["phone"]
        password <- map["password"]
        sex <- map["sex"]
        birthday <- map["birthday"]
        userToken <- map["userToken"]
        couple <- map["couple"]
    }
}

class ModelShow: Mappable {
    var marketPay: Bool = true
    var marketCoinAd: Bool = true
    var couple: Bool = true
    var couplePlace: Bool = true
    var coupleWeather: Bool = true
    var note: Bool = true
    var topic: Bool = true
    var more: Bool = true
    var moreVip: Bool = true
    var moreCoin: Bool = true
    var moreMatch: Bool = true
    var moreFeature: Bool = true
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        marketPay <- map["marketPay"]
        marketCoinAd <- map["marketCoinAd"]
        couple <- map["couple"]
        couplePlace <- map["couplePlace"]
        coupleWeather <- map["coupleWeather"]
        note <- map["note"]
        topic <- map["topic"]
        more <- map["more"]
        moreVip <- map["moreVip"]
        moreCoin <- map["moreCoin"]
        moreMatch <- map["moreMatch"]
        moreFeature <- map["moreFeature"]
    }
}

class CommonConst: Mappable {
    var companyName: String = StringUtils.getString("now_no")
    var customerQQ: String = StringUtils.getString("now_no")
    var officialGroup: String = StringUtils.getString("now_no")
    var officialWeibo: String = StringUtils.getString("now_no")
    var officialWeb: String = StringUtils.getString("now_no")
    var contactEmail: String = StringUtils.getString("now_no")
    var iosAppId: String = ""
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        companyName <- map["companyName"]
        customerQQ <- map["customerQQ"]
        officialGroup <- map["officialGroup"]
        officialWeibo <- map["officialWeibo"]
        officialWeb <- map["officialWeb"]
        contactEmail <- map["contactEmail"]
        iosAppId <- map["iosAppId"]
    }
}

class CommonCount: Mappable {
    var noticeNewCount: Int = 0
    var versionNewCount: Int = 0
    var noteTrendsNewCount: Int = 0
    var topicMsgNewCount: Int = 0
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        noticeNewCount <- map["noticeNewCount"]
        versionNewCount <- map["versionNewCount"]
        noteTrendsNewCount <- map["noteTrendsNewCount"]
        topicMsgNewCount <- map["topicMsgNewCount"]
    }
}

class Limit: Mappable {
    // common
    var smsCodeLength: Int = 6
    var smsBetweenSec: Int = 60 * 2
    // settings
    var suggestTitleLength: Int = 20
    var suggestContentLength: Int = 200
    var suggestCommentContentLength: Int = 200
    // couple
    var coupleInviteIntervalSec: Int64 = 3 * 60
    var coupleBreakNeedSec: Int64 = 60 * 60 * 24 * 20
    var coupleBreakSec: Int64 = 60 * 60 * 24
    var coupleNameLength: Int = 6
    // note
    var noteResExpireSec: Int64 = 60 * 60 * 24 * 30 * 3
    var mensesMaxPerMonth: Int = 2
    var mensesMaxCycleDay: Int = 60
    var mensesMaxDurationDay: Int = 15
    var mensesDefaultCycleDay: Int = 30
    var mensesDefaultDurationDay: Int = 7
    var shyMaxPerDay: Int = 5
    var shySafeLength: Int = 10
    var shyDescLength: Int = 50
    var sleepMaxPerDay: Int = 10
    var noteSleepSuccessMinSec: Int64 = 60 * 30
    var noteSleepSuccessMaxSec: Int64 = 60 * 60 * 24
    var noteLockLength: Int = 6
    var souvenirTitleLength: Int = 20
    var souvenirForeignYearCount: Int = 1
    var travelPlaceCount: Int = 1
    var travelVideoCount: Int = 1
    var travelFoodCount: Int = 1
    var travelMovieCount: Int = 1
    var travelAlbumCount: Int = 1
    var travelDiaryCount: Int = 1
    var audioTitleLength: Int = 20
    var videoTitleLength: Int = 20
    var albumTitleLength: Int = 10
    var picturePushCount: Int = 1
    var wordContentLength: Int = 100
    var whisperContentLength: Int = 100
    var whisperChannelLength: Int = 10
    var diaryContentLength: Int = 2000
    var awardContentLength: Int = 100
    var awardRuleTitleLength: Int = 30
    var awardRuleScoreMax: Int = 100
    var dreamContentLength: Int = 1000
    var giftTitleLength: Int = 20
    var foodTitleLength: Int = 20
    var foodContentLength: Int = 200
    var travelTitleLength: Int = 20
    var travelPlaceContentLength: Int = 200
    var angryContentLength: Int = 200
    var promiseContentLength: Int = 200
    var promiseBreakContentLength: Int = 100
    var movieTitleLength: Int = 20
    var movieContentLength: Int = 200
    // topic
    var postTitleLength: Int = 20
    var postContentLength: Int = 100
    var postScreenReportCount: Int = 10
    var postCommentContentLength: Int = 100
    var postCommentScreenReportCount: Int = 20
    // more
    var payVipGoods1Title: String = ""
    var payVipGoods1Days: Int = 0
    var payVipGoods1Amount: Double = 0
    var payVipGoods2Title: String = ""
    var payVipGoods2Days: Int = 0
    var payVipGoods2Amount: Double = 0
    var payVipGoods3Title: String = ""
    var payVipGoods3Days: Int = 0
    var payVipGoods3Amount: Double = 0
    var payCoinGoods1Title: String = ""
    var payCoinGoods1Count: Int = 0
    var payCoinGoods1Amount: Double = 0
    var payCoinGoods2Title: String = ""
    var payCoinGoods2Count: Int = 0
    var payCoinGoods2Amount: Double = 0
    var payCoinGoods3Title: String = ""
    var payCoinGoods3Count: Int = 0
    var payCoinGoods3Amount: Double = 0
    var coinSignMinCount: Int = 1
    var coinSignMaxCount: Int = 10
    var coinSignIncreaseCount: Int = 1
    var coinAdBetweenSec: Int = 60 * 10
    var coinAdWatchCount: Int = 1
    var coinAdClickCount: Int = 2
    var coinAdMaxPerDayCount: Int = 10
    var matchWorkScreenReportCount: Int = 10
    var matchWorkTitleLength: Int = 100
    var matchWorkContentLength: Int = 200
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        smsCodeLength <- map["smsCodeLength"]
        smsBetweenSec <- map["smsBetweenSec"]
        suggestTitleLength <- map["suggestTitleLength"]
        suggestContentLength <- map["suggestContentLength"]
        suggestCommentContentLength <- map["suggestCommentContentLength"]
        coupleInviteIntervalSec <- map["coupleInviteIntervalSec"]
        coupleBreakNeedSec <- map["coupleBreakNeedSec"]
        coupleBreakSec <- map["coupleBreakSec"]
        coupleNameLength <- map["coupleNameLength"]
        noteResExpireSec <- map["noteResExpireSec"]
        mensesMaxPerMonth <- map["mensesMaxPerMonth"]
        mensesMaxCycleDay <- map["mensesMaxCycleDay"]
        mensesMaxDurationDay <- map["mensesMaxDurationDay"]
        mensesDefaultCycleDay <- map["mensesDefaultCycleDay"]
        mensesDefaultDurationDay <- map["mensesDefaultDurationDay"]
        shyMaxPerDay <- map["shyMaxPerDay"]
        shySafeLength <- map["shySafeLength"]
        shyDescLength <- map["shyDescLength"]
        sleepMaxPerDay <- map["sleepMaxPerDay"]
        noteSleepSuccessMinSec <- map["noteSleepSuccessMinSec"]
        noteSleepSuccessMaxSec <- map["noteSleepSuccessMaxSec"]
        noteLockLength <- map["noteLockLength"]
        souvenirTitleLength <- map["souvenirTitleLength"]
        souvenirForeignYearCount <- map["souvenirForeignYearCount"]
        travelPlaceCount <- map["travelPlaceCount"]
        travelVideoCount <- map["travelVideoCount"]
        travelFoodCount <- map["travelFoodCount"]
        travelMovieCount <- map["travelMovieCount"]
        travelAlbumCount <- map["travelAlbumCount"]
        travelDiaryCount <- map["travelDiaryCount"]
        audioTitleLength <- map["audioTitleLength"]
        videoTitleLength <- map["videoTitleLength"]
        albumTitleLength <- map["albumTitleLength"]
        picturePushCount <- map["picturePushCount"]
        wordContentLength <- map["wordContentLength"]
        whisperContentLength <- map["whisperContentLength"]
        whisperChannelLength <- map["whisperChannelLength"]
        diaryContentLength <- map["diaryContentLength"]
        awardContentLength <- map["awardContentLength"]
        awardRuleTitleLength <- map["awardRuleTitleLength"]
        awardRuleScoreMax <- map["awardRuleScoreMax"]
        dreamContentLength <- map["dreamContentLength"]
        giftTitleLength <- map["giftTitleLength"]
        foodTitleLength <- map["foodTitleLength"]
        foodContentLength <- map["foodContentLength"]
        travelTitleLength <- map["travelTitleLength"]
        travelPlaceContentLength <- map["travelPlaceContentLength"]
        angryContentLength <- map["angryContentLength"]
        promiseContentLength <- map["promiseContentLength"]
        promiseBreakContentLength <- map["promiseBreakContentLength"]
        movieTitleLength <- map["movieTitleLength"]
        movieContentLength <- map["movieContentLength"]
        postTitleLength <- map["postTitleLength"]
        postContentLength <- map["postContentLength"]
        postScreenReportCount <- map["postScreenReportCount"]
        postCommentContentLength <- map["postCommentContentLength"]
        postCommentScreenReportCount <- map["postCommentScreenReportCount"]
        payVipGoods1Title <- map["payVipGoods1Title"]
        payVipGoods1Days <- map["payVipGoods1Days"]
        payVipGoods1Amount <- map["payVipGoods1Amount"]
        payVipGoods2Title <- map["payVipGoods2Title"]
        payVipGoods2Days <- map["payVipGoods2Days"]
        payVipGoods2Amount <- map["payVipGoods2Amount"]
        payVipGoods3Title <- map["payVipGoods3Title"]
        payVipGoods3Days <- map["payVipGoods3Days"]
        payVipGoods3Amount <- map["payVipGoods3Amount"]
        payCoinGoods1Title <- map["payCoinGoods1Title"]
        payCoinGoods1Count <- map["payCoinGoods1Count"]
        payCoinGoods1Amount <- map["payCoinGoods1Amount"]
        payCoinGoods2Title <- map["payCoinGoods2Title"]
        payCoinGoods2Count <- map["payCoinGoods2Count"]
        payCoinGoods2Amount <- map["payCoinGoods2Amount"]
        payCoinGoods3Title <- map["payCoinGoods3Title"]
        payCoinGoods3Count <- map["payCoinGoods3Count"]
        payCoinGoods3Amount <- map["payCoinGoods3Amount"]
        coinSignMinCount <- map["coinSignMinCount"]
        coinSignMaxCount <- map["coinSignMaxCount"]
        coinSignIncreaseCount <- map["coinSignIncreaseCount"]
        coinAdBetweenSec <- map["coinAdBetweenSec"]
        coinAdWatchCount <- map["coinAdWatchCount"]
        coinAdClickCount <- map["coinAdClickCount"]
        coinAdMaxPerDayCount <- map["coinAdMaxPerDayCount"]
        matchWorkScreenReportCount <- map["matchWorkScreenReportCount"]
        matchWorkTitleLength <- map["matchWorkTitleLength"]
        matchWorkContentLength <- map["matchWorkContentLength"]
    }
}

class VipLimit: Mappable {
    // common
    var advertiseHide: Bool = false
    // couple
    var wallPaperSize: Int64 = 0
    var wallPaperCount: Int = 1
    // note
    var noteTotalEnable: Bool = false
    var souvenirCount: Int = 1
    var videoSize: Int64 = 0
    var audioSize: Int64 = 0
    var pictureSize: Int64 = 0
    var pictureOriginal: Bool = false
    var pictureTotalCount: Int = 100
    var diaryImageSize: Int64 = 0
    var diaryImageCount: Int = 0
    var whisperImageEnable: Bool = false
    var giftImageCount: Int = 0
    var foodImageCount: Int = 0
    var movieImageCount: Int = 0
    // topic
    var topicPostImageCount: Int = 0
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        advertiseHide <- map["advertiseHide"]
        wallPaperSize <- map["wallPaperSize"]
        wallPaperCount <- map["wallPaperCount"]
        noteTotalEnable <- map["noteTotalEnable"]
        souvenirCount <- map["souvenirCount"]
        videoSize <- map["videoSize"]
        audioSize <- map["audioSize"]
        pictureSize <- map["pictureSize"]
        pictureOriginal <- map["pictureOriginal"]
        pictureTotalCount <- map["pictureTotalCount"]
        diaryImageSize <- map["diaryImageSize"]
        diaryImageCount <- map["diaryImageCount"]
        whisperImageEnable <- map["whisperImageEnable"]
        giftImageCount <- map["giftImageCount"]
        foodImageCount <- map["foodImageCount"]
        movieImageCount <- map["movieImageCount"]
        topicPostImageCount <- map["topicPostImageCount"]
    }
}

class OssInfo: Mappable {
    // sts
    var securityToken: String = ""
    var accessKeyId: String = ""
    var accessKeySecret: String = ""
    // oss
    var region: String = ""
    var domain: String = ""
    var bucket: String = ""
    var stsExpireTime: Int64 = DateUtils.getCurrentInt64() + 60 * 30
    var ossRefreshSec: Int64 = 60 * 30
    var urlExpireSec: Int64 = 60 * 10
    // path
    var pathLog: String = ""
    var pathSuggest: String = ""
    var pathCoupleAvatar: String = ""
    var pathCoupleWall: String = ""
    var pathNoteVideo: String = ""
    var pathNoteVideoThumb: String = ""
    var pathNoteAudio: String = ""
    var pathNoteAlbum: String = ""
    var pathNotePicture: String = ""
    var pathNoteWhisper: String = ""
    var pathNoteDiary: String = ""
    var pathNoteGift: String = ""
    var pathNoteFood: String = ""
    var pathNoteMovie: String = ""
    var pathTopicPost: String = ""
    var pathMoreMatch: String = ""
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        securityToken <- map["securityToken"]
        accessKeyId <- map["accessKeyId"]
        accessKeySecret <- map["accessKeySecret"]
        region <- map["region"]
        domain <- map["domain"]
        bucket <- map["bucket"]
        stsExpireTime <- map["stsExpireTime"]
        ossRefreshSec <- map["ossRefreshSec"]
        urlExpireSec <- map["urlExpireSec"]
        pathLog <- map["pathLog"]
        pathSuggest <- map["pathSuggest"]
        pathCoupleAvatar <- map["pathCoupleAvatar"]
        pathCoupleWall <- map["pathCoupleWall"]
        pathNoteVideo <- map["pathNoteVideo"]
        pathNoteVideoThumb <- map["pathNoteVideoThumb"]
        pathNoteAudio <- map["pathNoteAudio"]
        pathNoteAlbum <- map["pathNoteAlbum"]
        pathNotePicture <- map["pathNotePicture"]
        pathNoteWhisper <- map["pathNoteWhisper"]
        pathNoteDiary <- map["pathNoteDiary"]
        pathNoteGift <- map["pathNoteGift"]
        pathNoteFood <- map["pathNoteFood"]
        pathNoteMovie <- map["pathNoteMovie"]
        pathTopicPost <- map["pathTopicPost"]
        pathMoreMatch <- map["pathMoreMatch"]
    }
}

class PushInfo: Mappable {
    var aliAppKey: String = ""
    var aliAppSecret: String = ""
    var noticeLight: Bool = true
    var noticeSound: Bool = true
    var noticeVibrate: Bool = false
    var noStartHour: Int = 22
    var noEndHour: Int = 8
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        aliAppKey <- map["aliAppKey"]
        aliAppSecret <- map["aliAppSecret"]
        noticeLight <- map["noticeLight"]
        noticeSound <- map["noticeSound"]
        noticeVibrate <- map["noticeVibrate"]
        noStartHour <- map["noStartHour"]
        noEndHour <- map["noEndHour"]
    }
}

class AdInfo: Mappable {
    var appId: String = ""
    var topicPostPosId: String = ""
    var topicPostJump: Int = 20
    var topicPostStart: Int = 10
    var coinFreePosId: String = ""
    var coinFreeTickSec: Int = 5
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        appId <- map["appId"]
        topicPostPosId <- map["topicPostPosId"]
        topicPostJump <- map["topicPostJump"]
        topicPostStart <- map["topicPostStart"]
        coinFreePosId <- map["coinFreePosId"]
        coinFreeTickSec <- map["coinFreeTickSec"]
    }
}

class Notice: BaseObj {
    public static let TYPE_TEXT = 0; // 文章
    public static let TYPE_URL = 1; // 网址
    public static let TYPE_IMAGE = 2; // 图片
    
    var title: String = ""
    var contentType: Int = TYPE_TEXT
    var contentText: String = ""
    var read: Bool = false
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        title <- map["title"]
        contentType <- map["contentType"]
        contentText <- map["contentText"]
        read <- map["read"]
    }
}

class Suggest: BaseObj {
    // 状态
    static let STATUS_REPLY_NO = 0
    static let STATUS_REPLY_YES = 10
    static let STATUS_ACCEPT_NO = 20
    static let STATUS_ACCEPT_YES = 30
    static let STATUS_HANDLE_ING = 40
    static let STATUS_HANDLE_OVER = 50
    // 种类
    static let KIND_ALL = 0
    static let KIND_ERROR = 10
    static let KIND_FUNCTION = 20
    static let KIND_OPTIMIZE = 30
    static let KIND_DEBUNK = 40
    
    var kind: Int = KIND_ALL
    var title: String = ""
    var contentText: String = ""
    var contentImage: String = ""
    var followCount: Int = 0
    var commentCount: Int = 0
    var top: Bool = false
    var official: Bool = false
    var mine: Bool = false
    var follow: Bool = false
    var comment: Bool = false
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        kind <- map["kind"]
        title <- map["title"]
        contentText <- map["contentText"]
        contentImage <- map["contentImage"]
        followCount <- map["followCount"]
        commentCount <- map["commentCount"]
        top <- map["top"]
        official <- map["official"]
        mine <- map["mine"]
        follow <- map["follow"]
        comment <- map["comment"]
    }
}

class SuggestComment: BaseObj {
    var suggestId: Int64 = 0
    var contentText: String = ""
    var official: Bool = false
    var mine: Bool = false
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        suggestId <- map["suggestId"]
        contentText <- map["contentText"]
        official <- map["official"]
        mine <- map["mine"]
    }
}

class SuggestFollow: BaseObj {
    var suggestId: Int64 = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        suggestId <- map["suggestId"]
    }
}

class PairCard: Mappable {
    var taPhone: String = ""
    var title: String = ""
    var message: String = ""
    var btnGood: String = ""
    var btnBad: String = ""
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        taPhone <- map["taPhone"]
        title <- map["title"]
        message <- map["message"]
        btnGood <- map["btnGood"]
        btnBad <- map["btnBad"]
    }
}

class Couple: BaseObj {
    var togetherAt: Int64 = 0
    var creatorId: Int64 = 0
    var inviteeId: Int64 = 0
    var creatorName: String = ""
    var inviteeName: String = ""
    var creatorAvatar: String = ""
    var inviteeAvatar: String = ""
    var state: CoupleState?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        togetherAt <- map["togetherAt"]
        creatorId <- map["creatorId"]
        inviteeId <- map["inviteeId"]
        creatorName <- map["creatorName"]
        inviteeName <- map["inviteeName"]
        creatorAvatar <- map["creatorAvatar"]
        inviteeAvatar <- map["inviteeAvatar"]
        state <- map["state"]
    }
}

class CoupleState: BaseCp {
    public static let STATUS_INVITE = 0 // 正在邀请(SelfVisible)
    public static let STATUS_INVITE_CANCEL = 110 // 邀请者撤回(NoVisible)
    public static let STATUS_INVITE_REJECT = 120 // 被邀请者拒绝(NoVisible)
    public static let STATUS_BREAK = 210 // 正在分手(Visible)/已分手(NoVisible)
    public static let STATUS_BREAK_ACCEPT = 220 // 被分手者同意(NoVisible)
    public static let STATUS_TOGETHER = 520 // 在一起(Visible)
    
    var state: Int = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        state <- map["state"]
    }
}

class WallPaper: BaseObj {
    var contentImageList: [String] = [String]()
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        contentImageList <- map["contentImageList"]
    }
}

class Place: BaseObj {
    var userId: Int64 = 0
    var longitude: Double = 0
    var latitude: Double = 0
    var address: String = ""
    var country: String = ""
    var province: String = ""
    var city: String = ""
    var district: String = ""
    var street: String = ""
    var cityId: String = ""
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        userId <- map["userId"]
        longitude <- map["longitude"]
        latitude <- map["latitude"]
        address <- map["address"]
        country <- map["country"]
        province <- map["province"]
        city <- map["city"]
        district <- map["district"]
        street <- map["street"]
        cityId <- map["cityId"]
    }
}

class WeatherToday: Mappable {
    var condition: String = ""
    var icon: String = ""
    var temp: String = ""
    var humidity: String = ""
    var windLevel: String = ""
    var windDir: String = ""
    var updateAt: Int64 = 0
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        condition <- map["condition"]
        icon <- map["icon"]
        temp <- map["temp"]
        humidity <- map["humidity"]
        windLevel <- map["windLevel"]
        windDir <- map["windDir"]
        updateAt <- map["updateAt"]
    }
}

class WeatherForecast: Mappable {
    var timeAt: Int64 = 0
    var timeShow: String = ""
    var conditionDay: String = ""
    var conditionNight: String = ""
    var iconDay: String = ""
    var iconNight: String = ""
    var tempDay: String = ""
    var tempNight: String = ""
    var windDay: String = ""
    var windNight: String = ""
    var updateAt: Int64 = 0
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        timeAt <- map["timeAt"]
        conditionDay <- map["conditionDay"]
        conditionNight <- map["conditionNight"]
        iconDay <- map["iconDay"]
        iconNight <- map["iconNight"]
        tempDay <- map["tempDay"]
        tempNight <- map["tempNight"]
        windDay <- map["windDay"]
        windNight <- map["windNight"]
        updateAt <- map["updateAt"]
    }
}

class WeatherForecastInfo: Mappable {
    var show: String = ""
    var weatherForecastList: [WeatherForecast] = [WeatherForecast]()
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        show <- map["show"]
        weatherForecastList <- map["weatherForecastList"]
    }
}

class Lock: BaseCp {
    var password: String = ""
    var isLock: Bool = false
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        password <- map["password"]
        isLock <- map["isLock"]
    }
}

class Trends: BaseCp {
    // 操作类型
    public static let TRENDS_ACT_TYPE_INSERT = 1 // 添加
    public static let TRENDS_ACT_TYPE_DELETE = 2 // 删除
    public static let TRENDS_ACT_TYPE_UPDATE = 3 // 修改
    public static let TRENDS_ACT_TYPE_QUERY = 4 // 查看
    // 内容类型
    public static let TRENDS_CON_TYPE_SOUVENIR = 100 // 纪念日
    public static let TRENDS_CON_TYPE_WISH = 110 // 愿望清单
    public static let TRENDS_CON_TYPE_SHY = 200 // 羞羞
    public static let TRENDS_CON_TYPE_MENSES = 210 // 姨妈
    public static let TRENDS_CON_TYPE_SLEEP = 220 // 睡眠
    public static let TRENDS_CON_TYPE_AUDIO = 300 // 音频
    public static let TRENDS_CON_TYPE_VIDEO = 310 // 视频
    public static let TRENDS_CON_TYPE_ALBUM = 320 // 相册
    public static let TRENDS_CON_TYPE_WORD = 500 // 留言
    public static let TRENDS_CON_TYPE_WHISPER = 510 // 耳语
    public static let TRENDS_CON_TYPE_DIARY = 520 // 日记
    public static let TRENDS_CON_TYPE_AWARD = 530 // 打卡
    public static let TRENDS_CON_TYPE_AWARD_RULE = 540 // 约定
    public static let TRENDS_CON_TYPE_DREAM = 550 // 梦境
    public static let TRENDS_CON_TYPE_FOOD = 560 // 美食
    public static let TRENDS_CON_TYPE_TRAVEL = 570 // 游记
    public static let TRENDS_CON_TYPE_GIFT = 580 // 礼物
    public static let TRENDS_CON_TYPE_PROMISE = 590 // 承诺
    public static let TRENDS_CON_TYPE_ANGRY = 600 // 生气
    public static let TRENDS_CON_TYPE_MOVIE = 610 // 电影
    // 内容Id
    public static let TRENDS_CON_ID_LIST = 610 // 列表信息
    
    var actionType: Int = 0
    var contentType: Int = 0
    var contentId: Int64 = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        actionType <- map["actionType"]
        contentType <- map["contentType"]
        contentId <- map["contentId"]
    }
}

class NoteTotal: Mappable {
    var totalSouvenir: Int64 = 0
    var totalWord: Int64 = 0
    var totalDiary: Int64 = 0
    var totalAlbum: Int64 = 0
    var totalPicture: Int64 = 0
    var totalAudio: Int64 = 0
    var totalVideo: Int64 = 0
    var totalFood: Int64 = 0
    var totalTravel: Int64 = 0
    var totalGift: Int64 = 0
    var totalPromise: Int64 = 0
    var totalAngry: Int64 = 0
    var totalDream: Int64 = 0
    var totalAward: Int64 = 0
    var totalMovie: Int64 = 0
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        totalSouvenir <- map["totalSouvenir"]
        totalWord <- map["totalWord"]
        totalDiary <- map["totalDiary"]
        totalAlbum <- map["totalAlbum"]
        totalPicture <- map["totalPicture"]
        totalAudio <- map["totalAudio"]
        totalVideo <- map["totalVideo"]
        totalFood <- map["totalFood"]
        totalTravel <- map["totalTravel"]
        totalGift <- map["totalGift"]
        totalPromise <- map["totalPromise"]
        totalAngry <- map["totalAngry"]
        totalDream <- map["totalDream"]
        totalAward <- map["totalAward"]
        totalMovie <- map["totalMovie"]
    }
}

class Souvenir: BaseCp {
    var happenAt: Int64 = 0
    var title: String = ""
    var done: Bool = false
    var longitude: Double = 0
    var latitude: Double = 0
    var address: String = ""
    var cityId: String = ""
    var souvenirGiftList: [SouvenirGift] = [SouvenirGift]()
    var souvenirTravelList: [SouvenirTravel] = [SouvenirTravel]()
    var souvenirAlbumList: [SouvenirAlbum] = [SouvenirAlbum]()
    var souvenirVideoList: [SouvenirVideo] = [SouvenirVideo]()
    var souvenirFoodList: [SouvenirFood] = [SouvenirFood]()
    var souvenirMovieList: [SouvenirMovie] = [SouvenirMovie]()
    var souvenirDiaryList: [SouvenirDiary] = [SouvenirDiary]()
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        happenAt <- map["happenAt"]
        title <- map["title"]
        done <- map["done"]
        longitude <- map["longitude"]
        latitude <- map["latitude"]
        address <- map["address"]
        cityId <- map["cityId"]
        souvenirGiftList <- map["souvenirGiftList"]
        souvenirTravelList <- map["souvenirTravelList"]
        souvenirAlbumList <- map["souvenirAlbumList"]
        souvenirVideoList <- map["souvenirVideoList"]
        souvenirFoodList <- map["souvenirFoodList"]
        souvenirMovieList <- map["souvenirMovieList"]
        souvenirDiaryList <- map["souvenirDiaryList"]
    }
}

class SouvenirAlbum: BaseCp {
    var souvenirId: Int64 = 0
    var albumId: Int64 = 0
    var year: Int = 0
    var album: Album?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        souvenirId <- map["souvenirId"]
        albumId <- map["albumId"]
        year <- map["year"]
        album <- map["album"]
    }
}

class SouvenirDiary: BaseCp {
    var souvenirId: Int64 = 0
    var diaryId: Int64 = 0
    var year: Int = 0
    var diary: Diary?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        souvenirId <- map["souvenirId"]
        diaryId <- map["diaryId"]
        year <- map["year"]
        diary <- map["diary"]
    }
}

class SouvenirFood: BaseCp {
    var souvenirId: Int64 = 0
    var foodId: Int64 = 0
    var year: Int = 0
    var food: Food?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        souvenirId <- map["souvenirId"]
        foodId <- map["foodId"]
        year <- map["year"]
        food <- map["food"]
    }
}

class SouvenirGift: BaseCp {
    var souvenirId: Int64 = 0
    var giftId: Int64 = 0
    var year: Int = 0
    var gift: Gift?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        souvenirId <- map["souvenirId"]
        giftId <- map["giftId"]
        year <- map["year"]
        gift <- map["gift"]
    }
}

class SouvenirMovie: BaseCp {
    var souvenirId: Int64 = 0
    var movieId: Int64 = 0
    var year: Int = 0
    var movie: Movie?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        souvenirId <- map["souvenirId"]
        movieId <- map["movieId"]
        year <- map["year"]
        movie <- map["movie"]
    }
}

class SouvenirTravel: BaseCp {
    var souvenirId: Int64 = 0
    var travelId: Int64 = 0
    var year: Int = 0
    var travel: Travel?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        souvenirId <- map["souvenirId"]
        travelId <- map["travelId"]
        year <- map["year"]
        travel <- map["travel"]
    }
}

class SouvenirVideo: BaseCp {
    var souvenirId: Int64 = 0
    var videoId: Int64 = 0
    var year: Int = 0
    var video: Video?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        souvenirId <- map["souvenirId"]
        videoId <- map["videoId"]
        year <- map["year"]
        video <- map["video"]
    }
}

class Travel: BaseCp {
    var happenAt: Int64 = 0
    var title: String = ""
    var travelPlaceList: [TravelPlace] = [TravelPlace]()
    var travelAlbumList: [TravelAlbum] = [TravelAlbum]()
    var travelVideoList: [TravelVideo] = [TravelVideo]()
    var travelFoodList: [TravelFood] = [TravelFood]()
    var travelMovieList: [TravelMovie] = [TravelMovie]()
    var travelDiaryList: [TravelDiary] = [TravelDiary]()
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        happenAt <- map["happenAt"]
        title <- map["title"]
        travelPlaceList <- map["travelPlaceList"]
        travelAlbumList <- map["travelAlbumList"]
        travelVideoList <- map["travelVideoList"]
        travelFoodList <- map["travelFoodList"]
        travelMovieList <- map["travelMovieList"]
        travelDiaryList <- map["travelDiaryList"]
    }
}

class TravelAlbum: BaseCp {
    var albumId: Int64 = 0
    var album: Album?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        albumId <- map["albumId"]
        album <- map["album"]
    }
}

class TravelDiary: BaseCp {
    var diaryId: Int64 = 0
    var diary: Diary?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        diaryId <- map["diaryId"]
        diary <- map["diary"]
    }
}

class TravelFood: BaseCp {
    var foodId: Int64 = 0
    var food: Food?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        foodId <- map["foodId"]
        food <- map["food"]
    }
}

class TravelMovie: BaseCp {
    var movieId: Int64 = 0
    var movie: Movie?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        movieId <- map["movieId"]
        movie <- map["movie"]
    }
}

class TravelPlace: BaseCp {
    var happenAt: Int64 = 0
    var contentText: String = ""
    var longitude: Double = 0
    var latitude: Double = 0
    var address: String = ""
    var cityId: String = ""
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        happenAt <- map["happenAt"]
        contentText <- map["contentText"]
        longitude <- map["longitude"]
        latitude <- map["latitude"]
        address <- map["address"]
        cityId <- map["cityId"]
    }
}

class TravelVideo: BaseCp {
    var videoId: Int64 = 0
    var video: Video?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        videoId <- map["videoId"]
        video <- map["video"]
    }
}

class MensesInfo: Mappable {
    var canMe: Bool = false
    var canTa: Bool = false
    var mensesLengthMe: MensesLength?
    var mensesLengthTa: MensesLength?
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        canMe <- map["canMe"]
        canTa <- map["canTa"]
        mensesLengthMe <- map["mensesLengthMe"]
        mensesLengthTa <- map["mensesLengthTa"]
    }
}

class MensesLength: BaseCp {
    var cycleDay: Int = 0
    var durationDay: Int = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        cycleDay <- map["cycleDay"]
        durationDay <- map["durationDay"]
    }
}

class Menses2: BaseCp {
    var startAt: Int64 = 0
    var endAt: Int64 = 0
    var startYear: Int = 0
    var startMonthOfYear: Int = 0
    var startDayOfMonth: Int = 0
    var endYear: Int = 0
    var endMonthOfYear: Int = 0
    var endDayOfMonth: Int = 0
    // 关联
    var isReal: Bool = false
    var mensesDayList: [MensesDay] = [MensesDay]()
    var safeStartYear: Int = 0
    var safeStartMonthOfYear: Int = 0
    var safeStartDayOfMonth: Int = 0
    var safeEndYear: Int = 0
    var safeEndMonthOfYear: Int = 0
    var safeEndDayOfMonth: Int = 0
    var dangerStartYear: Int = 0
    var dangerStartMonthOfYear: Int = 0
    var dangerStartDayOfMonth: Int = 0
    var dangerEndYear: Int = 0
    var dangerEndMonthOfYear: Int = 0
    var dangerEndDayOfMonth: Int = 0
    var ovulationYear: Int = 0
    var ovulationMonthOfYear: Int = 0
    var ovulationDayOfMonth: Int = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        startAt <- map["startAt"]
        endAt <- map["endAt"]
        startYear <- map["startYear"]
        startMonthOfYear <- map["startMonthOfYear"]
        startDayOfMonth <- map["startDayOfMonth"]
        endYear <- map["endYear"]
        endMonthOfYear <- map["endMonthOfYear"]
        endDayOfMonth <- map["endDayOfMonth"]
        isReal <- map["isReal"]
        mensesDayList <- map["mensesDayList"]
        safeStartYear <- map["safeStartYear"]
        safeStartMonthOfYear <- map["safeStartMonthOfYear"]
        safeStartDayOfMonth <- map["safeStartDayOfMonth"]
        safeEndYear <- map["safeEndYear"]
        safeEndMonthOfYear <- map["safeEndMonthOfYear"]
        safeEndDayOfMonth <- map["safeEndDayOfMonth"]
        dangerStartYear <- map["dangerStartYear"]
        dangerStartMonthOfYear <- map["dangerStartMonthOfYear"]
        dangerStartDayOfMonth <- map["dangerStartDayOfMonth"]
        dangerEndYear <- map["dangerEndYear"]
        dangerEndMonthOfYear <- map["dangerEndMonthOfYear"]
        dangerEndDayOfMonth <- map["dangerEndDayOfMonth"]
        ovulationYear <- map["ovulationYear"]
        ovulationMonthOfYear <- map["ovulationMonthOfYear"]
        ovulationDayOfMonth <- map["ovulationDayOfMonth"]
    }
}

class MensesDay: BaseCp {
    var menses2Id: Int64 = 0
    var year: Int = 0
    var monthOfYear: Int = 0
    var dayOfMonth: Int = 0
    var blood: Int = 0
    var pain: Int = 0
    var mood: Int = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        menses2Id <- map["menses2Id"]
        year <- map["year"]
        monthOfYear <- map["monthOfYear"]
        dayOfMonth <- map["dayOfMonth"]
        blood <- map["blood"]
        pain <- map["pain"]
        mood <- map["mood"]
    }
}

class Menses: BaseCp {
    var isMe: Bool = true
    var year: Int = 0
    var monthOfYear: Int = 0
    var dayOfMonth: Int = 0
    var isStart: Bool = false
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        isMe <- map["isMe"]
        year <- map["year"]
        monthOfYear <- map["monthOfYear"]
        dayOfMonth <- map["dayOfMonth"]
        isStart <- map["isStart"]
    }
}

class Shy: BaseCp {
    var year: Int = 0
    var monthOfYear: Int = 0
    var dayOfMonth: Int = 0
    var happenAt: Int64 = 0
    var endAt: Int64 = 0
    var safe: String = ""
    var desc: String = ""
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        year <- map["year"]
        monthOfYear <- map["monthOfYear"]
        dayOfMonth <- map["dayOfMonth"]
        happenAt <- map["happenAt"]
        endAt <- map["endAt"]
        safe <- map["safe"]
        desc <- map["desc"]
    }
}

class Sleep: BaseCp {
    var year: Int = 0
    var monthOfYear: Int = 0
    var dayOfMonth: Int = 0
    var isSleep: Bool = false
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        year <- map["year"]
        monthOfYear <- map["monthOfYear"]
        dayOfMonth <- map["dayOfMonth"]
        isSleep <- map["isSleep"]
    }
}

class Audio: BaseCp {
    var happenAt: Int64 = 0
    var title: String = ""
    var contentAudio: String = ""
    var duration: Int = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        happenAt <- map["happenAt"]
        title <- map["title"]
        contentAudio <- map["contentAudio"]
        duration <- map["duration"]
    }
}

class Video: BaseCp {
    var happenAt: Int64 = 0
    var title: String = ""
    var contentThumb: String = ""
    var contentVideo: String = ""
    var duration: Int = 0
    var longitude: Double = 0
    var latitude: Double = 0
    var address: String = ""
    var cityId: String = ""
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        happenAt <- map["happenAt"]
        title <- map["title"]
        contentThumb <- map["contentThumb"]
        contentVideo <- map["contentVideo"]
        duration <- map["duration"]
        longitude <- map["longitude"]
        latitude <- map["latitude"]
        address <- map["address"]
        cityId <- map["cityId"]
    }
}

class Album: BaseCp {
    var title: String = ""
    var cover: String = ""
    var startAt: Int64 = 0
    var endAt: Int64 = 0
    var pictureCount: Int = 0
    var pictureList: [Picture] = [Picture]()
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        title <- map["title"]
        cover <- map["cover"]
        startAt <- map["startAt"]
        endAt <- map["endAt"]
        pictureCount <- map["pictureCount"]
        pictureList <- map["pictureList"]
    }
}

class Picture: BaseCp {
    var albumId: Int64 = 0
    var happenAt: Int64 = 0
    var contentImage: String = ""
    var longitude: Double = 0
    var latitude: Double = 0
    var address: String = ""
    var cityId: String = ""
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        albumId <- map["albumId"]
        happenAt <- map["happenAt"]
        contentImage <- map["contentImage"]
        longitude <- map["longitude"]
        latitude <- map["latitude"]
        address <- map["address"]
        cityId <- map["cityId"]
    }
}

class Whisper: BaseCp {
    var channel: String = ""
    var content: String = ""
    var isImage: Bool = false
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        channel <- map["channel"]
        content <- map["content"]
        isImage <- map["isImage"]
    }
}

class Word: BaseCp {
    var contentText: String = ""
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        contentText <- map["contentText"]
    }
}

class Diary: BaseCp {
    var happenAt: Int64 = 0
    var contentText: String = ""
    var contentImageList: [String] = [String]()
    var readCount: Int = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        happenAt <- map["happenAt"]
        contentText <- map["contentText"]
        contentImageList <- map["contentImageList"]
        readCount <- map["readCount"]
    }
}

class Award: BaseCp {
    var happenId: Int64 = 0
    var awardRuleId: Int64 = 0
    var happenAt: Int64 = 0
    var contentText: String = ""
    var scoreChange: Int = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        happenId <- map["happenId"]
        awardRuleId <- map["awardRuleId"]
        happenAt <- map["happenAt"]
        contentText <- map["contentText"]
        scoreChange <- map["scoreChange"]
    }
}

class AwardRule: BaseCp {
    var title: String = ""
    var score: Int = 0
    var useCount: Int = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        title <- map["title"]
        score <- map["score"]
        useCount <- map["useCount"]
    }
}

class AwardScore: BaseCp {
    var changeCount: Int = 0
    var totalScore: Int64 = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        changeCount <- map["changeCount"]
        totalScore <- map["totalScore"]
    }
}

class Food: BaseCp {
    var happenAt: Int64 = 0
    var title: String = ""
    var contentText: String = ""
    var longitude: Double = 0
    var latitude: Double = 0
    var address: String = ""
    var cityId: String = ""
    var contentImageList: [String] = [String]()
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        happenAt <- map["happenAt"]
        title <- map["title"]
        contentText <- map["contentText"]
        longitude <- map["longitude"]
        latitude <- map["latitude"]
        address <- map["address"]
        cityId <- map["cityId"]
        contentImageList <- map["contentImageList"]
    }
}

class Movie: BaseCp {
    var happenAt: Int64 = 0
    var title: String = ""
    var contentText: String = ""
    var longitude: Double = 0
    var latitude: Double = 0
    var address: String = ""
    var cityId: String = ""
    var contentImageList: [String] = [String]()
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        happenAt <- map["happenAt"]
        title <- map["title"]
        contentText <- map["contentText"]
        longitude <- map["longitude"]
        latitude <- map["latitude"]
        address <- map["address"]
        cityId <- map["cityId"]
        contentImageList <- map["contentImageList"]
    }
}

class Dream: BaseCp {
    var happenAt: Int64 = 0
    var contentText: String = ""
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        happenAt <- map["happenAt"]
        contentText <- map["contentText"]
    }
}

class Angry: BaseCp {
    var happenId: Int64 = 0
    var happenAt: Int64 = 0
    var contentText: String = ""
    var giftId: Int64 = 0
    var promiseId: Int64 = 0
    var gift: Gift?
    var promise: Promise?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        happenId <- map["happenId"]
        happenAt <- map["happenAt"]
        contentText <- map["contentText"]
        giftId <- map["giftId"]
        promiseId <- map["promiseId"]
        gift <- map["gift"]
        promise <- map["promise"]
    }
}

class Gift: BaseCp {
    var receiveId: Int64 = 0
    var happenAt: Int64 = 0
    var title: String = ""
    var contentImageList: [String] = [String]()
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        receiveId <- map["receiveId"]
        happenAt <- map["happenAt"]
        title <- map["title"]
        contentImageList <- map["contentImageList"]
    }
}

class Promise: BaseCp {
    var happenId: Int64 = 0
    var happenAt: Int64 = 0
    var contentText: String = ""
    var breakCount: Int = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        happenId <- map["happenId"]
        happenAt <- map["happenAt"]
        contentText <- map["contentText"]
        breakCount <- map["breakCount"]
    }
}

class PromiseBreak: BaseCp {
    var promiseId: Int64 = 0
    var happenAt: Int64 = 0
    var contentText: String = ""
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        promiseId <- map["promiseId"]
        happenAt <- map["happenAt"]
        contentText <- map["contentText"]
    }
}

class PostKindInfo: Mappable {
    var kind: Int = 0
    var enable: Bool = false
    var name: String = ""
    var postSubKindInfoList: [PostSubKindInfo] = [PostSubKindInfo]()
    var topicInfo: TopicInfo?
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        kind <- map["kind"]
        enable <- map["enable"]
        name <- map["name"]
        postSubKindInfoList <- map["postSubKindInfoList"]
        topicInfo <- map["topicInfo"]
    }
}

class PostSubKindInfo: Mappable {
    var kind: Int = 0
    var enable: Bool = false
    var name: String = ""
    var push: Bool = false
    var anonymous: Bool = false
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        kind <- map["kind"]
        enable <- map["enable"]
        name <- map["name"]
        push <- map["push"]
        anonymous <- map["anonymous"]
    }
}

class TopicInfo: BaseObj {
    var kind: Int = 0
    var year: Int = 0
    var dayOfYear: Int = 0
    var postCount: Int = 0
    var browseCount: Int = 0
    var commentCount: Int = 0
    var reportCount: Int = 0
    var pointCount: Int = 0
    var collectCount: Int = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        kind <- map["kind"]
        year <- map["year"]
        dayOfYear <- map["dayOfYear"]
        postCount <- map["postCount"]
        browseCount <- map["browseCount"]
        commentCount <- map["commentCount"]
        reportCount <- map["reportCount"]
        pointCount <- map["pointCount"]
        collectCount <- map["collectCount"]
    }
}

class Post: BaseCp {
    var kind: Int = 0
    var subKind: Int = 0
    var title: String = ""
    var contentText: String = ""
    var top: Bool = false
    var official: Bool = false
    var well: Bool = false
    var reportCount: Int = 0
    var readCount: Int = 0
    var pointCount: Int = 0
    var collectCount: Int = 0
    var commentCount: Int = 0
    // 关联
    var contentImageList: [String] = [String]()
    var screen: Bool = false
    var hot: Bool = false
    var couple: Couple?
    var mine: Bool = false
    var our: Bool = false
    var report: Bool = false
    var read: Bool = false
    var point: Bool = false
    var collect: Bool = false
    var comment: Bool = false
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        kind <- map["kind"]
        subKind <- map["subKind"]
        title <- map["title"]
        contentText <- map["contentText"]
        top <- map["top"]
        official <- map["official"]
        well <- map["well"]
        reportCount <- map["reportCount"]
        readCount <- map["readCount"]
        pointCount <- map["pointCount"]
        collectCount <- map["collectCount"]
        commentCount <- map["commentCount"]
        contentImageList <- map["contentImageList"]
        screen <- map["screen"]
        hot <- map["hot"]
        couple <- map["couple"]
        mine <- map["mine"]
        our <- map["our"]
        report <- map["report"]
        read <- map["read"]
        point <- map["point"]
        collect <- map["collect"]
        comment <- map["comment"]
    }
}

class PostReport: BaseCp {
    var postId: Int64 = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        postId <- map["postId"]
    }
}

class PostPoint: BaseCp {
    var postId: Int64 = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        postId <- map["postId"]
    }
}

class PostCollect: BaseCp {
    var postId: Int64 = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        postId <- map["postId"]
    }
}

class PostComment: BaseCp {
    public static let KIND_TEXT = 0
    public static let KIND_JAB = 1
    
    var postId: Int64 = 0
    var toCommentId: Int64 = 0
    var floor: Int = 0
    var kind: Int = 0
    var contentText: String = ""
    var official: Bool = false
    var subCommentCount: Int = 0
    var reportCount: Int = 0
    var pointCount: Int = 0
    // 关联
    var screen: Bool = false
    var couple: Couple?
    var mine: Bool = false
    var our: Bool = false
    var subComment: Bool = false
    var report: Bool = false
    var point: Bool = false
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        postId <- map["postId"]
        toCommentId <- map["toCommentId"]
        floor <- map["floor"]
        kind <- map["kind"]
        contentText <- map["contentText"]
        official <- map["official"]
        subCommentCount <- map["subCommentCount"]
        reportCount <- map["reportCount"]
        pointCount <- map["pointCount"]
        screen <- map["screen"]
        couple <- map["couple"]
        mine <- map["mine"]
        our <- map["our"]
        subComment <- map["subComment"]
        report <- map["report"]
        point <- map["point"]
    }
}

class PostCommentReport: BaseCp {
    var postCommentId: Int64 = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        postCommentId <- map["postCommentId"]
    }
}

class PostCommentPoint: BaseCp {
    var postCommentId: Int64 = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        postCommentId <- map["postCommentId"]
    }
}

class TopicMessage: BaseCp {
    public static let KIND_ALL = 0
    public static let KIND_OFFICIAL_TEXT = 1
    public static let KIND_JAB_IN_POST = 10
    public static let KIND_JAB_IN_COMMENT = 11
    public static let KIND_POST_BE_REPORT = 20
    public static let KIND_POST_BE_POINT = 21
    public static let KIND_POST_BE_COLLECT = 22
    public static let KIND_POST_BE_COMMENT = 23
    public static let KIND_COMMENT_BE_REPLY = 30
    public static let KIND_COMMENT_BE_REPORT = 31
    public static let KIND_COMMENT_BE_POINT = 32
    
    var kind: Int = 0
    var contentText: String = ""
    var contentId: Int64 = 0
    // 关联
    var couple: Couple?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        kind <- map["kind"]
        contentText <- map["contentText"]
        contentId <- map["contentId"]
        couple <- map["couple"]
    }
}

class Broadcast: BaseObj {
    public static let TYPE_TEXT = 0; // 文章
    public static let TYPE_URL = 1; // 网址
    public static let TYPE_IMAGE = 2; // 图片
    
    var title: String = ""
    var cover: String = ""
    var startAt: Int64 = 0
    var endAt: Int64 = 0
    var contentType: Int = TYPE_TEXT
    var contentText: String = ""
    var isEnd: Bool = false
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        title <- map["title"]
        cover <- map["cover"]
        startAt <- map["startAt"]
        endAt <- map["endAt"]
        contentType <- map["contentType"]
        contentText <- map["contentText"]
        isEnd <- map["isEnd"]
    }
}

class Sign: BaseCp {
    var year: Int = 0
    var monthOfYear: Int = 0
    var dayOfMonth: Int = 0
    var continueDay: Int = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        year <- map["year"]
        monthOfYear <- map["monthOfYear"]
        dayOfMonth <- map["dayOfMonth"]
        continueDay <- map["continueDay"]
    }
}

class Bill: Mappable {
    // 平台
    public static let PAY_PLATFORM_ALI = 100
    public static let PAY_PLATFORM_WX = 200
    public static let PAY_PLATFORM_APPLE = 300
    public static let PAY_PLATFORM_GOOGLE = 400
    // 商品
    public static let GOODS_VIP_1 = 110100
    public static let GOODS_VIP_2 = 12010
    public static let GOODS_VIP_3 = 13010
    public static let GOODS_COIN_1 = 21010
    public static let GOODS_COIN_2 = 22010
    public static let GOODS_COIN_3 = 23010
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
    }
}

class OrderBefore: Mappable {
    var platform: Int = Bill.PAY_PLATFORM_APPLE
    var appleOrder: AppleOrder?
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        platform <- map["platform"]
        appleOrder <- map["appleOrder"]
    }
}

class AppleOrder: Mappable {
    var productId: String = ""
    var transactionId: String = ""
    var receipt: String = ""
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        productId <- map["productId"]
        transactionId <- map["transactionId"]
        receipt <- map["receipt"]
    }
}

class Coin: BaseCp {
    public static let KIND_ADD_BY_SYS = 10 // +系统变更
    public static let KIND_ADD_BY_PLAY_PAY = 100 // +商店充值
    public static let KIND_ADD_BY_SIGN_DAY = 200 // +每日签到
    public static let KIND_ADD_BY_AD_WATCH = 210 // +广告观看
    public static let KIND_ADD_BY_AD_CLICK = 211 // +广告点击
    public static let KIND_ADD_BY_MATCH_POST = 300 // +参加比拼
    public static let KIND_SUB_BY_MATCH_UP = -300 // -比拼投币
    public static let KIND_SUB_BY_WISH_UP = -410 // -许愿投币
    public static let KIND_SUB_BY_CARD_UP = -420 // -明信投币
    
    var kind: Int = 0
    var billId: Int64 = 0
    var change: Int = 0
    var count: Int = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        kind <- map["kind"]
        billId <- map["billId"]
        change <- map["change"]
        count <- map["count"]
    }
}

class Vip: BaseCp {
    var fromType: Int = 0
    var billId: Int64 = 0
    var expireDays: Int = 0
    var expireAt: Int64 = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        fromType <- map["fromType"]
        billId <- map["billId"]
        expireDays <- map["expireDays"]
        expireAt <- map["expireAt"]
    }
}

class MatchPeriod: BaseObj {
    public static let MATCH_KIND_WIFE_PICTURE = 100 // 照片墙
    public static let MATCH_KIND_LETTER_SHOW = 200 // 情话集
    
    var startAt: Int64 = 0
    var endAt: Int64 = 0
    var period: Int = 0
    var kind: Int = 0
    var title: String = ""
    var coinChange: Int = 0
    var worksCount: Int = 0
    var reportCount: Int = 0
    var pointCount: Int = 0
    var coinCount: Int = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        startAt <- map["startAt"]
        endAt <- map["endAt"]
        period <- map["period"]
        kind <- map["kind"]
        title <- map["title"]
        coinChange <- map["coinChange"]
        worksCount <- map["worksCount"]
        reportCount <- map["reportCount"]
        pointCount <- map["pointCount"]
        coinCount <- map["coinCount"]
    }
}

class MatchWork: BaseCp {
    var matchPeriodId: Int64 = 0
    var kind: Int = 0
    var title: String = ""
    var contentText: String = ""
    var contentImage: String = ""
    var reportCount: Int = 0
    var pointCount: Int = 0
    var coinCount: Int = 0
    // 关联
    var screen: Bool = false
    var couple: Couple?
    var mine: Bool = false
    var our: Bool = false
    var report: Bool = false
    var point: Bool = false
    var coin: Bool = false
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        matchPeriodId <- map["matchPeriodId"]
        kind <- map["kind"]
        title <- map["title"]
        contentText <- map["contentText"]
        contentImage <- map["contentImage"]
        reportCount <- map["reportCount"]
        pointCount <- map["pointCount"]
        coinCount <- map["coinCount"]
        screen <- map["screen"]
        couple <- map["couple"]
        mine <- map["mine"]
        our <- map["our"]
        report <- map["report"]
        point <- map["point"]
        coin <- map["coin"]
    }
}

class MatchCoin: BaseCp {
    var matchPeriodId: Int64 = 0
    var matchWorkId: Int64 = 0
    var coinId: Int64 = 0
    var coinCount: Int = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        matchPeriodId <- map["matchPeriodId"]
        matchWorkId <- map["matchWorkId"]
        coinId <- map["coinId"]
        coinCount <- map["coinCount"]
    }
}

class MatchPoint: BaseCp {
    var matchPeriodId: Int64 = 0
    var matchWorkId: Int64 = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        matchPeriodId <- map["matchPeriodId"]
        matchWorkId <- map["matchWorkId"]
    }
}

class MatchReport: BaseCp {
    var matchPeriodId: Int64 = 0
    var matchWorkId: Int64 = 0
    var reason: String = ""
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        matchPeriodId <- map["matchPeriodId"]
        matchWorkId <- map["matchWorkId"]
        reason <- map["reason"]
    }
}
