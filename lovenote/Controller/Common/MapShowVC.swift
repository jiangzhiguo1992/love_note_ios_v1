//
//  MapShowVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/21.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import AMapSearchKit

class MapShowVC: BaseVC, MAMapViewDelegate, AMapSearchDelegate {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    
    // view
    private var vMap: MAMapView!
    
    // var
    lazy var address: String = ""
    lazy var longitude: Double = 0
    lazy var latitude: Double = 0
    lazy var searchAPI = AMapSearchAPI()
    
    public static func pushVC(address: String?, lon: Double?, lat: Double?) {
        if !AmapHelper.checkLocationEnable() {
            return
        }
        if StringUtils.isEmpty(address) && (lon == 0 || lat == 0) {
            ToastUtils.show(StringUtils.getString("no_location_info_cant_go_map"))
            return
        }
        AppDelegate.runOnMainAsync {
            let vc = MapShowVC(nibName: nil, bundle: nil)
            vc.address = address ?? ""
            vc.longitude = lon ?? 0
            vc.latitude = lat ?? 0
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "map")
        // map
        vMap = MAMapView()
        vMap.frame.size = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
        vMap.frame.origin = CGPoint(x: 0, y: 0)
        vMap.delegate = self
        // 控件
        vMap.showsScale = true
        vMap.scaleOrigin = CGPoint(x: margin, y: margin)
        vMap.showsCompass = true
        vMap.compassOrigin = CGPoint(x: self.view.frame.size.width - vMap.compassSize.width - margin, y: margin)
        // 我的位置
        vMap.isShowsUserLocation = true
        vMap.userTrackingMode = .none
        vMap.zoomLevel = 17
        
        self.view.addSubview(vMap)
    }
    
    override func initData() {
        AMapServices.shared().enableHTTPS = true
        // 目标位置
        if longitude != 0 && latitude != 0 {
            // 根据经纬度
            moveByPoint(longitude: longitude, latitude: latitude)
        } else if !StringUtils.isEmpty(address) {
            // 根据地址，关键词搜索
            searchAPI?.delegate = self
            let request = AmapHelper.getSearchKeywordRequest(keyword: address)
            searchAPI?.aMapPOIKeywordsSearch(request)
        }
    }
    
    // 大头针回调
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAPointAnnotation.self) {
            return AmapHelper.getAnnotationView(mapView: mapView, viewFor: annotation)
        }
        return nil
    }
    
    // 搜索成功回调
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        if response.count <= 0 || response.pois.count <= 0 {
            self.vMap.userTrackingMode = .follow
            return
        }
        let poi = response.pois[0]
        self.moveByPoint(longitude: Double(poi.location!.longitude), latitude: Double(poi.location!.latitude))
    }
    
    // 搜索失败回调
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        ToastUtils.show(StringUtils.getString("location_error"))
    }
    
    // 目标位置移动
    private func moveByPoint(longitude: Double, latitude: Double) {
        let pointAnnotation = AmapHelper.getAnnotationPoint(longitude: longitude, latitude: latitude, address: address)
        vMap.addAnnotation(pointAnnotation)
        vMap.setCenter(CLLocationCoordinate2D(latitude: latitude, longitude: longitude), animated: false)
    }
    
}
