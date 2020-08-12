//
// Created by 蒋治国 on 2018-12-15.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation

class DateUtils {
    
    public static let UNIT_SEC: Int64 = 1
    public static let UNIT_MIN: Int64 = UNIT_SEC * 60
    public static let UNIT_HOUR: Int64 = UNIT_MIN * 60
    public static let UNIT_DAY: Int64 = UNIT_HOUR * 24
    public static let UNIT_MONTH: Int64 = UNIT_DAY * 30
    public static let UNIT_YEAR: Int64 = UNIT_MONTH * 12
    
    public static let FORMAT_CHINA_Y_M_D__H_M_S_S = "yyyyMMdd-HHmmssSSS" // 一般用于流水号
    public static let FORMAT_LINE_Y_M_D_H_M_S = "yyyy-MM-dd HH:mm:ss"
    public static let FORMAT_CHINA_Y_M_D_H_M_S = "yyyy年MM月dd日 HH时mm分ss秒"
    public static let FORMAT_LINE_Y_M_D_H_M = "yyyy-MM-dd HH:mm"
    public static let FORMAT_CHINA_Y_M_D_H_M = "yyyy年MM月dd日 HH:mm"
    public static let FORMAT_LINE_Y_M_D = "yyyy-MM-dd"
    public static let FORMAT_POINT_Y_M_D = "yyyy.MM.dd"
    public static let FORMAT_CHINA_M_SPCAE_Y = "MM月 yyyy"
    public static let FORMAT_CHINA_Y_M_D = "yyyy年MM月dd日"
    public static let FORMAT_LINE_Y_M = "yyyy-MM"
    public static let FORMAT_POINT_M_D = "yyyy.MM"
    public static let FORMAT_CHINA_M_D = "MM月dd日"
    public static let FORMAT_LINE_M_D = "MM-dd"
    public static let FORMAT_LINE_M_D_H_M = "MM-dd HH:mm"
    public static let FORMAT_H_M_S = "HH:mm:ss"
    public static let FORMAT_H_M = "HH:mm"
    public static let FORMAT_M_S = "mm:ss"
    public static let FORMAT_12_A = "hh:mm a" // 12小时制
    
    /**
     * 获取当前时间
     */
    public static func getCurrentDate() -> Date {
        return Date()
    }
    
    public static func getCurrentDC() -> DateComponents {
        return getDC(getCurrentDate())
    }
    
    public static func getCurrentInt64() -> Int64 {
        return getInt64(getCurrentDate())
    }
    
    public static func getCurrentStr(_ format: String?) -> String {
        return getStr(getCurrentDate(), format)
    }
    
    /**
     * 获取Date类型时间
     */
    public static func getDate(_ dc: DateComponents?) -> Date {
        if dc == nil {
            LogUtils.w(tag: "DateUtils", method: "getDate", "dc == nil")
            return getCurrentDate();
        }
        let date = Calendar.current.date(from: dc!)
        return date ?? getCurrentDate()
    }
    
    public static func getDate(_ timestamp: Int64?) -> Date {
        if timestamp == nil {
            LogUtils.w(tag: "DateUtils", method: "getDate", "timestamp == nil")
            return getCurrentDate();
        }
        return Date(timeIntervalSince1970: TimeInterval(timestamp!))
    }
    
    public static func getDate(_ time: String?, _ format: String?) -> Date {
        if StringUtils.isEmpty(time) || StringUtils.isEmpty(format) {
            LogUtils.w(tag: "DateUtils", method: "getDate", "time == null || format == nil")
            return getCurrentDate();
        }
        let formatter = DateFormatter()
        formatter.dateFormat = format!
        formatter.locale = Locale.current
        return formatter.date(from: time!) ?? getCurrentDate()
    }
    
    /**
     * 获取DateComponents类型时间
     */
    public static func getDC(_ date: Date?) -> DateComponents {
        if date == nil {
            LogUtils.w(tag: "DateUtils", method: "getDC", "date == nil")
            return getCurrentDC()
        }
        return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date!)
    }
    
    public static func getDC(_ timestamp: Int64?) -> DateComponents {
        let date = getDate(timestamp)
        return getDC(date)
    }
    
    public static func getDC(_ time: String?, _ format: String?) -> DateComponents {
        let date = getDate(time, format)
        return getDC(date)
    }
    
    /**
     * 获取int64类型的时间
     */
    public static func getInt64(_ date: Date?) -> Int64 {
        if date == nil {
            LogUtils.w(tag: "DateUtils", method: "getInt64", "date == nil")
            return getCurrentInt64()
        }
        return Int64(date!.timeIntervalSince1970)
    }
    
    public static func getInt64(_ dc: DateComponents?) -> Int64 {
        let date = getDate(dc)
        return getInt64(date)
    }
    
    public static func getInt64(_ time: String?, _ format: String?) -> Int64 {
        let date = getDate(time, format)
        return getInt64(date)
    }
    
    /**
     * 获取String类型时间
     */
    public static func getStr(_ date: Date?, _ format: String?) -> String {
        if date == nil || StringUtils.isEmpty(format) {
            LogUtils.w(tag: "DateUtils", method: "getStr", "date == nil || format == nil")
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = format!
        formatter.locale = Locale.current
        return formatter.string(from: date!)
    }
    
    public static func getStr(_ dc: DateComponents?, _ format: String?) -> String {
        let date = getDate(dc)
        return getStr(date, format)
    }
    
    public static func getStr(_ timestamp: Int64?, _ format: String?) -> String {
        let date = getDate(timestamp)
        return getStr(date, format)
    }
    
    /*************************************日历操作**************************************/
    
    // 判断是否是同一时
    public static func isSameHour(_ t1: Int64?, _ t2: Int64?) -> Bool {
        if t1 == nil || t2 == nil {
            LogUtils.w(tag: "DateUtils", method: "isSameHour", "t1 == nil || t2 == nil")
            return false;
        }
        let dc1 = getDC(t1)
        let dc2 = getDC(t2)
        return dc1.year == dc2.year && dc1.month == dc2.month && dc1.day == dc2.day && dc1.hour == dc2.hour
    }
    
    // 判断是否是同一天
    public static func isSameDay(_ t1: Int64?, _ t2: Int64?) -> Bool {
        if t1 == nil || t2 == nil {
            LogUtils.w(tag: "DateUtils", method: "isSameDay", "t1 == nil || t2 == nil")
            return false;
        }
        let dc1 = getDC(t1)
        let dc2 = getDC(t2)
        return dc1.year == dc2.year && dc1.month == dc2.month && dc1.day == dc2.day
    }
    
    // 判断是否是同一周
    public static func isSameWeek(_ t1: Int64?, _ t2: Int64?) -> Bool {
        if t1 == nil || t2 == nil {
            LogUtils.w(tag: "DateUtils", method: "isSameWeek", "t1 == nil || t2 == nil")
            return false;
        }
        let dc1 = getDC(t1)
        let dc2 = getDC(t2)
        return dc1.year == dc2.year && dc1.weekOfYear == dc2.weekOfYear
    }
    
    // 判断是否是同一月
    public static func isSameMonth(_ t1: Int64?, _ t2: Int64?) -> Bool {
        if t1 == nil || t2 == nil {
            LogUtils.w(tag: "DateUtils", method: "isSameMonth", "t1 == nil || t2 == nil")
            return false;
        }
        let dc1 = getDC(t1)
        let dc2 = getDC(t2)
        return dc1.year == dc2.year && dc1.month == dc2.month
    }
    
    // 判断是否是同一月
    public static func isSameYear(_ t1: Int64?, _ t2: Int64?) -> Bool {
        if t1 == nil || t2 == nil {
            LogUtils.w(tag: "DateUtils", method: "isSameYear", "t1 == nil || t2 == nil")
            return false;
        }
        let dc1 = getDC(t1)
        let dc2 = getDC(t2)
        return dc1.year == dc2.year
    }
    
    // 获取差值
    public static func getDiff(_ t1: Int64?, _ t2: Int64?) -> DateComponents {
        if t1 == nil || t2 == nil {
            LogUtils.w(tag: "DateUtils", method: "getDiff", "t1 == nil || t2 == nil")
            return DateComponents();
        }
        let dc1 = getDC(t1)
        let dc2 = getDC(t2)
        return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dc1, to: dc2)
    }
    
    // 判断闰年
    public static func isLeapYear(_ year: Int?) -> Bool {
        if year == nil {
            return false
        }
        return year! % 4 == 0 && year! % 100 != 0 || year! % 400 == 0
    }
    
    /*************************************农历操作**************************************/
    
    public static let lunarMonths: [String] = ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月",
                                           "九月", "十月", "冬月", "腊月"]
    
    public static let lunarDays: [String] = [ "初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十",
                                          "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "廿",
                                          "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"]
    
    private static func component() -> Set<Calendar.Component> {
        return [.year, .month, .day, .hour, .minute, .second]
    }
    
    public static func getLunarDC(date: Date) -> DateComponents {
        let calendar: Calendar = Calendar(identifier: .chinese)
        return calendar.dateComponents(component(), from: date)
    }
    
}
