//
//  CoupleWallPaperVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/19.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class CoupleWallPaperVC: BaseVC, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // view
    private var collectView: UICollectionView!
    
    // var
    private var isDel = false
    
    public static func pushVC() {
        if UserHelper.isCoupleBreak(couple: UDHelper.getCouple()) {
            CouplePairVC.pushVC()
            return
        }
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(CoupleWallPaperVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "wall_paper")
        let barAdd = UIBarButtonItem(image: UIImage(named: "ic_add_white_24dp"), style: .plain, target: self, action: #selector(targetAdd))
        let barRemove = UIBarButtonItem(image: UIImage(named: "ic_delete_white_24dp"), style: .plain, target: self, action: #selector(targetModelRemove))
        self.navigationItem.rightBarButtonItems = [barAdd, barRemove]
        
        // collect
        collectView = ViewUtils.getCollectionView(target: self, frame: self.view.bounds, layout: CoupleWallPaperCell.getLayout(),
                                                  cellCls: CoupleWallPaperCell.self, id: CoupleWallPaperCell.ID)
        initScrollState(scroll: collectView, clipTopBar: false, clipBottomNav: true, canEmpty: true, emptyColor: ColorHelper.getFontGrey(),
                        canRefresh: true, refreshBlock: { self.refreshData() },
                        canMore: false, moreBlock: nil)
        
        // view
        self.view.addSubview(collectView)
    }
    
    override func initData() {
        startScrollDataSet(scroll: collectView)
    }
    
    private func refreshData() {
        let api = Api.request(.coupleWallPaperGet,
                              loading: false, success: { (_, _, data) in
                                UDHelper.setWallPaper(data.wallPaper)
                                self.endScrollDataRefresh(scroll: self.collectView, msg: data.show)
        }) { (_, msg, _) in
            self.endScrollState(scroll: self.collectView, msg: msg)
        }
        pushApi(api)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UDHelper.getWallPaper().contentImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataList = UDHelper.getWallPaper().contentImageList
        return CoupleWallPaperCell.getCellWithData(view: collectionView, indexPath: indexPath, dataList: dataList, target: self, action: #selector(targetRemoveItem))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ossKeyList = UDHelper.getWallPaper().contentImageList
        BrowserHelper.goBrowserImage(delegate: self, index: indexPath.item, ossKeyList: ossKeyList)
    }
    
    @objc private func targetAdd(sender: UIBarButtonItem) {
        let limit = UDHelper.getVipLimit().wallPaperCount
        if UDHelper.getWallPaper().contentImageList.count >= limit {
            MoreVipVC.pushVC()
            return
        }
        PickerHelper.selectImage(target: self, maxCount: 1, gif: true, compress: false, crop: true, complete: nil)
    }
    
    override func onImageCropSuccess(data: Data?) {
        OssHelper.uploadWall(data: data, success: { (_, ossKey) in
            self.addWallPaper(ossKey: ossKey)
        }, failure: nil)
    }
    
    private func addWallPaper(ossKey: String) {
        let wallPaper = UDHelper.getWallPaper()
        wallPaper.contentImageList.append(ossKey)
        // api
        let api = Api.request(.coupleWallPaperUpdate(wallPaper: wallPaper.toJSON()),
                              loading: true, cancel: true, success: { (_, _, data) in
                                UDHelper.setWallPaper(data.wallPaper)
                                self.endScrollDataRefresh(scroll: self.collectView, msg: data.show)
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_WALL_PAPER_REFRESH, obj: data.wallPaper)
        }, failure: nil)
        pushApi(api)
    }
    
    @objc private func targetModelRemove(sender: UIBarButtonItem) {
        isDel = !isDel
        CoupleWallPaperCell.toggleModel(view: collectView, count: UDHelper.getWallPaper().contentImageList.count, del: isDel)
    }
    
    @objc private func targetRemoveItem(sender: UIButton) {
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_delete_this_image"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm")],
                                  cancel: StringUtils.getString("cancel"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    if let indexPath = ViewUtils.findCollectIndexPath(view: sender) {
                                        self.delWallPaper(index: indexPath.item)
                                    }
        },
                                  cancelHandler: nil)
    }
    
    private func delWallPaper(index: Int) {
        let body = UDHelper.getWallPaper()
        body.contentImageList.remove(at: index)
        // api
        let api = Api.request(.coupleWallPaperUpdate(wallPaper: body.toJSON()),
                              loading: true, cancel: true, success: { (_, _, data) in
                                UDHelper.setWallPaper(data.wallPaper)
                                self.collectView.deleteItems(at: [IndexPath(item: index, section: 0)])
                                self.endScrollState(scroll: self.collectView, msg: data.show)
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_WALL_PAPER_REFRESH, obj: data.wallPaper)
        }, failure: nil)
        pushApi(api)
    }
    
}
