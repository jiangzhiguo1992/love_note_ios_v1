//
//  CouplePlaceVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/19.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class CouplePlaceVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    // view
    private var tableView: UITableView!
    
    // var
    private var placeList: [Place]?
    private var page = 0
    
    public static func pushVC() {
        if !AmapHelper.checkLocationEnable() {
            return
        }
        if UserHelper.isCoupleBreak(couple: UDHelper.getCouple()) {
            CouplePairVC.pushVC()
            return
        }
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(CouplePlaceVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "place_info")
        let barHelp = UIBarButtonItem(image: UIImage(named: "ic_help_outline_white_24dp"), style: .plain, target: self, action: #selector(targetGoHelp))
        self.navigationItem.rightBarButtonItems = [barHelp]
        
        // tableView
        tableView = ViewUtils.getTableView(target: self, frame: self.view.bounds, cellCls: CouplePlaceCell.self, id: CouplePlaceCell.ID)
        initScrollState(scroll: tableView, clipTopBar: true, canEmpty: true, emptyColor: ColorHelper.getFontGrey(),
                        canRefresh: true, refreshBlock: { self.refreshData(more: false) },
                        canMore: true) { self.refreshData(more: true)
        }
        
        // view
        self.view.addSubview(tableView)
    }
    
    override func initData() {
        startScrollDataSet(scroll: tableView)
    }
    
    private func refreshData(more: Bool) {
        page = more ? page + 1 : 0
        // api
        let api = Api.request(.couplePlaceListGet(page: page),
                              success: { (_, _, data) in
                                CouplePlaceCell.refreshHeightMap(refresh: !more, start: self.placeList?.count ?? 0, dataList: data.placeList)
                                if !more {
                                    self.placeList = data.placeList
                                    self.endScrollDataRefresh(scroll: self.tableView, msg: data.show, count: data.placeList?.count ?? 0)
                                } else {
                                    self.placeList = (self.placeList ?? [Place]()) + (data.placeList ?? [Place]())
                                    self.endScrollDataMore(scroll: self.tableView, msg: data.show, count: data.placeList?.count ?? 0)
                                }
        }, failure: { (_, msg, _) in
            self.endScrollState(scroll: self.tableView, msg: msg)
        })
        pushApi(api)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CouplePlaceCell.getCellHeight(view: tableView, indexPath: indexPath, dataList: placeList)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return CouplePlaceCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: placeList)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let place = placeList?[indexPath.row] {
            MapShowVC.pushVC(address: place.address, lon: place.longitude, lat: place.latitude)
        }
    }
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC(HelpVC.INDEX_COUPLE_PLACE)
    }
    
}
