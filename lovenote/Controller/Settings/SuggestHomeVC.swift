//
//  SuggestHomeVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/18.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class SuggestHomeVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    lazy var btnWidth = maxWidth / 3
    lazy var btnHeight = ScreenUtils.heightFit(40)
    
    // view
    private var tableView: UITableView!
    
    // var
    private var suggestList: [Suggest]?
    private var heightMap: [Int: CGFloat] = [Int: CGFloat]()
    private var page = 0
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(SuggestHomeVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "suggest_feedback")
        let barItemHelp = UIBarButtonItem(image: UIImage(named: "ic_help_outline_white_24dp"), style: .plain, target: self, action: #selector(targetGoHelp))
        self.navigationItem.setRightBarButtonItems([barItemHelp], animated: true)
        
        // head
        let vHeadCard = UIView(frame: CGRect(x: margin, y: margin * 2, width: maxWidth, height: btnHeight))
        ViewUtils.setViewRadiusCircle(vHeadCard)
        ViewUtils.setViewShadow(vHeadCard, offset: ViewHelper.SHADOW_NORMAL)
        
        let vHead = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: vHeadCard.frame.origin.y * 2 + vHeadCard.frame.size.height))
        vHead.addSubview(vHeadCard)
        
        // mine
        let btnMine = ViewHelper.getBtnBGPrimary(width: btnWidth, height: btnHeight, HAlign: .center, VAlign: .center, title: StringUtils.getString("my_push"), titleSize: ViewHelper.FONT_SIZE_NORMAL, titleColor: ColorHelper.getFontWhite(), titleLines: 1, titleAlign: .center)
        btnMine.frame.origin = CGPoint(x: 0, y: 0)
        ViewUtils.setViewCorner(btnMine, corner: btnHeight / 2, round: [.topLeft, .bottomLeft])
        
        // follow
        let btnFollow = ViewHelper.getBtnBGWhite(width: btnWidth, height: btnHeight, HAlign: .center, VAlign: .center, title: StringUtils.getString("my_follow"), titleSize: ViewHelper.FONT_SIZE_NORMAL, titleColor: ThemeHelper.getColorPrimary(), titleLines: 1, titleAlign: .center)
        btnFollow.frame.origin = CGPoint(x: btnMine.frame.origin.x + btnMine.frame.size.width, y: 0)
        
        // add
        let btnAdd = ViewHelper.getBtnBGPrimary(width: btnWidth, height: btnHeight, HAlign: .center, VAlign: .center, title: StringUtils.getString("i_want_feedback"), titleSize: ViewHelper.FONT_SIZE_NORMAL, titleColor: ColorHelper.getFontWhite(), titleLines: 1, titleAlign: .center)
        btnAdd.frame.origin = CGPoint(x: btnFollow.frame.origin.x + btnFollow.frame.size.width, y: 0)
        ViewUtils.setViewCorner(btnAdd, corner: btnHeight / 2, round: [.topRight, .bottomRight])
        
        vHeadCard.addSubview(btnMine)
        vHeadCard.addSubview(btnFollow)
        vHeadCard.addSubview(btnAdd)
        
        // tableView
        tableView = ViewUtils.getTableView(target: self, frame: self.view.bounds, cellCls: SuggestCell.self, id: SuggestCell.ID)
        initScrollState(scroll: tableView, clipTopBar: true, canEmpty: true, emptyColor: ColorHelper.getFontGrey(),
                        canRefresh: true, refreshBlock: { self.refreshData(more: false) },
                        canMore: true) { self.refreshData(more: true) }
        tableView.tableHeaderView = vHead
        
        // view
        self.view.addSubview(tableView)
        
        // target
        btnMine.addTarget(self, action: #selector(targetGoMine), for: .touchUpInside)
        btnFollow.addTarget(self, action: #selector(targetGoFollow), for: .touchUpInside)
        btnAdd.addTarget(self, action: #selector(targetGoAdd), for: .touchUpInside)
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_SUGGEST_LIST_REFRESH)
        NotifyHelper.addObserver(self, selector: #selector(notifyListItemDelete), name: NotifyHelper.TAG_SUGGEST_LIST_ITEM_DELETE)
        NotifyHelper.addObserver(self, selector: #selector(notifyListItemRefresh), name: NotifyHelper.TAG_SUGGEST_LIST_ITEM_REFRESH)
        // data
        startScrollDataSet(scroll: tableView)
    }
    
    @objc func notifyRefresh(notify: NSNotification) {
        startScrollDataSet(scroll: tableView)
    }
    
    @objc func notifyListItemDelete(notify: NSNotification) {
        let index = ListHelper.findIndexByIdInList(list: suggestList, obj: notify.object)
        if index < 0 || suggestList == nil || suggestList!.count <= index {
            return
        }
        suggestList?.remove(at: index)
        refreshHeightMap(refresh: true, start: 0, dataList: suggestList)
        tableView?.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        endScrollState(scroll: tableView, msg: nil)
    }
    
    @objc func notifyListItemRefresh(notify: NSNotification) {
        let index = ListHelper.findIndexByIdInList(list: suggestList, obj: notify.object)
        if index < 0 || suggestList == nil || suggestList!.count <= index {
            return
        }
        suggestList?[index] = (notify.object as? Suggest) ?? Suggest()
        refreshHeightMap(refresh: true, start: 0, dataList: suggestList)
        tableView?.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func refreshData(more: Bool) {
        page = more ? page + 1 : 0
        // api
        let api = Api.request(.setSuggestListGet(status: Suggest.STATUS_REPLY_NO, kind: Suggest.KIND_ALL, page: page),
                              success: { (_, _, data) in
                                self.refreshHeightMap(refresh: !more, start: self.suggestList?.count ?? 0, dataList: data.suggestList)
                                if !more {
                                    self.suggestList = data.suggestList
                                    self.endScrollDataRefresh(scroll: self.tableView, msg: data.show, count: data.suggestList?.count ?? 0)
                                } else {
                                    self.suggestList = (self.suggestList ?? [Suggest]()) + (data.suggestList ?? [Suggest]())
                                    self.endScrollDataMore(scroll: self.tableView, msg: data.show, count: data.suggestList?.count ?? 0)
                                }
        }, failure: { (_, msg, _) in
            self.endScrollState(scroll: self.tableView, msg: msg)
        })
        pushApi(api)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getCellHeight(view: tableView, indexPath: indexPath, dataList: suggestList)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let height = getCellHeight(view: tableView, indexPath: indexPath, dataList: suggestList)
        return SuggestCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: suggestList, height: height)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SuggestCell.goSuggestDetail(view: tableView, indexPath: indexPath, dataList: suggestList)
    }
    
    public func getCellHeight(view: UITableView, indexPath: IndexPath, dataList: [Suggest]?) -> CGFloat {
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
        let suggest = dataList![row]
        return SuggestCell.getHeightByData(suggest: suggest)
    }
    
    public func refreshHeightMap(refresh: Bool, start: Int, dataList: [Suggest]?) {
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
        for (index, suggest) in dataList!.enumerated() {
            let height = SuggestCell.getHeightByData(suggest: suggest)
            heightMap[index + startIndex] = height
        }
    }
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC(HelpVC.INDEX_USER_SUGGEST)
    }
    
    @objc private func targetGoMine() {
        SuggestListVC.pushVC(entry: SuggestListVC.ENTRY_MINE)
    }
    
    @objc private func targetGoFollow() {
        SuggestListVC.pushVC(entry: SuggestListVC.ENTRY_FOLLOW)
    }
    
    @objc private func targetGoAdd() {
        SuggestAddVC.pushVC()
    }
    
}
