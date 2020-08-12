//
// Created by 蒋治国 on 2018-12-16.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation
import CoreLocation

class LocationInfo {
    var longitude: Double? // 经度
    var latitude: Double? // 纬度
    var country: String = "" // 国
    var province: String = "" // 省
    var city: String = "" // 城/市
    var district: String = "" //区
    var street: String = "" // 详
    var address: String = "" // 所有总和
    var cityId: String = "" // 城市编号
}

class LocationUtils {

    // 检查权限
    public static func isLocationEnable() -> Bool {
        let isUserOK = (CLLocationManager.authorizationStatus() != .denied) && (CLLocationManager.authorizationStatus() != .notDetermined) && (CLLocationManager.authorizationStatus() != .restricted)
        return CLLocationManager.locationServicesEnabled() && isUserOK
    }

    // 获取管理类
    public static func getLocationManager() -> CLLocationManager {
        return CLLocationManager()
    }

    // 开始定位
    public static func startLocation(manager: CLLocationManager?, delegate: CLLocationManagerDelegate) {
        manager?.delegate = delegate
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        // kCLLocationAccuracyNearestTenMeters 精确到10米
        manager?.distanceFilter = 10
        manager?.requestWhenInUseAuthorization()
        //requestAlwaysAuthorization;
        manager?.startUpdatingLocation()
    }

    public static func stopLocation(manager: CLLocationManager?) {
        manager?.stopUpdatingLocation()
    }

    // 转换location为封装好的info
    public static func convertLocation2Info(location: CLLocation?, finish: @escaping (LocationInfo?) -> Void) {
        if location == nil {
            finish(nil)
            return
        }
        let info = LocationInfo()
        info.longitude = location!.coordinate.longitude
        info.latitude = location!.coordinate.latitude

        getAddress(location: location!) { (address) in
            info.country = address?.country ?? ""
            info.province = address?.province ?? ""
            info.city = address?.city ?? ""
            info.district = address?.district ?? ""
            info.street = address?.street ?? ""
            info.cityId = address?.cityId ?? ""
            info.address = address?.address ?? ""
            finish(info)
        }
    }

    /// 转换location为address
    private static func getAddress(location: CLLocation, finish: @escaping (LocationInfo?) -> Void) {
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemark, error) in
            if (error == nil) {
                let mark = placemark?.first
                if mark == nil {
                    finish(nil)
                    return
                }
                let info = LocationInfo()
                info.country = mark?.country ?? ""
                info.province = mark?.administrativeArea ?? ""
                info.city = mark?.locality ?? ""
                info.district = mark?.subLocality ?? ""
                info.street = mark?.thoroughfare ?? ""
                info.cityId = ""
                let a1 = info.country + info.province + info.city
                let a2 = info.district + info.street
                info.address = a1 + a2
                finish(info)
            } else {
                LogUtils.e(tag: "LocationUtils", method: "getAddress", error as Any)
                finish(nil)
            }
        }
    }

    // 两点距离
    public static func distance(lon1: Double, lat1: Double, lon2: Double, lat2: Double) -> Double {
        let l1 = CLLocation(latitude: lat1, longitude: lon1)
        let l2 = CLLocation(latitude: lat2, longitude: lon2)
        return l1.distance(from: l2)
    }

}
