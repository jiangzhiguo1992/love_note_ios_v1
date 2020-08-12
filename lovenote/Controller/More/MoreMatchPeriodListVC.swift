//
//  MoreMatchPeriodListVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/5/8.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import XLPagerTabStrip

class MoreMatchPeriodListVC: BaseVC, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    
    // view
    private var tableView: UITableView!
    
    // var
    private var height = CGFloat(0)
    private var itemInfo: IndicatorInfo = IndicatorInfo(title: StringUtils.getString("old_period"))
    private var kind = 0
    private var periodList: [MatchPeriod]?
    private var page = 0
    
    public static func get(height: CGFloat, kind: Int) -> MoreMatchPeriodListVC {
        let vc = MoreMatchPeriodListVC(nibName: nil, bundle: nil)
        vc.height = height
        vc.kind = kind
        return vc
    }
    
    override func initView() {
        // 不设置的话parent顶部会没有nav
        self.navigationBarShow = true
        
        // tableView
        let tableFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.height)
        tableView = ViewUtils.getTableView(target: self, frame: tableFrame, cellCls: MoreMatchPeriodCell.self, id: MoreMatchPeriodCell.ID)
        initScrollState(scroll: tableView, clipTopBar: true, canEmpty: true, emptyColor: ColorHelper.getFontGrey(),
                        canRefresh: true, refreshBlock: { self.refreshData(more: false) },
                        canMore: true) { self.refreshData(more: true) }
        
        // view
        self.view.addSubview(tableView)
    }
    
    override func initData() {
        // refresh
        startScrollDataSet(scroll: tableView)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    private func refreshData(more: Bool) {
        page = more ? page + 1 : 0
        // api
        let api = Api.request(.moreMatchPeriodListGet(kind: kind, page: page),
                              success: { (_, _, data) in
                                MoreMatchPeriodCell.refreshHeightMap(refresh: !more, start: self.periodList?.count ?? 0, dataList: data.matchPeriodList)
                                if !more {
                                    self.periodList = data.matchPeriodList
                                    self.endScrollDataRefresh(scroll: self.tableView, msg: data.show, count: data.matchPeriodList?.count ?? 0)
                                } else {
                                    self.periodList = (self.periodList ?? [MatchPeriod]()) + (data.matchPeriodList ?? [MatchPeriod]())
                                    self.endScrollDataMore(scroll: self.tableView, msg: data.show, count: data.matchPeriodList?.count ?? 0)
                                }
        }, failure: { (_, msg, _) in
            self.endScrollState(scroll: self.tableView, msg: msg)
        })
        pushApi(api)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return periodList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MoreMatchPeriodCell.getCellHeight(view: tableView, indexPath: indexPath, dataList: periodList)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return MoreMatchPeriodCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: periodList)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MoreMatchPeriodCell.goWorkList(view: tableView, indexPath: indexPath, dataList: periodList)
    }
    
}
