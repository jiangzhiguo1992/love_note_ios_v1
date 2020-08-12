//
//  NoteFoodVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/2/23.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteFoodVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var screenHeight = ScreenUtils.getScreenHeight() - RootVC.get().getTopBarHeight()
    
    // view
    private var tableView: UITableView!
    
    // var
    private var foodList: [Food]?
    private var page = 0
    
    public static func pushVC(select: Bool = false) {
        AppDelegate.runOnMainAsync {
            let vc = NoteFoodVC(nibName: nil, bundle: nil)
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
        initNavBar(title: isFromSelect() ? "please_select_food" : "food")
        
        // tableView
        tableView = ViewUtils.getTableView(target: self, frame: self.view.bounds, cellCls: NoteFoodCell.self, id: NoteFoodCell.ID)
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
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_FOOD_LIST_REFRESH)
        NotifyHelper.addObserver(self, selector: #selector(notifyListItemDelete), name: NotifyHelper.TAG_FOOD_LIST_ITEM_DELETE)
        NotifyHelper.addObserver(self, selector: #selector(notifyListItemRefresh), name: NotifyHelper.TAG_FOOD_LIST_ITEM_REFRESH)
        // refresh
        startScrollDataSet(scroll: tableView)
    }
    
    @objc func notifyRefresh(notify: NSNotification) {
        startScrollDataSet(scroll: tableView)
    }
    
    @objc func notifyListItemDelete(notify: NSNotification) {
        let index = ListHelper.findIndexByIdInList(list: foodList, obj: notify.object)
        if index < 0 || foodList == nil || foodList!.count <= index {
            return
        }
        foodList?.remove(at: index)
        NoteFoodCell.refreshHeightMap(refresh: true, start: 0, dataList: foodList)
        tableView?.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        endScrollState(scroll: tableView, msg: nil)
    }
    
    @objc func notifyListItemRefresh(notify: NSNotification) {
        let index = ListHelper.findIndexByIdInList(list: foodList, obj: notify.object)
        if index < 0 || foodList == nil || foodList!.count <= index {
            return
        }
        foodList?[index] = (notify.object as? Food) ?? Food()
        NoteFoodCell.refreshHeightMap(refresh: true, start: 0, dataList: foodList)
        tableView?.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func isFromSelect() -> Bool {
        return actFrom == BaseVC.ACT_LIST_FROM_SELECT
    }
    
    private func refreshData(more: Bool) {
        page = more ? page + 1 : 0
        // api
        let api = Api.request(.noteFoodListGet(page: page),
                              success: { (_, _, data) in
                                NoteFoodCell.refreshHeightMap(refresh: !more, start: self.foodList?.count ?? 0, dataList: data.foodList)
                                if !more {
                                    self.foodList = data.foodList
                                    self.endScrollDataRefresh(scroll: self.tableView, msg: data.show, count: data.foodList?.count ?? 0)
                                } else {
                                    self.foodList = (self.foodList ?? [Food]()) + (data.foodList ?? [Food]())
                                    self.endScrollDataMore(scroll: self.tableView, msg: data.show, count: data.foodList?.count ?? 0)
                                }
        }, failure: { (_, msg, _) in
            self.endScrollState(scroll: self.tableView, msg: msg)
        })
        pushApi(api)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NoteFoodCell.getCellHeight(view: tableView, indexPath: indexPath, dataList: foodList)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return NoteFoodCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: foodList, target: self, actionEdit: #selector(goEdit), actionAddress: #selector(goMap))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromSelect() {
            NoteFoodCell.selectFood(view: tableView, indexPath: indexPath, dataList: foodList)
        }
    }
    
    @objc func goEdit(sender: UIButton) {
        NoteFoodCell.goEdit(view: sender, dataList: foodList)
    }
    
    @objc func goMap(sender: UIGestureRecognizer) {
        NoteFoodCell.goMap(view: sender.view, dataList: foodList)
    }
    
    @objc func goAdd() {
        NoteFoodEditVC.pushVC()
    }
    
}
