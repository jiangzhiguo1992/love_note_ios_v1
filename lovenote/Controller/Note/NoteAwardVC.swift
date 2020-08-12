//
//  NoteAwardVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/2/23.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteAwardVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    
    // view
    private var lScoreTa: UILabel!
    private var lScoreMe: UILabel!
    private var lSearch: UILabel!
    private var tableView: UITableView!
    
    // var
    private var awardList: [Award]?
    private var page = 0
    private var searchIndex = 0
    
    public static func pushVC(select: Bool = false) {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(NoteAwardVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "award")
        let barHelp = UIBarButtonItem(image: UIImage(named: "ic_help_outline_white_24dp"), style: .plain, target: self, action: #selector(targetGoHelp))
        self.navigationItem.rightBarButtonItems = [barHelp]
        
        // scoreTa
        lScoreTa = ViewHelper.getLabelBold(text: "0", size: ViewHelper.FONT_SIZE_BIG, color: ColorHelper.getFontWhite(), lines: 1, align: .center, mode: .byTruncatingMiddle)
        lScoreTa.frame.size.height += margin * 2
        lScoreTa.frame.size.width = (screenWidth - margin - lScoreTa.frame.size.height) / 2
        lScoreTa.frame.origin = CGPoint(x: 0, y: margin / 2)
        lScoreTa.backgroundColor = ThemeHelper.getColorPrimary()
        ViewUtils.setViewShadow(lScoreTa, offset: ViewHelper.SHADOW_NORMAL)
        let vScoreCircleTa = UIView(frame: CGRect(x: lScoreTa.frame.origin.x + lScoreTa.frame.size.width - lScoreTa.frame.size.height / 2, y: lScoreTa.frame.origin.y, width: lScoreTa.frame.size.height, height: lScoreTa.frame.size.height))
        vScoreCircleTa.backgroundColor = ThemeHelper.getColorPrimary()
        ViewUtils.setViewRadiusCircle(vScoreCircleTa)
        
        // scoreMe
        lScoreMe = ViewHelper.getLabelBold(text: "0", size: ViewHelper.FONT_SIZE_BIG, color: ColorHelper.getFontWhite(), lines: 1, align: .center, mode: .byTruncatingMiddle)
        lScoreMe.frame.size.height += margin * 2
        lScoreMe.frame.size.width = (screenWidth - margin - lScoreMe.frame.size.height) / 2
        lScoreMe.frame.origin = CGPoint(x: screenWidth - lScoreMe.frame.size.width, y: margin / 2)
        lScoreMe.backgroundColor = ThemeHelper.getColorPrimary()
        ViewUtils.setViewShadow(lScoreMe, offset: ViewHelper.SHADOW_NORMAL)
        let vScoreCircleMe = UIView(frame: CGRect(x: lScoreMe.frame.origin.x - lScoreMe.frame.size.height / 2, y: lScoreMe.frame.origin.y, width: lScoreMe.frame.size.height, height: lScoreMe.frame.size.height))
        vScoreCircleMe.backgroundColor = ThemeHelper.getColorPrimary()
        ViewUtils.setViewRadiusCircle(vScoreCircleMe)
        
        // search
        lSearch = ViewHelper.getLabelGreyNormal(text: ApiHelper.LIST_NOTE_WHO_SHOW[searchIndex], lines: 1, align: .center, mode: .byTruncatingTail)
        let ivSearch = ViewHelper.getImageView(img: UIImage(named: "ic_perm_identity_grey_18dp"), width: lSearch.frame.size.height, height: lSearch.frame.size.height, mode: .scaleAspectFit)
        let vSearch = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth / 3, height: lSearch.frame.size.height + margin * 2))
        
        ivSearch.frame.origin = CGPoint(x: (vSearch.frame.size.width - ivSearch.frame.size.width - margin - lSearch.frame.size.width) / 2, y: margin)
        lSearch.frame.origin = CGPoint(x: ivSearch.frame.origin.x + ivSearch.frame.size.width + margin, y: margin)
        vSearch.addSubview(ivSearch)
        vSearch.addSubview(lSearch)
        
        // rule
        let lRule = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("award_rule"), lines: 1, align: .center, mode: .byTruncatingTail)
        let ivRule = ViewHelper.getImageView(img: UIImage(named: "ic_exposure_grey_18dp"), width: lRule.frame.size.height, height: lRule.frame.size.height, mode: .scaleAspectFit)
        let vRule = UIView(frame: CGRect(x: screenWidth / 3, y: 0, width: screenWidth / 3, height: lRule.frame.size.height + margin * 2))
        
        ivRule.frame.origin = CGPoint(x: (vRule.frame.size.width - ivRule.frame.size.width - margin - lRule.frame.size.width) / 2, y: margin)
        lRule.frame.origin = CGPoint(x: ivRule.frame.origin.x + ivRule.frame.size.width + margin, y: margin)
        vRule.addSubview(ivRule)
        vRule.addSubview(lRule)
        
        // add
        let lAdd = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("publish"), lines: 1, align: .center, mode: .byTruncatingTail)
        let ivAdd = ViewHelper.getImageView(img: UIImage(named: "ic_add_circle_outline_grey_18dp"), width: lAdd.frame.size.height, height: lAdd.frame.size.height, mode: .scaleAspectFit)
        let vAdd = UIView(frame: CGRect(x: screenWidth / 3 * 2, y: 0, width: screenWidth / 3, height: lAdd.frame.size.height + margin * 2))
        
        ivAdd.frame.origin = CGPoint(x: (vAdd.frame.size.width - ivAdd.frame.size.width - margin - lAdd.frame.size.width) / 2, y: margin)
        lAdd.frame.origin = CGPoint(x: ivAdd.frame.origin.x + ivAdd.frame.size.width + margin, y: margin)
        vAdd.addSubview(ivAdd)
        vAdd.addSubview(lAdd)
        
        // line
        let vLineTop = ViewHelper.getViewLine(width: screenWidth)
        vLineTop.frame.origin = CGPoint(x: 0, y: 0)
        let vLineLeft = ViewHelper.getViewLine(height: vRule.frame.size.height)
        vLineLeft.center.x = screenWidth / 3
        vLineLeft.frame.origin.y = 0
        let vLineRight = ViewHelper.getViewLine(height: vRule.frame.size.height)
        vLineRight.center.x = screenWidth / 3 * 2
        vLineRight.frame.origin.y = 0
        
        // bottomBar
        let vBottomBar = UIView()
        vBottomBar.frame.size = CGSize(width: screenWidth, height: vSearch.frame.size.height + ScreenUtils.getBottomNavHeight())
        vBottomBar.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height - RootVC.get().getTopBarHeight() - vBottomBar.frame.size.height)
        vBottomBar.backgroundColor = ColorHelper.getWhite()
        
        vBottomBar.addSubview(vSearch)
        vBottomBar.addSubview(vRule)
        vBottomBar.addSubview(vAdd)
        vBottomBar.addSubview(vLineTop)
        vBottomBar.addSubview(vLineLeft)
        vBottomBar.addSubview(vLineRight)
        
        // tableView
        tableView = ViewUtils.getTableView(target: self, frame: self.view.bounds, cellCls: NoteAwardCell.self, id: NoteAwardCell.ID)
        initScrollState(scroll: tableView, clipTopBar: true, canEmpty: true, emptyColor: ColorHelper.getFontGrey(),
                        canRefresh: true, refreshBlock: { self.refreshData(more: false) },
                        canMore: true) { self.refreshData(more: true) }
        tableView.frame.origin.y += lScoreTa.frame.origin.y * 2 + lScoreTa.frame.size.height
        tableView.frame.size.height -= vBottomBar.frame.size.height + lScoreTa.frame.origin.y * 2 + lScoreTa.frame.size.height
        
        // view
        self.view.addSubview(lScoreTa)
        self.view.addSubview(vScoreCircleTa)
        self.view.addSubview(lScoreMe)
        self.view.addSubview(vScoreCircleMe)
        self.view.addSubview(tableView)
        self.view.addSubview(vBottomBar)
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vSearch, action: #selector(showSearchAlert))
        ViewUtils.addViewTapTarget(target: self, view: vRule, action: #selector(goRule))
        ViewUtils.addViewTapTarget(target: self, view: vAdd, action: #selector(goAdd))
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_AWARD_LIST_REFRESH)
        // refresh
        startScrollDataSet(scroll: tableView)
    }
    
    @objc func notifyRefresh(notify: NSNotification) {
        startScrollDataSet(scroll: tableView)
    }
    
    private func refreshData(more: Bool) {
        if !more { refreshScoreData() } // 加载分数
        page = more ? page + 1 : 0
        let searchType = ApiHelper.LIST_NOTE_WHO_TYPE[searchIndex]
        // api
        let api = Api.request(.noteAwardListGet(who: searchType, page: page),
                              success: { (_, _, data) in
                                NoteAwardCell.refreshHeightMap(refresh: !more, start: self.awardList?.count ?? 0, dataList: data.awardList)
                                if !more {
                                    self.awardList = data.awardList
                                    self.endScrollDataRefresh(scroll: self.tableView, msg: data.show, count: data.awardList?.count ?? 0)
                                } else {
                                    self.awardList = (self.awardList ?? [Award]()) + (data.awardList ?? [Award]())
                                    self.endScrollDataMore(scroll: self.tableView, msg: data.show, count: data.awardList?.count ?? 0)
                                }
        }, failure: { (_, msg, _) in
            self.endScrollState(scroll: self.tableView, msg: msg)
        })
        pushApi(api)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return awardList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NoteAwardCell.getCellHeight(view: tableView, indexPath: indexPath, dataList: awardList)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return NoteAwardCell.getCellWithData(view: tableView, indexPath: indexPath, dataList: awardList, target: self, actionEdit: #selector(targetRemoveItem))
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
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC(HelpVC.INDEX_NOTE_AWARD)
    }
    
    @objc func goRule() {
        NoteAwardRuleVC.pushVC()
    }
    
    @objc func goAdd() {
        NoteAwardEditVC.pushVC()
    }
    
    func refreshScoreData() {
        let api = Api.request(.noteAwardScoreGet, loading: false, cancel: false, success: { (_, _, data) in
            let scoreMe = data.awardScoreMe?.totalScore
            var scoreMeShow = "0"
            if scoreMe != nil && scoreMe! != 0 {
                scoreMeShow = scoreMe! > Int64(0) ? "+\(scoreMe!)" : "\(scoreMe!)"
            }
            self.lScoreMe.text = scoreMeShow
            let scoreTa = data.awardScoreTa?.totalScore
            var scoreTaShow = "0"
            if scoreTa != nil && scoreTa! != 0 {
                scoreTaShow = scoreTa! > Int64(0) ? "+\(scoreTa!)" : "\(scoreTa!)"
            }
            self.lScoreTa.text = scoreTaShow
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
                                        self.delAward(index: indexPath.row)
                                    }
        },
                                  cancelHandler: nil)
    }
    
    private func delAward(index: Int) {
        if awardList == nil || awardList!.count <= index {
            return
        }
        let award = awardList![index]
        if !award.isMine() {
            ToastUtils.show(StringUtils.getString("can_operation_self_create_note"))
            return
        }
        // api
        let api = Api.request(.noteAwardDel(aid: award.id),
                              loading: true, cancel: true, success: { (_, _, data) in
                                self.awardList!.remove(at: index)
                                NoteAwardCell.refreshHeightMap(refresh: true, start: 0, dataList: self.awardList)
                                self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                                self.endScrollState(scroll: self.tableView, msg: nil)
        }, failure: nil)
        pushApi(api)
    }
    
}
