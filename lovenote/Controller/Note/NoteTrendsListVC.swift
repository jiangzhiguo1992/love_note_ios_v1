//
//  NoteTrendsListVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/2/22.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteTrendsListVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    // view
    private var tableView: UITableView!
    
    // var
    private var trendsList: [Trends]?
    private var createAt: Int64 = 0
    private var page = 0
    
    public static func pushVC() {
        if UserHelper.isCoupleBreak(couple: UDHelper.getCouple()) {
            // 无效配对
            CouplePairVC.pushVC()
            return
        }
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(NoteTrendsListVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "trends")
        
        // tableView
        tableView = ViewUtils.getTableView(target: self, frame: self.view.bounds, cellCls: NoteTrendsCell.self, id: NoteTrendsCell.ID)
        initScrollState(scroll: tableView, clipTopBar: true, canEmpty: true, emptyColor: ColorHelper.getFontGrey(),
                        canRefresh: true, refreshBlock: { self.refreshData(more: false) },
                        canMore: true) { self.refreshData(more: true)
        }
        
        // view
        let gradient = ViewHelper.getGradientPrimaryTrans(frame: self.view.bounds)
        self.view.layer.insertSublayer(gradient, at: 0)
        self.view.addSubview(tableView)
    }
    
    override func initData() {
        // count
        let commonCount = UDHelper.getCommonCount()
        commonCount.noteTrendsNewCount = 0
        UDHelper.setCommonCount(commonCount)
        // data
        startScrollDataSet(scroll: tableView)
    }
    
    private func refreshData(more: Bool) {
        page = more ? page + 1 : 0
        if !more {
            createAt = DateUtils.getCurrentInt64()
        }
        // api
        let api = Api.request(.noteTrendsListGet(create: createAt, page: page),
                              success: { (_, _, data) in
                                if !more {
                                    self.trendsList = data.trendsList
                                    self.endScrollDataRefresh(scroll: self.tableView, msg: data.show, count: data.trendsList?.count ?? 0)
                                } else {
                                    self.trendsList = (self.trendsList ?? [Trends]()) + (data.trendsList ?? [Trends]())
                                    self.endScrollDataMore(scroll: self.tableView, msg: data.show, count: data.trendsList?.count ?? 0)
                                }
        }, failure: { (_, msg, _) in
            self.endScrollState(scroll: self.tableView, msg: msg)
        })
        pushApi(api)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NoteTrendsCell.getCellHeight(view: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return NoteTrendsCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: trendsList, target: self, action: #selector(targetGo))
    }
    
    @objc func targetGo(sender: UIGestureRecognizer) {
        NoteTrendsCell.go(view: sender.view, dataList: trendsList)
    }
    
}

