//
//  MapSelectVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/9.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import AMapSearchKit

class MapSelectVC: BaseVC, UITableViewDelegate, UITableViewDataSource, MAMapViewDelegate, AMapSearchDelegate {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var mapHeight = ScreenUtils.heightFit(250)
    
    // view
    private var vMap: MAMapView!
    private var tableView: UITableView!
    
    // var
    lazy var address: String = ""
    lazy var longitude: Double = 0
    lazy var latitude: Double = 0
    lazy var selectIndex = -1
    lazy var moveWithSearch = true
    lazy var searchAPI = AMapSearchAPI()
    private var locationMe: LocationInfo?
    private var locationSelect: LocationInfo?
    private var poiList: [AMapPOI]?
    
    public static func pushVC(address: String?, lon: Double?, lat: Double?) {
        if !AmapHelper.checkLocationEnable() {
            return
        }
        AppDelegate.runOnMainAsync {
            let vc = MapSelectVC(nibName: nil, bundle: nil)
            vc.address = address ?? ""
            vc.longitude = lon ?? 0
            vc.latitude = lat ?? 0
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "please_select_address")
        let barItemComplete = UIBarButtonItem(title: StringUtils.getString("complete"), style: .plain, target: self, action: #selector(notifySelectComplete))
        barItemComplete.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        let barItemSearch = UIBarButtonItem(image: UIImage(named: "ic_search_white_24dp"), style: .plain, target: self, action: #selector(notifyGoSearch))
        self.navigationItem.setRightBarButtonItems([barItemComplete, barItemSearch], animated: true)
        
        // map
        vMap = MAMapView()
        vMap.frame.size = CGSize(width: self.view.frame.size.width, height: mapHeight)
        vMap.frame.origin = CGPoint(x: 0, y: 0)
        vMap.delegate = self
        
        vMap.showsScale = true
        vMap.scaleOrigin = CGPoint(x: margin, y: margin)
        vMap.showsCompass = true
        vMap.compassOrigin = CGPoint(x: self.view.frame.size.width - vMap.compassSize.width - margin, y: margin)
        
        vMap.isShowsUserLocation = true
        vMap.userTrackingMode = .follow
        vMap.zoomLevel = 17
        
        // tableView
        let tableFrame = CGRect(x: 0, y: vMap.frame.origin.y + vMap.frame.size.height - RootVC.get().getTopBarHeight(),
                                width: self.view.frame.size.width, height: self.view.frame.size.height - vMap.frame.size.height)
        tableView = ViewUtils.getTableView(target: self, frame: tableFrame, cellCls: MapSelectCell.self, id: MapSelectCell.ID)
        initScrollState(scroll: tableView, clipTopBar: false, canEmpty: true, emptyColor: ColorHelper.getFontGrey(),
                        canRefresh: true, refreshBlock: {(
                            self.mapView(self.vMap, mapDidMoveByUser: false)
                            )}, canMore: false, moreBlock: nil)
        
        self.view.addSubview(vMap)
        self.view.addSubview(tableView)
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyMapSelect), name: NotifyHelper.TAG_MAP_SELECT)
        // amap
        AMapServices.shared().enableHTTPS = true
        searchAPI?.delegate = self
        moveWithSearch = true
        // 传入位置
        var info: LocationInfo?
        if !StringUtils.isEmpty(address) && (longitude != 0 && latitude != 0) {
            info = LocationInfo()
            info?.longitude = longitude
            info?.latitude = latitude
            info?.address = address
            setLocationSelect(info: info, move: true, search: true)
        }
    }
    
    // 前往搜索
    @objc func notifyGoSearch(notify: NSNotification) {
        MapSearchVC.pushVC(lon: locationMe?.longitude ?? 0, lat: locationMe?.latitude ?? 0)
    }
    
    // 右上角选择
    @objc func notifySelectComplete(notify: NSNotification) {
        if locationSelect == nil {
            ToastUtils.show(StringUtils.getString("please_select_address"))
            return
        }
        NotifyHelper.post(NotifyHelper.TAG_MAP_SELECT, obj: locationSelect)
        // RootVC.get().popBack()
    }
    
    // 选择完成退出
    @objc func notifyMapSelect(notify: NSNotification) {
        // 修改选中位置
        //setLocationSelect(info, true, true);
        // 地址搜索成功，退出界面
        
        AppDelegate.runOnMainAsync {
            RootVC.get().popBack()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poiList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MapSelectCell.getCellHeight(view: tableView, indexPath: indexPath, dataList: poiList)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let select = indexPath.row == selectIndex
        return MapSelectCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: poiList, select: select)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 修改选中位置，移动，但不搜索
        let info = onSelectCell(row: indexPath.row)
        setLocationSelect(info: info, move: true, search: false)
    }
    
    // 选中效果
    func onSelectCell(row: Int) -> LocationInfo? {
        let foreSelectIndex = selectIndex
        selectIndex = row
        if foreSelectIndex >= 0 && foreSelectIndex < (poiList?.count ?? 0) {
            tableView.reloadRows(at: [IndexPath(row: foreSelectIndex, section: 0)], with: .automatic)
        }
        if selectIndex < 0 || selectIndex >= (poiList?.count ?? 0) {
            return nil
        }
        tableView.reloadRows(at: [IndexPath(row: selectIndex, section: 0)], with: .automatic)
        // locationInfo
        let poi = poiList?[selectIndex]
        let info = LocationInfo()
        info.longitude = Double(poi?.location.longitude ?? 0)
        info.latitude = Double(poi?.location.latitude ?? 0)
        info.address = poi?.name ?? poi?.address ?? ""
        info.cityId = poi?.adcode ?? ""
        return info
    }
    
    // 用户位置更新
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        // 只检测第一次
        let longitude = userLocation.location?.coordinate.longitude ?? userLocation.coordinate.longitude
        let latitude = userLocation.location?.coordinate.latitude ?? userLocation.coordinate.latitude
        if (locationMe == nil || locationMe!.longitude == 0 || locationMe!.latitude == 0) && (longitude != 0 || latitude != 0) {
            locationMe = LocationInfo()
            locationMe!.longitude = longitude
            locationMe!.latitude = latitude
            // 添加大头针
            let pointCenter = CGPoint(x: mapView.center.x, y: mapView.center.y)
            let pointAnno = AmapHelper.getAnnotationPoint(longitude: locationMe!.longitude ?? 0, latitude: locationMe!.latitude ?? 0, lockPoint: pointCenter)
            mapView.addAnnotation(pointAnno)
            // 手动调用，多余但必须的操作
            self.mapView(mapView, mapDidMoveByUser: true)
        }
    }
    
    // 大头针回调
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAPointAnnotation.self) {
            return AmapHelper.getAnnotationView(mapView: mapView, viewFor: annotation)
        }
        return nil
    }
    
    // 地图拖动回调
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        if !wasUserAction {
            endScrollState(scroll: tableView)
            return
        }
        if !moveWithSearch {
            moveWithSearch = true
            endScrollState(scroll: tableView)
            return
        }
        // 将指定view坐标系的坐标转换为经纬度，从而进行反地理编码
        let moveCoor = mapView.convert(CGPoint(x: mapView.center.x, y: mapView.center.y), toCoordinateFrom: mapView)
        if moveCoor.longitude == 0 && moveCoor.latitude == 0 {
            ToastUtils.show(StringUtils.getString("search_location_no_exist"))
            endScrollState(scroll: tableView)
            return
        }
        // 开始搜索
        let request = AmapHelper.getSearchReGeocodeRequest(longitude: moveCoor.longitude, latitude: moveCoor.latitude)
        searchAPI?.aMapReGoecodeSearch(request)
        startScrollDataSet(scroll: tableView)
    }
    
    // 移动搜索成功
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        // table
        poiList = response.regeocode.pois
        MapSelectCell.refreshHeightMap(refresh: true, start: 0, dataList: poiList)
        endScrollDataRefresh(scroll: tableView, msg: "", count: poiList?.count ?? 0)
        // 取消选中的数据
        _ = onSelectCell(row: -1)
        setLocationSelect(info: nil, move: false, search: false)
    }
    
    // 移动搜索失败
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        ToastUtils.show(StringUtils.getString("location_error"))
        endScrollState(scroll: tableView)
    }
    
    // 修改选中位置，地图移动 + 搜索列表
    func setLocationSelect(info: LocationInfo?, move: Bool, search: Bool) {
        locationSelect = info
        if locationSelect == nil {
            return
        }
        if move {
            moveWithSearch = search
            vMap.setCenter(CLLocationCoordinate2D(latitude: locationSelect!.latitude ?? 0, longitude: locationSelect!.longitude ?? 0), animated: true)
            vMap.setZoomLevel(17, animated: true)
        }
    }
    
}
