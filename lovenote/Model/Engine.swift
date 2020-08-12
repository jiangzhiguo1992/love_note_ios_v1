//
// Created by 蒋治国 on 2018-12-16.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation
import ObjectMapper

class Help: BaseObj {
    var index: Int = 0
    var title: String = ""
    var desc: String = ""
    var contentList: [HelpContent] = [HelpContent]()
    var subList: [Help] = [Help]()
}

class HelpContent {
    var question: String = ""
    var answer: String = ""
}

class NoteCustom {
    var souvenir: Bool = true
    var shy: Bool = true
    var menses: Bool = true
    var sleep: Bool = true
    var word: Bool = true
    var whisper: Bool = true
    var diary: Bool = true
    var award: Bool = true
    var dream: Bool = true
    var movie: Bool = true
    var food: Bool = true
    var travel: Bool = true
    var angry: Bool = true
    var gift: Bool = true
    var promise: Bool = true
    var audio: Bool = true
    var video: Bool = true
    var album: Bool = true
    var total: Bool = true
    var trends: Bool = true
    var custom: Bool = true
}

class PushExtra: Mappable {
    public static let TYPE_APP = 0;
    public static let TYPE_SUGGEST = 50;
    public static let TYPE_COUPLE = 100;
    public static let TYPE_COUPLE_INFO = 110;
    public static let TYPE_COUPLE_WALL = 120;
    public static let TYPE_COUPLE_PLACE = 130;
    public static let TYPE_COUPLE_WEATHER = 140;
    public static let TYPE_NOTE = 200;
    public static let TYPE_NOTE_LOCK = 210;
    public static let TYPE_NOTE_TRENDS = 211;
    public static let TYPE_NOTE_TOTAL = 212;
    public static let TYPE_NOTE_SHY = 220;
    public static let TYPE_NOTE_MENSES = 221;
    public static let TYPE_NOTE_SLEEP = 222;
    public static let TYPE_NOTE_AUDIO = 230;
    public static let TYPE_NOTE_VIDEO = 231;
    public static let TYPE_NOTE_ALBUM = 232;
    public static let TYPE_NOTE_PICTURE = 233;
    public static let TYPE_NOTE_SOUVENIR = 240;
    public static let TYPE_NOTE_WISH = 241;
    public static let TYPE_NOTE_WORD = 250;
    public static let TYPE_NOTE_AWARD = 251;
    public static let TYPE_NOTE_AWARD_RULE = 252;
    public static let TYPE_NOTE_DIARY = 253;
    public static let TYPE_NOTE_DREAM = 260;
    public static let TYPE_NOTE_ANGRY = 261;
    public static let TYPE_NOTE_GIFT = 262;
    public static let TYPE_NOTE_PROMISE = 263;
    public static let TYPE_NOTE_PROMISE_BREAK = 264;
    public static let TYPE_NOTE_TRAVEL = 270;
    public static let TYPE_NOTE_MOVIE = 271;
    public static let TYPE_NOTE_FOOD = 272;
    public static let TYPE_TOPIC = 300;
    public static let TYPE_TOPIC_MINE = 310;
    public static let TYPE_TOPIC_COLLECT = 320;
    public static let TYPE_TOPIC_MESSAGE = 330;
    public static let TYPE_TOPIC_POST = 340;
    public static let TYPE_TOPIC_COMMENT = 350;
    public static let TYPE_MORE = 400;
    
    var createAt: Int64 = 0
    var userId: Int64 = 0
    var toUserId: Int64 = 0
    var platform: String = ""
    var title: String = ""
    var contentText: String = ""
    var contentType: Int = 0
    var contentId: Int64 = 0
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        createAt <- map["createAt"]
        userId <- map["userId"]
        toUserId <- map["toUserId"]
        platform <- map["platform"]
        title <- map["title"]
        contentText <- map["contentText"]
        contentType <- map["contentType"]
        contentId <- map["contentId"]
    }
}

class SuggestInfo {
    var statusList: [SuggestStatus] = [SuggestStatus]()
    var kindList: [SuggestKind] = [SuggestKind]()
}

class SuggestStatus {
    var status: Int = 0
    var show: String = ""
}

class SuggestKind {
    var kind: Int = 0
    var show: String = ""
}
