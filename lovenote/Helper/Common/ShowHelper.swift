//
//  ShowHelper.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/27.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation

class ShowHelper {
    
    public static func getShowCount2Thousand(_ count: Int?) -> String {
        if count == nil {
            return "0"
        }
        let unit = 10000 // 万
        if abs(count!) < unit {
            return String(count!)
        }
        let show = Double(count!) / Double(unit)
        return StringUtils.getString("holder_thousand_point1", arguments: [show])
    }
    
    public static func getShowDistance(_ distance: Double?) -> String {
        var distanceShow: String = "-m"
        if distance == nil {
            return distanceShow
        }
        if distance! >= 1000 * 100 {
            let km: Double = distance! / 1000
            distanceShow = String(format: "%.0fkm", arguments: [km])
        } else if distance! >= 1000 {
            let km: Double = distance! / 1000
            distanceShow = String(format: "%.1fkm", arguments: [km])
        } else if distance! >= 0 {
            distanceShow = String(format: "%.0fm", arguments: [distance!])
        }
        return distanceShow
    }
    
    public static func getDurationShow(_ duration: Int) -> String {
        var secShow = ""
        let sec = duration % Int(DateUtils.UNIT_MIN / DateUtils.UNIT_SEC)
        
        if (sec < 1) {
            secShow = "00"
        } else if (sec < 10) {
            secShow = "0" + "\(sec)"
        } else {
            secShow = "\(sec)"
        }
        var minShow = ""
        let min = duration / Int(DateUtils.UNIT_MIN / DateUtils.UNIT_SEC)
        if (min < 1) {
            minShow = "00"
        } else if (min < 10) {
            minShow = "0" + "\(min)"
        } else {
            minShow = "\(min)"
        }
        return minShow + ":" + secShow
    }
    
    public static func getBetweenTimeGoneShow(between: Int64) -> String {
        var time = StringUtils.getString("just_now")
        if between >= DateUtils.UNIT_YEAR {
            time = "\((between / DateUtils.UNIT_YEAR))" + StringUtils.getString("year") + StringUtils.getString("before")
        } else if between >= DateUtils.UNIT_MONTH {
            time = "\((between / DateUtils.UNIT_MONTH))" + StringUtils.getString("month") + StringUtils.getString("before")
        } else if between >= DateUtils.UNIT_DAY {
            time = "\((between / DateUtils.UNIT_DAY))" + StringUtils.getString("dayT") + StringUtils.getString("before")
        } else if between >= DateUtils.UNIT_HOUR {
            time = "\((between / DateUtils.UNIT_HOUR))" + StringUtils.getString("hour") + StringUtils.getString("before")
        } else if between >= DateUtils.UNIT_MIN * 5 {
            time = "\((between / DateUtils.UNIT_MIN))" + StringUtils.getString("minute") + StringUtils.getString("before")
        }
        return time
    }
    
    public static func getPostTagListShow(post: Post?, kind: Bool, subKind: Bool) -> [String] {
        var showList = [String]()
        if post == nil {
            return showList
        }
        if post!.top {
            showList.append(StringUtils.getString("top"))
        }
        if kind || subKind {
            let kindInfo = ListHelper.getPostKindInfo(kind: post!.kind)
            let subKindInfo = ListHelper.getPostSubKindInfo(kindInfo: kindInfo, subKind: post!.subKind)
            if (kind && kindInfo != nil) {
                showList.append(kindInfo!.name)
            }
            if (subKind && subKindInfo != nil) {
                showList.append(subKindInfo!.name)
            }
        }
        if post!.official {
            showList.append(StringUtils.getString("administrators"))
        }
        if post!.well {
            showList.append(StringUtils.getString("well"))
        }
        if post!.hot {
            showList.append(StringUtils.getString("hot"))
        }
        if post!.mine {
            showList.append(StringUtils.getString("me_de"))
        }
        if post!.our && !post!.mine {
            showList.append(StringUtils.getString("ta_de"))
        }
        if post!.report {
            showList.append(StringUtils.getString("already_report"))
        }
        return showList
    }
    
}
