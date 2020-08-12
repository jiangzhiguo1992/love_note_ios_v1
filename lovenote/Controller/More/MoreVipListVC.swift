//
//  VipListVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/23.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class MoreVipListVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    // view
    private var tableView: UITableView!
    
    // var
    private var vipList: [Vip]?
    private var page = 0
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(MoreVipListVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "buy_history")
        
        // tableView
        tableView = ViewUtils.getTableView(target: self, frame: self.view.bounds, cellCls: MoreVipCell.self, id: MoreVipCell.ID)
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
        let api = Api.request(.moreVipListGet(page: page),
                              success: { (_, _, data) in
                                if !more {
                                    self.vipList = data.vipList
                                    self.endScrollDataRefresh(scroll: self.tableView, msg: data.show, count: data.vipList?.count ?? 0)
                                } else {
                                    self.vipList = (self.vipList ?? [Vip]()) + (data.vipList ?? [Vip]())
                                    self.endScrollDataMore(scroll: self.tableView, msg: data.show, count: data.vipList?.count ?? 0)
                                }
        }, failure: { (_, msg, _) in
            self.endScrollState(scroll: self.tableView, msg: msg)
        })
        pushApi(api)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vipList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MoreVipCell.getCellHeight(view: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return MoreVipCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: vipList)
    }
    
}
