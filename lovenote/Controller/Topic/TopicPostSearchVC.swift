//
//  TopicPostSearchVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/30.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class TopicPostSearchVC: BaseVC, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // view
    private var sbSearch: UISearchBar!
    private var tableView: UITableView!
    
    // var
    private var postList: [Post]?
    private var heightMap: [Int: CGFloat] = [Int: CGFloat]()
    private var page = 0
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(TopicPostSearchVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "")
        let vNaviBar = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: ScreenUtils.getTopStatusHeight()))
        vNaviBar.backgroundColor = ThemeHelper.getColorPrimary()
        
        // searchBar
        let hint = StringUtils.getString("please_input_search_content")
        let searchFrame = CGRect(x: 0, y: vNaviBar.frame.origin.y + vNaviBar.frame.size.height, width: self.view.frame.size.width, height: 0)
        sbSearch = ViewHelper.getSearchBar(delegate: self, frame: searchFrame, placeholder: hint)
        HoldTextFiledDelete = false // 记得取消tf的代理
        
        // tableView
        let tableFrame = CGRect(x: 0, y: sbSearch.frame.origin.y + sbSearch.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height - sbSearch.frame.origin.y - sbSearch.frame.size.height)
        tableView = ViewUtils.getTableView(target: self, frame: tableFrame, cellCls: TopicPostCell.self, id: TopicPostCell.ID)
        initScrollState(scroll: tableView, clipTopBar: false, canEmpty: true, emptyColor: ColorHelper.getFontGrey(),
                        canRefresh: true, refreshBlock: { self.refreshData(more: false) },
                        canMore: true) { self.refreshData(more: true) }
        
        // view
        self.view.addSubview(vNaviBar)
        self.view.addSubview(sbSearch)
        self.view.addSubview(tableView)
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyListItemDelete), name: NotifyHelper.TAG_POST_LIST_ITEM_DELETE)
        NotifyHelper.addObserver(self, selector: #selector(notifyListItemRefresh), name: NotifyHelper.TAG_POST_LIST_ITEM_REFRESH)
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        startScrollDataSet(scroll: tableView)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        RootVC.get().popBack()
    }
    
    private func refreshData(more: Bool) {
        let search = sbSearch.text ?? ""
        if StringUtils.isEmpty(search) {
            ToastUtils.show(sbSearch.placeholder)
            endScrollState(scroll: tableView)
            return
        }
        page = more ? page + 1 : 0
        // api
        let api = Api.request(.topicPostListSearchGet(search: search, page: page),
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
