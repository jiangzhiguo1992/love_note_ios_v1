//
//  NoteAlbumVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/2/23.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteAlbumVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    // const
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var screenHeight = ScreenUtils.getScreenHeight() - RootVC.get().getTopBarHeight()
    
    // view
    private var tableView: UITableView!
    
    // var
    private var albumList: [Album]?
    private var page = 0
    
    public static func pushVC(select: Bool = false) {
        let vc = NoteAlbumVC(nibName: nil, bundle: nil)
        if select {
            vc.actFrom = ACT_LIST_FROM_SELECT
        } else {
            vc.actFrom = ACT_LIST_FROM_BROWSE
        }
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: isFromSelect() ? "please_select_album" : "album")
        let barHelp = UIBarButtonItem(image: UIImage(named: "ic_help_outline_white_24dp"), style: .plain, target: self, action: #selector(targetGoHelp))
        self.navigationItem.rightBarButtonItems = [barHelp]
        
        // tableView
        tableView = ViewUtils.getTableView(target: self, frame: self.view.bounds, cellCls: NoteAlbumCell.self, id: NoteAlbumCell.ID)
        initScrollState(scroll: tableView, clipTopBar: true, canEmpty: true, emptyColor: ColorHelper.getFontGrey(),
                        canRefresh: true, refreshBlock: { self.refreshData(more: false) },
                        canMore: true) { self.refreshData(more: true)
        }
        
        // add
        let btnAdd = ViewHelper.getBtnImgCenter(width: ViewHelper.FAB_SIZE, height: ViewHelper.FAB_SIZE, bgColor: ThemeHelper.getColorAccent(), bgImg: UIImage(named: "ic_add_white_24dp"), circle: true, shadow: true)
        btnAdd.frame.origin = CGPoint(x: screenWidth - ViewHelper.FAB_MARGIN - btnAdd.frame.size.width, y: screenHeight - ViewHelper.FAB_MARGIN - btnAdd.frame.size.height)
        
        // view
        self.view.addSubview(tableView)
        self.view.addSubview(btnAdd)
        
        // target
        btnAdd.addTarget(self, action: #selector(add), for: .touchUpInside)
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_ALBUM_LIST_REFRESH)
        NotifyHelper.addObserver(self, selector: #selector(notifyListItemDelete), name: NotifyHelper.TAG_ALBUM_LIST_ITEM_DELETE)
        NotifyHelper.addObserver(self, selector: #selector(notifyListItemRefresh), name: NotifyHelper.TAG_ALBUM_LIST_ITEM_REFRESH)
        // refresh
        startScrollDataSet(scroll: tableView)
    }
    
    @objc func notifyRefresh(notify: NSNotification) {
        startScrollDataSet(scroll: tableView)
    }
    
    @objc func notifyListItemDelete(notify: NSNotification) {
        let index = ListHelper.findIndexByIdInList(list: albumList, obj: notify.object)
        if index < 0 || albumList == nil || albumList!.count <= index {
            return
        }
        albumList?.remove(at: index)
        tableView?.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        self.endScrollState(scroll: self.tableView, msg: nil)
    }
    
    @objc func notifyListItemRefresh(notify: NSNotification) {
        let index = ListHelper.findIndexByIdInList(list: albumList, obj: notify.object)
        if index < 0 || albumList == nil || albumList!.count <= index {
            return
        }
        albumList?[index] = (notify.object as? Album) ?? Album()
        tableView?.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func isFromSelect() -> Bool {
        return actFrom == BaseVC.ACT_LIST_FROM_SELECT
    }
    
    private func refreshData(more: Bool) {
        page = more ? page + 1 : 0
        // api
        let api = Api.request(.noteAlbumListGet(page: page),
                              success: { (_, _, data) in
                                if !more {
                                    self.albumList = data.albumList
                                    self.endScrollDataRefresh(scroll: self.tableView, msg: data.show, count: data.albumList?.count ?? 0)
                                } else {
                                    self.albumList = (self.albumList ?? [Album]()) + (data.albumList ?? [Album]())
                                    self.endScrollDataMore(scroll: self.tableView, msg: data.show, count: data.albumList?.count ?? 0)
                                }
        }, failure: { (_, msg, _) in
            self.endScrollState(scroll: self.tableView, msg: msg)
        })
        pushApi(api)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NoteAlbumCell.getCellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return NoteAlbumCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: albumList)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromSelect() {
            NoteAlbumCell.selectAlbum(view: tableView, indexPath: indexPath, dataList: albumList)
        } else {
            NoteAlbumCell.goPictureList(view: tableView, indexPath: indexPath, dataList: albumList)
        }
    }
    
    @objc func add() {
        NoteAlbumEditVC.pushVC()
    }
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC(HelpVC.INDEX_NOTE_ALBUM)
    }
    
}
