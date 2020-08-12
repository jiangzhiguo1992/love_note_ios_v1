//
//  NotePromiseDetailVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/25.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NotePromiseDetailVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    lazy var screenHeight = ScreenUtils.getScreenHeight() - RootVC.get().getTopBarHeight()
    
    // view
    private var vHead: UIView!
    private var lContent: UILabel!
    private var lHappenUser: UILabel!
    private var lHappenAt: UILabel!
    private var lTime: UILabel!
    private var lineTimeLeft: UIView!
    private var lineTimeRight: UIView!
    private var tableView: UITableView!
    
    // var
    private var promise: Promise?
    private var pid: Int64 = 0
    private var promiseBreakList: [PromiseBreak]?
    private var page = 0
    
    public static func pushVC(promise: Promise? = nil, pid: Int64 = 0) {
        AppDelegate.runOnMainAsync {
            let vc = NotePromiseDetailVC(nibName: nil, bundle: nil)
            vc.promise = promise
            vc.pid = pid
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "promise")
        let barItemDel = UIBarButtonItem(image: UIImage(named: "ic_delete_white_24dp"), style: .plain, target: self, action: #selector(showDeleteAlert))
        self.navigationItem.setRightBarButtonItems([barItemDel], animated: true)
        
        // content
        lContent = ViewHelper.getLabelBold(width: maxWidth, height: CGFloat(0), text: "-", size: ViewHelper.FONT_SIZE_BIG, color: ColorHelper.getFontBlack(), lines: 0, align: .left)
        lContent.frame.origin = CGPoint(x: margin, y: ScreenUtils.heightFit(30))
        
        // user
        lHappenUser = ViewHelper.getLabelGreySmall(width: (maxWidth - margin) / 2, text: "-", lines: 1, align: .left, mode: .byTruncatingMiddle)
        lHappenUser.frame.origin = CGPoint(x: margin, y: lContent.frame.origin.y + lContent.frame.size.height + ScreenUtils.heightFit(20))
        
        // at
        lHappenAt = ViewHelper.getLabelGreySmall(width: (maxWidth - margin) / 2, text: "-", lines: 1, align: .right, mode: .byTruncatingMiddle)
        lHappenAt.frame.origin = CGPoint(x: lHappenUser.frame.origin.x + lHappenUser.frame.size.width + margin, y: lContent.frame.origin.y + lContent.frame.size.height + ScreenUtils.heightFit(20))
        
        // time
        lTime = ViewHelper.getLabelGreySmall(width: ScreenUtils.widthFit(100), text: "-", lines: 1, align: .center, mode: .byTruncatingMiddle)
        lTime.center.x = screenWidth / 2
        lTime.frame.origin.y = lHappenUser.frame.origin.y + lHappenUser.frame.size.height + ScreenUtils.heightFit(40)
        lineTimeLeft = ViewHelper.getViewLine(width: (maxWidth - lTime.frame.size.width) / 2)
        lineTimeLeft.frame.origin.x = margin
        lineTimeLeft.center.y = lTime.center.y
        lineTimeRight = ViewHelper.getViewLine(width: (maxWidth - lTime.frame.size.width) / 2)
        lineTimeRight.frame.origin.x = lTime.frame.origin.x + lTime.frame.size.width
        lineTimeRight.center.y = lTime.center.y
        
        // head
        vHead = UIView()
        vHead.frame.size = CGSize(width: screenWidth, height: lTime.frame.origin.y + lTime.frame.size.height + margin)
        vHead.addSubview(lContent)
        vHead.addSubview(lHappenUser)
        vHead.addSubview(lHappenAt)
        vHead.addSubview(lTime)
        vHead.addSubview(lineTimeLeft)
        vHead.addSubview(lineTimeRight)
        
        // tableView
        tableView = ViewUtils.getTableView(target: self, frame: self.view.bounds, cellCls: NotePromiseBreakCell.self, id: NotePromiseBreakCell.ID)
        initScrollState(scroll: tableView, clipTopBar: true, canEmpty: true, emptyColor: ColorHelper.getFontGrey(),
                        canRefresh: true, refreshBlock: { self.refreshBreakData(more: false) },
                        canMore: true) { self.refreshBreakData(more: true) }
        tableView.tableHeaderView = vHead
        
        // add
        let btnAdd = ViewHelper.getBtnImgCenter(width: ViewHelper.FAB_SIZE, height: ViewHelper.FAB_SIZE, bgColor: ThemeHelper.getColorAccent(), bgImg: UIImage(named: "ic_add_white_24dp"), circle: true, shadow: true)
        btnAdd.frame.origin = CGPoint(x: screenWidth - ViewHelper.FAB_MARGIN - btnAdd.frame.size.width, y: screenHeight - ViewHelper.FAB_MARGIN - btnAdd.frame.size.height)
        
        // view
        self.view.addSubview(tableView)
        self.view.addSubview(btnAdd)
        
        // target
        btnAdd.addTarget(self, action: #selector(goAdd), for: .touchUpInside)
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_PROMISE_DETAIL_REFRESH)
        // init
        if promise != nil {
            refreshHeadView()
            // 没有详情页的，可以不加
            refreshPromiseData(pid: promise!.id)
        } else if pid > 0 {
            refreshPromiseData(pid: pid)
        } else {
            RootVC.get().popBack()
        }
    }
    
    @objc func notifyRefresh(notify: NSNotification) {
        if let promise = notify.object as? Promise {
            refreshPromiseData(pid: promise.id)
        }
    }
    
    func refreshPromiseData(pid: Int64) {
        // api
        let api = Api.request(.notePromiseGet(pid: pid), success: { (_, _, data) in
            self.promise = data.promise
            // head
            self.refreshHeadView()
            // break
            self.startScrollDataSet(scroll: self.tableView)
            // event
            NotifyHelper.post(NotifyHelper.TAG_PROMISE_LIST_ITEM_REFRESH, obj: self.promise)
        }, failure: nil)
        self.pushApi(api)
    }
    
    func refreshHeadView() {
        if promise == nil {
            return
        }
        let me = UDHelper.getMe()
        lContent.text = promise!.contentText
        lHappenUser.text = StringUtils.getString("creator_colon_space_holder", arguments: [UserHelper.getName(user: me, uid: promise!.happenId)])
        lHappenAt.text = StringUtils.getString("create_at_colon_space_holder", arguments: [TimeHelper.getTimeShowLine_HM_MD_YMD_ByGo(promise!.happenAt)])
        lTime.text = StringUtils.getString("break_space_holder_space_time", arguments: [promise!.breakCount])
        
        // size
        lContent.frame.size.height = ViewUtils.getFontHeight(font: lContent.font, width: lContent.frame.width, text: lContent.text)
        lHappenUser.frame.origin.y = lContent.frame.origin.y + lContent.frame.size.height + ScreenUtils.heightFit(20)
        lHappenAt.frame.origin.y = lContent.frame.origin.y + lContent.frame.size.height + ScreenUtils.heightFit(20)
        lTime.frame.origin.y = lHappenUser.frame.origin.y + lHappenUser.frame.size.height + ScreenUtils.heightFit(40)
        lineTimeLeft.center.y = lTime.center.y
        lineTimeRight.center.y = lTime.center.y
        vHead.frame.size.height = lTime.frame.origin.y + lTime.frame.size.height + margin
        // tableView.reloadData()
    }
    
    private func refreshBreakData(more: Bool) {
        page = more ? page + 1 : 0
        // api
        let api = Api.request(.notePromiseBreakListGet(pid: promise?.id ?? pid, page: page),
                              success: { (_, _, data) in
                                NotePromiseBreakCell.refreshHeightMap(refresh: !more, start: self.promiseBreakList?.count ?? 0, dataList: data.promiseBreakList)
                                if !more {
                                    self.promiseBreakList = data.promiseBreakList
                                    self.endScrollDataRefresh(scroll: self.tableView, msg: data.show, count: data.promiseBreakList?.count ?? 0)
                                } else {
                                    self.promiseBreakList = (self.promiseBreakList ?? [PromiseBreak]()) + (data.promiseBreakList ?? [PromiseBreak]())
                                    self.endScrollDataMore(scroll: self.tableView, msg: data.show, count: data.promiseBreakList?.count ?? 0)
                                }
        }, failure: { (_, msg, _) in
            self.endScrollState(scroll: self.tableView, msg: msg)
        })
        pushApi(api)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promiseBreakList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NotePromiseBreakCell.getCellHeight(view: tableView, indexPath: indexPath, dataList: promiseBreakList)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return NotePromiseBreakCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: promiseBreakList, target: self, actionEdit: #selector(targetRemoveItem))
    }
    
    @objc func showDeleteAlert() {
        if promise == nil || !promise!.isMine() {
            ToastUtils.show(StringUtils.getString("can_operation_self_create_note"))
            return
        }
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_delete_this_note"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    self.delPromise()
        },
                                  cancelHandler: nil)
    }
    
    private func delPromise() {
        if promise == nil {
            return
        }
        // api
        let api = Api.request(.notePromiseDel(pid: promise!.id),
                              loading: true, cancel: true, success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_PROMISE_LIST_ITEM_DELETE, obj: self.promise!)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
    @objc private func targetRemoveItem(sender: UIButton) {
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_delete_this_note"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    if let indexPath = ViewUtils.findTableIndexPath(view: sender) {
                                        self.delPromiseBreak(index: indexPath.row)
                                    }
        },
                                  cancelHandler: nil)
    }
    
    private func delPromiseBreak(index: Int) {
        if promiseBreakList == nil || promiseBreakList!.count <= index {
            return
        }
        let promiseBreak = promiseBreakList![index]
        if !promiseBreak.isMine() {
            ToastUtils.show(StringUtils.getString("can_operation_self_create_note"))
            return
        }
        // api
        let api = Api.request(.notePromiseBreakDel(pbid: promiseBreak.id),
                              loading: true, cancel: true, success: { (_, _, data) in
                                self.promiseBreakList!.remove(at: index)
                                NotePromiseBreakCell.refreshHeightMap(refresh: true, start: 0, dataList: self.promiseBreakList)
                                self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                                self.endScrollState(scroll: self.tableView, msg: nil)
                                // event
                                let bNotify = Promise()
                                bNotify.id = self.pid
                                NotifyHelper.post(NotifyHelper.TAG_PROMISE_DETAIL_REFRESH, obj: self.promise ?? bNotify)
                                
        }, failure: nil)
        pushApi(api)
    }
    
    @objc func goAdd() {
        NotePromiseBreakEditVC.pushVC(pid: promise?.id ?? pid)
    }
    
}
