//
//  NoteAlbumEditVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/7.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteAlbumEditVC: BaseVC, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    
    // view
    private var scroll: UIScrollView!
    private var tfTitle: UITextField!
    private var collectImgList: UICollectionView!
    
    // var
    private var album: Album?
    private var albumOld: Album!
    private var newImgDataList = [Data]()
    
    public static func pushVC(album: Album? = nil) {
        AppDelegate.runOnMainAsync {
            let vc = NoteAlbumEditVC(nibName: nil, bundle: nil)
            if album == nil {
                vc.actFrom = ACT_EDIT_FROM_ADD
            } else {
                if album!.isMine() {
                    vc.actFrom = ACT_EDIT_FROM_UPDATE
                    vc.album = album
                    // 需要拷贝可编辑的数据
                    vc.albumOld = Album()
                    vc.albumOld.title = album!.title
                    vc.albumOld.cover = album!.cover
                } else {
                    ToastUtils.show(StringUtils.getString("can_operation_self_create_note"))
                    return
                }
            }
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "album")
        let barItemCommit = UIBarButtonItem(title: StringUtils.getString("commit"), style: .plain, target: self, action: #selector(checkPush))
        barItemCommit.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        self.navigationItem.setRightBarButtonItems([barItemCommit], animated: true)
        
        // title
        tfTitle = ViewHelper.getTextField(width: maxWidth, paddingV: ScreenUtils.heightFit(10), textSize: ViewHelper.FONT_SIZE_NORMAL, textColor: ColorHelper.getFontGrey(), placeholder: StringUtils.getString("please_input_title"), placeColor: ColorHelper.getFontHint())
        tfTitle.frame.origin = CGPoint(x: margin, y: margin * 2)
        
        // imgList
        let layoutImgList = ImgSquareEditCell.getLayout(maxWidth: maxWidth)
        let marginImgList = layoutImgList.sectionInset
        let collectImgListWidth = maxWidth + marginImgList.left + marginImgList.right
        let collectImgListX = margin - marginImgList.left
        let collectImgListY = tfTitle.frame.origin.y + tfTitle.frame.size.height + ScreenUtils.heightFit(30) - marginImgList.top
        collectImgList = ViewUtils.getCollectionView(target: self, frame: CGRect(x: collectImgListX, y: collectImgListY, width: collectImgListWidth, height: 0), layout: layoutImgList, cellCls: ImgSquareEditCell.self, id: ImgSquareEditCell.ID)
        collectImgList.frame.size.height = ImgSquareEditCell.getCollectHeight(collect: collectImgList, oldOssKeyList: nil, newImgDataList: newImgDataList, limit: 1)
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = collectImgList.frame.origin.y + self.view.frame.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight()
        scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        
        scroll.addSubview(tfTitle)
        scroll.addSubview(collectImgList)
        
        // view
        self.view.backgroundColor = ColorHelper.getWhite()
        self.view.addSubview(scroll)
    }
    
    override func initData() {
        // init
        if album == nil {
            album = Album()
        }
        // title
        let placeholder = StringUtils.getString("please_input_name_no_over_holder_text", arguments: [UDHelper.getLimit().albumTitleLength])
        ViewUtils.setTextFiledPlaceholder(textField: tfTitle, placeholder: placeholder)
        tfTitle.text = album?.title
        // img
        if !StringUtils.isEmpty(album!.cover) {
            collectImgList.reloadData()
        }
    }
    
    override func canPop() -> Bool {
        // 更新，返还原来的值
        if isFromUpdate() {
            album?.title = albumOld.title
            album?.cover = albumOld.cover
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var oldOssKeyList = [String]()
        if !StringUtils.isEmpty(album?.cover) {
            oldOssKeyList.append(album!.cover)
        }
        return ImgSquareEditCell.getNumberOfItems(oldOssKeyList: oldOssKeyList, newImgDataList: newImgDataList, limit: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var oldOssKeyList = [String]()
        if !StringUtils.isEmpty(album?.cover) {
            oldOssKeyList.append(album!.cover)
        }
        return ImgSquareEditCell.getCellWithData(view: collectionView, indexPath: indexPath,
                                                 oldOssKeyList: oldOssKeyList, newImgDataList: newImgDataList,
                                                 limit: 1, target: self,
                                                 actionGoBig: #selector(targrtGoBigImg), actionAdd: #selector(targrtAdd), actionDel: #selector(targrtDel))
    }
    
    @objc func targrtGoBigImg(sender: UIGestureRecognizer) {
        var oldOssKeyList = [String]()
        if !StringUtils.isEmpty(album?.cover) {
            oldOssKeyList.append(album!.cover)
        }
        ImgSquareEditCell.goBigImg(view: sender.view, oldOssKeyList: oldOssKeyList, newImgDataList: newImgDataList)
    }
    
    @objc func targrtAdd(sender: UIButton) {
        var oldOssKeyList = [String]()
        if !StringUtils.isEmpty(album?.cover) {
            oldOssKeyList.append(album!.cover)
        }
        ImgSquareEditCell.goAddImg(view: sender, oldOssKeyList: oldOssKeyList, newImgDataList: newImgDataList,
                                   limit: 1, gif: true, compress: true, crop: false,
                                   dataChange: { (datas) in
                                    self.newImgDataList = datas
        },
                                   complete: nil)
    }
    
    @objc func targrtDel(sender: UIButton) {
        var oldOssKeyList = [String]()
        if !StringUtils.isEmpty(album?.cover) {
            oldOssKeyList.append(album!.cover)
        }
        ImgSquareEditCell.showDelAlert(sender: sender, oldOssKeyList: oldOssKeyList, newImgDataList: newImgDataList,
                                       limit: 1,
                                       dataChange: { (keys, datas) in
                                        if keys.count <= 0 {
                                            self.album?.cover = ""
                                        }
                                        self.newImgDataList = datas
        },
                                       complete: nil)
    }
    
    func isFromUpdate() -> Bool {
        return actFrom == BaseVC.ACT_EDIT_FROM_UPDATE
    }
    
    @objc func checkPush() {
        if album == nil {
            return
        }
        // title
        if StringUtils.isEmpty(tfTitle.text) {
            ToastUtils.show(tfTitle.placeholder)
            return
        } else if (tfTitle.text?.count ?? 0) > UDHelper.getLimit().albumTitleLength {
            ToastUtils.show(tfTitle.placeholder)
            return
        }
        album?.title = tfTitle.text ?? ""
        // img
        if newImgDataList.count > 0 {
            ossUploadImage(data: newImgDataList[0])
        } else {
            checkApi()
        }
    }
    
    func ossUploadImage(data: Data) {
        if album == nil {
            return
        }
        OssHelper.uploadAlbum(data: data, success: { (_, ossKey) in
            self.album?.cover = ossKey
            self.checkApi()
        }, failure: nil)
    }
    
    func checkApi() {
        if album == nil {
            return
        }
        if isFromUpdate() {
            updateApi()
        } else {
            addApi()
        }
    }
    
    func updateApi() {
        if album == nil {
            return
        }
        let api = Api.request(.noteAlbumUpdate(Album: album?.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // notify
                                let album = data.album
                                NotifyHelper.post(NotifyHelper.TAG_ALBUM_LIST_ITEM_REFRESH, obj: album)
                                NotifyHelper.post(NotifyHelper.TAG_ALBUM_DETAIL_REFRESH, obj: album)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
    func addApi() {
        if album == nil {
            return
        }
        let api = Api.request(.noteAlbumAdd(album: album?.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_ALBUM_LIST_REFRESH, obj: nil)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
}
