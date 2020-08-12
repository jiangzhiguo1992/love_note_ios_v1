//
// Created by 蒋治国 on 2018-12-16.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation

class TimeHelper {
    
    public static func getTimeShowLocal_MD_YMD_ByGo(_ time: Int64) -> String {
        let year = StringUtils.getString("year")
        let month = StringUtils.getString("month")
        let day = StringUtils.getString("dayR")
        var format: String
        if DateUtils.isSameYear(DateUtils.getCurrentInt64(), time) {
            // 同一年
            format = "MM" + month + "dd" + day
        } else {
            // 不同年
            format = "yyyy" + year + " MM" + month + " dd" + day
        }
        return DateUtils.getStr(time, format)
    }
    
    public static func getTimeShowLine_HM_MD_YMD_ByGo(_ time: Int64) -> String {
        var format: String
        if DateUtils.isSameDay(DateUtils.getCurrentInt64(), time) {
            // 同一天
            format = DateUtils.FORMAT_H_M
        } else if DateUtils.isSameYear(DateUtils.getCurrentInt64(), time) {
            // 同一年
            format = DateUtils.FORMAT_LINE_M_D
        } else {
            // 不同年
            format = DateUtils.FORMAT_LINE_Y_M_D
        }
        return DateUtils.getStr(time, format)
    }
    
    public static func getTimeShowLine_HM_MDHM_YMDHM_ByGo(_ time: Int64) -> String {
        var format: String
        if DateUtils.isSameDay(DateUtils.getCurrentInt64(), time) {
            // 同一天
            format = DateUtils.FORMAT_H_M
        } else if DateUtils.isSameYear(DateUtils.getCurrentInt64(), time) {
            // 同一年
            format = DateUtils.FORMAT_LINE_M_D_H_M
        } else {
            // 不同年
            format = DateUtils.FORMAT_LINE_Y_M_D_H_M
        }
        return DateUtils.getStr(time, format)
    }
    
}
