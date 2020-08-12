//
//  NotifyUtils.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/11.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NotifyHelper {
    
    // common
    public static let TAG_THEME_UPDATE = "theme_update"
    public static let TAG_MAP_SELECT = "map_select"
    public static let TAG_VIDEO_SELECT = "video_select"
    public static let TAG_ALBUM_SELECT = "album_select"
    public static let TAG_DIARY_SELECT = "diary_select"
    public static let TAG_AWARD_RULE_SELECT = "award_select"
    public static let TAG_TRAVEL_SELECT = "travel_select"
    public static let TAG_GIFT_SELECT = "gift_select"
    public static let TAG_FOOD_SELECT = "food_select"
    public static let TAG_PROMISE_SELECT = "promise_select"
    public static let TAG_MOVIE_SELECT = "movie_select"
    // suggest
    public static let TAG_SUGGEST_LIST_REFRESH = "suggest_list_refresh" // 建议
    public static let TAG_SUGGEST_LIST_ITEM_DELETE = "suggest_list_item_delete"
    public static let TAG_SUGGEST_LIST_ITEM_REFRESH = "suggest_list_item_refresh"
    public static let TAG_SUGGEST_DETAIL_REFRESH = "suggest_detail_refresh"
    // user
    public static let TAG_USER_REFRESH = "user_refresh" // 用户
    // couple
    public static let TAG_COUPLE_REFRESH = "couple_refresh" // 配对
    public static let TAG_WALL_PAPER_REFRESH = "wall_paper_refresh" // 墙纸
    // note
    public static let TAG_LOCK_REFRESH = "lock_refresh" // 密码锁
    public static let TAG_CUSTOM_REFRESH = "custom_refresh" // 功能定制
    public static let TAG_MENSES_INFO_UPDATE = "menses_info_update" // 姨妈
    public static let TAG_SHY_LIST_REFRESH = "shy_list_refresh" // 羞羞
    public static let TAG_SHY_LIST_ITEM_DELETE = "shy_list_item_delete"
    public static let TAG_SLEEP_LIST_ITEM_DELETE = "sleep_list_item_delete" // 睡眠
    public static let TAG_AUDIO_LIST_REFRESH = "audio_list_refresh" // 音频
    public static let TAG_AUDIO_LIST_ITEM_DELETE = "audio_list_item_delete"
    public static let TAG_VIDEO_LIST_REFRESH = "video_list_refresh" // 视频
    public static let TAG_VIDEO_LIST_ITEM_DELETE = "video_list_item_delete"
    public static let TAG_ALBUM_LIST_REFRESH = "album_list_refresh" // 相册
    public static let TAG_ALBUM_LIST_ITEM_DELETE = "album_list_item_delete"
    public static let TAG_ALBUM_LIST_ITEM_REFRESH = "album_list_item_refresh"
    public static let TAG_ALBUM_DETAIL_REFRESH = "album_detail_refresh"
    public static let TAG_PICTURE_LIST_REFRESH = "picture_list_refresh" // 照片
    public static let TAG_SOUVENIR_LIST_REFRESH = "souvenir_list_refresh" // 纪念日
    public static let TAG_SOUVENIR_LIST_ITEM_DELETE = "souvenir_list_item_delete"
    public static let TAG_SOUVENIR_LIST_ITEM_REFRESH = "souvenir_list_item_refresh"
    public static let TAG_SOUVENIR_DETAIL_REFRESH = "souvenir_detail_refresh"
    public static let TAG_AWARD_LIST_REFRESH = "award_list_refresh" // 约定
    public static let TAG_AWARD_RULE_LIST_REFRESH = "award_rule_list_refresh"
    public static let TAG_DIARY_LIST_REFRESH = "diary_list_refresh" // 日记
    public static let TAG_DIARY_LIST_ITEM_DELETE = "diary_list_item_delete"
    public static let TAG_DIARY_LIST_ITEM_REFRESH = "diary_list_item_refresh"
    public static let TAG_DIARY_DETAIL_REFRESH = "diary_detail_refresh"
    public static let TAG_DREAM_LIST_REFRESH = "dream_list_refresh" // 梦境
    public static let TAG_DREAM_LIST_ITEM_DELETE = "dream_list_item_delete"
    public static let TAG_DREAM_LIST_ITEM_REFRESH = "dream_list_item_refresh"
    public static let TAG_DREAM_DETAIL_REFRESH = "dream_detail_refresh"
    public static let TAG_ANGRY_LIST_REFRESH = "angry_list_refresh" // 生气
    public static let TAG_ANGRY_LIST_ITEM_DELETE = "angry_list_item_delete"
    public static let TAG_ANGRY_LIST_ITEM_REFRESH = "angry_list_item_refresh"
    public static let TAG_GIFT_LIST_REFRESH = "gift_list_refresh" // 礼物
    public static let TAG_GIFT_LIST_ITEM_DELETE = "gift_list_item_delete"
    public static let TAG_GIFT_LIST_ITEM_REFRESH = "gift_list_item_refresh"
    public static let TAG_PROMISE_LIST_REFRESH = "promise_list_refresh" // 承诺
    public static let TAG_PROMISE_LIST_ITEM_DELETE = "promise_list_item_delete"
    public static let TAG_PROMISE_LIST_ITEM_REFRESH = "promise_list_item_refresh"
    public static let TAG_PROMISE_DETAIL_REFRESH = "promise_detail_refresh"
    public static let TAG_TRAVEL_LIST_REFRESH = "travel_list_refresh" // 游记
    public static let TAG_TRAVEL_LIST_ITEM_DELETE = "travel_list_item_delete"
    public static let TAG_TRAVEL_LIST_ITEM_REFRESH = "travel_list_item_refresh"
    public static let TAG_TRAVEL_DETAIL_REFRESH = "travel_detail_refresh"
    public static let TAG_TRAVEL_EDIT_ADD_PLACE = "travel_edit_add_place"
    public static let TAG_FOOD_LIST_REFRESH = "food_list_refresh" // 美食
    public static let TAG_FOOD_LIST_ITEM_DELETE = "food_list_item_delete"
    public static let TAG_FOOD_LIST_ITEM_REFRESH = "food_list_item_refresh"
    public static let TAG_MOVIE_LIST_REFRESH = "movie_list_refresh" // 电影
    public static let TAG_MOVIE_LIST_ITEM_DELETE = "movie_list_item_delete"
    public static let TAG_MOVIE_LIST_ITEM_REFRESH = "movie_list_item_refresh"
    // topic
    public static let TAG_POST_SEARCH_ALL = "post_search_all"
    public static let TAG_POST_SEARCH_OFFICIAL = "post_search_official"
    public static let TAG_POST_SEARCH_WELL = "post_search_well"
    public static let TAG_POST_LIST_REFRESH = "post_list_refresh"
    public static let TAG_POST_LIST_ITEM_DELETE = "post_list_item_delete"
    public static let TAG_POST_LIST_ITEM_REFRESH = "post_list_item_refresh"
    public static let TAG_POST_DETAIL_REFRESH = "post_detail_refresh"
    public static let TAG_POST_COMMENT_LIST_REFRESH = "post_comment_list_refresh"
    public static let TAG_POST_COMMENT_LIST_ITEM_DELETE = "post_comment_list_item_delete"
    public static let TAG_POST_COMMENT_LIST_ITEM_REFRESH = "post_comment_list_item_refresh"
    public static let TAG_POST_COMMENT_DETAIL_REFRESH = "post_comment_detail_refresh"
    // more
    public static let TAG_VIP_INFO_REFRESH = "vip_info_refresh"
    public static let TAG_COIN_INFO_REFRESH = "coin_info_refresh"
    
    public static func post(_ name: String, obj: Any?, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: NSNotification.Name(name), object: obj, userInfo: userInfo)
    }
    
    public static func addObserver(_ observer: Any, selector: Selector, name: String, object: Any? = nil) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(name), object: nil)
    }
    
    public static func removeObserver(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
    
}
