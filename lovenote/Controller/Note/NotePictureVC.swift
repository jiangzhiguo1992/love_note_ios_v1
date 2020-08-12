//
//  NotePictureVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/7.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NotePictureVC: BaseVC, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    
    // view
    private var collectView: UICollectionView!
    
    // var
    private var album: Album?
    private var pictureList: [Picture]?
    private var sectionCount = 0
    private var sectionList: [[Picture]] = [[Picture]]()
    private var page = 0
    private var isDelete = false
    private var isDetail = false
    
    public static func pushVC(album: Album? = nil, aid: Int64 = 0) {
        if album == nil && aid == 0 {
            return
        }
        AppDelegate.runOnMainAsync {
            let vc = NotePictureVC(nibName: nil, bundle: nil)
            if album != nil {
                vc.album = album
            } else if aid != 0 {
                vc.album = Album()
                vc.album!.id = aid
            } else {
                return
            }
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "picture")
        let barItemEdit = UIBarButtonItem(image: UIImage(named: "ic_edit_white_24dp"), style: .plain, target: self, action: #selector(targetAlbumGoEdit))
        let barItemDel = UIBarButtonItem(image: UIImage(named: "ic_delete_white_24dp"), style: .plain, target: self, action: #selector(showAlbumDeleteAlert))
        self.navigationItem.setRightBarButtonItems([barItemEdit, barItemDel], animated: true)
        
        // delete
        let lDelete = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("delete"), lines: 1, align: .center, mode: .byTruncatingTail)
        let ivDelete = ViewHelper.getImageView(img: UIImage(named: "ic_delete_grey_18dp"), width: lDelete.frame.size.height, height: lDelete.frame.size.height, mode: .scaleAspectFit)
        let vDelete = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth / 3, height: lDelete.frame.size.height + margin * 2))
        
        ivDelete.frame.origin = CGPoint(x: (vDelete.frame.size.width - ivDelete.frame.size.width - margin - lDelete.frame.size.width) / 2, y: margin)
        lDelete.frame.origin = CGPoint(x: ivDelete.frame.origin.x + ivDelete.frame.size.width + margin, y: margin)
        vDelete.addSubview(ivDelete)
        vDelete.addSubview(lDelete)
        
        // model
        let lModel = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("model"), lines: 1, align: .center, mode: .byTruncatingTail)
        let ivModel = ViewHelper.getImageView(img: UIImage(named: "ic_loop_grey_18dp"), width: lModel.frame.size.height, height: lModel.frame.size.height, mode: .scaleAspectFit)
        let vModel = UIView(frame: CGRect(x: screenWidth / 3, y: 0, width: screenWidth / 3, height: lModel.frame.size.height + margin * 2))
        
        ivModel.frame.origin = CGPoint(x: (vModel.frame.size.width - ivModel.frame.size.width - margin - lModel.frame.size.width) / 2, y: margin)
        lModel.frame.origin = CGPoint(x: ivModel.frame.origin.x + ivModel.frame.size.width + margin, y: margin)
        vModel.addSubview(ivModel)
        vModel.addSubview(lModel)
        
        // add
        let lAdd = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("add"), lines: 1, align: .center, mode: .byTruncatingTail)
        let ivAdd = ViewHelper.getImageView(img: UIImage(named: "ic_add_circle_outline_grey_18dp"), width: lAdd.frame.size.height, height: lAdd.frame.size.height, mode: .scaleAspectFit)
        let vAdd = UIView(frame: CGRect(x: screenWidth / 3 * 2, y: 0, width: screenWidth / 3, height: lAdd.frame.size.height + margin * 2))
        
        ivAdd.frame.origin = CGPoint(x: (vAdd.frame.size.width - ivAdd.frame.size.width - margin - lAdd.frame.size.width) / 2, y: margin)
        lAdd.frame.origin = CGPoint(x: ivAdd.frame.origin.x + ivAdd.frame.size.width + margin, y: margin)
        vAdd.addSubview(ivAdd)
        vAdd.addSubview(lAdd)
        
        // line
        let vLineTop = ViewHelper.getViewLine(width: screenWidth)
        vLineTop.frame.origin = CGPoint(x: 0, y: 0)
        let vLineLeft = ViewHelper.getViewLine(height: vModel.frame.size.height)
        vLineLeft.center.x = screenWidth / 3
        vLineLeft.frame.origin.y = 0
        let vLineRight = ViewHelper.getViewLine(height: vModel.frame.size.height)
        vLineRight.center.x = screenWidth / 3 * 2
        vLineRight.frame.origin.y = 0
        
        // bottomBar
        let vBottomBar = UIView()
        vBottomBar.frame.size = CGSize(width: screenWidth, height: vModel.frame.size.height + ScreenUtils.getBottomNavHeight())
        vBottomBar.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height - RootVC.get().getTopBarHeight() - vBottomBar.frame.size.height)
        vBottomBar.backgroundColor = ColorHelper.getWhite()
        
        vBottomBar.addSubview(vDelete)
        vBottomBar.addSubview(vModel)
        vBottomBar.addSubview(vAdd)
        vBottomBar.addSubview(vLineTop)
        vBottomBar.addSubview(vLineLeft)
        vBottomBar.addSubview(vLineRight)
        
        // collect
        let layout = NotePictureCell.getLayout()
        layout.headerReferenceSize = CGSize(width: 0, height: ScreenUtils.heightFit(50))
        collectView = ViewUtils.getCollectionView(target: self, frame: self.view.bounds, layout: layout,
                                                  cellCls: NotePictureCell.self, id: NotePictureCell.ID)
        initScrollState(scroll: collectView, clipTopBar: true, canEmpty: true, emptyColor: ColorHelper.getFontGrey(),
                        canRefresh: true, refreshBlock: { self.refreshData(more: false) },
                        canMore: true) { self.refreshData(more: true)
        }
        collectView.register(NotePictureSectionCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NotePictureSectionCell.ID_HEAD)
        collectView.frame.size.height -= vBottomBar.frame.size.height
        
        // view
        self.view.addSubview(vBottomBar)
        self.view.addSubview(collectView)
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vDelete, action: #selector(targetModelDelete))
        ViewUtils.addViewTapTarget(target: self, view: vModel, action: #selector(targetModelDetail))
        ViewUtils.addViewTapTarget(target: self, view: vAdd, action: #selector(targetPictureGoEdit))
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyAlbumRefresh), name: NotifyHelper.TAG_ALBUM_DETAIL_REFRESH)
        NotifyHelper.addObserver(self, selector: #selector(notifyPictureRefresh), name: NotifyHelper.TAG_PICTURE_LIST_REFRESH)
        // album
        refreshAlbumView()
        // picture
        startScrollDataSet(scroll: collectView)
    }
    
    @objc func notifyAlbumRefresh(notify: NSNotification) {
        refreshAlbum()
    }
    
    @objc func notifyPictureRefresh(notify: NSNotification) {
        startScrollDataSet(scroll: collectView)
    }
    
    func getSectionList(clear: Bool, sectionList: [[Picture]]? = nil, pictureList: [Picture]?) -> [[Picture]] {
        if clear || sectionList == nil {
            return getNewSectionList(pictureList: pictureList)
        } else {
            return getMoreSectionList(sl: sectionList!, pictureList: pictureList)
        }
    }
    
    func getNewSectionList(pictureList: [Picture]?) -> [[Picture]] {
        var sectionList: [[Picture]] = [[Picture]]()
        if pictureList == nil || pictureList!.count <= 0 {
            return sectionList
        }
        // 当前head
        var head: Picture?
        var subList = [Picture]()
        for (index, picture) in pictureList!.enumerated() {
            // 开始循环
            if index <= 0 || subList.count <= 0 || head == nil {
                // 第一个
                head = picture
                subList.append(picture)
            } else {
                // 不是第一个
                if !DateUtils.isSameDay(head!.happenAt, picture.happenAt) {
                    // 不是同一天
                    sectionList.append(subList)
                    subList = [Picture]()
                    head = picture
                    subList.append(picture)
                } else {
                    // 是同一天
                    subList.append(picture)
                }
            }
        }
        // 加上最后一个
        sectionList.append(subList)
        return sectionList
    }
    
    func getMoreSectionList(sl: [[Picture]], pictureList: [Picture]?) -> [[Picture]] {
        var sectionList = sl
        if pictureList == nil || pictureList!.count <= 0 {
            return sectionList
        }
        if sectionList.count <= 0 {
            return getNewSectionList(pictureList: pictureList)
        }
        // 当前head
        var head: Picture?
        for (index, picture) in pictureList!.enumerated() {
            // 开始循环
            if index <= 0 || head == nil {
                // 是第一个
                let lastSection = sectionList[sectionList.count - 1]
                if lastSection.count <= 0 {
                    head = picture
                } else {
                    head = lastSection[lastSection.count - 1]
                }
            }
            if !DateUtils.isSameDay(head!.happenAt, picture.happenAt) {
                head = picture
                sectionList.append([Picture]())
            }
            sectionList[sectionList.count - 1].append(picture)
        }
        return sectionList
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sectionList.count <= section {
            return 0
        }
        return sectionList[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let head = collectView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NotePictureSectionCell.ID_HEAD, for: indexPath) as! NotePictureSectionCell
        var picture: Picture?
        let section = indexPath.section
        if sectionList.count > section && section >= 0 {
            let pictureList = sectionList[section]
            if pictureList.count > 0 {
                picture = pictureList[0]
            }
        }
        head.lHappenAt.text = (picture == nil) ? "" : DateUtils.getStr(picture!.happenAt, DateUtils.FORMAT_LINE_Y_M_D)
        return head
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var pictureList = self.pictureList
        let section = indexPath.section
        if sectionList.count > section && section >= 0 {
            pictureList = sectionList[section]
        }
        return NotePictureCell.getCellWithData(view: collectionView, indexPath: indexPath, dataList: pictureList,
                                               delete: isDelete, detail: isDetail,
                                               target: self, actionDelete: #selector(showPictureDeleteAlert), actionAddress: #selector(goMap))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if pictureList == nil || pictureList!.count <= 0 {
            return
        }
        let section = indexPath.section
        if sectionList.count <= section {
            return
        }
        let item = indexPath.item
        if sectionList[section].count <= item {
            return
        }
        // 再ossKeyList
        var ossKeyList = [String]()
        for picture in pictureList! {
            if !StringUtils.isEmpty(picture.contentImage) {
                ossKeyList.append(picture.contentImage)
            }
        }
        // 再index
        var index = 0
        for (i, ps) in sectionList.enumerated() {
            if i == section {
                index += item
                break
            }
            index += ps.count
        }
        // 最后跳转大图浏览
        if index >= ossKeyList.count {
            return
        }
        BrowserHelper.goBrowserImage(delegate: self, index: index, ossKeyList: ossKeyList)
    }
    
    @objc func targetAlbumGoEdit() {
        if album == nil || album!.id == 0 {
            return
        }
        NoteAlbumEditVC.pushVC(album: album)
    }
    
    @objc func showAlbumDeleteAlert() {
        if album == nil || !album!.isMine() {
            ToastUtils.show(StringUtils.getString("can_operation_self_create_note"))
            return
        }
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_delete_this_note"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    self.delAlbum()
        },
                                  cancelHandler: nil)
    }
    
    private func delAlbum() {
        if album == nil {
            return
        }
        // api
        let api = Api.request(.noteAlbumDel(aid: album!.id),
                              loading: true, cancel: true, success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_ALBUM_LIST_ITEM_DELETE, obj: self.album!)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
    func refreshAlbum() {
        if album == nil || album!.id == 0 {
            return
        }
        let api = Api.request(.noteAlbumGet(aid: album!.id),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                self.album = data.album
                                self.refreshAlbumView()
        },
                              failure: nil)
        pushApi(api)
    }
    
    func refreshAlbumView() {
        if album == nil {
            return
        }
        initNavBar(title: album!.title + "(\(album!.pictureCount))")
    }
    
    private func refreshData(more: Bool) {
        if album == nil {
            self.endScrollState(scroll: self.collectView, msg: nil)
            return
        }
        page = more ? page + 1 : 0
        // api
        let api = Api.request(.notePictureListGet(aid: album!.id, page: page),
                              success: { (_, _, data) in
                                // self.setSectionList(clear: !more, pictureList: data.pictureList)
                                if !more {
                                    self.pictureList = data.pictureList
                                    self.sectionList = self.getSectionList(clear: true, pictureList: self.pictureList)
                                    self.sectionCount = self.sectionList.count
                                    self.collectView.reloadData()
                                    self.endScrollState(scroll: self.collectView, msg: data.show)
                                } else {
                                    self.pictureList = (self.pictureList ?? [Picture]()) + (data.pictureList ?? [Picture]())
                                    let sectionNewList = self.getSectionList(clear: false, sectionList: self.sectionList, pictureList: data.pictureList ?? [Picture]())
                                    var isStart = true
                                    var indexSection = self.sectionList.count - 1
                                    var indexPaths = [IndexPath]()
                                    var indexSet = IndexSet()
                                    while indexSection < sectionNewList.count {
                                        let items = sectionNewList[indexSection]
                                        var indexItem = isStart ? self.sectionList[indexSection].count : 0
                                        while indexItem < items.count {
                                            indexPaths.append(IndexPath(item: indexItem, section: indexSection))
                                            indexItem += 1
                                        }
                                        if indexItem > 0 {
                                            if !isStart {
                                                indexSet.insert(indexSection)
                                            }
                                        }
                                        indexSection += 1
                                        isStart = false
                                    }
                                    self.sectionCount = sectionNewList.count
                                    if indexSet.count > 0 {
                                        self.collectView.insertSections(indexSet)
                                    }
                                    self.sectionList = sectionNewList
                                    if indexPaths.count > 0 {
                                        self.collectView.insertItems(at: indexPaths)
                                    }
                                    self.endScrollState(scroll: self.collectView, msg: data.show)
                                }
        }, failure: { (_, msg, _) in
            self.endScrollState(scroll: self.collectView, msg: msg)
        })
        pushApi(api)
    }
    
    @objc private func targetModelDelete() {
        isDelete = !isDelete
        for (i1, pictureList) in sectionList.enumerated() {
            for (i2, _) in pictureList.enumerated() {
                if let cell = collectView.cellForItem(at: IndexPath(item: i2, section: i1)) as? NotePictureCell {
                    cell.setModelDelete(open: isDelete)
                }
            }
        }
    }
    
    @objc private func targetModelDetail() {
        isDetail = !isDetail
        for (i1, pictureList) in sectionList.enumerated() {
            for (i2, picture) in pictureList.enumerated() {
                if let cell = collectView.cellForItem(at: IndexPath(item: i2, section: i1)) as? NotePictureCell {
                    cell.setModelDetail(open: isDetail, picture: picture)
                }
            }
        }
    }
    
    @objc private func targetPictureGoEdit() {
        NotePictureEditVC.pushVC(album: album)
    }
    
    @objc func goMap(sender: UIButton) {
        let cell = sender.superview as? NotePictureCell
        if cell == nil {
            return
        }
        let indexPath = self.collectView.indexPath(for: cell!)
        if indexPath == nil {
            return
        }
        let section = indexPath!.section
        if sectionList.count <= section {
            return
        }
        let item = indexPath!.item
        if sectionList[section].count <= item {
            return
        }
        let picture = sectionList[section][item]
        NotePictureCell.goMap(picture: picture)
    }
    
    @objc func showPictureDeleteAlert(sender: UIButton) {
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_delete_this_note"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    let cell = sender.superview as? NotePictureCell
                                    if cell == nil {
                                        return
                                    }
                                    if let indexPath = self.collectView.indexPath(for: cell!) {
                                        self.delPicture(indexPath: indexPath)
                                    }
        },
                                  cancelHandler: nil)
    }
    
    private func delPicture(indexPath: IndexPath) {
        if indexPath.section < 0 || indexPath.section >= sectionList.count {
            return
        }
        if indexPath.item < 0 || indexPath.item >= sectionList[indexPath.section].count {
            return
        }
        let picture = sectionList[indexPath.section][indexPath.item]
        let delSection = sectionList[indexPath.section].count <= 1
        // api
        let api = Api.request(.notePictureDel(pid: picture.id),
                              loading: true, cancel: true, success: { (_, _, data) in
                                // 不要notify了
                                if self.album != nil {
                                    self.album!.pictureCount = self.album!.pictureCount - 1
                                    self.refreshAlbumView()
                                }
                                // 删除pictureList
                                let pIndex = ListHelper.findIndexByIdInList(list: self.pictureList, obj: picture)
                                if pIndex < 0 || self.pictureList == nil || self.pictureList!.count <= pIndex {
                                    return
                                }
                                self.pictureList?.remove(at: pIndex)
                                // 同步sectionList
                                self.sectionList = self.getSectionList(clear: true, pictureList: self.pictureList)
                                self.sectionCount = self.sectionList.count
                                // 删除collect
                                if delSection {
                                    self.collectView.deleteSections([indexPath.section])
                                } else {
                                    self.collectView.deleteItems(at: [indexPath])
                                }
                                self.endScrollState(scroll: self.collectView, msg: nil)
                                
        }, failure: nil)
        pushApi(api)
    }
    
}
