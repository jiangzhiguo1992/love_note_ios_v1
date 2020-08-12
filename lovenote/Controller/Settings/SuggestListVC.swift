//
//  SuggestListVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/5/5.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class SuggestListVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    // const
    public static let ENTRY_MINE = 0
    public static let ENTRY_FOLLOW = 1
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    
    // view
    private var tableView: UITableView!
    
    // var
    private var entry = ENTRY_MINE
    private var suggestList: [Suggest]?
    private var heightMap: [Int: CGFloat] = [Int: CGFloat]()
    private var page = 0
    
    public static func pushVC(entry: Int) {
        AppDelegate.runOnMainAsync {
            let vc = SuggestListVC(nibName: nil, bundle: nil)
            vc.entry = entry
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        var title = ""
        if entry == SuggestListVC.ENTRY_MINE {
            title = "my_push"
        } else if entry == SuggestListVC.ENTRY_FOLLOW {
            title = "my_follow"
        } else {
            title = "suggest_feedback"
        }
        initNavBar(title: title)
        
        // tableView
        tableView = ViewUtils.getTableView(target: self, frame: self.view.bounds, cellCls: SuggestCell.self, id: SuggestCell.ID)
        initScrollState(scroll: tableView, clipTopBar: true, canEmpty: true, emptyColor: ColorHelper.getFontGrey(),
                        canRefresh: true, refreshBlock: { self.refreshData(more: false) },
                        canMore: true) { self.refreshData(more: true) }
        
        // view
        self.view.addSubview(tableView)
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_SUGGEST_LIST_REFRESH)
        NotifyHelper.addObserver(self, selector: #selector(notifyListItemDelete), name: NotifyHelper.TAG_SUGGEST_LIST_ITEM_DELETE)
        NotifyHelper.addObserver(self, selector: #selector(notifyListItemRefresh), name: NotifyHelper.TAG_SUGGEST_LIST_ITEM_REFRESH)
        // data
        startScrollDataSet(scroll: tableView)
    }
    
    @objc func notifyRefresh(notify: NSNotification) {
        startScrollDataSet(scroll: tableView)
    }
    
    @objc func notifyListItemDelete(notify: NSNotification) {
        let index = ListHelper.findIndexByIdInList(list: suggestList, obj: notify.object)
        if index < 0 || suggestList == nil || suggestList!.count <= index {
            return
        }
        suggestList?.remove(at: index)
        refreshHeightMap(refresh: true, start: 0, dataList: suggestList)
        tableView?.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        endScrollState(scroll: tableView, msg: nil)
    }
    
    @objc func notifyListItemRefresh(notify: NSNotification) {
        let index = ListHelper.findIndexByIdInList(list: suggestList, obj: notify.object)
        if index < 0 || suggestList == nil || suggestList!.count <= index {
            return
        }
        suggestList?[index] = (notify.object as? Suggest) ?? Suggest()
        refreshHeightMap(refresh: true, start: 0, dataList: suggestList)
        tableView?.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func refreshData(more: Bool) {
        page = more ? page + 1 : 0
        var request = Api.setSuggestListGet(status: Suggest.STATUS_REPLY_NO, kind: Suggest.KIND_ALL, page: page)
        if entry == SuggestListVC.ENTRY_MINE {
            request = Api.setSuggestListMineGet(page: page)
        } else if entry == SuggestListVC.ENTRY_FOLLOW {
            request = Api.setSuggestListFollowGet(page: page)
        }
        // api
        let api = Api.request(request,
                              success: { (_, _, data) in
                                self.refreshHeightMap(refresh: !more, start: self.suggestList?.count ?? 0, dataList: data.suggestList)
                                if !more {
                                    self.suggestList = data.suggestList
                                    self.endScrollDataRefresh(scroll: self.tableView, msg: data.show, count: data.suggestList?.count ?? 0)
                                } else {
                                    self.suggestList = (self.suggestList ?? [Suggest]()) + (data.suggestList ?? [Suggest]())
                                    self.endScrollDataMore(scroll: self.tableView, msg: data.show, count: data.suggestList?.count ?? 0)
                                }
        }, failure: { (_, msg, _) in
            self.endScrollState(scroll: self.tableView, msg: msg)
        })
        pushApi(api)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getCellHeight(view: tableView, indexPath: indexPath, dataList: suggestList)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let height = getCellHeight(view: tableView, indexPath: indexPath, dataList: suggestList)
        return SuggestCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: suggestList, height: height)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SuggestCell.goSuggestDetail(view: tableView, indexPath: indexPath, dataList: suggestList)
    }
    
    public func getCellHeight(view: UITableView, indexPath: IndexPath, dataList: [Suggest]?) -> CGFloat {
        // cache
        let row = indexPath.row
        let height = heightMap[row]
        if height != nil && height! > CGFloat(0) {
            return height!
        }
        // get
        if dataList == nil || dataList!.count <= row {
            return CGFloat(0)
        }
        let suggest = dataList![row]
        return SuggestCell.getHeightByData(suggest: suggest)
    }
    
    public func refreshHeightMap(refresh: Bool, start: Int, dataList: [Suggest]?) {
        // clear
        var startIndex = start
        if refresh {
            heightMap.removeAll()
            startIndex = 0
        }
        // heightMap
        if dataList == nil || dataList!.count <= 0 {
            return
        }
        for (index, suggest) in dataList!.enumerated() {
            let height = SuggestCell.getHeightByData(suggest: suggest)
            heightMap[index + startIndex] = height
        }
    }
    
}
