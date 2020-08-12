//
//  NoticeListVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/18.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoticeListVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    // view
    private var tableView: UITableView!
    
    // var
    private var noticeList: [Notice]?
    private var page = 0
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(NoticeListVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "new_notice")
        
        // tableView
        tableView = ViewUtils.getTableView(target: self, frame: self.view.bounds, cellCls: NoticeCell.self, id: NoticeCell.ID)
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
        let api = Api.request(.setNoticeListGet(page: page),
                              success: { (_, _, data) in
                                if !more {
                                    self.noticeList = data.noticeList
                                    self.endScrollDataRefresh(scroll: self.tableView, msg: data.show, count: data.noticeList?.count ?? 0)
                                } else {
                                    self.noticeList = (self.noticeList ?? [Notice]()) + (data.noticeList ?? [Notice]())
                                    self.endScrollDataMore(scroll: self.tableView, msg: data.show, count: data.noticeList?.count ?? 0)
                                }
                                // count
                                let oldCC = UDHelper.getCommonCount()
                                oldCC.noticeNewCount = data.commonCount?.noticeNewCount ?? 0
                                UDHelper.setCommonCount(oldCC)
        }, failure: { (_, msg, _) in
            self.endScrollState(scroll: self.tableView, msg: msg)
        })
        pushApi(api)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NoticeCell.getCellHeight(view: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return NoticeCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: noticeList)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notice = noticeList?[indexPath.row]
        noticeRead(indexPath: indexPath, notice: notice)
        goNoticeDetail(notice: notice)
    }
    
    func goNoticeDetail(notice: Notice?) {
        if notice == nil {
            return
        }
        switch notice!.contentType {
        case Notice.TYPE_URL: // 网页
            WebVC.pushVC(title: notice!.title, url: notice!.contentText)
        case Notice.TYPE_IMAGE: // 图片
            BrowserHelper.goBrowserImage(delegate: self, index: 0, ossKeyList: [notice!.contentText])
        default: // 文本
            NoticeDetailVC.pushVC(notice: notice)
            break
        }
    }
    
    func noticeRead(indexPath: IndexPath, notice: Notice?) {
        if notice == nil {
            return
        }
        if !notice!.read {
            let commonCount = UDHelper.getCommonCount()
            commonCount.noticeNewCount = commonCount.noticeNewCount - 1
            UDHelper.setCommonCount(commonCount)
        }
        notice!.read = true
        tableView.reloadRows(at: [indexPath], with: .fade)
        // api
        let api = Api.request(.setNoticeRead(nid: notice!.id), loading: false, cancel: true, success: nil, failure: nil)
        pushApi(api)
    }
    
}
