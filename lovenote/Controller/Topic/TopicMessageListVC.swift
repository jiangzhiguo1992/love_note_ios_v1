//
//  TopicMessageListVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/5/2.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import XLPagerTabStrip

class TopicMessageListVC: BaseVC, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    
    // view
    private var tableView: UITableView!
    
    // var
    private var height = CGFloat(0)
    private var kind = 0
    private var itemInfo: IndicatorInfo = IndicatorInfo(title: "")
    private var messageList: [TopicMessage]?
    private var heightMap: [Int: CGFloat] = [Int: CGFloat]()
    private var page = 0
    
    public static func get(height: CGFloat, kind: Int) -> TopicMessageListVC {
        let vc = TopicMessageListVC(nibName: nil, bundle: nil)
        vc.height = height
        vc.kind = kind
        switch kind {
        case TopicMessage.KIND_ALL:
            vc.itemInfo.title = StringUtils.getString("all")
            break
        case TopicMessage.KIND_JAB_IN_POST:
            vc.itemInfo.title = StringUtils.getString("jab_in_post")
            break
        case TopicMessage.KIND_JAB_IN_COMMENT:
            vc.itemInfo.title = StringUtils.getString("jab_in_comment")
            break
        case TopicMessage.KIND_POST_BE_COMMENT:
            vc.itemInfo.title = StringUtils.getString("post_comment")
            break
        case TopicMessage.KIND_COMMENT_BE_REPLY:
            vc.itemInfo.title = StringUtils.getString("comment_reply")
            break
        default:
            vc.itemInfo.title = StringUtils.getString("my_message")
            break
        }
        return vc
    }
    
    override func initView() {
        // 不设置的话parent顶部会没有nav
        self.navigationBarShow = true
        
        // tableView
        let tableFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.height)
        tableView = ViewUtils.getTableView(target: self, frame: tableFrame, cellCls: TopicMessageCell.self, id: TopicMessageCell.ID)
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
        let api = Api.request(.topicMessageListGet(kind: kind, page: page),
                              success: { (_, _, data) in
                                self.refreshHeightMap(refresh: !more, start: self.messageList?.count ?? 0, dataList: data.topicMessageList)
                                if !more {
                                    self.messageList = data.topicMessageList
                                    self.endScrollDataRefresh(scroll: self.tableView, msg: data.show, count: data.topicMessageList?.count ?? 0)
                                } else {
                                    self.messageList = (self.messageList ?? [TopicMessage]()) + (data.topicMessageList ?? [TopicMessage]())
                                    self.endScrollDataMore(scroll: self.tableView, msg: data.show, count: data.topicMessageList?.count ?? 0)
                                }
        }, failure: { (_, msg, _) in
            self.endScrollState(scroll: self.tableView, msg: msg)
        })
        pushApi(api)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getCellHeight(view: tableView, indexPath: indexPath, dataList: messageList)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let height = getCellHeight(view: tableView, indexPath: indexPath, dataList: messageList)
        return TopicMessageCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: messageList, height: height)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TopicMessageCell.goSomeDetail(view: tableView, indexPath: indexPath, dataList: messageList)
    }
    
    public func getCellHeight(view: UITableView, indexPath: IndexPath, dataList: [TopicMessage]?) -> CGFloat {
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
        let message = dataList![row]
        return TopicMessageCell.getHeightByData(message: message)
    }
    
    public func refreshHeightMap(refresh: Bool, start: Int, dataList: [TopicMessage]?) {
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
        for (index, message) in dataList!.enumerated() {
            let height = TopicMessageCell.getHeightByData(message: message)
            heightMap[index + startIndex] = height
        }
    }
    
}
