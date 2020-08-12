//
//  NoteVideoVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/2/23.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteVideoVC: BaseVC, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var screenHeight = ScreenUtils.getScreenHeight() - RootVC.get().getTopBarHeight()
    
    // view
    private var collectView: UICollectionView!
    
    // var
    private var videoList: [Video]?
    private var page = 0
    
    public static func pushVC(select: Bool = false) {
        AppDelegate.runOnMainAsync {
            let vc = NoteVideoVC(nibName: nil, bundle: nil)
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
        initNavBar(title: isFromSelect() ? "please_select_video" : "video")
        
        // collect
        collectView = ViewUtils.getCollectionView(target: self, frame: self.view.bounds, layout: NoteVideoCell.getLayout(),
                                                  cellCls: NoteVideoCell.self, id: NoteVideoCell.ID)
        initScrollState(scroll: collectView, clipTopBar: true, canEmpty: true, emptyColor: ColorHelper.getFontGrey(),
                        canRefresh: true, refreshBlock: { self.refreshData(more: false) },
                        canMore: true, moreBlock: { self.refreshData(more: true) })
        
        // add
        let btnAdd = ViewHelper.getBtnImgCenter(width: ViewHelper.FAB_SIZE, height: ViewHelper.FAB_SIZE, bgColor: ThemeHelper.getColorAccent(), bgImg: UIImage(named: "ic_add_white_24dp"), circle: true, shadow: true)
        btnAdd.frame.origin = CGPoint(x: screenWidth - ViewHelper.FAB_MARGIN - btnAdd.frame.size.width, y: screenHeight - ViewHelper.FAB_MARGIN - btnAdd.frame.size.height)
        
        // view
        self.view.addSubview(collectView)
        self.view.addSubview(btnAdd)
        
        // target
        btnAdd.addTarget(self, action: #selector(goAdd), for: .touchUpInside)
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyRefresh), name: NotifyHelper.TAG_VIDEO_LIST_REFRESH)
        // refresh
        startScrollDataSet(scroll: collectView)
    }
    
    @objc func notifyRefresh(notify: NSNotification) {
        startScrollDataSet(scroll: collectView)
    }
    
    func isFromSelect() -> Bool {
        return actFrom == BaseVC.ACT_LIST_FROM_SELECT
    }
    
    private func refreshData(more: Bool) {
        page = more ? page + 1 : 0
        // api
        let api = Api.request(.noteVideoListGet(page: page),
                              success: { (_, _, data) in
                                if !more {
                                    self.videoList = data.videoList
                                    self.endScrollDataRefresh(scroll: self.collectView, msg: data.show, count: data.videoList?.count ?? 0)
                                } else {
                                    self.videoList = (self.videoList ?? [Video]()) + (data.videoList ?? [Video]())
                                    self.endScrollDataMore(scroll: self.collectView, msg: data.show, count: data.videoList?.count ?? 0)
                                }
        }, failure: { (_, msg, _) in
            self.endScrollState(scroll: self.collectView, msg: msg)
        })
        pushApi(api)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return NoteVideoCell.getCellWithData(view: collectionView, indexPath: indexPath, dataList: videoList, target: self, actionAddress: #selector(goMap), actionMore: #selector(targetRemoveItem))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isFromSelect() {
            NoteVideoCell.selectVideo(view: collectionView, indexPath: indexPath, dataList: videoList)
        } else {
            NoteVideoCell.goPlay(view: collectionView, indexPath: indexPath, dataList: videoList)
        }
    }
    
    @objc private func targetRemoveItem(sender: UIButton) {
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_delete_this_note"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    if let indexPath = ViewUtils.findCollectIndexPath(view: sender) {
                                        self.delVideo(index: indexPath.item)
                                    }
        },
                                  cancelHandler: nil)
    }
    
    private func delVideo(index: Int) {
        if videoList == nil || videoList!.count <= index {
            return
        }
        let video = videoList![index]
        if !video.isMine() {
            ToastUtils.show(StringUtils.getString("can_operation_self_create_note"))
            return
        }
        // api
        let api = Api.request(.noteVideoDel(vid: video.id),
                              loading: true, cancel: true, success: { (_, _, data) in
                                self.videoList!.remove(at: index)
                                self.collectView.deleteItems(at: [IndexPath(item: index, section: 0)])
                                self.endScrollState(scroll: self.collectView, msg: nil)
        }, failure: nil)
        pushApi(api)
    }
    
    @objc func goMap(sender: UIButton) {
        NoteVideoCell.goMap(view: sender, dataList: videoList)
    }
    
    @objc func goAdd() {
        NoteVideoEditVC.pushVC()
    }
    
}
