//
//  NoteDiaryVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/2/23.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteDiaryVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    
    // view
    private var lSearch: UILabel!
    private var tableView: UITableView!
    
    // var
    private var diaryList: [Diary]?
    private var page = 0
    private var searchIndex = 0
    
    public static func pushVC(select: Bool = false) {
        AppDelegate.runOnMainAsync {
            let vc = NoteDiaryVC(nibName: nil, bundle: nil)
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
        initNavBar(title: isFromSelect() ? "please_select_diary" : "diary")
        let barHelp = UIBarButtonItem(image: UIImage(named: "ic_help_outline_white_24dp"), style: .plain, target: self, action: #selector(targetGoHelp))
        self.navigationItem.rightBarButtonItems = [barHelp]
        
        // search
        lSearch = ViewHelper.getLabelGreyNormal(text: ApiHelper.LIST_NOTE_WHO_SHOW[searchIndex], lines: 1, align: .center, mode: .byTruncatingTail)
        let ivSearch = ViewHelper.getImageView(img: UIImage(named: "ic_perm_identity_grey_18dp"), width: lSearch.frame.size.height, height: lSearch.frame.size.height, mode: .scaleAspectFit)
        let vSearch = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth / 2, height: lSearch.frame.size.height + margin * 2))
        
        ivSearch.frame.origin = CGPoint(x: (vSearch.frame.size.width - ivSearch.frame.size.width - margin - lSearch.frame.size.width) / 2, y: margin)
        lSearch.frame.origin = CGPoint(x: ivSearch.frame.origin.x + ivSearch.frame.size.width + margin, y: margin)
        vSearch.addSubview(ivSearch)
        vSearch.addSubview(lSearch)
        
        // add
        let lAdd = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("publish"), lines: 1, align: .center, mode: .byTruncatingTail)
        let ivAdd = ViewHelper.getImageView(img: UIImage(named: "ic_add_circle_outline_grey_18dp"), width: lAdd.frame.size.height, height: lAdd.frame.size.height, mode: .scaleAspectFit)
        let vAdd = UIView(frame: CGRect(x: screenWidth / 2, y: 0, width: screenWidth / 2, height: lAdd.frame.size.height + margin * 2))
        
        ivAdd.frame.origin = CGPoint(x: (vAdd.frame.size.width - ivAdd.frame.size.width - margin - lAdd.frame.size.width) / 2, y: margin)
        lAdd.frame.origin = CGPoint(x: ivAdd.frame.origin.x + ivAdd.frame.size.width + margin, y: margin)
        vAdd.addSubview(ivAdd)
        vAdd.addSubview(lAdd)
        
        // line
        let vLineTop = ViewHelper.getViewLine(width: screenWidth)
        vLineTop.frame.origin = CGPoint(x: 0, y: 0)
        let vLineCenter = ViewHelper.getViewLine(height: vSearch.frame.size.height)
        vLineCenter.center.x = screenWidth / 2
        vLineCenter.frame.origin.y = 0
        
        // bottomBar
        let vBottomBar = UIView()
        vBottomBar.frame.size = CGSize(width: screenWidth, height: vSearch.frame.size.height + ScreenUtils.getBottomNavHeight())
        vBottomBar.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height - RootVC.get().getTopBarHeight() - vBottomBar.frame.size.height)
        vBottomBar.backgroundColor = ColorHelper.getWhite()
        
        vBottomBar.addSubview(vSearch)
        vBottomBar.addSubview(vAdd)
        vBottomBar.addSubview(vLineTop)
        vBottomBar.addSubview(vLineCenter)
        
        // tableView
        tableView = ViewUtils.getTableView(target: self, frame: self.view.bounds, cellCls: NoteDiaryCell.self, id: NoteDiaryCell.ID)
        initScrollState(scroll: tableView, clipTopBar: true, canEmpty: true, emptyColor: ColorHelper.getFontGrey(),
                        canRefresh: true, refreshBlock: { self.refreshData(more: false) },
                        canMore: true) { self.refreshData(more: true) }
        tableView.frame.size.height -= vBottomBar.frame.size.height
        
        // view
        self.view.addSubview(tableView)
        self.view.addSubview(vBottomBar)
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vSearch, action: #selector(showSearchAlert))
        ViewUtils.addViewTapTarget(target: self, view: vAdd, action: #selector(goAdd))
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_DIARY_LIST_REFRESH)
        NotifyHelper.addObserver(self, selector: #selector(notifyListItemDelete), name: NotifyHelper.TAG_DIARY_LIST_ITEM_DELETE)
        NotifyHelper.addObserver(self, selector: #selector(notifyListItemRefresh), name: NotifyHelper.TAG_DIARY_LIST_ITEM_REFRESH)
        // refresh
        startScrollDataSet(scroll: tableView)
    }
    
    @objc func notifyRefresh(notify: NSNotification) {
        startScrollDataSet(scroll: tableView)
    }
    
    @objc func notifyListItemDelete(notify: NSNotification) {
        let index = ListHelper.findIndexByIdInList(list: diaryList, obj: notify.object)
        if index < 0 || diaryList == nil || diaryList!.count <= index {
            return
        }
        diaryList?.remove(at: index)
        NoteDiaryCell.refreshHeightMap(refresh: true, start: 0, dataList: diaryList)
        tableView?.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        endScrollState(scroll: tableView, msg: nil)
    }
    
    @objc func notifyListItemRefresh(notify: NSNotification) {
        let index = ListHelper.findIndexByIdInList(list: diaryList, obj: notify.object)
        if index < 0 || diaryList == nil || diaryList!.count <= index {
            return
        }
        diaryList?[index] = (notify.object as? Diary) ?? Diary()
        NoteDiaryCell.refreshHeightMap(refresh: true, start: 0, dataList: diaryList)
        tableView?.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func isFromSelect() -> Bool {
        return actFrom == BaseVC.ACT_LIST_FROM_SELECT
    }
    
    private func refreshData(more: Bool) {
        page = more ? page + 1 : 0
        let searchType = ApiHelper.LIST_NOTE_WHO_TYPE[searchIndex]
        // api
        let api = Api.request(.noteDiaryListGet(who: searchType, page: page),
                              success: { (_, _, data) in
                                NoteDiaryCell.refreshHeightMap(refresh: !more, start: self.diaryList?.count ?? 0, dataList: data.diaryList)
                                if !more {
                                    self.diaryList = data.diaryList
                                    self.endScrollDataRefresh(scroll: self.tableView, msg: data.show, count: data.diaryList?.count ?? 0)
                                } else {
                                    self.diaryList = (self.diaryList ?? [Diary]()) + (data.diaryList ?? [Diary]())
                                    self.endScrollDataMore(scroll: self.tableView, msg: data.show, count: data.diaryList?.count ?? 0)
                                }
        }, failure: { (_, msg, _) in
            self.endScrollState(scroll: self.tableView, msg: msg)
        })
        pushApi(api)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NoteDiaryCell.getCellHeight(view: tableView, indexPath: indexPath, dataList: diaryList)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return NoteDiaryCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: diaryList)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromSelect() {
            NoteDiaryCell.selectDiary(view: tableView, indexPath: indexPath, dataList: diaryList)
        } else {
            NoteDiaryCell.goDiaryDetail(view: tableView, indexPath: indexPath, dataList: diaryList)
        }
    }
    
    @objc func showSearchAlert() {
        // search
        _ = AlertHelper.showAlert(title: StringUtils.getString("select_search_type"),
                                  confirms: ApiHelper.LIST_NOTE_WHO_SHOW,
                                  cancel: StringUtils.getString("cancel"),
                                  canCancel: true,
                                  actionHandler: { (_, index, _) in
                                    self.searchIndex = Int(index)
                                    self.lSearch.text = ApiHelper.LIST_NOTE_WHO_SHOW[self.searchIndex]
                                    self.startScrollDataSet(scroll: self.tableView)
        }, cancelHandler: nil)
    }
    
    @objc func goAdd() {
        NoteDiaryEditVC.pushVC()
    }
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC(HelpVC.INDEX_NOTE_DIARY)
    }
    
}
