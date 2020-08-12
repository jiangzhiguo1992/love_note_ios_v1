//
//  TopicPostMineListVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/5/2.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import XLPagerTabStrip

class TopicPostMineListVC: BaseVC, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    
    // view
    private var tableView: UITableView!
    
    // var
    private var height = CGFloat(0)
    private var itemInfo: IndicatorInfo = IndicatorInfo(title: StringUtils.getString("my_push"))
    private var postList: [Post]?
    private var heightMap: [Int: CGFloat] = [Int: CGFloat]()
    private var page = 0
    
    public static func get(height: CGFloat) -> TopicPostMineListVC {
        let vc = TopicPostMineListVC(nibName: nil, bundle: nil)
        vc.height = height
        return vc
    }
    
    override func initView() {
        // 不设置的话parent顶部会没有nav
        self.navigationBarShow = true
        
        // tableView
        let tableFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.height)
        tableView = ViewUtils.getTableView(target: self, frame: tableFrame, cellCls: TopicPostCell.self, id: TopicPostCell.ID)
        initScrollState(scroll: tableView, clipTopBar: true, canEmpty: true, emptyColor: ColorHelper.getFontGrey(),
                        canRefresh: true, refreshBlock: { self.refreshData(more: false) },
                        canMore: true) { self.refreshData(more: true) }
        
        // view
        self.view.addSubview(tableView)
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyListItemDelete), name: NotifyHelper.TAG_POST_LIST_ITEM_DELETE)
        NotifyHelper.addObserver(self, selector: #selector(notifyListItemRefresh), name: NotifyHelper.TAG_POST_LIST_ITEM_REFRESH)
        // refresh
        startScrollDataSet(scroll: tableView)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    @objc func notifyListItemDelete(notify: NSNotification) {
        let index = ListHelper.findIndexByIdInList(list: postList, obj: notify.object)
        if index < 0 || postList == nil || postList!.count <= index {
            return
        }
        postList?.remove(at: index)
        refreshHeightMap(refresh: true, start: 0, dataList: postList)
        tableView?.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        endScrollState(scroll: tableView, msg: nil)
    }
    
    @objc func notifyListItemRefresh(notify: NSNotification) {
        let index = ListHelper.findIndexByIdInList(list: postList, obj: notify.object)
        if index < 0 || postList == nil || postList!.count <= index {
            return
        }
        postList?[index] = (notify.object as? Post) ?? Post()
        refreshHeightMap(refresh: true, start: 0, dataList: postList)
        tableView?.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func refreshData(more: Bool) {
        page = more ? page + 1 : 0
        // api
        let api = Api.request(.topicPostMineListGet(page: page),
                              success: { (_, _, data) in
                                self.refreshHeightMap(refresh: !more, start: self.postList?.count ?? 0, dataList: data.postList)
                                if !more {
                                    self.postList = data.postList
                                    self.endScrollDataRefresh(scroll: self.tableView, msg: data.show, count: data.postList?.count ?? 0)
                                } else {
                                    self.postList = (self.postList ?? [Post]()) + (data.postList ?? [Post]())
                                    self.endScrollDataMore(scroll: self.tableView, msg: data.show, count: data.postList?.count ?? 0)
                                }
        }, failure: { (_, msg, _) in
            self.endScrollState(scroll: self.tableView, msg: msg)
        })
        pushApi(api)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getCellHeight(view: tableView, indexPath: indexPath, dataList: postList)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let height = getCellHeight(view: tableView, indexPath: indexPath, dataList: postList)
        return TopicPostCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: postList, height: height)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TopicPostCell.goPostDetail(view: tableView, indexPath: indexPath, dataList: postList)
    }
    
    public func getCellHeight(view: UITableView, indexPath: IndexPath, dataList: [Post]?) -> CGFloat {
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
        let post = dataList![row]
        return TopicPostCell.getHeightByData(post: post)
    }
    
    public func refreshHeightMap(refresh: Bool, start: Int, dataList: [Post]?) {
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
        for (index, post) in dataList!.enumerated() {
            let height = TopicPostCell.getHeightByData(post: post)
            heightMap[index + startIndex] = height
        }
    }
    
}
