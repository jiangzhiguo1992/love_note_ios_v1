//
//  MoreMatchLetterOurVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/5/8.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import XLPagerTabStrip

class MoreMatchLetterOurVC: BaseVC, IndicatorInfoProvider, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    
    // view
    private var collectView: UICollectionView!
    
    // var
    private var height = CGFloat(0)
    private var itemInfo: IndicatorInfo = IndicatorInfo(title: StringUtils.getString("we_de"))
    private var workList: [MatchWork]?
    private var page = 0
    
    public static func get(height: CGFloat) -> MoreMatchLetterOurVC {
        let vc = MoreMatchLetterOurVC(nibName: nil, bundle: nil)
        vc.height = height
        return vc
    }
    
    override func initView() {
        // 不设置的话parent顶部会没有nav
        self.navigationBarShow = true
        
        // collect
        let collectFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.height)
        collectView = ViewUtils.getCollectionView(target: self, frame: collectFrame, layout: MoreMatchLetterCell.getLayout(),
                                                  cellCls: MoreMatchLetterCell.self, id: MoreMatchLetterCell.ID)
        initScrollState(scroll: collectView, clipTopBar: true, canEmpty: true, emptyColor: ColorHelper.getFontGrey(),
                        canRefresh: true, refreshBlock: { self.refreshData(more: false) },
                        canMore: true, moreBlock: { self.refreshData(more: true) })
        
        // view
        self.view.addSubview(collectView)
    }
    
    override func initData() {
        // refresh
        startScrollDataSet(scroll: collectView)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    private func refreshData(more: Bool) {
        page = more ? page + 1 : 0
        // api
        let api = Api.request(.moreMatchWorkOurListGet(kind: MatchPeriod.MATCH_KIND_LETTER_SHOW, page: page),
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
