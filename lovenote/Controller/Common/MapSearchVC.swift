//
//  MapSearchVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/15.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import AMapSearchKit

class MapSearchVC: BaseVC, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, AMapSearchDelegate {
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    
    // view
    private var sbAddress: UISearchBar!
    private var tableView: UITableView!
    
    // var
    lazy var longitude: Double = 0
    lazy var latitude: Double = 0
    lazy var searchAPI = AMapSearchAPI()
    private var poiList: [AMapPOI]?
    
    public static func pushVC(lon: Double?, lat: Double?) {
        if !AmapHelper.checkLocationEnable() {
            return
        }
        AppDelegate.runOnMainAsync {
            let vc = MapSearchVC(nibName: nil, bundle: nil)
            vc.longitude = lon ?? 0
            vc.latitude = lat ?? 0
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "")
        let vNaviBar = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: ScreenUtils.getTopStatusHeight()))
        vNaviBar.backgroundColor = ThemeHelper.getColorPrimary()
        
        // searchBar
        let hint = StringUtils.getString("please_input_search_address_remember_get_province")
        let searchFrame = CGRect(x: 0, y: vNaviBar.frame.origin.y + vNaviBar.frame.size.height, width: self.view.frame.size.width, height: 0)
        sbAddress = ViewHelper.getSearchBar(delegate: self, frame: searchFrame, placeholder: hint)
        HoldTextFiledDelete = false // 记得取消tf的代理
        
        // tableView
        let tableFrame = CGRect(x: 0, y: sbAddress.frame.origin.y + sbAddress.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height - sbAddress.frame.origin.y - sbAddress.frame.size.height)
        tableView = ViewUtils.getTableView(target: self, frame: tableFrame, cellCls: MapSearchCell.self, id: MapSearchCell.ID)
        initScrollState(scroll: tableView, clipTopBar: false, canEmpty: true, emptyColor: ColorHelper.getFontGrey(),
                        canRefresh: true, refreshBlock: {(
                            self.startSearch(keyword: self.sbAddress.text)
                            )}, canMore: false, moreBlock: nil)
        
        self.view.addSubview(vNaviBar)
        self.view.addSubview(sbAddress)
        self.view.addSubview(tableView)
    }
    
    override func initData() {
        searchAPI?.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poiList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MapSearchCell.getCellHeight(view: tableView, indexPath: indexPath, dataList: poiList)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return MapSearchCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: poiList)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let poi = poiList?[indexPath.row] {
            let info = LocationInfo()
            info.longitude = Double(poi.location.longitude)
            info.latitude = Double(poi.location.latitude)
            info.address = poi.name ?? poi.address
            info.cityId = poi.adcode
            // notify
            NotifyHelper.post(NotifyHelper.TAG_MAP_SELECT, obj: info)
            RootVC.get().popBack()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        startSearch(keyword: searchBar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        RootVC.get().popBack()
    }
    
    // 开始搜索
    func startSearch(keyword: String?) {
        if StringUtils.isEmpty(keyword) {
            ToastUtils.show(StringUtils.getString("please_input_search_content"))
            return
        }
        let request = AmapHelper.getSearchKeywordRequest(keyword: keyword)
        searchAPI?.aMapPOIKeywordsSearch(request)
        startScrollDataSet(scroll: tableView)
    }
    
    // 搜索成功回调
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        // table
        poiList = response.pois
        MapSelectCell.refreshHeightMap(refresh: true, start: 0, dataList: poiList)
        endScrollDataRefresh(scroll: tableView, msg: "", count: poiList?.count ?? 0)
    }
    
    // 搜索失败回调
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        ToastUtils.show(StringUtils.getString("location_search_fail"))
        endScrollState(scroll: tableView)
    }
    
}
