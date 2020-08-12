//
//  ApiResult.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/7.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import ObjectMapper

class ApiResult: Mappable {
    public static let CODE_OK = 0
    public static let CODE_TOAST = 10
    public static let CODE_DIALOG = 11
    public static let CODE_NO_USER_INFO = 20
    public static let CODE_NO_CP = 30
    
    var code: Int = 0
    var message: String = ""
    var data: ApiData?
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        data <- map["data"]
    }
}

class ApiData: Mappable {
    var show: String = ""
    var total: Int64 = 0
    var commonConst: CommonConst?
    var commonCount: CommonCount?
    var modelShow: ModelShow?
    var limit: Limit?
    var vipLimit: VipLimit?
    var vipYesLimit: VipLimit?
    var vipNoLimit: VipLimit?
    var ossInfo: OssInfo?
    var pushInfo: PushInfo?
    var adInfo: AdInfo?
    var user: User?
    var notice: Notice?
    var noticeList: [Notice]?
    var suggest: Suggest?
    var suggestList: [Suggest]?
    var suggestCommentList: [SuggestComment]?
    // couple
    var couple: Couple?
    var coupleStateList: [CoupleState]?
    var pairCard: PairCard?
    var ta: User?
    var wallPaper: WallPaper?
    var placeMe: Place?
    var placeTa: Place?
    var placeList: [Place]?
    var weatherTodayMe: WeatherToday?
    var weatherTodayTa: WeatherToday?
    var weatherForecastMe: WeatherForecastInfo?
    var weatherForecastTa: WeatherForecastInfo?
    // note
    var lock: Lock?
    var trendsList: [Trends]?
    var noteTotal: NoteTotal?
    var souvenirLatest: Souvenir?
    var souvenir: Souvenir?
    var souvenirList: [Souvenir]?
    var mensesInfo: MensesInfo?
    var menses2: Menses2?
    var menses2List: [Menses2]?
    var mensesDay: MensesDay?
    var shy: Shy?
    var shyList: [Shy]?
    var sleep: Sleep?
    var sleepMe: Sleep?
    var sleepTa: Sleep?
    var sleepList: [Sleep]?
    var word: Word?
    var wordList: [Word]?
    var whisper: Whisper?
    var whisperList: [Whisper]?
    var diary: Diary?
    var diaryList: [Diary]?
    var album: Album?
    var albumList: [Album]?
    var picture: Picture?
    var pictureList: [Picture]?
    var audio: Audio?
    var audioList: [Audio]?
    var video: Video?
    var videoList: [Video]?
    var food: Food?
    var foodList: [Food]?
    var travel: Travel?
    var travelList: [Travel]?
    var gift: Gift?
    var giftList: [Gift]?
    var promise: Promise?
    var promiseList: [Promise]?
    var promiseBreak: PromiseBreak?
    var promiseBreakList: [PromiseBreak]?
    var angry: Angry?
    var angryList: [Angry]?
    var dream: Dream?
    var dreamList: [Dream]?
    var awardScoreMe: AwardScore?
    var awardScoreTa: AwardScore?
    var award: Award?
    var awardList: [Award]?
    var awardRule: AwardRule?
    var awardRuleList: [AwardRule]?
    var movie: Movie?
    var movieList: [Movie]?
    // topic
    var postKindInfoList: [PostKindInfo]?
    var topicMessageList: [TopicMessage]?
    var post: Post?
    var postList: [Post]?
    var postReport: PostReport?
    var postPoint: PostPoint?
    var postCollect: PostCollect?
    var postComment: PostComment?
    var postCommentList: [PostComment]?
    var postCommentReport: PostCommentReport?
    var postCommentPoint: PostCommentPoint?
    // more
    var broadcastList: [Broadcast]?
    var orderBefore: OrderBefore?
    var vip: Vip?
    var vipList: [Vip]?
    var coin: Coin?
    var coinList: [Coin]?
    var sign: Sign?
    var signList: [Sign]?
    var wifePeriod: MatchPeriod?
    var letterPeriod: MatchPeriod?
    var matchPeriodList: [MatchPeriod]?
    var matchWork: MatchWork?
    var matchWorkList: [MatchWork]?
    var matchReport: MatchReport?
    var matchPoint: MatchPoint?
    var matchCoin: MatchCoin?
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        show <- map["show"]
        total <- map["total"]
        commonConst <- map["commonConst"]
        commonCount <- map["commonCount"]
        modelShow <- map["modelShow"]
        limit <- map["limit"]
        vipLimit <- map["vipLimit"]
        vipYesLimit <- map["vipYesLimit"]
        vipNoLimit <- map["vipNoLimit"]
        ossInfo <- map["ossInfo"]
        pushInfo <- map["pushInfo"]
        adInfo <- map["adInfo"]
        user <- map["user"]
        notice <- map["notice"]
        noticeList <- map["noticeList"]
        suggest <- map["suggest"]
        suggestList <- map["suggestList"]
        suggestCommentList <- map["suggestCommentList"]
        couple <- map["couple"]
        coupleStateList <- map["coupleStateList"]
        pairCard <- map["pairCard"]
        ta <- map["ta"]
        wallPaper <- map["wallPaper"]
        placeMe <- map["placeMe"]
        placeTa <- map["placeTa"]
        placeList <- map["placeList"]
        weatherTodayMe <- map["weatherTodayMe"]
        weatherTodayTa <- map["weatherTodayTa"]
        weatherForecastMe <- map["weatherForecastMe"]
        weatherForecastTa <- map["weatherForecastTa"]
        lock <- map["lock"]
        trendsList <- map["trendsList"]
        noteTotal <- map["noteTotal"]
        souvenirLatest <- map["souvenirLatest"]
        souvenir <- map["souvenir"]
        souvenirList <- map["souvenirList"]
        mensesInfo <- map["mensesInfo"]
        menses2 <- map["menses2"]
        menses2List <- map["menses2List"]
        mensesDay <- map["mensesDay"]
        shy <- map["shy"]
        shyList <- map["shyList"]
        sleep <- map["sleep"]
        sleepMe <- map["sleepMe"]
        sleepTa <- map["sleepTa"]
        sleepList <- map["sleepList"]
        word <- map["word"]
        wordList <- map["wordList"]
        whisper <- map["whisper"]
        whisperList <- map["whisperList"]
        diary <- map["diary"]
        diaryList <- map["diaryList"]
        album <- map["album"]
        albumList <- map["albumList"]
        picture <- map["picture"]
        pictureList <- map["pictureList"]
        audio <- map["audio"]
        audioList <- map["audioList"]
        video <- map["video"]
        videoList <- map["videoList"]
        food <- map["food"]
        foodList <- map["foodList"]
        travel <- map["travel"]
        travelList <- map["travelList"]
        gift <- map["gift"]
        giftList <- map["giftList"]
        promise <- map["promise"]
        promiseList <- map["promiseList"]
        promiseBreak <- map["promiseBreak"]
        promiseBreakList <- map["promiseBreakList"]
        angry <- map["angry"]
        angryList <- map["angryList"]
        dream <- map["dream"]
        dreamList <- map["dreamList"]
        awardScoreMe <- map["awardScoreMe"]
        awardScoreTa <- map["awardScoreTa"]
        award <- map["award"]
        awardList <- map["awardList"]
        awardRule <- map["awardRule"]
        awardRuleList <- map["awardRuleList"]
        movie <- map["movie"]
        movieList <- map["movieList"]
        postKindInfoList <- map["postKindInfoList"]
        topicMessageList <- map["topicMessageList"]
        post <- map["post"]
        postList <- map["postList"]
        postReport <- map["postReport"]
        postPoint <- map["postPoint"]
        postCollect <- map["postCollect"]
        postComment <- map["postComment"]
        postCommentList <- map["postCommentList"]
        postCommentReport <- map["postCommentReport"]
        postCommentPoint <- map["postCommentPoint"]
        broadcastList <- map["broadcastList"]
        orderBefore <- map["orderBefore"]
        vip <- map["vip"]
        vipList <- map["vipList"]
        coin <- map["coin"]
        coinList <- map["coinList"]
        sign <- map["sign"]
        signList <- map["signList"]
        wifePeriod <- map["wifePeriod"]
        letterPeriod <- map["letterPeriod"]
        matchPeriodList <- map["matchPeriodList"]
        matchWork <- map["matchWork"]
        matchWorkList <- map["matchWorkList"]
        matchReport <- map["matchReport"]
        matchPoint <- map["matchPoint"]
        matchCoin <- map["matchCoin"]
    }
}
