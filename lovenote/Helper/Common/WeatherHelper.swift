//
// Created by 蒋治国 on 2018-12-16.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation

class WeatherHelper {
    
    public static func getIconByAMap(show: String) -> String {
        if StringUtils.isEmpty(show) {
            return show
        }
        switch show {
        case "晴天", "晴": return "0"
        case "多云", "少云", "晴间多云": return "1"
        case "阴": return "2"
        case "阵雨", "强阵雨": return "3"
        case "雷阵雨", "强雷阵雨": return "4"
        case "冰雹", "雷阵雨并伴有冰雹": return "5"
        case "雨夹雪", "雨雪天气", "阵雨夹雪": return "6"
        case "雨", "小雨", "毛毛雨/细雨", "小雨-中雨": return "7"
        case "中雨", "中雨-大雨": return "8"
        case "大雨", "大雨-暴雨": return "9"
        case "暴雨", "大暴雨", "特大暴雨", "极端降雨", "暴雨-大暴雨", "大暴雨-特大暴雨": return "10"
        case "雪", "阵雪": return "13"
        case "小雪", "小雪-中雪": return "14"
        case "中雪", "中雪-大雪": return "15"
        case "大雪", "大雪-暴雪": return "16"
        case "暴雪": return "17"
        case "雾", "浓雾", "强浓雾", "轻雾", "大雾", "特强浓雾": return "18"
        case "冻雨": return "19"
        case "沙尘暴", "强沙尘暴", "龙卷风": return "20"
        case "扬沙", "浮尘": return "29"
        case "霾", "中度霾", "重度霾", "严重霾": return "45"
        case "有风", "平静", "微风", "和风", "清风", "强风/劲风", "疾风", "大风", "烈风", "风暴", "狂爆风", "飓风", "热带风暴", "热", "冷", "未知":
            return ""
        default:
            return ""
        }
    }
    
    public static func getShow(id: String?) -> String {
        if StringUtils.isEmpty(id) {
            return ""
        }
        switch id!.trimmingCharacters(in: .whitespaces) {
        case "0", "30": return StringUtils.getString("sunny")
        case "1", "31": return StringUtils.getString("cloudy")
        case "2": return StringUtils.getString("over_cast")
        case "3", "33": return StringUtils.getString("showers")
        case "13", "34": return StringUtils.getString("snow_showers")
        case "18", "32": return StringUtils.getString("fog")
        case "20", "36": return StringUtils.getString("sandstorm")
        case "29", "35": return StringUtils.getString("dust")
        case "45", "46": return StringUtils.getString("haze")
        case "4": return StringUtils.getString("thunder_shower")
        case "5": return StringUtils.getString("hail")
        case "6": return StringUtils.getString("sleet")
        case "7": return StringUtils.getString("light_rain")
        case "8": return StringUtils.getString("rain")
        case "9": return StringUtils.getString("heavy_rain")
        case "10": return StringUtils.getString("rain_storm")
        case "14": return StringUtils.getString("light_snow")
        case "15": return StringUtils.getString("snow")
        case "16": return StringUtils.getString("heavy_snow")
        case "17": return StringUtils.getString("blizzard")
        case "19": return StringUtils.getString("freezing_rain")
        default: return "";
        }
    }
    
    public static func getIcon(id: String?) -> String {
        if StringUtils.isEmpty(id) {
            return "w0"
        }
        switch id!.trimmingCharacters(in: .whitespaces) {
        case "0": return "w0"
        case "1": return "w1"
        case "2": return "w2"
        case "3": return "w3"
        case "4": return "w4"
        case "5": return "w5"
        case "6": return "w6"
        case "7": return "w7"
        case "8": return "w8"
        case "9": return "w9"
        case "10": return "w10"
        case "13": return "w13"
        case "14": return "w14"
        case "15": return "w15"
        case "16": return "w16"
        case "17": return "w17"
        case "18": return "w18"
        case "19": return "w19"
        case "20": return "w20"
        case "29": return "w29"
        case "30": return "w30"
        case "31": return "w31"
        case "32": return "w32"
        case "33": return "w33"
        case "34": return "w34"
        case "35": return "w35"
        case "36": return "w36"
        case "44": return "w44"
        case "45": return "w45"
        case "46": return "w46"
        default: return "w0";
        }
    }
    
}
