//
// Created by 蒋治国 on 2018/12/4.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation

class UDHelper {
    
    // 标准存储
    private static let UB = UserDefaults.standard
    
    // common
    private static let FIELD_COMMON_THEME = "gg_common_theme"
    private static let FIELD_COMMON_NOTICE_SYSTEM = "gg_common_notice_system"
    private static let FIELD_COMMON_NOTICE_SOCIAL = "gg_common_notice_social"
    private static let FIELD_COMMON_NOTICE_DISTURB = "gg_common_notice_disturb"
    // modelShow
    private static let FIELD_MODEL_SHOW = "gg_model_show"
    private static let FIELD_MODEL_SHOW_MARKET_PAY = "gg_model_show_market_pay"
    private static let FIELD_MODEL_SHOW_MARKET_COIN_AD = "gg_model_show_market_coin_ad"
    private static let FIELD_MODEL_SHOW_COUPLE = "gg_model_show_couple"
    private static let FIELD_MODEL_SHOW_COUPLE_PLACE = "gg_model_show_couple_place"
    private static let FIELD_MODEL_SHOW_COUPLE_WEATHER = "gg_model_show_couple_weather"
    private static let FIELD_MODEL_SHOW_NOTE = "gg_model_show_note"
    private static let FIELD_MODEL_SHOW_TOPIC = "gg_model_show_topic"
    private static let FIELD_MODEL_SHOW_MORE = "gg_model_show_more"
    private static let FIELD_MODEL_SHOW_MORE_VIP = "gg_model_show_more_vip"
    private static let FIELD_MODEL_SHOW_MORE_COIN = "gg_model_show_more_coin"
    private static let FIELD_MODEL_SHOW_MORE_MATCH = "gg_model_show_more_match"
    private static let FIELD_MODEL_SHOW_MORE_FEATURE = "gg_model_show_more_feature"
    // noteCustom
    private static let FIELD_NOTE_CUSTOM = "gg_note_custom"
    private static let FIELD_NOTE_CUSTOM_SOUVENIR = "gg_note_custom_souvenir"
    private static let FIELD_NOTE_CUSTOM_SHY = "gg_note_custom_shy"
    private static let FIELD_NOTE_CUSTOM_MENSES = "gg_note_custom_menses"
    private static let FIELD_NOTE_CUSTOM_SLEEP = "gg_note_custom_sleep"
    private static let FIELD_NOTE_CUSTOM_WORD = "gg_note_custom_word"
    private static let FIELD_NOTE_CUSTOM_WHISPER = "gg_note_custom_whisper"
    private static let FIELD_NOTE_CUSTOM_DIARY = "gg_note_custom_diary"
    private static let FIELD_NOTE_CUSTOM_AWARD = "gg_note_custom_award"
    private static let FIELD_NOTE_CUSTOM_DREAM = "gg_note_custom_dream"
    private static let FIELD_NOTE_CUSTOM_MOVIE = "gg_note_custom_movie"
    private static let FIELD_NOTE_CUSTOM_FOOD = "gg_note_custom_food"
    private static let FIELD_NOTE_CUSTOM_TRAVEL = "gg_note_custom_travel"
    private static let FIELD_NOTE_CUSTOM_ANGRY = "gg_note_custom_angry"
    private static let FIELD_NOTE_CUSTOM_GIFT = "gg_note_custom_gift"
    private static let FIELD_NOTE_CUSTOM_PROMISE = "gg_note_custom_promise"
    private static let FIELD_NOTE_CUSTOM_AUDIO = "gg_note_custom_audio"
    private static let FIELD_NOTE_CUSTOM_VIDEO = "gg_note_custom_video"
    private static let FIELD_NOTE_CUSTOM_ALBUM = "gg_note_custom_album"
    private static let FIELD_NOTE_CUSTOM_TOTAL = "gg_note_custom_total"
    private static let FIELD_NOTE_CUSTOM_TRENDS = "gg_note_custom_trends"
    private static let FIELD_NOTE_CUSTOM_CUSTOM = "gg_note_custom_custom"
    // commonConst
    private static let FIELD_COMMON_CONST_COMPANY_NAME = "gg_common_const_company_name"
    private static let FIELD_COMMON_CONST_CUSTOMER_QQ = "gg_common_const_customer_qq"
    private static let FIELD_COMMON_CONST_OFFICIAL_GROUP = "gg_common_const_official_group"
    private static let FIELD_COMMON_CONST_OFFICIAL_WEIBO = "gg_common_const_official_weibo"
    private static let FIELD_COMMON_CONST_OFFICIAL_WEB = "gg_common_const_official_web"
    private static let FIELD_COMMON_CONST_CONTACT_EMAIL = "gg_common_const_contact_email"
    private static let FIELD_COMMON_CONST_IOS_APP_ID = "gg_common_const_ios_app_id"
    // commonCount
    private static let FIELD_COMMON_COUNT_NOTICE_NEW_COUNT = "gg_common_count_notice_new_count"
    private static let FIELD_COMMON_COUNT_VERSION_NEW_COUNT = "gg_common_count_version_new_count"
    private static let FIELD_COMMON_COUNT_NOTE_TRENDS_NEW_COUNT = "gg_common_count_note_trends_new_count"
    private static let FIELD_COMMON_COUNT_TOPIC_MSG_NEW_COUNT = "gg_common_count_topic_msg_new_count"
    // ossInfo
    private static let FIELD_OSS_SECURITY_TOKEN = "gg_oss_security_token"
    private static let FIELD_OSS_KEY_ID = "gg_oss_access_key_id"
    private static let FIELD_OSS_KEY_SECRET = "gg_oss_access_key_secret"
    private static let FIELD_OSS_REGION = "gg_oss_region"
    private static let FIELD_OSS_DOMAIN = "gg_oss_domain"
    private static let FIELD_OSS_BUCKET = "gg_oss_bucket"
    private static let FIELD_OSS_STS_EXPIRE_TIME = "gg_oss_sts_expire_time"
    private static let FIELD_OSS_OSS_REFRESH_SEC = "gg_oss_oss_refresh_sec"
    private static let FIELD_OSS_URL_EXPIRE_SEC = "gg_oss_url_expire_sec"
    private static let FIELD_OSS_PATH_LOG = "gg_oss_path_log"
    private static let FIELD_OSS_PATH_SUGGEST = "gg_oss_path_suggest"
    private static let FIELD_OSS_PATH_COUPLE_AVATAR = "gg_oss_path_couple_avatar"
    private static let FIELD_OSS_PATH_COUPLE_WALL = "gg_oss_path_couple_wall"
    private static let FIELD_OSS_PATH_NOTE_WHISPER = "gg_oss_path_note_whisper"
    private static let FIELD_OSS_PATH_NOTE_DIARY = "gg_oss_path_note_diary"
    private static let FIELD_OSS_PATH_NOTE_ALBUM = "gg_oss_path_note_album"
    private static let FIELD_OSS_PATH_NOTE_PICTURE = "gg_oss_path_note_picture"
    private static let FIELD_OSS_PATH_NOTE_AUDIO = "gg_oss_path_note_audio"
    private static let FIELD_OSS_PATH_NOTE_VIDEO = "gg_oss_path_note_video"
    private static let FIELD_OSS_PATH_NOTE_VIDEO_THUMB = "gg_oss_path_note_video_thumb"
    private static let FIELD_OSS_PATH_NOTE_FOOD = "gg_oss_path_note_food"
    private static let FIELD_OSS_PATH_NOTE_GIFT = "gg_oss_path_note_gift"
    private static let FIELD_OSS_PATH_NOTE_MOVIE = "gg_oss_path_note_movie"
    private static let FIELD_OSS_PATH_TOPIC_POST = "gg_oss_path_topic_post"
    private static let FIELD_OSS_PATH_MORE_MATCH = "gg_oss_path_more_match"
    // pushInfo
    private static let FIELD_PUSH = "gg_push";
    private static let FIELD_PUSH_ALI_APP_KEY = "gg_push_ali_app_key"
    private static let FIELD_PUSH_ALI_APP_SECRET = "gg_push_ali_app_secret"
    private static let FIELD_PUSH_NOTICE_LIGHT = "gg_push_notice_light"
    private static let FIELD_PUSH_NOTICE_SOUND = "gg_push_notice_sound"
    private static let FIELD_PUSH_NOTICE_VIBRATE = "gg_push_notice_vibrate"
    private static let FIELD_PUSH_NO_START_HOUR = "gg_push_no_start_hour"
    private static let FIELD_PUSH_NO_END_HOUR = "gg_push_no_end_hour"
    // adInfo
    private static let FIELD_AD_APP_ID = "gg_ad_app_id";
    private static let FIELD_AD_TOPIC_POST_POS_ID = "gg_ad_topic_post_pos_id";
    private static let FIELD_AD_TOPIC_POST_JUMP = "gg_ad_topic_post_jump";
    private static let FIELD_AD_TOPIC_POST_START = "gg_ad_topic_post_start";
    private static let FIELD_AD_COIN_FREE_POS_ID = "gg_ad_coin_free_pos_id";
    private static let FIELD_AD_COIN_FREE_TICK_SEC = "gg_ad_coin_free_tick_sec";
    // limit
    private static let FIELD_LIMIT_SMS_CODE_LENGTH = "gg_limit_sms_code_length"
    private static let FIELD_LIMIT_SMS_BETWEEN = "gg_limit_sms_between"
    private static let FIELD_LIMIT_SUGGEST_TITLE_LENGTH = "gg_limit_suggest_title_length"
    private static let FIELD_LIMIT_SUGGEST_CONTENT_LENGTH = "gg_limit_suggest_content_length"
    private static let FIELD_LIMIT_SUGGEST_COMMENT_CONTENT_LENGTH = "gg_limit_suggest_comment_content_length"
    private static let FIELD_LIMIT_COUPLE_INVITE_INTERVAL_SEC = "gg_limit_couple_invite_interval_sec"
    private static let FIELD_LIMIT_COUPLE_BREAK_NEED_SEC = "gg_limit_couple_break_need_sec"
    private static let FIELD_LIMIT_COUPLE_BREAK_SEC = "gg_limit_couple_break_sec"
    private static let FIELD_LIMIT_COUPLE_NAME_LENGTH = "gg_limit_couple_name_length"
    private static let FIELD_LIMIT_NOTE_OSS_EXPIRE_SECONDS = "gg_limit_note_oss_expire_seconds"
    private static let FIELD_LIMIT_MENSES_MAX_PER_MONTH = "gg_limit_menses_max_per_month"
    private static let FIELD_LIMIT_MENSES_MAX_CYCLE_DAY = "gg_limit_menses_max_cycle_day"
    private static let FIELD_LIMIT_MENSES_MAX_DURATION_DAY = "gg_limit_menses_max_duration_day"
    private static let FIELD_LIMIT_MENSES_DEFAULT_CYCLE_DAY = "gg_limit_menses_default_cycle_day"
    private static let FIELD_LIMIT_MENSES_DEFAULT_DURATION_DAY = "gg_limit_menses_default_duration_day"
    private static let FIELD_LIMIT_SHY_MAX_PER_DAY = "gg_limit_shy_max_per_day"
    private static let FIELD_LIMIT_SHY_SAFE_LENGTH = "gg_limit_shy_safe_length"
    private static let FIELD_LIMIT_SHY_DESC_LENGTH = "gg_limit_shy_desc_length"
    private static let FIELD_LIMIT_SLEEP_MAX_PER_DAY = "gg_limit_sleep_max_per_day"
    private static let FIELD_LIMIT_NOTE_SLEEP_SUCCESS_MIN_SEC = "gg_limit_note_sleep_success_min_sec"
    private static let FIELD_LIMIT_NOTE_SLEEP_SUCCESS_MAX_SEC = "gg_limit_note_sleep_success_max_sec"
    private static let FIELD_LIMIT_NOTE_LOCK_LENGTH = "gg_limit_note_lock_length"
    private static let FIELD_LIMIT_SOUVENIR_TITLE_LENGTH = "gg_limit_souvenir_title_length"
    private static let FIELD_LIMIT_SOUVENIR_FOREIGN_YEAR_COUNT = "gg_limit_souvenir_foreign_year_count"
    private static let FIELD_LIMIT_TRAVEL_PLACE_COUNT = "gg_limit_travel_place_count"
    private static let FIELD_LIMIT_TRAVEL_VIDEO_COUNT = "gg_limit_travel_video_count"
    private static let FIELD_LIMIT_TRAVEL_FOOD_COUNT = "gg_limit_travel_food_count"
    private static let FIELD_LIMIT_TRAVEL_MOVIE_COUNT = "gg_limit_travel_movie_count"
    private static let FIELD_LIMIT_TRAVEL_ALBUM_COUNT = "gg_limit_travel_album_count"
    private static let FIELD_LIMIT_TRAVEL_DIARY_COUNT = "gg_limit_travel_diary_count"
    private static let FIELD_LIMIT_WHISPER_CONTENT_LENGTH = "gg_limit_whisper_content_length"
    private static let FIELD_LIMIT_WHISPER_CHANNEL_LENGTH = "gg_limit_whisper_channel_length"
    private static let FIELD_LIMIT_WORD_CONTENT_LENGTH = "gg_limit_word_content_length"
    private static let FIELD_LIMIT_DIARY_CONTENT_LENGTH = "gg_limit_diary_content_length"
    private static let FIELD_LIMIT_ALBUM_TITLE_LENGTH = "gg_limit_album_title_length"
    private static let FIELD_LIMIT_PICTURE_PUSH_COUNT = "gg_limit_picture_push_count"
    private static let FIELD_LIMIT_AUDIO_TITLE_LENGTH = "gg_limit_audio_title_length"
    private static let FIELD_LIMIT_VIDEO_TITLE_LENGTH = "gg_limit_video_title_length"
    private static let FIELD_LIMIT_FOOD_TITLE_LENGTH = "gg_limit_food_title_length"
    private static let FIELD_LIMIT_FOOD_CONTENT_LENGTH = "gg_limit_food_content_length"
    private static let FIELD_LIMIT_TRAVEL_TITLE_LENGTH = "gg_limit_travel_title_length"
    private static let FIELD_LIMIT_TRAVEL_PLACE_CONTENT_LENGTH = "gg_limit_travel_place_content_length"
    private static let FIELD_LIMIT_GIFT_TITLE_LENGTH = "gg_limit_gift_title_length"
    private static let FIELD_LIMIT_PROMISE_CONTENT_LENGTH = "gg_limit_promise_content_length"
    private static let FIELD_LIMIT_PROMISE_BREAK_CONTENT_LENGTH = "gg_limit_promise_break_content_length"
    private static let FIELD_LIMIT_ANGRY_CONTENT_LENGTH = "gg_limit_angry_content_length"
    private static let FIELD_LIMIT_DREAM_CONTENT_LENGTH = "gg_limit_dream_content_length"
    private static let FIELD_LIMIT_AWARD_CONTENT_LENGTH = "gg_limit_award_content_length"
    private static let FIELD_LIMIT_AWARD_RULE_TITLE_LENGTH = "gg_limit_award_rule_title_length"
    private static let FIELD_LIMIT_AWARD_RULE_SCORE_MAX = "gg_limit_award_rule_score_max"
    private static let FIELD_LIMIT_MOVIE_TITLE_LENGTH = "gg_limit_movie_title_length"
    private static let FIELD_LIMIT_MOVIE_CONTENT_LENGTH = "gg_limit_movie_content_length"
    private static let FIELD_LIMIT_POST_TITLE_LENGTH = "gg_limit_post_title_length"
    private static let FIELD_LIMIT_POST_CONTENT_LENGTH = "gg_limit_post_content_length"
    private static let FIELD_LIMIT_POST_SCREEN_REPORT_COUNT = "gg_limit_post_screen_report_count"
    private static let FIELD_LIMIT_POST_COMMENT_CONTENT_LENGTH = "gg_limit_post_comment_content_length"
    private static let FIELD_LIMIT_POST_COMMENT_SCREEN_REPORT_COUNT = "gg_limit_post_comment_screen_report_count"
    private static let FIELD_LIMIT_PAY_VIP_GOODS_1_TITLE = "gg_limit_pay_vip_goods_1_title"
    private static let FIELD_LIMIT_PAY_VIP_GOODS_1_DAYS = "gg_limit_pay_vip_goods_1_days"
    private static let FIELD_LIMIT_PAY_VIP_GOODS_1_AMOUNT = "gg_limit_pay_vip_goods_1_amount"
    private static let FIELD_LIMIT_PAY_VIP_GOODS_2_TITLE = "gg_limit_pay_vip_goods_2_title"
    private static let FIELD_LIMIT_PAY_VIP_GOODS_2_DAYS = "gg_limit_pay_vip_goods_2_days"
    private static let FIELD_LIMIT_PAY_VIP_GOODS_2_AMOUNT = "gg_limit_pay_vip_goods_2_amount"
    private static let FIELD_LIMIT_PAY_VIP_GOODS_3_TITLE = "gg_limit_pay_vip_goods_3_title"
    private static let FIELD_LIMIT_PAY_VIP_GOODS_3_DAYS = "gg_limit_pay_vip_goods_3_days"
    private static let FIELD_LIMIT_PAY_VIP_GOODS_3_AMOUNT = "gg_limit_pay_vip_goods_3_amount"
    private static let FIELD_LIMIT_PAY_COIN_GOODS_1_TITLE = "gg_limit_pay_coin_goods_1_title"
    private static let FIELD_LIMIT_PAY_COIN_GOODS_1_COUNT = "gg_limit_pay_coin_goods_1_count"
    private static let FIELD_LIMIT_PAY_COIN_GOODS_1_AMOUNT = "gg_limit_pay_coin_goods_1_amount"
    private static let FIELD_LIMIT_PAY_COIN_GOODS_2_TITLE = "gg_limit_pay_coin_goods_2_title"
    private static let FIELD_LIMIT_PAY_COIN_GOODS_2_COUNT = "gg_limit_pay_coin_goods_2_count"
    private static let FIELD_LIMIT_PAY_COIN_GOODS_2_AMOUNT = "gg_limit_pay_coin_goods_2_amount"
    private static let FIELD_LIMIT_PAY_COIN_GOODS_3_TITLE = "gg_limit_pay_coin_goods_3_title"
    private static let FIELD_LIMIT_PAY_COIN_GOODS_3_COUNT = "gg_limit_pay_coin_goods_3_count"
    private static let FIELD_LIMIT_PAY_COIN_GOODS_3_AMOUNT = "gg_limit_pay_coin_goods_3_amount"
    private static let FIELD_LIMIT_COIN_SIGN_MIN_COUNT = "gg_limit_coin_sign_min_count"
    private static let FIELD_LIMIT_COIN_SIGN_MAX_COUNT = "gg_limit_coin_sign_max_count"
    private static let FIELD_LIMIT_COIN_SIGN_INCREASE_COUNT = "gg_limit_coin_sign_increase_count"
    private static let FIELD_LIMIT_MATCH_WORK_SCREEN_REPORT_COUNT = "gg_limit_match_work_screen_report_count"
    private static let FIELD_LIMIT_COIN_AD_BETWEEN_SEC = "gg_limit_coin_ad_between_sec"
    private static let FIELD_LIMIT_COIN_AD_WATCH_COUNT = "gg_limit_coin_ad_watch_count"
    private static let FIELD_LIMIT_COIN_AD_CLICK_COUNT = "gg_limit_coin_ad_click_count"
    private static let FIELD_LIMIT_COIN_AD_MAX_PER_DAY_COUNT = "gg_limit_coin_ad_max_per_day_count"
    private static let FIELD_LIMIT_MATCH_WORK_TITLE_LENGTH = "gg_limit_match_work_title_length"
    private static let FIELD_LIMIT_MATCH_WORK_CONTENT_LENGTH = "gg_limit_match_work_content_length"
    // vipLimit
    private static let FIELD_VIP_LIMIT_ADVERTISE_HIDE = "gg_vip_limit_advertise_hide"
    private static let FIELD_VIP_LIMIT_WALL_PAPER_SIZE = "gg_vip_limit_wall_paper_size"
    private static let FIELD_VIP_LIMIT_WALL_PAPER_COUNT = "gg_vip_limit_wall_paper_count"
    private static let FIELD_VIP_LIMIT_TRENDS_TOTAL_ENABLE = "gg_vip_limit_note_total_enable"
    private static let FIELD_VIP_LIMIT_SOUVENIR_COUNT = "gg_vip_limit_souvenir_count"
    private static let FIELD_VIP_LIMIT_WHISPER_IMG_ENABLE = "gg_vip_limit_whisper_image_enable"
    private static let FIELD_VIP_LIMIT_MOVIE_IMG_COUNT = "gg_vip_limit_movie_image_count"
    private static let FIELD_VIP_LIMIT_FOOD_IMG_COUNT = "gg_vip_limit_food_image_count"
    private static let FIELD_VIP_LIMIT_GIFT_IMG_COUNT = "gg_vip_limit_gift_image_count"
    private static let FIELD_VIP_LIMIT_DIARY_IMG_SIZE = "gg_vip_limit_diary_image_size"
    private static let FIELD_VIP_LIMIT_DIARY_IMG_COUNT = "gg_vip_limit_diary_image_count"
    private static let FIELD_VIP_LIMIT_PICTURE_ORIGINAL = "gg_vip_limit_picture_original"
    private static let FIELD_VIP_LIMIT_PICTURE_TOTAL_COUNT = "gg_vip_limit_picture_total_count"
    private static let FIELD_VIP_LIMIT_AUDIO_SIZE = "gg_vip_limit_audio_size"
    private static let FIELD_VIP_LIMIT_VIDEO_SIZE = "gg_vip_limit_video_size"
    private static let FIELD_VIP_LIMIT_PICTURE_SIZE = "gg_vip_limit_picture_size"
    private static let FIELD_VIP_LIMIT_TOPIC_POST_IMAGE_COUNT = "gg_vip_limit_topic_post_image_count"
    // me
    private static let FIELD_ME_USER_ID = "gg_me_user_id"
    private static let FIELD_ME_USER_PHONE = "gg_me_user_phone"
    private static let FIELD_ME_USER_SEX = "gg_me_user_sex"
    private static let FIELD_ME_USER_BIRTHDAY = "gg_me_user_birthday"
    private static let FIELD_ME_USER_TOKEN = "gg_me_user_token"
    // ta
    private static let FIELD_TA_USER_ID = "gg_ta_user_id"
    private static let FIELD_TA_USER_PHONE = "gg_ta_user_phone"
    private static let FIELD_TA_USER_SEX = "gg_ta_user_sex"
    private static let FIELD_TA_USER_BIRTHDAY = "gg_ta_birthday"
    // couple
    private static let FIELD_CP_ID = "gg_couple_id"
    private static let FIELD_CP_CREATE_AT = "gg_couple_create_at"
    private static let FIELD_CP_UPDATE_AT = "gg_couple_update_at"
    private static let FIELD_CP_CREATOR_ID = "gg_couple_creator_id"
    private static let FIELD_CP_CREATOR_NAME = "gg_couple_creator_name"
    private static let FIELD_CP_CREATOR_AVATAR = "gg_couple_creator_avatar"
    private static let FIELD_CP_INVITEE_ID = "gg_couple_invitee_id"
    private static let FIELD_CP_INVITEE_NAME = "gg_couple_invitee_name"
    private static let FIELD_CP_INVITEE_AVATAR = "gg_couple_invitee_avatar"
    private static let FIELD_CP_TOGETHER_AT = "gg_couple_together_at"
    private static let FIELD_CP_STATE_ID = "gg_couple_state_id"
    private static let FIELD_CP_STATE_CREATE_AT = "gg_couple_state_create_at"
    private static let FIELD_CP_STATE_UPDATE_AT = "gg_couple_state_update_at"
    private static let FIELD_CP_STATE_USER_ID = "gg_couple_state_user_id"
    private static let FIELD_CP_STATE_STATE = "gg_couple_state_state"
    // wallPaper
    private static let FIELD_WALL_PAPER_IMAGES = "gg_wall_paper_images"
    // draft
    private static let FIELD_DRAFT_DIARY_CONTENT_TEXT = "gg_draft_diary_content_text"
    private static let FIELD_DRAFT_DREAM_CONTENT_TEXT = "gg_draft_dream_content_text"
    private static let FIELD_DRAFT_POST_TITLE = "gg_draft_post_title"
    private static let FIELD_DRAFT_POST_CONTENT_TEXT = "gg_draft_post_content_text"
    
    /**
     * ***********************************清除***********************************
     */
    public static func clearAll() {
        clearCommonCount()
        clearOssInfo()
        clearVipLimit()
        clearMe()
        clearTa()
        clearCouple()
        clearWallPaper()
        clearDraft()
    }
    
    public static func clearCommonCount() {
        UB.removeObject(forKey: FIELD_COMMON_COUNT_VERSION_NEW_COUNT)
        UB.removeObject(forKey: FIELD_COMMON_COUNT_NOTICE_NEW_COUNT)
        UB.removeObject(forKey: FIELD_COMMON_COUNT_NOTE_TRENDS_NEW_COUNT)
        UB.removeObject(forKey: FIELD_COMMON_COUNT_TOPIC_MSG_NEW_COUNT)
    }
    
    public static func clearOssInfo() {
        UB.removeObject(forKey: FIELD_OSS_SECURITY_TOKEN)
        UB.removeObject(forKey: FIELD_OSS_KEY_ID)
        UB.removeObject(forKey: FIELD_OSS_KEY_SECRET)
        UB.removeObject(forKey: FIELD_OSS_REGION)
        UB.removeObject(forKey: FIELD_OSS_DOMAIN)
        UB.removeObject(forKey: FIELD_OSS_BUCKET)
        UB.removeObject(forKey: FIELD_OSS_STS_EXPIRE_TIME)
        UB.removeObject(forKey: FIELD_OSS_OSS_REFRESH_SEC)
        UB.removeObject(forKey: FIELD_OSS_URL_EXPIRE_SEC)
        UB.removeObject(forKey: FIELD_OSS_PATH_LOG)
        UB.removeObject(forKey: FIELD_OSS_PATH_SUGGEST)
        UB.removeObject(forKey: FIELD_OSS_PATH_COUPLE_AVATAR)
        UB.removeObject(forKey: FIELD_OSS_PATH_COUPLE_WALL)
        UB.removeObject(forKey: FIELD_OSS_PATH_NOTE_WHISPER)
        UB.removeObject(forKey: FIELD_OSS_PATH_NOTE_DIARY)
        UB.removeObject(forKey: FIELD_OSS_PATH_NOTE_ALBUM)
        UB.removeObject(forKey: FIELD_OSS_PATH_NOTE_PICTURE)
        UB.removeObject(forKey: FIELD_OSS_PATH_NOTE_AUDIO)
        UB.removeObject(forKey: FIELD_OSS_PATH_NOTE_VIDEO)
        UB.removeObject(forKey: FIELD_OSS_PATH_NOTE_VIDEO_THUMB)
        UB.removeObject(forKey: FIELD_OSS_PATH_NOTE_FOOD)
        UB.removeObject(forKey: FIELD_OSS_PATH_NOTE_GIFT)
        UB.removeObject(forKey: FIELD_OSS_PATH_NOTE_MOVIE)
        UB.removeObject(forKey: FIELD_OSS_PATH_TOPIC_POST)
        UB.removeObject(forKey: FIELD_OSS_PATH_MORE_MATCH)
    }
    
    public static func clearVipLimit() {
        UB.removeObject(forKey: FIELD_VIP_LIMIT_ADVERTISE_HIDE)
        UB.removeObject(forKey: FIELD_VIP_LIMIT_WALL_PAPER_SIZE)
        UB.removeObject(forKey: FIELD_VIP_LIMIT_WALL_PAPER_COUNT)
        UB.removeObject(forKey: FIELD_VIP_LIMIT_TRENDS_TOTAL_ENABLE)
        UB.removeObject(forKey: FIELD_VIP_LIMIT_SOUVENIR_COUNT)
        UB.removeObject(forKey: FIELD_VIP_LIMIT_WHISPER_IMG_ENABLE)
        UB.removeObject(forKey: FIELD_VIP_LIMIT_MOVIE_IMG_COUNT)
        UB.removeObject(forKey: FIELD_VIP_LIMIT_FOOD_IMG_COUNT)
        UB.removeObject(forKey: FIELD_VIP_LIMIT_GIFT_IMG_COUNT)
        UB.removeObject(forKey: FIELD_VIP_LIMIT_DIARY_IMG_SIZE)
        UB.removeObject(forKey: FIELD_VIP_LIMIT_DIARY_IMG_COUNT)
        UB.removeObject(forKey: FIELD_VIP_LIMIT_PICTURE_ORIGINAL)
        UB.removeObject(forKey: FIELD_VIP_LIMIT_PICTURE_TOTAL_COUNT)
        UB.removeObject(forKey: FIELD_VIP_LIMIT_AUDIO_SIZE)
        UB.removeObject(forKey: FIELD_VIP_LIMIT_VIDEO_SIZE)
        UB.removeObject(forKey: FIELD_VIP_LIMIT_PICTURE_SIZE)
        UB.removeObject(forKey: FIELD_VIP_LIMIT_TOPIC_POST_IMAGE_COUNT)
    }
    
    public static func clearMe() {
        UB.removeObject(forKey: FIELD_ME_USER_ID)
        UB.removeObject(forKey: FIELD_ME_USER_PHONE)
        UB.removeObject(forKey: FIELD_ME_USER_SEX)
        UB.removeObject(forKey: FIELD_ME_USER_BIRTHDAY)
        UB.removeObject(forKey: FIELD_ME_USER_TOKEN)
    }
    
    public static func clearTa() {
        UB.removeObject(forKey: FIELD_TA_USER_ID)
        UB.removeObject(forKey: FIELD_TA_USER_PHONE)
        UB.removeObject(forKey: FIELD_TA_USER_SEX)
        UB.removeObject(forKey: FIELD_TA_USER_BIRTHDAY)
    }
    
    public static func clearCouple() {
        UB.removeObject(forKey: FIELD_CP_ID)
        UB.removeObject(forKey: FIELD_CP_CREATE_AT)
        UB.removeObject(forKey: FIELD_CP_UPDATE_AT)
        UB.removeObject(forKey: FIELD_CP_CREATOR_ID)
        UB.removeObject(forKey: FIELD_CP_CREATOR_NAME)
        UB.removeObject(forKey: FIELD_CP_CREATOR_AVATAR)
        UB.removeObject(forKey: FIELD_CP_INVITEE_ID)
        UB.removeObject(forKey: FIELD_CP_INVITEE_NAME)
        UB.removeObject(forKey: FIELD_CP_INVITEE_AVATAR)
        UB.removeObject(forKey: FIELD_CP_TOGETHER_AT)
        UB.removeObject(forKey: FIELD_CP_STATE_ID)
        UB.removeObject(forKey: FIELD_CP_STATE_CREATE_AT)
        UB.removeObject(forKey: FIELD_CP_STATE_UPDATE_AT)
        UB.removeObject(forKey: FIELD_CP_STATE_USER_ID)
        UB.removeObject(forKey: FIELD_CP_STATE_STATE)
    }
    
    public static func clearWallPaper() {
        UB.removeObject(forKey: FIELD_WALL_PAPER_IMAGES)
    }
    
    public static func clearDraft() {
        UB.removeObject(forKey: FIELD_DRAFT_DIARY_CONTENT_TEXT)
        UB.removeObject(forKey: FIELD_DRAFT_DREAM_CONTENT_TEXT)
        UB.removeObject(forKey: FIELD_DRAFT_POST_TITLE)
        UB.removeObject(forKey: FIELD_DRAFT_POST_CONTENT_TEXT)
    }
    
    /**
     * ***********************************Common***********************************
     */
    public static func setTheme(_ theme: Int) {
        UB.set(theme, forKey: FIELD_COMMON_THEME)
    }
    
    public static func getTheme() -> Int {
        return UB.integer(forKey: FIELD_COMMON_THEME)
    }
    
    public static func setSettingsNoticeSystem(_ open: Bool) {
        UB.set(open ? 1 : 2, forKey: FIELD_COMMON_NOTICE_SYSTEM)
    }
    
    public static func getSettingsNoticeSystem() -> Bool {
        return UB.integer(forKey: FIELD_COMMON_NOTICE_SYSTEM) != 2
    }
    
    public static func setSettingsNoticeSocial(_ open: Bool) {
        UB.set(open ? 1 : 2, forKey: FIELD_COMMON_NOTICE_SOCIAL)
    }
    
    public static func getSettingsNoticeSocial() -> Bool {
        return UB.integer(forKey: FIELD_COMMON_NOTICE_SOCIAL) != 2
    }
    
    public static func setSettingsNoticeDisturb(_ open: Bool) {
        UB.set(open ? 1 : 2, forKey: FIELD_COMMON_NOTICE_DISTURB)
    }
    
    public static func getSettingsNoticeDisturb() -> Bool {
        return UB.integer(forKey: FIELD_COMMON_NOTICE_DISTURB) != 2
    }
    
    /**
     * ***********************************ModelShow***********************************
     */
    public static func setModelShow(_ modelShow: ModelShow?) {
        if modelShow == nil {
            LogUtils.i(tag: "UDHelper", method: "setModelShow", "modelShow == nil");
            return
        }
        UB.set(1, forKey: FIELD_MODEL_SHOW)
        UB.set(modelShow!.marketPay, forKey: FIELD_MODEL_SHOW_MARKET_PAY)
        UB.set(modelShow!.marketCoinAd, forKey: FIELD_MODEL_SHOW_MARKET_COIN_AD)
        UB.set(modelShow!.couple, forKey: FIELD_MODEL_SHOW_COUPLE)
        UB.set(modelShow!.couplePlace, forKey: FIELD_MODEL_SHOW_COUPLE_PLACE)
        UB.set(modelShow!.coupleWeather, forKey: FIELD_MODEL_SHOW_COUPLE_WEATHER)
        UB.set(modelShow!.note, forKey: FIELD_MODEL_SHOW_NOTE)
        UB.set(modelShow!.topic, forKey: FIELD_MODEL_SHOW_TOPIC)
        UB.set(modelShow!.more, forKey: FIELD_MODEL_SHOW_MORE)
        UB.set(modelShow!.moreVip, forKey: FIELD_MODEL_SHOW_MORE_VIP)
        UB.set(modelShow!.moreCoin, forKey: FIELD_MODEL_SHOW_MORE_COIN)
        UB.set(modelShow!.moreMatch, forKey: FIELD_MODEL_SHOW_MORE_MATCH)
        UB.set(modelShow!.moreFeature, forKey: FIELD_MODEL_SHOW_MORE_FEATURE)
    }
    
    public static func getModelShow() -> ModelShow {
        let modelShow = ModelShow()
        if UB.integer(forKey: FIELD_MODEL_SHOW) != 1 {
            return modelShow
        }
        modelShow.marketPay = UB.bool(forKey: FIELD_MODEL_SHOW_MARKET_PAY)
        modelShow.marketCoinAd = UB.bool(forKey: FIELD_MODEL_SHOW_MARKET_COIN_AD)
        modelShow.couple = UB.bool(forKey: FIELD_MODEL_SHOW_COUPLE)
        modelShow.couplePlace = UB.bool(forKey: FIELD_MODEL_SHOW_COUPLE_PLACE)
        modelShow.coupleWeather = UB.bool(forKey: FIELD_MODEL_SHOW_COUPLE_WEATHER)
        modelShow.note = UB.bool(forKey: FIELD_MODEL_SHOW_NOTE)
        modelShow.topic = UB.bool(forKey: FIELD_MODEL_SHOW_TOPIC)
        modelShow.more = UB.bool(forKey: FIELD_MODEL_SHOW_MORE)
        modelShow.moreVip = UB.bool(forKey: FIELD_MODEL_SHOW_MORE_VIP)
        modelShow.moreCoin = UB.bool(forKey: FIELD_MODEL_SHOW_MORE_COIN)
        modelShow.moreMatch = UB.bool(forKey: FIELD_MODEL_SHOW_MORE_MATCH)
        modelShow.moreFeature = UB.bool(forKey: FIELD_MODEL_SHOW_MORE_FEATURE)
        return modelShow
    }
    
    /**
     * ***********************************NoteCustom***********************************
     */
    public static func setNoteCustom(_ noteCustom: NoteCustom?) {
        if noteCustom == nil {
            LogUtils.i(tag: "UDHelper", method: "setNoteCustom", "noteCustom == nil");
            return
        }
        UB.set(1, forKey: FIELD_NOTE_CUSTOM)
        UB.set(noteCustom!.souvenir, forKey: FIELD_NOTE_CUSTOM_SOUVENIR)
        UB.set(noteCustom!.shy, forKey: FIELD_NOTE_CUSTOM_SHY)
        UB.set(noteCustom!.menses, forKey: FIELD_NOTE_CUSTOM_MENSES)
        UB.set(noteCustom!.sleep, forKey: FIELD_NOTE_CUSTOM_SLEEP)
        UB.set(noteCustom!.word, forKey: FIELD_NOTE_CUSTOM_WORD)
        UB.set(noteCustom!.whisper, forKey: FIELD_NOTE_CUSTOM_WHISPER)
        UB.set(noteCustom!.award, forKey: FIELD_NOTE_CUSTOM_AWARD)
        UB.set(noteCustom!.diary, forKey: FIELD_NOTE_CUSTOM_DIARY)
        UB.set(noteCustom!.dream, forKey: FIELD_NOTE_CUSTOM_DREAM)
        UB.set(noteCustom!.food, forKey: FIELD_NOTE_CUSTOM_FOOD)
        UB.set(noteCustom!.movie, forKey: FIELD_NOTE_CUSTOM_MOVIE)
        UB.set(noteCustom!.travel, forKey: FIELD_NOTE_CUSTOM_TRAVEL)
        UB.set(noteCustom!.angry, forKey: FIELD_NOTE_CUSTOM_ANGRY)
        UB.set(noteCustom!.gift, forKey: FIELD_NOTE_CUSTOM_GIFT)
        UB.set(noteCustom!.promise, forKey: FIELD_NOTE_CUSTOM_PROMISE)
        UB.set(noteCustom!.audio, forKey: FIELD_NOTE_CUSTOM_AUDIO)
        UB.set(noteCustom!.video, forKey: FIELD_NOTE_CUSTOM_VIDEO)
        UB.set(noteCustom!.album, forKey: FIELD_NOTE_CUSTOM_ALBUM)
        UB.set(noteCustom!.total, forKey: FIELD_NOTE_CUSTOM_TOTAL)
        UB.set(noteCustom!.trends, forKey: FIELD_NOTE_CUSTOM_TRENDS)
        UB.set(noteCustom!.custom, forKey: FIELD_NOTE_CUSTOM_CUSTOM)
    }
    
    public static func getNoteCustom() -> NoteCustom {
        let noteCustom = NoteCustom()
        if UB.integer(forKey: FIELD_NOTE_CUSTOM) != 1 {
            return noteCustom
        }
        noteCustom.souvenir = UB.bool(forKey: FIELD_NOTE_CUSTOM_SOUVENIR)
        noteCustom.shy = UB.bool(forKey: FIELD_NOTE_CUSTOM_SHY)
        noteCustom.menses = UB.bool(forKey: FIELD_NOTE_CUSTOM_MENSES)
        noteCustom.sleep = UB.bool(forKey: FIELD_NOTE_CUSTOM_SLEEP)
        noteCustom.word = UB.bool(forKey: FIELD_NOTE_CUSTOM_WORD)
        noteCustom.whisper = UB.bool(forKey: FIELD_NOTE_CUSTOM_WHISPER)
        noteCustom.award = UB.bool(forKey: FIELD_NOTE_CUSTOM_AWARD)
        noteCustom.diary = UB.bool(forKey: FIELD_NOTE_CUSTOM_DIARY)
        noteCustom.dream = UB.bool(forKey: FIELD_NOTE_CUSTOM_DREAM)
        noteCustom.food = UB.bool(forKey: FIELD_NOTE_CUSTOM_FOOD)
        noteCustom.movie = UB.bool(forKey: FIELD_NOTE_CUSTOM_MOVIE)
        noteCustom.travel = UB.bool(forKey: FIELD_NOTE_CUSTOM_TRAVEL)
        noteCustom.angry = UB.bool(forKey: FIELD_NOTE_CUSTOM_ANGRY)
        noteCustom.gift = UB.bool(forKey: FIELD_NOTE_CUSTOM_GIFT)
        noteCustom.promise = UB.bool(forKey: FIELD_NOTE_CUSTOM_PROMISE)
        noteCustom.audio = UB.bool(forKey: FIELD_NOTE_CUSTOM_AUDIO)
        noteCustom.video = UB.bool(forKey: FIELD_NOTE_CUSTOM_VIDEO)
        noteCustom.album = UB.bool(forKey: FIELD_NOTE_CUSTOM_ALBUM)
        noteCustom.total = UB.bool(forKey: FIELD_NOTE_CUSTOM_TOTAL)
        noteCustom.trends = UB.bool(forKey: FIELD_NOTE_CUSTOM_TRENDS)
        noteCustom.custom = UB.bool(forKey: FIELD_NOTE_CUSTOM_CUSTOM)
        return noteCustom
    }
    
    /**
     * ***********************************CommonConst***********************************
     */
    public static func setCommonConst(_ commonConst: CommonConst?) {
        if commonConst == nil {
            LogUtils.i(tag: "UDHelper", method: "setCommonConst", "commonConst == nil");
            return
        }
        UB.set(commonConst!.companyName, forKey: FIELD_COMMON_CONST_COMPANY_NAME)
        UB.set(commonConst!.customerQQ, forKey: FIELD_COMMON_CONST_CUSTOMER_QQ)
        UB.set(commonConst!.officialGroup, forKey: FIELD_COMMON_CONST_OFFICIAL_GROUP)
        UB.set(commonConst!.officialWeibo, forKey: FIELD_COMMON_CONST_OFFICIAL_WEIBO)
        UB.set(commonConst!.officialWeb, forKey: FIELD_COMMON_CONST_OFFICIAL_WEB)
        UB.set(commonConst!.contactEmail, forKey: FIELD_COMMON_CONST_CONTACT_EMAIL)
        UB.set(commonConst!.iosAppId, forKey: FIELD_COMMON_CONST_IOS_APP_ID)
    }
    
    public static func getCommonConst() -> CommonConst {
        let commonConst = CommonConst()
        commonConst.companyName = UB.string(forKey: FIELD_COMMON_CONST_COMPANY_NAME) ?? commonConst.companyName
        commonConst.customerQQ = UB.string(forKey: FIELD_COMMON_CONST_CUSTOMER_QQ) ?? commonConst.customerQQ
        commonConst.officialGroup = UB.string(forKey: FIELD_COMMON_CONST_OFFICIAL_GROUP) ?? commonConst.officialGroup
        commonConst.officialWeibo = UB.string(forKey: FIELD_COMMON_CONST_OFFICIAL_WEIBO) ?? commonConst.officialWeibo
        commonConst.officialWeb = UB.string(forKey: FIELD_COMMON_CONST_OFFICIAL_WEB) ?? commonConst.officialWeb
        commonConst.contactEmail = UB.string(forKey: FIELD_COMMON_CONST_CONTACT_EMAIL) ?? commonConst.contactEmail
        commonConst.iosAppId = UB.string(forKey: FIELD_COMMON_CONST_IOS_APP_ID) ?? commonConst.iosAppId
        return commonConst
    }
    
    /**
     * ***********************************CommonCount***********************************
     */
    public static func setCommonCount(_ commonCount: CommonCount?) {
        if commonCount == nil {
            LogUtils.i(tag: "UDHelper", method: "setCommonCount", "commonCount == nil");
            return
        }
        UB.set(commonCount!.noticeNewCount, forKey: FIELD_COMMON_COUNT_NOTICE_NEW_COUNT)
        UB.set(commonCount!.versionNewCount, forKey: FIELD_COMMON_COUNT_VERSION_NEW_COUNT)
        UB.set(commonCount!.noteTrendsNewCount, forKey: FIELD_COMMON_COUNT_NOTE_TRENDS_NEW_COUNT)
        UB.set(commonCount!.topicMsgNewCount, forKey: FIELD_COMMON_COUNT_TOPIC_MSG_NEW_COUNT)
    }
    
    public static func getCommonCount() -> CommonCount {
        let commonCount = CommonCount()
        commonCount.noticeNewCount = UB.integer(forKey: FIELD_COMMON_COUNT_NOTICE_NEW_COUNT)
        commonCount.versionNewCount = UB.integer(forKey: FIELD_COMMON_COUNT_VERSION_NEW_COUNT)
        commonCount.noteTrendsNewCount = UB.integer(forKey: FIELD_COMMON_COUNT_NOTE_TRENDS_NEW_COUNT)
        commonCount.topicMsgNewCount = UB.integer(forKey: FIELD_COMMON_COUNT_TOPIC_MSG_NEW_COUNT)
        return commonCount
    }
    
    /**
     * ***********************************OssInfo***********************************
     */
    public static func setOssInfo(_ oss: OssInfo?) {
        clearOssInfo()
        if oss == nil {
            LogUtils.i(tag: "UDHelper", method: "setOssInfo", "oss == nil");
            return
        }
        UB.set(oss!.securityToken, forKey: FIELD_OSS_SECURITY_TOKEN)
        UB.set(oss!.accessKeyId, forKey: FIELD_OSS_KEY_ID)
        UB.set(oss!.accessKeySecret, forKey: FIELD_OSS_KEY_SECRET)
        UB.set(oss!.region, forKey: FIELD_OSS_REGION)
        UB.set(oss!.domain, forKey: FIELD_OSS_DOMAIN)
        UB.set(oss!.bucket, forKey: FIELD_OSS_BUCKET)
        UB.set(oss!.stsExpireTime, forKey: FIELD_OSS_STS_EXPIRE_TIME)
        UB.set(oss!.ossRefreshSec, forKey: FIELD_OSS_OSS_REFRESH_SEC)
        UB.set(oss!.urlExpireSec, forKey: FIELD_OSS_URL_EXPIRE_SEC)
        UB.set(oss!.pathLog, forKey: FIELD_OSS_PATH_LOG)
        UB.set(oss!.pathSuggest, forKey: FIELD_OSS_PATH_SUGGEST)
        UB.set(oss!.pathCoupleAvatar, forKey: FIELD_OSS_PATH_COUPLE_AVATAR)
        UB.set(oss!.pathCoupleWall, forKey: FIELD_OSS_PATH_COUPLE_WALL)
        UB.set(oss!.pathNoteWhisper, forKey: FIELD_OSS_PATH_NOTE_WHISPER)
        UB.set(oss!.pathNoteDiary, forKey: FIELD_OSS_PATH_NOTE_DIARY)
        UB.set(oss!.pathNoteAlbum, forKey: FIELD_OSS_PATH_NOTE_ALBUM)
        UB.set(oss!.pathNotePicture, forKey: FIELD_OSS_PATH_NOTE_PICTURE)
        UB.set(oss!.pathNoteAudio, forKey: FIELD_OSS_PATH_NOTE_AUDIO)
        UB.set(oss!.pathNoteVideo, forKey: FIELD_OSS_PATH_NOTE_VIDEO)
        UB.set(oss!.pathNoteVideoThumb, forKey: FIELD_OSS_PATH_NOTE_VIDEO_THUMB)
        UB.set(oss!.pathNoteFood, forKey: FIELD_OSS_PATH_NOTE_FOOD)
        UB.set(oss!.pathNoteGift, forKey: FIELD_OSS_PATH_NOTE_GIFT)
        UB.set(oss!.pathNoteMovie, forKey: FIELD_OSS_PATH_NOTE_MOVIE)
        UB.set(oss!.pathTopicPost, forKey: FIELD_OSS_PATH_TOPIC_POST)
        UB.set(oss!.pathMoreMatch, forKey: FIELD_OSS_PATH_MORE_MATCH)
    }
    
    public static func getOssInfo() -> OssInfo {
        let oss = OssInfo()
        oss.securityToken = UB.string(forKey: FIELD_OSS_SECURITY_TOKEN) ?? oss.securityToken
        oss.accessKeyId = UB.string(forKey: FIELD_OSS_KEY_ID) ?? oss.accessKeyId
        oss.accessKeySecret = UB.string(forKey: FIELD_OSS_KEY_SECRET) ?? oss.accessKeySecret
        oss.region = UB.string(forKey: FIELD_OSS_REGION) ?? oss.region
        oss.domain = UB.string(forKey: FIELD_OSS_DOMAIN) ?? oss.domain
        oss.bucket = UB.string(forKey: FIELD_OSS_BUCKET) ?? oss.bucket
        oss.stsExpireTime = (UB.object(forKey: FIELD_OSS_STS_EXPIRE_TIME) as? Int64) ?? oss.stsExpireTime
        oss.ossRefreshSec = (UB.object(forKey: FIELD_OSS_OSS_REFRESH_SEC) as? Int64) ?? oss.ossRefreshSec
        oss.urlExpireSec = (UB.object(forKey: FIELD_OSS_URL_EXPIRE_SEC) as? Int64) ?? oss.urlExpireSec
        oss.pathLog = UB.string(forKey: FIELD_OSS_PATH_LOG) ?? oss.pathLog
        oss.pathSuggest = UB.string(forKey: FIELD_OSS_PATH_SUGGEST) ?? oss.pathSuggest
        oss.pathCoupleAvatar = UB.string(forKey: FIELD_OSS_PATH_COUPLE_AVATAR) ?? oss.pathCoupleAvatar
        oss.pathCoupleWall = UB.string(forKey: FIELD_OSS_PATH_COUPLE_WALL) ?? oss.pathCoupleWall
        oss.pathNoteWhisper = UB.string(forKey: FIELD_OSS_PATH_NOTE_WHISPER) ?? oss.pathNoteWhisper
        oss.pathNoteDiary = UB.string(forKey: FIELD_OSS_PATH_NOTE_DIARY) ?? oss.pathNoteDiary
        oss.pathNoteAlbum = UB.string(forKey: FIELD_OSS_PATH_NOTE_ALBUM) ?? oss.pathNoteAlbum
        oss.pathNotePicture = UB.string(forKey: FIELD_OSS_PATH_NOTE_PICTURE) ?? oss.pathNotePicture
        oss.pathNoteAudio = UB.string(forKey: FIELD_OSS_PATH_NOTE_AUDIO) ?? oss.pathNoteAudio
        oss.pathNoteVideo = UB.string(forKey: FIELD_OSS_PATH_NOTE_VIDEO) ?? oss.pathNoteVideo
        oss.pathNoteVideoThumb = UB.string(forKey: FIELD_OSS_PATH_NOTE_VIDEO_THUMB) ?? oss.pathNoteVideoThumb
        oss.pathNoteFood = UB.string(forKey: FIELD_OSS_PATH_NOTE_FOOD) ?? oss.pathNoteFood
        oss.pathNoteGift = UB.string(forKey: FIELD_OSS_PATH_NOTE_GIFT) ?? oss.pathNoteGift
        oss.pathNoteMovie = UB.string(forKey: FIELD_OSS_PATH_NOTE_MOVIE) ?? oss.pathNoteMovie
        oss.pathTopicPost = UB.string(forKey: FIELD_OSS_PATH_TOPIC_POST) ?? oss.pathTopicPost
        oss.pathMoreMatch = UB.string(forKey: FIELD_OSS_PATH_MORE_MATCH) ?? oss.pathMoreMatch
        return oss
    }
    
    /**
     * ***********************************PushInfo***********************************
     */
    public static func setPushInfo(_ pushInfo: PushInfo?) {
        if pushInfo == nil {
            LogUtils.i(tag: "UDHelper", method: "setPushInfo", "pushInfo == nil");
            return
        }
        UB.set(1, forKey: FIELD_PUSH)
        UB.set(pushInfo!.aliAppKey, forKey: FIELD_PUSH_ALI_APP_KEY)
        UB.set(pushInfo!.aliAppSecret, forKey: FIELD_PUSH_ALI_APP_SECRET)
        UB.set(pushInfo!.noticeLight, forKey: FIELD_PUSH_NOTICE_LIGHT)
        UB.set(pushInfo!.noticeSound, forKey: FIELD_PUSH_NOTICE_SOUND)
        UB.set(pushInfo!.noticeVibrate, forKey: FIELD_PUSH_NOTICE_VIBRATE)
        UB.set(pushInfo!.noStartHour, forKey: FIELD_PUSH_NO_START_HOUR)
        UB.set(pushInfo!.noEndHour, forKey: FIELD_PUSH_NO_END_HOUR)
    }
    
    public static func getPushInfo() -> PushInfo {
        let pushInfo = PushInfo()
        if UB.integer(forKey: FIELD_PUSH) != 1 {
            return pushInfo
        }
        pushInfo.aliAppKey = UB.string(forKey: FIELD_PUSH_ALI_APP_KEY) ?? pushInfo.aliAppKey
        pushInfo.aliAppSecret = UB.string(forKey: FIELD_PUSH_ALI_APP_SECRET) ?? pushInfo.aliAppSecret
        pushInfo.noticeLight = UB.bool(forKey: FIELD_PUSH_NOTICE_LIGHT)
        pushInfo.noticeSound = UB.bool(forKey: FIELD_PUSH_NOTICE_SOUND)
        pushInfo.noticeVibrate = UB.bool(forKey: FIELD_PUSH_NOTICE_VIBRATE)
        pushInfo.noStartHour = UB.integer(forKey: FIELD_PUSH_NO_START_HOUR)
        pushInfo.noEndHour = UB.integer(forKey: FIELD_PUSH_NO_END_HOUR)
        return pushInfo
    }
    
    /**
     * ***********************************AdInfo***********************************
     */
    public static func setAdInfo(_ adInfo: AdInfo?) {
        if adInfo == nil {
            LogUtils.i(tag: "UDHelper", method: "setAdInfo", "adInfo == nil");
            return
        }
        UB.set(adInfo!.appId, forKey: FIELD_AD_APP_ID)
        UB.set(adInfo!.topicPostPosId, forKey: FIELD_AD_TOPIC_POST_POS_ID)
        UB.set(adInfo!.topicPostJump, forKey: FIELD_AD_TOPIC_POST_JUMP)
        UB.set(adInfo!.topicPostStart, forKey: FIELD_AD_TOPIC_POST_START)
        UB.set(adInfo!.coinFreePosId, forKey: FIELD_AD_COIN_FREE_POS_ID)
        UB.set(adInfo!.coinFreeTickSec, forKey: FIELD_AD_COIN_FREE_TICK_SEC)
    }
    
    public static func getAdInfo() -> AdInfo {
        let adInfo = AdInfo()
        adInfo.appId = UB.string(forKey: FIELD_AD_APP_ID) ?? adInfo.appId
        adInfo.topicPostPosId = UB.string(forKey: FIELD_AD_TOPIC_POST_POS_ID) ?? adInfo.topicPostPosId
        adInfo.topicPostJump = UB.integer(forKey: FIELD_AD_TOPIC_POST_JUMP) == 0 ? 20 : UB.integer(forKey: FIELD_AD_TOPIC_POST_JUMP)
        adInfo.topicPostStart = UB.integer(forKey: FIELD_AD_TOPIC_POST_START) == 0 ? 10 : UB.integer(forKey: FIELD_AD_TOPIC_POST_START)
        adInfo.coinFreePosId = UB.string(forKey: FIELD_AD_COIN_FREE_POS_ID) ?? adInfo.coinFreePosId
        adInfo.coinFreeTickSec = UB.integer(forKey: FIELD_AD_COIN_FREE_TICK_SEC) == 0 ? 5 : UB.integer(forKey: FIELD_AD_COIN_FREE_TICK_SEC)
        return adInfo
    }
    
    /**
     * ***********************************Limit***********************************
     */
    public static func setLimit(_ limit: Limit?) {
        if limit == nil {
            LogUtils.i(tag: "UDHelper", method: "setLimit", "limit == nil");
            return
        }
        UB.set(limit!.smsCodeLength, forKey: FIELD_LIMIT_SMS_CODE_LENGTH)
        UB.set(limit!.smsBetweenSec, forKey: FIELD_LIMIT_SMS_BETWEEN)
        UB.set(limit!.suggestTitleLength, forKey: FIELD_LIMIT_SUGGEST_TITLE_LENGTH)
        UB.set(limit!.suggestContentLength, forKey: FIELD_LIMIT_SUGGEST_CONTENT_LENGTH)
        UB.set(limit!.suggestCommentContentLength, forKey: FIELD_LIMIT_SUGGEST_COMMENT_CONTENT_LENGTH)
        UB.set(limit!.coupleInviteIntervalSec, forKey: FIELD_LIMIT_COUPLE_INVITE_INTERVAL_SEC)
        UB.set(limit!.coupleBreakNeedSec, forKey: FIELD_LIMIT_COUPLE_BREAK_NEED_SEC)
        UB.set(limit!.coupleBreakSec, forKey: FIELD_LIMIT_COUPLE_BREAK_SEC)
        UB.set(limit!.coupleNameLength, forKey: FIELD_LIMIT_COUPLE_NAME_LENGTH)
        UB.set(limit!.noteResExpireSec, forKey: FIELD_LIMIT_NOTE_OSS_EXPIRE_SECONDS)
        UB.set(limit!.mensesMaxPerMonth, forKey: FIELD_LIMIT_MENSES_MAX_PER_MONTH)
        UB.set(limit!.mensesMaxCycleDay, forKey: FIELD_LIMIT_MENSES_MAX_CYCLE_DAY)
        UB.set(limit!.mensesMaxDurationDay, forKey: FIELD_LIMIT_MENSES_MAX_DURATION_DAY)
        UB.set(limit!.mensesDefaultCycleDay, forKey: FIELD_LIMIT_MENSES_DEFAULT_CYCLE_DAY)
        UB.set(limit!.mensesDefaultDurationDay, forKey: FIELD_LIMIT_MENSES_DEFAULT_DURATION_DAY)
        UB.set(limit!.shyMaxPerDay, forKey: FIELD_LIMIT_SHY_MAX_PER_DAY)
        UB.set(limit!.shySafeLength, forKey: FIELD_LIMIT_SHY_SAFE_LENGTH)
        UB.set(limit!.shyDescLength, forKey: FIELD_LIMIT_SHY_DESC_LENGTH)
        UB.set(limit!.sleepMaxPerDay, forKey: FIELD_LIMIT_SLEEP_MAX_PER_DAY)
        UB.set(limit!.noteSleepSuccessMinSec, forKey: FIELD_LIMIT_NOTE_SLEEP_SUCCESS_MIN_SEC)
        UB.set(limit!.noteSleepSuccessMaxSec, forKey: FIELD_LIMIT_NOTE_SLEEP_SUCCESS_MAX_SEC)
        UB.set(limit!.noteLockLength, forKey: FIELD_LIMIT_NOTE_LOCK_LENGTH)
        UB.set(limit!.souvenirTitleLength, forKey: FIELD_LIMIT_SOUVENIR_TITLE_LENGTH)
        UB.set(limit!.souvenirForeignYearCount, forKey: FIELD_LIMIT_SOUVENIR_FOREIGN_YEAR_COUNT)
        UB.set(limit!.travelPlaceCount, forKey: FIELD_LIMIT_TRAVEL_PLACE_COUNT)
        UB.set(limit!.travelVideoCount, forKey: FIELD_LIMIT_TRAVEL_VIDEO_COUNT)
        UB.set(limit!.travelFoodCount, forKey: FIELD_LIMIT_TRAVEL_FOOD_COUNT)
        UB.set(limit!.travelMovieCount, forKey: FIELD_LIMIT_TRAVEL_MOVIE_COUNT)
        UB.set(limit!.travelAlbumCount, forKey: FIELD_LIMIT_TRAVEL_ALBUM_COUNT)
        UB.set(limit!.travelDiaryCount, forKey: FIELD_LIMIT_TRAVEL_DIARY_COUNT)
        UB.set(limit!.whisperContentLength, forKey: FIELD_LIMIT_WHISPER_CONTENT_LENGTH)
        UB.set(limit!.whisperChannelLength, forKey: FIELD_LIMIT_WHISPER_CHANNEL_LENGTH)
        UB.set(limit!.wordContentLength, forKey: FIELD_LIMIT_WORD_CONTENT_LENGTH)
        UB.set(limit!.diaryContentLength, forKey: FIELD_LIMIT_DIARY_CONTENT_LENGTH)
        UB.set(limit!.albumTitleLength, forKey: FIELD_LIMIT_ALBUM_TITLE_LENGTH)
        UB.set(limit!.picturePushCount, forKey: FIELD_LIMIT_PICTURE_PUSH_COUNT)
        UB.set(limit!.audioTitleLength, forKey: FIELD_LIMIT_AUDIO_TITLE_LENGTH)
        UB.set(limit!.videoTitleLength, forKey: FIELD_LIMIT_VIDEO_TITLE_LENGTH)
        UB.set(limit!.foodTitleLength, forKey: FIELD_LIMIT_FOOD_TITLE_LENGTH)
        UB.set(limit!.foodContentLength, forKey: FIELD_LIMIT_FOOD_CONTENT_LENGTH)
        UB.set(limit!.travelTitleLength, forKey: FIELD_LIMIT_TRAVEL_TITLE_LENGTH)
        UB.set(limit!.travelPlaceContentLength, forKey: FIELD_LIMIT_TRAVEL_PLACE_CONTENT_LENGTH)
        UB.set(limit!.giftTitleLength, forKey: FIELD_LIMIT_GIFT_TITLE_LENGTH)
        UB.set(limit!.promiseContentLength, forKey: FIELD_LIMIT_PROMISE_CONTENT_LENGTH)
        UB.set(limit!.promiseBreakContentLength, forKey: FIELD_LIMIT_PROMISE_BREAK_CONTENT_LENGTH)
        UB.set(limit!.angryContentLength, forKey: FIELD_LIMIT_ANGRY_CONTENT_LENGTH)
        UB.set(limit!.dreamContentLength, forKey: FIELD_LIMIT_DREAM_CONTENT_LENGTH)
        UB.set(limit!.awardContentLength, forKey: FIELD_LIMIT_AWARD_CONTENT_LENGTH)
        UB.set(limit!.awardRuleTitleLength, forKey: FIELD_LIMIT_AWARD_RULE_TITLE_LENGTH)
        UB.set(limit!.awardRuleScoreMax, forKey: FIELD_LIMIT_AWARD_RULE_SCORE_MAX)
        UB.set(limit!.movieTitleLength, forKey: FIELD_LIMIT_MOVIE_TITLE_LENGTH)
        UB.set(limit!.movieContentLength, forKey: FIELD_LIMIT_MOVIE_CONTENT_LENGTH)
        UB.set(limit!.postTitleLength, forKey: FIELD_LIMIT_POST_TITLE_LENGTH)
        UB.set(limit!.postContentLength, forKey: FIELD_LIMIT_POST_CONTENT_LENGTH)
        UB.set(limit!.postScreenReportCount, forKey: FIELD_LIMIT_POST_SCREEN_REPORT_COUNT)
        UB.set(limit!.postCommentContentLength, forKey: FIELD_LIMIT_POST_COMMENT_CONTENT_LENGTH)
        UB.set(limit!.postCommentScreenReportCount, forKey: FIELD_LIMIT_POST_COMMENT_SCREEN_REPORT_COUNT)
        UB.set(limit!.payVipGoods1Title, forKey: FIELD_LIMIT_PAY_VIP_GOODS_1_TITLE)
        UB.set(limit!.payVipGoods1Days, forKey: FIELD_LIMIT_PAY_VIP_GOODS_1_DAYS)
        UB.set(limit!.payVipGoods1Amount, forKey: FIELD_LIMIT_PAY_VIP_GOODS_1_AMOUNT)
        UB.set(limit!.payVipGoods2Title, forKey: FIELD_LIMIT_PAY_VIP_GOODS_2_TITLE)
        UB.set(limit!.payVipGoods2Days, forKey: FIELD_LIMIT_PAY_VIP_GOODS_2_DAYS)
        UB.set(limit!.payVipGoods2Amount, forKey: FIELD_LIMIT_PAY_VIP_GOODS_2_AMOUNT)
        UB.set(limit!.payVipGoods3Title, forKey: FIELD_LIMIT_PAY_VIP_GOODS_3_TITLE)
        UB.set(limit!.payVipGoods3Days, forKey: FIELD_LIMIT_PAY_VIP_GOODS_3_DAYS)
        UB.set(limit!.payVipGoods3Amount, forKey: FIELD_LIMIT_PAY_VIP_GOODS_3_AMOUNT)
        UB.set(limit!.payCoinGoods1Title, forKey: FIELD_LIMIT_PAY_COIN_GOODS_1_TITLE)
        UB.set(limit!.payCoinGoods1Count, forKey: FIELD_LIMIT_PAY_COIN_GOODS_1_COUNT)
        UB.set(limit!.payCoinGoods1Amount, forKey: FIELD_LIMIT_PAY_COIN_GOODS_1_AMOUNT)
        UB.set(limit!.payCoinGoods2Title, forKey: FIELD_LIMIT_PAY_COIN_GOODS_2_TITLE)
        UB.set(limit!.payCoinGoods2Count, forKey: FIELD_LIMIT_PAY_COIN_GOODS_2_COUNT)
        UB.set(limit!.payCoinGoods2Amount, forKey: FIELD_LIMIT_PAY_COIN_GOODS_2_AMOUNT)
        UB.set(limit!.payCoinGoods3Title, forKey: FIELD_LIMIT_PAY_COIN_GOODS_3_TITLE)
        UB.set(limit!.payCoinGoods3Count, forKey: FIELD_LIMIT_PAY_COIN_GOODS_3_COUNT)
        UB.set(limit!.payCoinGoods3Amount, forKey: FIELD_LIMIT_PAY_COIN_GOODS_3_AMOUNT)
        UB.set(limit!.coinSignMinCount, forKey: FIELD_LIMIT_COIN_SIGN_MIN_COUNT)
        UB.set(limit!.coinSignMaxCount, forKey: FIELD_LIMIT_COIN_SIGN_MAX_COUNT)
        UB.set(limit!.coinSignIncreaseCount, forKey: FIELD_LIMIT_COIN_SIGN_INCREASE_COUNT)
        UB.set(limit!.coinAdBetweenSec, forKey: FIELD_LIMIT_COIN_AD_BETWEEN_SEC)
        UB.set(limit!.coinAdWatchCount, forKey: FIELD_LIMIT_COIN_AD_WATCH_COUNT)
        UB.set(limit!.coinAdClickCount, forKey: FIELD_LIMIT_COIN_AD_CLICK_COUNT)
        UB.set(limit!.coinAdMaxPerDayCount, forKey: FIELD_LIMIT_COIN_AD_MAX_PER_DAY_COUNT)
        UB.set(limit!.matchWorkScreenReportCount, forKey: FIELD_LIMIT_MATCH_WORK_SCREEN_REPORT_COUNT)
        UB.set(limit!.matchWorkTitleLength, forKey: FIELD_LIMIT_MATCH_WORK_TITLE_LENGTH)
        UB.set(limit!.matchWorkContentLength, forKey: FIELD_LIMIT_MATCH_WORK_CONTENT_LENGTH)
    }
    
    public static func getLimit() -> Limit {
        let limit = Limit()
        limit.smsCodeLength = UB.integer(forKey: FIELD_LIMIT_SMS_CODE_LENGTH) == 0 ? 6 : UB.integer(forKey: FIELD_LIMIT_SMS_CODE_LENGTH)
        limit.smsBetweenSec = UB.integer(forKey: FIELD_LIMIT_SMS_BETWEEN) == 0 ? 60 * 2 : UB.integer(forKey: FIELD_LIMIT_SMS_BETWEEN)
        limit.suggestTitleLength = UB.integer(forKey: FIELD_LIMIT_SUGGEST_TITLE_LENGTH) == 0 ? 20 : UB.integer(forKey: FIELD_LIMIT_SUGGEST_TITLE_LENGTH)
        limit.suggestContentLength = UB.integer(forKey: FIELD_LIMIT_SUGGEST_CONTENT_LENGTH) == 0 ? 200 : UB.integer(forKey: FIELD_LIMIT_SUGGEST_CONTENT_LENGTH)
        limit.suggestCommentContentLength = UB.integer(forKey: FIELD_LIMIT_SUGGEST_COMMENT_CONTENT_LENGTH) == 0 ? 200 : UB.integer(forKey: FIELD_LIMIT_SUGGEST_COMMENT_CONTENT_LENGTH)
        limit.coupleInviteIntervalSec = (UB.object(forKey: FIELD_LIMIT_COUPLE_INVITE_INTERVAL_SEC) as? Int64) ?? limit.coupleInviteIntervalSec
        limit.coupleBreakNeedSec = (UB.object(forKey: FIELD_LIMIT_COUPLE_BREAK_NEED_SEC) as? Int64) ?? limit.coupleBreakNeedSec
        limit.coupleBreakSec = (UB.object(forKey: FIELD_LIMIT_COUPLE_BREAK_SEC) as? Int64) ?? limit.coupleBreakSec
        limit.coupleNameLength = UB.integer(forKey: FIELD_LIMIT_COUPLE_NAME_LENGTH) == 0 ? 6 : UB.integer(forKey: FIELD_LIMIT_COUPLE_NAME_LENGTH)
        limit.noteResExpireSec = (UB.object(forKey: FIELD_LIMIT_NOTE_OSS_EXPIRE_SECONDS) as? Int64) ?? limit.noteResExpireSec
        limit.mensesMaxPerMonth = UB.integer(forKey: FIELD_LIMIT_MENSES_MAX_PER_MONTH) == 0 ? 2 : UB.integer(forKey: FIELD_LIMIT_MENSES_MAX_PER_MONTH)
        limit.mensesMaxCycleDay = UB.integer(forKey: FIELD_LIMIT_MENSES_MAX_CYCLE_DAY) == 0 ? 60 : UB.integer(forKey: FIELD_LIMIT_MENSES_MAX_CYCLE_DAY)
        limit.mensesMaxDurationDay = UB.integer(forKey: FIELD_LIMIT_MENSES_MAX_DURATION_DAY) == 0 ? 15 : UB.integer(forKey: FIELD_LIMIT_MENSES_MAX_DURATION_DAY)
        limit.mensesDefaultCycleDay = UB.integer(forKey: FIELD_LIMIT_MENSES_DEFAULT_CYCLE_DAY) == 0 ? 30 : UB.integer(forKey: FIELD_LIMIT_MENSES_DEFAULT_CYCLE_DAY)
        limit.mensesDefaultDurationDay = UB.integer(forKey: FIELD_LIMIT_MENSES_DEFAULT_DURATION_DAY) == 0 ? 7 : UB.integer(forKey: FIELD_LIMIT_MENSES_DEFAULT_DURATION_DAY)
        limit.shyMaxPerDay = UB.integer(forKey: FIELD_LIMIT_SHY_MAX_PER_DAY) == 0 ? 5 : UB.integer(forKey: FIELD_LIMIT_SHY_MAX_PER_DAY)
        limit.shySafeLength = UB.integer(forKey: FIELD_LIMIT_SHY_SAFE_LENGTH) == 0 ? 10 : UB.integer(forKey: FIELD_LIMIT_SHY_SAFE_LENGTH)
        limit.shyDescLength = UB.integer(forKey: FIELD_LIMIT_SHY_DESC_LENGTH) == 0 ? 50 : UB.integer(forKey: FIELD_LIMIT_SHY_DESC_LENGTH)
        limit.sleepMaxPerDay = UB.integer(forKey: FIELD_LIMIT_SLEEP_MAX_PER_DAY) == 0 ? 10 : UB.integer(forKey: FIELD_LIMIT_SLEEP_MAX_PER_DAY)
        limit.noteSleepSuccessMinSec = (UB.object(forKey: FIELD_LIMIT_NOTE_SLEEP_SUCCESS_MIN_SEC) as? Int64) ?? limit.noteSleepSuccessMinSec
        limit.noteSleepSuccessMaxSec = (UB.object(forKey: FIELD_LIMIT_NOTE_SLEEP_SUCCESS_MAX_SEC) as? Int64) ?? limit.noteSleepSuccessMaxSec
        limit.noteLockLength = UB.integer(forKey: FIELD_LIMIT_NOTE_LOCK_LENGTH) == 0 ? 6 : UB.integer(forKey: FIELD_LIMIT_NOTE_LOCK_LENGTH)
        limit.souvenirTitleLength = UB.integer(forKey: FIELD_LIMIT_SOUVENIR_TITLE_LENGTH) == 0 ? 20 : UB.integer(forKey: FIELD_LIMIT_SOUVENIR_TITLE_LENGTH)
        limit.souvenirForeignYearCount = UB.integer(forKey: FIELD_LIMIT_SOUVENIR_FOREIGN_YEAR_COUNT) == 0 ? 1 : UB.integer(forKey: FIELD_LIMIT_SOUVENIR_FOREIGN_YEAR_COUNT)
        limit.travelPlaceCount = UB.integer(forKey: FIELD_LIMIT_TRAVEL_PLACE_COUNT) == 0 ? 1 : UB.integer(forKey: FIELD_LIMIT_TRAVEL_PLACE_COUNT)
        limit.travelVideoCount = UB.integer(forKey: FIELD_LIMIT_TRAVEL_VIDEO_COUNT) == 0 ? 1 : UB.integer(forKey: FIELD_LIMIT_TRAVEL_VIDEO_COUNT)
        limit.travelFoodCount = UB.integer(forKey: FIELD_LIMIT_TRAVEL_FOOD_COUNT) == 0 ? 1 : UB.integer(forKey: FIELD_LIMIT_TRAVEL_FOOD_COUNT)
        limit.travelMovieCount = UB.integer(forKey: FIELD_LIMIT_TRAVEL_MOVIE_COUNT) == 0 ? 1 : UB.integer(forKey: FIELD_LIMIT_TRAVEL_MOVIE_COUNT)
        limit.travelAlbumCount = UB.integer(forKey: FIELD_LIMIT_TRAVEL_ALBUM_COUNT) == 0 ? 1 : UB.integer(forKey: FIELD_LIMIT_TRAVEL_ALBUM_COUNT)
        limit.travelDiaryCount = UB.integer(forKey: FIELD_LIMIT_TRAVEL_DIARY_COUNT) == 0 ? 1 : UB.integer(forKey: FIELD_LIMIT_TRAVEL_DIARY_COUNT)
        limit.whisperContentLength = UB.integer(forKey: FIELD_LIMIT_WHISPER_CONTENT_LENGTH) == 0 ? 100 : UB.integer(forKey: FIELD_LIMIT_WHISPER_CONTENT_LENGTH)
        limit.whisperChannelLength = UB.integer(forKey: FIELD_LIMIT_WHISPER_CHANNEL_LENGTH) == 0 ? 10 : UB.integer(forKey: FIELD_LIMIT_WHISPER_CHANNEL_LENGTH)
        limit.wordContentLength = UB.integer(forKey: FIELD_LIMIT_WORD_CONTENT_LENGTH) == 0 ? 100 : UB.integer(forKey: FIELD_LIMIT_WORD_CONTENT_LENGTH)
        limit.diaryContentLength = UB.integer(forKey: FIELD_LIMIT_DIARY_CONTENT_LENGTH) == 0 ? 2000 : UB.integer(forKey: FIELD_LIMIT_DIARY_CONTENT_LENGTH)
        limit.albumTitleLength = UB.integer(forKey: FIELD_LIMIT_ALBUM_TITLE_LENGTH) == 0 ? 10 : UB.integer(forKey: FIELD_LIMIT_ALBUM_TITLE_LENGTH)
        limit.picturePushCount = UB.integer(forKey: FIELD_LIMIT_PICTURE_PUSH_COUNT) == 0 ? 1 : UB.integer(forKey: FIELD_LIMIT_PICTURE_PUSH_COUNT)
        limit.audioTitleLength = UB.integer(forKey: FIELD_LIMIT_AUDIO_TITLE_LENGTH) == 0 ? 20 : UB.integer(forKey: FIELD_LIMIT_AUDIO_TITLE_LENGTH)
        limit.videoTitleLength = UB.integer(forKey: FIELD_LIMIT_VIDEO_TITLE_LENGTH) == 0 ? 20 : UB.integer(forKey: FIELD_LIMIT_VIDEO_TITLE_LENGTH)
        limit.foodTitleLength = UB.integer(forKey: FIELD_LIMIT_FOOD_TITLE_LENGTH) == 0 ? 20 : UB.integer(forKey: FIELD_LIMIT_FOOD_TITLE_LENGTH)
        limit.foodContentLength = UB.integer(forKey: FIELD_LIMIT_FOOD_CONTENT_LENGTH) == 0 ? 200 : UB.integer(forKey: FIELD_LIMIT_FOOD_CONTENT_LENGTH)
        limit.travelTitleLength = UB.integer(forKey: FIELD_LIMIT_TRAVEL_TITLE_LENGTH) == 0 ? 20 : UB.integer(forKey: FIELD_LIMIT_TRAVEL_TITLE_LENGTH)
        limit.travelPlaceContentLength = UB.integer(forKey: FIELD_LIMIT_TRAVEL_PLACE_CONTENT_LENGTH) == 0 ? 200 : UB.integer(forKey: FIELD_LIMIT_TRAVEL_PLACE_CONTENT_LENGTH)
        limit.giftTitleLength = UB.integer(forKey: FIELD_LIMIT_GIFT_TITLE_LENGTH) == 0 ? 20 : UB.integer(forKey: FIELD_LIMIT_GIFT_TITLE_LENGTH)
        limit.promiseContentLength = UB.integer(forKey: FIELD_LIMIT_PROMISE_CONTENT_LENGTH) == 0 ? 200 : UB.integer(forKey: FIELD_LIMIT_PROMISE_CONTENT_LENGTH)
        limit.promiseBreakContentLength = UB.integer(forKey: FIELD_LIMIT_PROMISE_BREAK_CONTENT_LENGTH) == 0 ? 100 : UB.integer(forKey: FIELD_LIMIT_PROMISE_BREAK_CONTENT_LENGTH)
        limit.angryContentLength = UB.integer(forKey: FIELD_LIMIT_ANGRY_CONTENT_LENGTH) == 0 ? 200 : UB.integer(forKey: FIELD_LIMIT_ANGRY_CONTENT_LENGTH)
        limit.dreamContentLength = UB.integer(forKey: FIELD_LIMIT_DREAM_CONTENT_LENGTH) == 0 ? 1000 : UB.integer(forKey: FIELD_LIMIT_DREAM_CONTENT_LENGTH)
        limit.awardContentLength = UB.integer(forKey: FIELD_LIMIT_AWARD_CONTENT_LENGTH) == 0 ? 100 : UB.integer(forKey: FIELD_LIMIT_AWARD_CONTENT_LENGTH)
        limit.awardRuleTitleLength = UB.integer(forKey: FIELD_LIMIT_AWARD_RULE_TITLE_LENGTH) == 0 ? 30 : UB.integer(forKey: FIELD_LIMIT_AWARD_RULE_TITLE_LENGTH)
        limit.awardRuleScoreMax = UB.integer(forKey: FIELD_LIMIT_AWARD_RULE_SCORE_MAX) == 0 ? 100 : UB.integer(forKey: FIELD_LIMIT_AWARD_RULE_SCORE_MAX)
        limit.movieTitleLength = UB.integer(forKey: FIELD_LIMIT_MOVIE_TITLE_LENGTH) == 0 ? 20 : UB.integer(forKey: FIELD_LIMIT_MOVIE_TITLE_LENGTH)
        limit.movieContentLength = UB.integer(forKey: FIELD_LIMIT_MOVIE_CONTENT_LENGTH) == 0 ? 200 : UB.integer(forKey: FIELD_LIMIT_MOVIE_CONTENT_LENGTH)
        limit.postTitleLength = UB.integer(forKey: FIELD_LIMIT_POST_TITLE_LENGTH) == 0 ? 20 : UB.integer(forKey: FIELD_LIMIT_POST_TITLE_LENGTH)
        limit.postContentLength = UB.integer(forKey: FIELD_LIMIT_POST_CONTENT_LENGTH) == 0 ? 100 : UB.integer(forKey: FIELD_LIMIT_POST_CONTENT_LENGTH)
        limit.postScreenReportCount = UB.integer(forKey: FIELD_LIMIT_POST_SCREEN_REPORT_COUNT) == 0 ? 10 : UB.integer(forKey: FIELD_LIMIT_POST_SCREEN_REPORT_COUNT)
        limit.postCommentContentLength = UB.integer(forKey: FIELD_LIMIT_POST_COMMENT_CONTENT_LENGTH) == 0 ? 100 : UB.integer(forKey: FIELD_LIMIT_POST_COMMENT_CONTENT_LENGTH)
        limit.postCommentScreenReportCount = UB.integer(forKey: FIELD_LIMIT_POST_COMMENT_SCREEN_REPORT_COUNT) == 0 ? 20 : UB.integer(forKey: FIELD_LIMIT_POST_COMMENT_SCREEN_REPORT_COUNT)
        limit.payVipGoods1Title = UB.string(forKey: FIELD_LIMIT_PAY_VIP_GOODS_1_TITLE) ?? limit.payVipGoods1Title
        limit.payVipGoods1Days = UB.integer(forKey: FIELD_LIMIT_PAY_VIP_GOODS_1_DAYS)
        limit.payVipGoods1Amount = UB.double(forKey: FIELD_LIMIT_PAY_VIP_GOODS_1_AMOUNT)
        limit.payVipGoods2Title = UB.string(forKey: FIELD_LIMIT_PAY_VIP_GOODS_2_TITLE) ?? limit.payVipGoods2Title
        limit.payVipGoods2Days = UB.integer(forKey: FIELD_LIMIT_PAY_VIP_GOODS_2_DAYS)
        limit.payVipGoods2Amount = UB.double(forKey: FIELD_LIMIT_PAY_VIP_GOODS_2_AMOUNT)
        limit.payVipGoods3Title = UB.string(forKey: FIELD_LIMIT_PAY_VIP_GOODS_3_TITLE) ?? limit.payVipGoods3Title
        limit.payVipGoods3Days = UB.integer(forKey: FIELD_LIMIT_PAY_VIP_GOODS_3_DAYS)
        limit.payVipGoods3Amount = UB.double(forKey: FIELD_LIMIT_PAY_VIP_GOODS_3_AMOUNT)
        limit.payCoinGoods1Title = UB.string(forKey: FIELD_LIMIT_PAY_COIN_GOODS_1_TITLE) ?? limit.payCoinGoods1Title
        limit.payCoinGoods1Count = UB.integer(forKey: FIELD_LIMIT_PAY_COIN_GOODS_1_COUNT)
        limit.payCoinGoods1Amount = UB.double(forKey: FIELD_LIMIT_PAY_COIN_GOODS_1_AMOUNT)
        limit.payCoinGoods2Title = UB.string(forKey: FIELD_LIMIT_PAY_COIN_GOODS_2_TITLE) ?? limit.payCoinGoods2Title
        limit.payCoinGoods2Count = UB.integer(forKey: FIELD_LIMIT_PAY_COIN_GOODS_2_COUNT)
        limit.payCoinGoods2Amount = UB.double(forKey: FIELD_LIMIT_PAY_COIN_GOODS_2_AMOUNT)
        limit.payCoinGoods3Title = UB.string(forKey: FIELD_LIMIT_PAY_COIN_GOODS_3_TITLE) ?? limit.payCoinGoods3Title
        limit.payCoinGoods3Count = UB.integer(forKey: FIELD_LIMIT_PAY_COIN_GOODS_3_COUNT)
        limit.payCoinGoods3Amount = UB.double(forKey: FIELD_LIMIT_PAY_COIN_GOODS_3_AMOUNT)
        limit.coinSignMinCount = UB.integer(forKey: FIELD_LIMIT_COIN_SIGN_MIN_COUNT) == 0 ? 1 : UB.integer(forKey: FIELD_LIMIT_COIN_SIGN_MIN_COUNT)
        limit.coinSignMaxCount = UB.integer(forKey: FIELD_LIMIT_COIN_SIGN_MAX_COUNT) == 0 ? 10 : UB.integer(forKey: FIELD_LIMIT_COIN_SIGN_MAX_COUNT)
        limit.coinSignIncreaseCount = UB.integer(forKey: FIELD_LIMIT_COIN_SIGN_INCREASE_COUNT) == 0 ? 1 : UB.integer(forKey: FIELD_LIMIT_COIN_SIGN_INCREASE_COUNT)
        limit.coinAdBetweenSec = UB.integer(forKey: FIELD_LIMIT_COIN_AD_BETWEEN_SEC) == 0 ? 1 : UB.integer(forKey: FIELD_LIMIT_COIN_AD_BETWEEN_SEC)
        limit.coinAdWatchCount = UB.integer(forKey: FIELD_LIMIT_COIN_AD_WATCH_COUNT) == 0 ? 1 : UB.integer(forKey: FIELD_LIMIT_COIN_AD_WATCH_COUNT)
        limit.coinAdClickCount = UB.integer(forKey: FIELD_LIMIT_COIN_AD_CLICK_COUNT) == 0 ? 2 : UB.integer(forKey: FIELD_LIMIT_COIN_AD_CLICK_COUNT)
        limit.coinAdMaxPerDayCount = UB.integer(forKey: FIELD_LIMIT_COIN_AD_MAX_PER_DAY_COUNT) == 0 ? 10 : UB.integer(forKey: FIELD_LIMIT_COIN_AD_MAX_PER_DAY_COUNT)
        limit.matchWorkScreenReportCount = UB.integer(forKey: FIELD_LIMIT_MATCH_WORK_SCREEN_REPORT_COUNT) == 0 ? 10 : UB.integer(forKey: FIELD_LIMIT_MATCH_WORK_SCREEN_REPORT_COUNT)
        limit.matchWorkTitleLength = UB.integer(forKey: FIELD_LIMIT_MATCH_WORK_TITLE_LENGTH) == 0 ? 100 : UB.integer(forKey: FIELD_LIMIT_MATCH_WORK_TITLE_LENGTH)
        limit.matchWorkContentLength = UB.integer(forKey: FIELD_LIMIT_MATCH_WORK_CONTENT_LENGTH) == 0 ? 200 : UB.integer(forKey: FIELD_LIMIT_MATCH_WORK_CONTENT_LENGTH)
        return limit
    }
    
    /**
     * ***********************************VipLimit***********************************
     */
    public static func setVipLimit(_ vipLimit: VipLimit?) {
        clearVipLimit()
        if vipLimit == nil {
            LogUtils.i(tag: "UDHelper", method: "setVipLimit", "vipLimit == nil");
            return
        }
        UB.set(vipLimit!.advertiseHide, forKey: FIELD_VIP_LIMIT_ADVERTISE_HIDE)
        UB.set(vipLimit!.wallPaperSize, forKey: FIELD_VIP_LIMIT_WALL_PAPER_SIZE)
        UB.set(vipLimit!.wallPaperCount, forKey: FIELD_VIP_LIMIT_WALL_PAPER_COUNT)
        UB.set(vipLimit!.noteTotalEnable, forKey: FIELD_VIP_LIMIT_TRENDS_TOTAL_ENABLE)
        UB.set(vipLimit!.souvenirCount, forKey: FIELD_VIP_LIMIT_SOUVENIR_COUNT)
        UB.set(vipLimit!.whisperImageEnable, forKey: FIELD_VIP_LIMIT_WHISPER_IMG_ENABLE)
        UB.set(vipLimit!.movieImageCount, forKey: FIELD_VIP_LIMIT_MOVIE_IMG_COUNT)
        UB.set(vipLimit!.foodImageCount, forKey: FIELD_VIP_LIMIT_FOOD_IMG_COUNT)
        UB.set(vipLimit!.giftImageCount, forKey: FIELD_VIP_LIMIT_GIFT_IMG_COUNT)
        UB.set(vipLimit!.diaryImageCount, forKey: FIELD_VIP_LIMIT_DIARY_IMG_COUNT)
        UB.set(vipLimit!.diaryImageSize, forKey: FIELD_VIP_LIMIT_DIARY_IMG_SIZE)
        UB.set(vipLimit!.pictureOriginal, forKey: FIELD_VIP_LIMIT_PICTURE_ORIGINAL)
        UB.set(vipLimit!.pictureTotalCount, forKey: FIELD_VIP_LIMIT_PICTURE_TOTAL_COUNT)
        UB.set(vipLimit!.audioSize, forKey: FIELD_VIP_LIMIT_AUDIO_SIZE)
        UB.set(vipLimit!.videoSize, forKey: FIELD_VIP_LIMIT_VIDEO_SIZE)
        UB.set(vipLimit!.pictureSize, forKey: FIELD_VIP_LIMIT_PICTURE_SIZE)
        UB.set(vipLimit!.topicPostImageCount, forKey: FIELD_VIP_LIMIT_TOPIC_POST_IMAGE_COUNT)
    }
    
    public static func getVipLimit() -> VipLimit {
        let vipLimit = VipLimit()
        vipLimit.advertiseHide = UB.bool(forKey: FIELD_VIP_LIMIT_ADVERTISE_HIDE)
        vipLimit.wallPaperSize = (UB.object(forKey: FIELD_VIP_LIMIT_WALL_PAPER_SIZE) as? Int64) ?? vipLimit.wallPaperSize
        vipLimit.wallPaperCount = UB.integer(forKey: FIELD_VIP_LIMIT_WALL_PAPER_COUNT) == 0 ? 1 : UB.integer(forKey: FIELD_VIP_LIMIT_WALL_PAPER_COUNT)
        vipLimit.noteTotalEnable = UB.bool(forKey: FIELD_VIP_LIMIT_TRENDS_TOTAL_ENABLE)
        vipLimit.souvenirCount = UB.integer(forKey: FIELD_VIP_LIMIT_SOUVENIR_COUNT) == 0 ? 1 : UB.integer(forKey: FIELD_VIP_LIMIT_SOUVENIR_COUNT)
        vipLimit.whisperImageEnable = UB.bool(forKey: FIELD_VIP_LIMIT_WHISPER_IMG_ENABLE)
        vipLimit.movieImageCount = UB.integer(forKey: FIELD_VIP_LIMIT_MOVIE_IMG_COUNT)
        vipLimit.foodImageCount = UB.integer(forKey: FIELD_VIP_LIMIT_FOOD_IMG_COUNT)
        vipLimit.giftImageCount = UB.integer(forKey: FIELD_VIP_LIMIT_GIFT_IMG_COUNT)
        vipLimit.diaryImageCount = UB.integer(forKey: FIELD_VIP_LIMIT_DIARY_IMG_COUNT)
        vipLimit.diaryImageSize = (UB.object(forKey: FIELD_VIP_LIMIT_DIARY_IMG_SIZE) as? Int64) ?? vipLimit.diaryImageSize
        vipLimit.pictureOriginal = UB.bool(forKey: FIELD_VIP_LIMIT_PICTURE_ORIGINAL)
        vipLimit.pictureTotalCount = UB.integer(forKey: FIELD_VIP_LIMIT_PICTURE_TOTAL_COUNT) == 0 ? 100 : UB.integer(forKey: FIELD_VIP_LIMIT_PICTURE_TOTAL_COUNT)
        vipLimit.audioSize = (UB.object(forKey: FIELD_VIP_LIMIT_AUDIO_SIZE) as? Int64) ?? vipLimit.audioSize
        vipLimit.videoSize = (UB.object(forKey: FIELD_VIP_LIMIT_VIDEO_SIZE) as? Int64) ?? vipLimit.videoSize
        vipLimit.pictureSize = (UB.object(forKey: FIELD_VIP_LIMIT_PICTURE_SIZE) as? Int64) ?? vipLimit.pictureSize
        vipLimit.topicPostImageCount = UB.integer(forKey: FIELD_VIP_LIMIT_TOPIC_POST_IMAGE_COUNT)
        return vipLimit
    }
    
    /**
     * ***********************************Me***********************************
     */
    public static func setMe(_ user: User?) {
        clearMe()
        clearCouple()
        if UserHelper.isEmpty(user: user) {
            LogUtils.i(tag: "UDHelper", method: "setMe", "user == nil");
            return
        }
        UB.set(user!.id, forKey: FIELD_ME_USER_ID)
        UB.set(user!.phone, forKey: FIELD_ME_USER_PHONE)
        UB.set(user!.sex, forKey: FIELD_ME_USER_SEX)
        UB.set(user!.birthday, forKey: FIELD_ME_USER_BIRTHDAY)
        UB.set(user!.userToken, forKey: FIELD_ME_USER_TOKEN)
        // 存cp
        setCouple(user?.couple)
    }
    
    public static func getMe() -> User? {
        let user = User()
        user.id = (UB.object(forKey: FIELD_ME_USER_ID) as? Int64) ?? user.id
        user.phone = UB.string(forKey: FIELD_ME_USER_PHONE) ?? user.phone
        user.sex = UB.integer(forKey: FIELD_ME_USER_SEX)
        user.birthday = (UB.object(forKey: FIELD_ME_USER_BIRTHDAY) as? Int64) ?? user.birthday
        user.userToken = UB.string(forKey: FIELD_ME_USER_TOKEN) ?? user.userToken
        if user.id == 0 || user.phone == "" || user.userToken == "" {
            return nil
        }
        // 取cp
        user.couple = getCouple()
        return user
    }
    
    /**
     * ***********************************Ta***********************************
     */
    public static func setTa(_ user: User?) {
        clearTa()
        if UserHelper.isEmpty(user: user) {
            LogUtils.i(tag: "UDHelper", method: "setTa", "user == nil");
            return
        }
        UB.set(user!.id, forKey: FIELD_TA_USER_ID)
        UB.set(user!.phone, forKey: FIELD_TA_USER_PHONE)
        UB.set(user!.sex, forKey: FIELD_TA_USER_SEX)
        UB.set(user!.birthday, forKey: FIELD_TA_USER_BIRTHDAY)
    }
    
    public static func getTa() -> User? {
        let user = User()
        user.id = (UB.object(forKey: FIELD_TA_USER_ID) as? Int64) ?? user.id
        user.phone = UB.string(forKey: FIELD_TA_USER_PHONE) ?? user.phone
        user.sex = UB.integer(forKey: FIELD_TA_USER_SEX)
        user.birthday = (UB.object(forKey: FIELD_TA_USER_BIRTHDAY) as? Int64) ?? user.birthday
        if user.id == 0 || user.phone == "" {
            return nil
        }
        return user
    }
    
    /**
     * ***********************************Couple***********************************
     */
    public static func setCouple(_ couple: Couple?) {
        clearCouple()
        if UserHelper.isEmpty(couple: couple) {
            LogUtils.i(tag: "UDHelper", method: "setCouple", "couple == nil");
            return
        }
        UB.set(couple!.id, forKey: FIELD_CP_ID)
        UB.set(couple!.createAt, forKey: FIELD_CP_CREATE_AT)
        UB.set(couple!.updateAt, forKey: FIELD_CP_UPDATE_AT)
        UB.set(couple!.creatorId, forKey: FIELD_CP_CREATOR_ID)
        UB.set(couple!.creatorName, forKey: FIELD_CP_CREATOR_NAME)
        UB.set(couple!.creatorAvatar, forKey: FIELD_CP_CREATOR_AVATAR)
        UB.set(couple!.inviteeId, forKey: FIELD_CP_INVITEE_ID)
        UB.set(couple!.inviteeName, forKey: FIELD_CP_INVITEE_NAME)
        UB.set(couple!.inviteeAvatar, forKey: FIELD_CP_INVITEE_AVATAR)
        UB.set(couple!.togetherAt, forKey: FIELD_CP_TOGETHER_AT)
        let state = couple!.state
        if state != nil {
            UB.set(state!.id, forKey: FIELD_CP_STATE_ID)
            UB.set(state!.createAt, forKey: FIELD_CP_STATE_CREATE_AT)
            UB.set(state!.updateAt, forKey: FIELD_CP_STATE_UPDATE_AT)
            UB.set(state!.userId, forKey: FIELD_CP_STATE_USER_ID)
            UB.set(state!.state, forKey: FIELD_CP_STATE_STATE)
        }
    }
    
    public static func getCouple() -> Couple? {
        let couple = Couple()
        couple.id = (UB.object(forKey: FIELD_CP_ID) as? Int64) ?? couple.id
        couple.createAt = (UB.object(forKey: FIELD_CP_CREATE_AT) as? Int64) ?? couple.createAt
        couple.updateAt = (UB.object(forKey: FIELD_CP_UPDATE_AT) as? Int64) ?? couple.updateAt
        couple.creatorId = (UB.object(forKey: FIELD_CP_CREATOR_ID) as? Int64) ?? couple.creatorId
        couple.creatorName = UB.string(forKey: FIELD_CP_CREATOR_NAME) ?? couple.creatorName
        couple.creatorAvatar = UB.string(forKey: FIELD_CP_CREATOR_AVATAR) ?? couple.creatorAvatar
        couple.inviteeId = (UB.object(forKey: FIELD_CP_INVITEE_ID) as? Int64) ?? couple.inviteeId
        couple.inviteeName = UB.string(forKey: FIELD_CP_INVITEE_NAME) ?? couple.inviteeName
        couple.inviteeAvatar = UB.string(forKey: FIELD_CP_INVITEE_AVATAR) ?? couple.inviteeAvatar
        couple.togetherAt = (UB.object(forKey: FIELD_CP_TOGETHER_AT) as? Int64) ?? couple.togetherAt
        if couple.id == 0 || couple.creatorId == 0 || couple.inviteeId == 0 {
            return nil
        }
        let state = CoupleState()
        state.id = (UB.object(forKey: FIELD_CP_STATE_ID) as? Int64) ?? state.id
        state.createAt = (UB.object(forKey: FIELD_CP_STATE_CREATE_AT) as? Int64) ?? state.createAt
        state.updateAt = (UB.object(forKey: FIELD_CP_STATE_UPDATE_AT) as? Int64) ?? state.updateAt
        state.userId = (UB.object(forKey: FIELD_CP_STATE_USER_ID) as? Int64) ?? state.userId
        state.state = UB.integer(forKey: FIELD_CP_STATE_STATE)
        if state.id != 0 {
            couple.state = state
        }
        return couple
    }
    
    /**
     * ***********************************WallPaper***********************************
     */
    public static func setWallPaper(_ wallPaper: WallPaper?) {
        clearWallPaper()
        if wallPaper == nil {
            LogUtils.i(tag: "UDHelper", method: "setWallPaper", "wallPaper == nil");
            return
        }
        let imageList: [String] = wallPaper!.contentImageList
        UB.set(imageList, forKey: FIELD_WALL_PAPER_IMAGES)
    }
    
    public static func getWallPaper() -> WallPaper {
        let wallPaper = WallPaper()
        wallPaper.contentImageList = UB.stringArray(forKey: FIELD_WALL_PAPER_IMAGES) ?? wallPaper.contentImageList
        return wallPaper
    }
    
    /**
     * ***********************************Draft***********************************
     */
    public static func setDraftDiary(_ diary: Diary?) {
        var draft = diary
        if draft == nil {
            draft = Diary()
        }
        UB.set(draft!.contentText, forKey: FIELD_DRAFT_DIARY_CONTENT_TEXT)
    }
    
    public static func getDraftDiary() -> Diary? {
        let diary = Diary()
        diary.contentText = UB.string(forKey: FIELD_DRAFT_DIARY_CONTENT_TEXT) ?? diary.contentText
        return diary
    }
    
    public static func setDraftDream(_ dream: Dream?) {
        var draft = dream
        if draft == nil {
            draft = Dream()
        }
        UB.set(draft!.contentText, forKey: FIELD_DRAFT_DREAM_CONTENT_TEXT)
    }
    
    public static func getDraftDream() -> Dream? {
        let dream = Dream()
        dream.contentText = UB.string(forKey: FIELD_DRAFT_DREAM_CONTENT_TEXT) ?? dream.contentText
        return dream
    }
    
    public static func setDraftPost(_ post: Post?) {
        var draft = post
        if draft == nil {
            draft = Post()
        }
        UB.set(draft!.title, forKey: FIELD_DRAFT_POST_TITLE)
        UB.set(draft!.contentText, forKey: FIELD_DRAFT_POST_CONTENT_TEXT)
    }
    
    public static func getDraftPost() -> Post? {
        let post = Post()
        post.title = UB.string(forKey: FIELD_DRAFT_POST_TITLE) ?? post.title
        post.contentText = UB.string(forKey: FIELD_DRAFT_POST_CONTENT_TEXT) ?? post.contentText
        return post
    }
    
}
