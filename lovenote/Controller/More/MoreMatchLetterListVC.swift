//
//  MoreMatchLetterListVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/5/8.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class MoreMatchLetterListVC: BaseVC, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    
    // view
    private var collectView: UICollectionView!
    private var lOrder: UILabel!
    
    // var
    private var pid: Int64 = 0
    private var workList: [MatchWork]?
    private var page = 0
    private var orderIndex = 0
    private var showNew = false
    
    public static func pushVC(pid: Int64, showNew: Bool) {
        if pid <= 0 {
            return
        }
        AppDelegate.runOnMainAsync {
            let vc = MoreMatchLetterListVC(nibName: nil, bundle: nil)
            vc.pid = pid
            vc.showNew = showNew
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "nav_letter")
        let barHelp = UIBarButtonItem(image: UIImage(named: "ic_help_outline_white_24dp"), style: .plain, target: self, action: #selector(targetGoHelp))
        let barMenu = UIBarButtonItem(image: UIImage(named: "ic_menu_white_24dp"), style: .plain, target: self, action: #selector(targetGoOld))
        self.navigationItem.rightBarButtonItems = [barMenu, barHelp]
        
        // top
        let lTop = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("top"), lines: 1, align: .center, mode: .byTruncatingTail)
        let ivTop = ViewHelper.getImageView(img: UIImage(named: "ic_publish_grey_18dp"), width: lTop.frame.size.height, height: lTop.frame.size.height, mode: .scaleAspectFit)
        let vTop = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth / 3, height: lTop.frame.size.height + margin * 2))
        
        ivTop.frame.origin = CGPoint(x: (vTop.frame.size.width - ivTop.frame.size.width - margin - lTop.frame.size.width) / 2, y: margin)
        lTop.frame.origin = CGPoint(x: ivTop.frame.origin.x + ivTop.frame.size.width + margin, y: margin)
        vTop.addSubview(ivTop)
        vTop.addSubview(lTop)
        
        // order
        lOrder = ViewHelper.getLabelGreyNormal(text: ApiHelper.LIST_MATCH_ORDER_SHOW[orderIndex], lines: 1, align: .center, mode: .byTruncatingTail)
        let ivOrder = ViewHelper.getImageView(img: UIImage(named: "ic_search_grey_18dp"), width: lOrder.frame.size.height, height: lOrder.frame.size.height, mode: .scaleAspectFit)
        let vOrder = UIView(frame: CGRect(x: screenWidth / 3, y: 0, width: screenWidth / 3, height: lOrder.frame.size.height + margin * 2))
        
        ivOrder.frame.origin = CGPoint(x: (vOrder.frame.size.width - ivOrder.frame.size.width - margin - lOrder.frame.size.width) / 2, y: margin)
        lOrder.frame.origin = CGPoint(x: ivOrder.frame.origin.x + ivOrder.frame.size.width + margin, y: margin)
        vOrder.addSubview(ivOrder)
        vOrder.addSubview(lOrder)
        
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
        let vLineLeft = ViewHelper.getViewLine(height: vTop.frame.size.height)
        vLineLeft.center.x = screenWidth / 3
        vLineLeft.frame.origin.y = 0
        let vLineRight = ViewHelper.getViewLine(height: vTop.frame.size.height)
        vLineRight.center.x = screenWidth / 3 * 2
        vLineRight.frame.origin.y = 0
        
        // bottomBar
        let vBottomBar = UIView()
        vBottomBar.frame.size = CGSize(width: screenWidth, height: vTop.frame.size.height + ScreenUtils.getBottomNavHeight())
        vBottomBar.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height - RootVC.get().getTopBarHeight() - vBottomBar.frame.size.height)
        vBottomBar.backgroundColor = ColorHelper.getWhite()
        
        vBottomBar.addSubview(vTop)
        vBottomBar.addSubview(vOrder)
        vBottomBar.addSubview(vAdd)
        vBottomBar.addSubview(vLineTop)
        vBottomBar.addSubview(vLineLeft)
        vBottomBar.addSubview(vLineRight)
        
        // collect
        collectView = ViewUtils.getCollectionView(target: self, frame: self.view.bounds, layout: MoreMatchLetterCell.getLayout(),
                                                  cellCls: MoreMatchLetterCell.self, id: MoreMatchLetterCell.ID)
        initScrollState(scroll: collectView, clipTopBar: true, canEmpty: true, emptyColor: ColorHelper.getFontGrey(),
                        canRefresh: true, refreshBlock: { self.refreshData(more: false) },
                        canMore: true, moreBlock: { self.refreshData(more: true) })
        collectView.frame.size.height -= vBottomBar.frame.size.height
        
        // view
        self.view.addSubview(collectView)
        self.view.addSubview(vBottomBar)
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vTop, action: #selector(targetGoTop))
        ViewUtils.addViewTapTarget(target: self, view: vOrder, action: #selector(showOrderAlert))
        ViewUtils.addViewTapTarget(target: self, view: vAdd, action: #selector(targetGoAdd))
    }
    
    override func initData() {
        // refresh
        startScrollDataSet(scroll: collectView)
    }
    
    private func refreshData(more: Bool) {
        page = more ? page + 1 : 0
        let orderType = ApiHelper.LIST_MATCH_ORDER_TYPE[orderIndex]
        // api
        let api = Api.request(.moreMatchWorkListGet(mpid: pid, order: orderType, page: page),
                              success: { (_, _, data) in
                                if !more {
                                    self.workList = data.matchWorkList
                                    if let layout = self.collectView.collectionViewLayout as? LetterFlowLayout {
                                        layout.setDataList(dataList: self.workList)
                                        layout.invalidateLayout()
                                    }
                                    self.endScrollDataRefresh(scroll: self.collectView, msg: data.show, count: data.matchWorkList?.count ?? 0)
                                } else {
                                    self.workList = (self.workList ?? [MatchWork]()) + (data.matchWorkList ?? [MatchWork]())
                                    if let layout = self.collectView.collectionViewLayout as? LetterFlowLayout {
                                        layout.setDataList(dataList: self.workList)
                                        layout.invalidateLayout()
                                    }
                                    self.endScrollDataMore(scroll: self.collectView, msg: data.show, count: data.matchWorkList?.count ?? 0)
                                }
        }, failure: { (_, msg, _) in
            self.endScrollState(scroll: self.collectView, msg: msg)
        })
        pushApi(api)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return MoreMatchLetterCell.getCellWithData(view: collectionView, indexPath: indexPath, dataList: workList, target: self, actionCoin: #selector(targetCoin), actionPoint: #selector(targetPoint), actionMore: #selector(targetMore))
    }
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC(HelpVC.INDEX_MORE_MATCH)
    }
    
    @objc private func targetGoOld() {
        MoreMatchLetterVC.pushVC()
    }
    
    @objc private func targetGoTop(sender: UIGestureRecognizer) {
        collectView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    
    @objc private func targetGoAdd(sender: UIGestureRecognizer) {
        MoreMatchLetterAddVC.pushVC(pid: pid)
    }
    
    @objc private func showOrderAlert(sender: UIGestureRecognizer) {
        var searchList = ApiHelper.LIST_MATCH_ORDER_SHOW
        if !showNew {
            searchList.remove(at: searchList.count - 1)
        }
        _ = AlertHelper.showAlert(title: StringUtils.getString("select_search_type"),
                                  confirms: searchList,
                                  cancel: StringUtils.getString("cancel"),
                                  canCancel: true,
                                  actionHandler: { (_, index, _) in
                                    self.orderIndex = Int(index)
                                    self.lOrder.text = ApiHelper.LIST_MATCH_ORDER_SHOW[self.orderIndex]
                                    self.startScrollDataSet(scroll: self.collectView)
        }, cancelHandler: nil)
    }
    
    @objc private func targetCoin(sender: UIGestureRecognizer) {
        if let indexPath = ViewUtils.findCollectIndexPath(view: sender.view) {
            _ = AlertHelper.showEdit(title: StringUtils.getString("input_coin_count"),
                                     msg: nil,
                                     text: "",
                                     placeHolder: StringUtils.getString("input_coin_count"),
                                     keyboard: .numberPad,
                                     confirms: [StringUtils.getString("confirm_no_wrong")],
                                     cancel: StringUtils.getString("i_think_again"),
                                     canCancel: true,
                                     actionHandler: { (_, _, _, input) in
                                        if !StringUtils.isEmpty(input) {
                                            self.itemCoin(index: indexPath.item, count: Int(input ?? "0") ?? 0)
                                        }
            },
                                     cancelHandler: nil)
        }
    }
    
    func itemCoin(index: Int, count: Int) {
        if workList == nil || workList!.count <= index || count <= 0 {
            return
        }
        let work = workList![index]
        let body = MatchCoin()
        body.matchWorkId = work.id
        body.coinCount = count
        // api
        let api = Api.request(.moreMatchCoinAdd(matchCoin: body.toJSON()),
                              success: { (_, _, _) in
                                work.coinCount += count
                                self.collectView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }, failure: nil)
        pushApi(api)
    }
    
    @objc private func targetPoint(sender: UIGestureRecognizer) {
        if let indexPath = ViewUtils.findCollectIndexPath(view: sender.view) {
            itemPoint(index: indexPath.item, api: true)
        }
    }
    
    func itemPoint(index: Int, api: Bool) {
        if workList == nil || workList!.count <= index {
            return
        }
        let work = workList![index]
        let newPoint = !work.point
        var newPointCount = newPoint ? work.pointCount + 1 : work.pointCount - 1
        if newPointCount < 0 {
            newPointCount = 0
        }
        work.point = newPoint
        work.pointCount = newPointCount
        collectView.reloadItems(at: [IndexPath(item: index, section: 0)])
        if !api {
            return
        }
        let body = MatchPoint()
        body.matchWorkId = work.id
        // api
        let api = Api.request(.moreMatchPointAdd(matchPoint: body.toJSON()),
                              success: nil, failure: { (_, msg, _) in
                                self.itemPoint(index: index, api: false)
        })
        pushApi(api)
    }
    
    @objc private func targetMore(sender: UIButton) {
        if let indexPath = ViewUtils.findCollectIndexPath(view: sender) {
            if workList == nil || workList!.count <= indexPath.item {
                return
            }
            let work = workList![indexPath.item]
            if work.mine {
                showItemDeleteAlert(index: indexPath.item)
            } else {
                showItemReportAlert(index: indexPath.item)
            }
        }
    }
    
    func showItemDeleteAlert(index: Int) {
        if workList == nil || workList!.count <= index {
            return
        }
        let work = workList![index]
        if !work.mine {
            return
        }
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_del_this_work"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    self.delItemWork(index: index)
        },
                                  cancelHandler: nil)
    }
    
    private func delItemWork(index: Int) {
        if workList == nil || workList!.count <= index {
            return
        }
        let work = workList![index]
        if !work.mine {
            return
        }
        // api
        let api = Api.request(.moreMatchWorkDel(mwid: work.id),
                              loading: true, cancel: true, success: { (_, _, data) in
                                self.workList!.remove(at: index)
                                self.collectView.deleteItems(at: [IndexPath(item: index, section: 0)])
        }, failure: nil)
        pushApi(api)
    }
    
    func showItemReportAlert(index: Int) {
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_report_this_work"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    self.reportItemWork(index: index, api: true)
        },
                                  cancelHandler: nil)
    }
    
    private func reportItemWork(index: Int, api: Bool) {
        if workList == nil || workList!.count <= index {
            return
        }
        let work = workList![index]
        if work.report {
            return
        }
        work.report = true
        collectView.reloadItems(at: [IndexPath(item: index, section: 0)])
        if !api {
            return
        }
        let body = MatchReport()
        body.matchWorkId = work.id
        // api
        let api = Api.request(.moreMatchReportAdd(matchReport: body.toJSON()),
                              success: nil, failure: { (_, msg, _) in
                                self.reportItemWork(index: index, api: false)
        })
        pushApi(api)
    }
    
}
