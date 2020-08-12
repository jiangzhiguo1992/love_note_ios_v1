//
//  NoteSouvenirVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/18.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteSouvenirVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var screenHeight = ScreenUtils.getScreenHeight() - RootVC.get().getTopBarHeight()
    
    // view
    private var scType: UISegmentedControl!
    private var tableView: UITableView!
    
    // var
    private var souvenirList: [Souvenir]?
    private var page = 0
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(NoteSouvenirVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "souvenir")
        let barItemHelp = UIBarButtonItem(image: UIImage(named: "ic_help_outline_white_24dp"), style: .plain, target: self, action: #selector(targetGoHelp))
        self.navigationItem.setRightBarButtonItems([barItemHelp], animated: true)
        
        // segment
        scType = ViewHelper.getSegmentedControl(items: [StringUtils.getString("souvenir"), StringUtils.getString("wish_list")], tintColor: ColorHelper.getFontWhite(), titleSize: ViewHelper.FONT_SIZE_NORMAL, multiLine: false)
        scType.frame.size.height = RootVC.get().navigationBar.frame.size.height - ScreenUtils.heightFit(10)
        scType.selectedSegmentIndex = 0
        self.navigationItem.titleView = scType
        
        // tableView
        tableView = ViewUtils.getTableView(target: self, frame: self.view.bounds, cellCls: NoteSouvenirCell.self, id: NoteSouvenirCell.ID)
        initScrollState(scroll: tableView, clipTopBar: true, canEmpty: true, emptyColor: ColorHelper.getFontGrey(),
                        canRefresh: true, refreshBlock: { self.refreshData(more: false, done: (self.scType.selectedSegmentIndex == 0)) },
                        canMore: true) { self.refreshData(more: true, done: (self.scType.selectedSegmentIndex == 0)) }
        
        // add
        let btnAdd = ViewHelper.getBtnImgCenter(width: ViewHelper.FAB_SIZE, height: ViewHelper.FAB_SIZE, bgColor: ThemeHelper.getColorAccent(), bgImg: UIImage(named: "ic_add_white_24dp"), circle: true, shadow: true)
        btnAdd.frame.origin = CGPoint(x: screenWidth - ViewHelper.FAB_MARGIN - btnAdd.frame.size.width, y: screenHeight - ViewHelper.FAB_MARGIN - btnAdd.frame.size.height)
        
        // view
        self.view.addSubview(tableView)
        self.view.addSubview(btnAdd)
        
        // target
        scType.addTarget(self, action: #selector(targetType(sender:)), for: .valueChanged)
        btnAdd.addTarget(self, action: #selector(goAdd), for: .touchUpInside)
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_SOUVENIR_LIST_REFRESH)
        NotifyHelper.addObserver(self, selector: #selector(notifyListItemDelete), name: NotifyHelper.TAG_SOUVENIR_LIST_ITEM_DELETE)
        NotifyHelper.addObserver(self, selector: #selector(notifyListItemRefresh), name: NotifyHelper.TAG_SOUVENIR_LIST_ITEM_REFRESH)
        // refresh
        startScrollDataSet(scroll: tableView)
    }
    
    @objc private func targetType(sender: UISegmentedControl) {
        startScrollDataSet(scroll: tableView)
    }
    
    @objc func notifyRefresh(notify: NSNotification) {
        startScrollDataSet(scroll: tableView)
    }
    
    @objc func notifyListItemDelete(notify: NSNotification) {
        let index = ListHelper.findIndexByIdInList(list: souvenirList, obj: notify.object)
        if index < 0 || souvenirList == nil || souvenirList!.count <= index {
            return
        }
        souvenirList?.remove(at: index)
        tableView?.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        endScrollState(scroll: tableView, msg: nil)
    }
    
    @objc func notifyListItemRefresh(notify: NSNotification) {
        let index = ListHelper.findIndexByIdInList(list: souvenirList, obj: notify.object)
        if index < 0 || souvenirList == nil || souvenirList!.count <= index {
            return
        }
        souvenirList?[index] = (notify.object as? Souvenir) ?? Souvenir()
        tableView?.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func refreshData(more: Bool, done: Bool) {
        page = more ? page + 1 : 0
        // api
        let api = Api.request(.noteSouvenirListGet(done: done, page: page),
                              success: { (_, _, data) in
                                if !more {
                                    self.souvenirList = data.souvenirList
                                    self.endScrollDataRefresh(scroll: self.tableView, msg: data.show, count: data.souvenirList?.count ?? 0)
                                } else {
                                    self.souvenirList = (self.souvenirList ?? [Souvenir]()) + (data.souvenirList ?? [Souvenir]())
                                    self.endScrollDataMore(scroll: self.tableView, msg: data.show, count: data.souvenirList?.count ?? 0)
                                }
        }, failure: { (_, msg, _) in
            self.endScrollState(scroll: self.tableView, msg: msg)
        })
        pushApi(api)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return souvenirList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NoteSouvenirCell.getCellHeight(view: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return NoteSouvenirCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: souvenirList)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NoteSouvenirCell.goSouvenirDetail(view: tableView, indexPath: indexPath, dataList: souvenirList)
    }
    
    @objc func goAdd() {
        NoteSouvenirEditVC.pushVC()
    }
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC(HelpVC.INDEX_NOTE_SOUVENIR)
    }
    
}

