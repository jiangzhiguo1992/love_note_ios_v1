//
//  MoreCoinListVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/23.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class MoreCoinListVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    // view
    private var tableView: UITableView!
    
    // var
    private var coinList: [Coin]?
    private var page = 0
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(MoreCoinListVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "get_history")
        
        // tableView
        tableView = ViewUtils.getTableView(target: self, frame: self.view.bounds, cellCls: MoreCoinCell.self, id: MoreCoinCell.ID)
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
        let api = Api.request(.moreCoinListGet(page: page),
                              success: { (_, _, data) in
                                if !more {
                                    self.coinList = data.coinList
                                    self.endScrollDataRefresh(scroll: self.tableView, msg: data.show, count: data.coinList?.count ?? 0)
                                } else {
                                    self.coinList = (self.coinList ?? [Coin]()) + (data.coinList ?? [Coin]())
                                    self.endScrollDataMore(scroll: self.tableView, msg: data.show, count: data.coinList?.count ?? 0)
                                }
        }, failure: { (_, msg, _) in
            self.endScrollState(scroll: self.tableView, msg: msg)
        })
        pushApi(api)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MoreCoinCell.getCellHeight(view: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return MoreCoinCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: coinList)
    }
    
}
