//
//  NoteAwardRuleVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/23.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteAwardRuleVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var screenHeight = ScreenUtils.getScreenHeight() - RootVC.get().getTopBarHeight()
    
    // view
    private var tableView: UITableView!
    
    // var
    private var awardRuleList: [AwardRule]?
    private var page = 0
    
    public static func pushVC(select: Bool = false) {
        AppDelegate.runOnMainAsync {
            let vc = NoteAwardRuleVC(nibName: nil, bundle: nil)
            if select {
                vc.actFrom = ACT_LIST_FROM_SELECT
            } else {
                vc.actFrom = ACT_LIST_FROM_BROWSE
            }
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: isFromSelect() ? "please_select_rule" : "award_rule")
        
        // tableView
        tableView = ViewUtils.getTableView(target: self, frame: self.view.bounds, cellCls: NoteAwardRuleCell.self, id: NoteAwardRuleCell.ID)
        initScrollState(scroll: tableView, clipTopBar: true, canEmpty: true, emptyColor: ColorHelper.getFontGrey(),
                        canRefresh: true, refreshBlock: { self.refreshData(more: false) },
                        canMore: true) { self.refreshData(more: true) }
        
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
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_AWARD_RULE_LIST_REFRESH)
        // refresh
        startScrollDataSet(scroll: tableView)
    }
    
    @objc func notifyRefresh(notify: NSNotification) {
        startScrollDataSet(scroll: tableView)
    }
    
    func isFromSelect() -> Bool {
        return actFrom == BaseVC.ACT_LIST_FROM_SELECT
    }
    
    private func refreshData(more: Bool) {
        page = more ? page + 1 : 0
        // api
        let api = Api.request(.noteAwardRuleListGet(page: page),
                              success: { (_, _, data) in
                                NoteAwardRuleCell.refreshHeightMap(refresh: !more, start: self.awardRuleList?.count ?? 0, dataList: data.awardRuleList)
                                if !more {
                                    self.awardRuleList = data.awardRuleList
                                    self.endScrollDataRefresh(scroll: self.tableView, msg: data.show, count: data.awardRuleList?.count ?? 0)
                                } else {
                                    self.awardRuleList = (self.awardRuleList ?? [AwardRule]()) + (data.awardRuleList ?? [AwardRule]())
                                    self.endScrollDataMore(scroll: self.tableView, msg: data.show, count: data.awardRuleList?.count ?? 0)
                                }
        }, failure: { (_, msg, _) in
            self.endScrollState(scroll: self.tableView, msg: msg)
        })
        pushApi(api)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return awardRuleList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NoteAwardRuleCell.getCellHeight(view: tableView, indexPath: indexPath, dataList: awardRuleList)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return NoteAwardRuleCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: awardRuleList, target: self, actionEdit: #selector(targetRemoveItem))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromSelect() {
            NoteAwardRuleCell.selectAwardRule(view: tableView, indexPath: indexPath, dataList: awardRuleList)
        }
    }
    
    @objc private func targetRemoveItem(sender: UIButton) {
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_delete_this_note"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    if let indexPath = ViewUtils.findTableIndexPath(view: sender) {
                                        self.delAwardRule(index: indexPath.row)
                                    }
        },
                                  cancelHandler: nil)
    }
    
    private func delAwardRule(index: Int) {
        if awardRuleList == nil || awardRuleList!.count <= index {
            return
        }
        let awardRule = awardRuleList![index]
        if !awardRule.isMine() {
            ToastUtils.show(StringUtils.getString("can_operation_self_create_note"))
            return
        }
        // api
        let api = Api.request(.noteAwardRuleDel(arid: awardRule.id),
                              loading: true, cancel: true, success: { (_, _, data) in
                                self.awardRuleList!.remove(at: index)
                                NoteAwardRuleCell.refreshHeightMap(refresh: true, start: 0, dataList: self.awardRuleList)
                                self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                                self.endScrollState(scroll: self.tableView, msg: nil)
        }, failure: nil)
        pushApi(api)
    }
    
    @objc func goAdd() {
        NoteAwardRuleEditVC.pushVC()
    }
    
}
