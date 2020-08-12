//
//  AmapHelper.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/16.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import AMapFoundationKit
import AMapLocationKit
import AMapSearchKit

// import MAMapKit

class AmapHelper {
    
    // 初始化
    public static func initApp() {
        AMapServices.shared().apiKey = AppUtils.getInfoString(key: "a_map_api_key")
    }
    
    // 权限检查
    public static func checkLocationEnable() -> Bool {
        if !LocationUtils.isLocationEnable() {
            AlertHelper.showNoPermAlert()
            return false
        }
        return true
    }
    
    // 定位，单次
    public static func startLocationOnce(manager: AMapLocationManager, complete: ((LocationInfo) -> ())?) {
        if !checkLocationEnable() {
            return
        }
        // 初始化
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.locationTimeout = 10
        manager.reGeocodeTimeout = 10
        // 开始定位
        manager.requestLocation(withReGeocode: true, completionBlock: { (location, reGeocode, error) in
            let err = error as NSError?
            if err?.code == AMapLocationErrorCode.locateFailed.rawValue {
                //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                LogUtils.w(tag: "LocationHelper", method: "startLocationOnce", "定位错误:{\(err!.code) - \(err!.localizedDescription)}")
                ToastUtils.show(StringUtils.getString("location_error"))
                return
            } else if err?.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                || err?.code == AMapLocationErrorCode.timeOut.rawValue
                || err?.code == AMapLocationErrorCode.cannotFindHost.rawValue
                || err?.code == AMapLocationErrorCode.badURL.rawValue
                || err?.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                || err?.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                LogUtils.w(tag: "LocationHelper", method: "startLocationOnce", "逆地理编码错误:{\(err!.code) - \(err!.localizedDescription)}")
                ToastUtils.show(StringUtils.getString("location_error"))
                return
            }
            if location == nil || reGeocode == nil {
                ToastUtils.show(StringUtils.getString("location_error"))
                return
            }
            let info = LocationInfo()
            info.longitude = location?.coordinate.longitude // 经度
            info.latitude = location?.coordinate.latitude // 纬度
            info.country = String(reGeocode?.country ?? "") // 国家
            info.province = String(reGeocode?.province ?? "") // 省份
            info.city = String(reGeocode?.city ?? "") // 城市
            info.district = String(reGeocode?.district ?? "") // 城区
            info.street = String(reGeocode?.street ?? "") // 街道
            info.cityId = String(reGeocode?.adcode ?? "") // 城市编号
            info.address = String(reGeocode?.formattedAddress ?? "") // 详细地址
            if StringUtils.isEmpty(info.address) {
                info.address = info.province + info.city + info.district + info.street
            }
            // 回调
            AppDelegate.runOnMainAsync {
                complete?(info)
            }
        })
    }
    
    // 两点距离
    public static func distance(lon1: Double, lat1: Double, lon2: Double, lat2: Double) -> Double {
        let point1 = MAMapPointForCoordinate(CLLocationCoordinate2D(latitude: lat1, longitude: lon1))
        let point2 = MAMapPointForCoordinate(CLLocationCoordinate2D(latitude: lat2, longitude: lon2))
        return MAMetersBetweenMapPoints(point1, point2)
    }
    
    
    // 大头针(坐标)
    public static func getAnnotationPoint(longitude: Double, latitude: Double, address: String? = nil, lockPoint: CGPoint? = nil) -> MAPointAnnotation {
        let pointAnnotation = MAPointAnnotation()
        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        pointAnnotation.title = address
        pointAnnotation.subtitle = StringUtils.getString("lon_lat_colon") + "\(longitude) , \(latitude)"
        if lockPoint != nil {
            pointAnnotation.isLockedToScreen = true
            pointAnnotation.lockedScreenPoint = lockPoint!
        }
        return pointAnnotation
    }
    
    // 大头针(视图)
    public static func getAnnotationView(mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAPinAnnotationView {
        let pointReuseIdentifier = "pointReuseIdentifier"
        var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIdentifier) as! MAPinAnnotationView?
        if annotationView == nil {
            annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIdentifier)
        }
        annotationView!.canShowCallout = true
        annotationView!.animatesDrop = true
        annotationView!.isDraggable = false
        return annotationView!
    }
    
    // 搜索请求(关键词)
    public static func getSearchKeywordRequest(keyword: String?, city: String? = nil) -> AMapPOIKeywordsSearchRequest {
        let request = AMapPOIKeywordsSearchRequest()
        // request.location = AMapGeoPoint()
        request.keywords = keyword ?? ""
        request.city = city
        request.offset = 100
        request.page = 1
        request.cityLimit = !StringUtils.isEmpty(city)
        request.requireExtension = true
        request.requireSubPOIs = true
        return request
    }
    
    // 搜索请求(周边)
    public static func getSearchAroundRequest(longitude: Double, latitude: Double) -> AMapPOIAroundSearchRequest {
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(latitude), longitude: CGFloat(longitude))
        // request.keywords = address
        // request.city = info?.city
        request.offset = 100
        request.page = 1
        // request.cityLimit = false
        request.requireExtension = true
        request.requireSubPOIs = true
        return request
    }
    
    // 搜索请求(逆地理)
    public static func getSearchReGeocodeRequest(longitude: Double, latitude: Double, radius: Int? = nil) -> AMapReGeocodeSearchRequest {
        let request = AMapReGeocodeSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(latitude), longitude: CGFloat(longitude))
        if radius != nil { request.radius = radius! }
        request.requireExtension = true
        return request
    }
    
    // 天气查询(实况)
    public static func getWeatherToday(city: String?) -> AMapWeatherSearchRequest {
        let request = AMapWeatherSearchRequest()
        request.city = city
        request.type = AMapWeatherType.live
        return request
    }
    
    // 天气查询(预报)
    public static func getWeatherForecast(city: String?) -> AMapWeatherSearchRequest {
        let request = AMapWeatherSearchRequest()
        request.city = city
        request.type = AMapWeatherType.forecast
        return request
    }
    
}
