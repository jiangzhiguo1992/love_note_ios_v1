//
//  NotePictureEditVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/8.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NotePictureEditVC: BaseVC, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    lazy var barVerticalMargin = ScreenUtils.heightFit(15)
    lazy var barIconMargin = ScreenUtils.widthFit(5)
    
    // view
    private var scroll: UIScrollView!
    private var collectImgList: UICollectionView!
    private var vHappenAt: UIView!
    private var lHappenAt: UILabel!
    private var vAddress: UIView!
    private var lAddress: UILabel!
    private var vAlbum: UIView!
    private var lAlbum: UILabel!
    
    // var
    private var album: Album?
    private var picture: Picture?
    private var newImgDataList = [Data]()
    
    public static func pushVC(album: Album? = nil, picture: Picture? = nil) {
        if UDHelper.getLimit().picturePushCount <= 0 {
            ToastUtils.show(StringUtils.getString("refuse_image_upload"))
            return
        } else if picture != nil && !picture!.isMine() {
            ToastUtils.show(StringUtils.getString("can_operation_self_create_note"))
            return
        }
        AppDelegate.runOnMainAsync {
            let vc = NotePictureEditVC(nibName: nil, bundle: nil)
            vc.album = album
            vc.picture = picture
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "picture")
        let barItemCommit = UIBarButtonItem(title: StringUtils.getString("commit"), style: .plain, target: self, action: #selector(checkPush))
        barItemCommit.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        self.navigationItem.setRightBarButtonItems([barItemCommit], animated: true)
        
        // imgList
        let layoutImgList = ImgSquareEditCell.getLayout(maxWidth: maxWidth)
        let marginImgList = layoutImgList.sectionInset
        let collectImgListWidth = maxWidth + marginImgList.left + marginImgList.right
        let collectImgListX = margin - marginImgList.left
        let collectImgListY = ScreenUtils.heightFit(20) - marginImgList.top
        collectImgList = ViewUtils.getCollectionView(target: self, frame: CGRect(x: collectImgListX, y: collectImgListY, width: collectImgListWidth, height: 0), layout: layoutImgList, cellCls: ImgSquareEditCell.self, id: ImgSquareEditCell.ID)
        collectImgList.frame.size.height = ImgSquareEditCell.getCollectHeight(collect: collectImgList, oldOssKeyList: nil, newImgDataList: newImgDataList, limit: 1)
        
        // happenAt
        let vLineHappenAt = ViewHelper.getViewLine(width: maxWidth)
        vLineHappenAt.frame.origin = CGPoint(x: margin, y: 0)
        lHappenAt = ViewHelper.getLabelGreyNormal(width: maxWidth, text: StringUtils.getString("time_colon_space_holder"), lines: 1, align: .left, mode: .byTruncatingMiddle)
        let ivHappenAt = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_access_time_grey_18dp"), color: ColorHelper.getFontGrey()), width: lHappenAt.frame.size.height, height: lHappenAt.frame.size.height, mode: .scaleAspectFit)
        ivHappenAt.frame.origin = CGPoint(x: margin, y: barVerticalMargin)
        lHappenAt.frame.size.width = screenWidth - ivHappenAt.frame.origin.x - ivHappenAt.frame.size.width - barIconMargin - margin
        lHappenAt.frame.origin = CGPoint(x: ivHappenAt.frame.origin.x + ivHappenAt.frame.size.width + barIconMargin, y: barVerticalMargin)
        vHappenAt = UIView(frame: CGRect(x: 0, y: collectImgList.frame.origin.y + collectImgList.frame.size.height + ScreenUtils.heightFit(30), width: screenWidth, height: ivHappenAt.frame.size.height + barVerticalMargin * 2))
        
        vHappenAt.addSubview(vLineHappenAt)
        vHappenAt.addSubview(ivHappenAt)
        vHappenAt.addSubview(lHappenAt)
        
        // address
        let vLineAddress = ViewHelper.getViewLine(width: maxWidth)
        vLineAddress.frame.origin = CGPoint(x: margin, y: 0)
        lAddress = ViewHelper.getLabelGreyNormal(width: maxWidth, text: StringUtils.getString("address_colon_space_holder"), lines: 1, align: .left, mode: .byTruncatingMiddle)
        let ivAddress = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_location_on_grey_18dp"), color: ColorHelper.getFontGrey()), width: lAddress.frame.size.height, height: lAddress.frame.size.height, mode: .scaleAspectFit)
        ivAddress.frame.origin = CGPoint(x: margin, y: barVerticalMargin)
        lAddress.frame.size.width = screenWidth - ivAddress.frame.origin.x - ivAddress.frame.size.width - barIconMargin - margin
        lAddress.frame.origin = CGPoint(x: ivAddress.frame.origin.x + ivAddress.frame.size.width + barIconMargin, y: barVerticalMargin)
        vAddress = UIView(frame: CGRect(x: 0, y: vHappenAt.frame.origin.y + vHappenAt.frame.size.height, width: screenWidth, height: ivAddress.frame.size.height + barVerticalMargin * 2))
        
        vAddress.addSubview(vLineAddress)
        vAddress.addSubview(ivAddress)
        vAddress.addSubview(lAddress)
        
        // album
        let vLineAlbum = ViewHelper.getViewLine(width: maxWidth)
        vLineAlbum.frame.origin = CGPoint(x: margin, y: 0)
        lAlbum = ViewHelper.getLabelGreyNormal(width: maxWidth, text: StringUtils.getString("album_colon_space_holder"), lines: 1, align: .left, mode: .byTruncatingMiddle)
        let ivAlbum = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_note_album_24dp"), color: ColorHelper.getFontGrey()), width: lAlbum.frame.size.height, height: lAlbum.frame.size.height, mode: .scaleAspectFit)
        ivAlbum.frame.origin = CGPoint(x: margin, y: barVerticalMargin)
        lAlbum.frame.size.width = screenWidth - ivAlbum.frame.origin.x - ivAlbum.frame.size.width - barIconMargin - margin
        lAlbum.frame.origin = CGPoint(x: ivAlbum.frame.origin.x + ivAlbum.frame.size.width + barIconMargin, y: barVerticalMargin)
        vAlbum = UIView(frame: CGRect(x: 0, y: vAddress.frame.origin.y + vAddress.frame.size.height, width: screenWidth, height: ivAlbum.frame.size.height + barVerticalMargin * 2))
        
        vAlbum.addSubview(vLineAlbum)
        vAlbum.addSubview(ivAlbum)
        vAlbum.addSubview(lAlbum)
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = vAlbum.frame.origin.y + vAlbum.frame.height + ScreenUtils.heightFit(30)
        scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        
        scroll.addSubview(collectImgList)
        scroll.addSubview(vHappenAt)
        scroll.addSubview(vAddress)
        scroll.addSubview(vAlbum)
        
        // view
        self.view.backgroundColor = ColorHelper.getWhite()
        self.view.addSubview(scroll)
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vHappenAt, action: #selector(showDatePicker))
        ViewUtils.addViewTapTarget(target: self, view: vAddress, action: #selector(selectLocation))
        ViewUtils.addViewTapTarget(target: self, view: vAlbum, action: #selector(selectAlbum))
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyAlbumSelect), name: NotifyHelper.TAG_ALBUM_SELECT)
        NotifyHelper.addObserver(self, selector: #selector(notifyLocationSelect), name: NotifyHelper.TAG_MAP_SELECT)
        // init
        if picture == nil {
            picture = Picture()
        }
        if picture!.happenAt == 0 {
            picture?.happenAt = DateUtils.getCurrentInt64()
        }
        // view
        refreshDateView()
        refreshLocationView()
        refreshAlbumView()
    }
    
    @objc func notifyAlbumSelect(notify: NSNotification) {
        album = (notify.object as? Album) ?? Album()
        refreshAlbumView()
    }
    
    @objc func notifyLocationSelect(notify: NSNotification) {
        let locationInfo = (notify.object as? LocationInfo)
        if locationInfo == nil || (StringUtils.isEmpty(locationInfo?.address) && locationInfo?.longitude == 0 && locationInfo?.latitude == 0) {
            return
        }
        picture?.address = locationInfo!.address
        picture?.longitude = locationInfo!.longitude ?? 0
        picture?.latitude = locationInfo!.latitude ?? 0
        picture?.cityId = locationInfo!.cityId
        refreshLocationView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImgSquareEditCell.getNumberOfItems(oldOssKeyList: nil, newImgDataList: newImgDataList, limit: UDHelper.getLimit().picturePushCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return ImgSquareEditCell.getCellWithData(view: collectionView, indexPath: indexPath, oldOssKeyList: nil, newImgDataList: newImgDataList,
                                                 limit: UDHelper.getLimit().picturePushCount, target: self,
                                                 actionGoBig: #selector(targrtGoBigImg), actionAdd: #selector(targrtAdd), actionDel: #selector(targrtDel))
    }
    
    @objc func targrtGoBigImg(sender: UIGestureRecognizer) {
        ImgSquareEditCell.goBigImg(view: sender.view, oldOssKeyList: nil, newImgDataList: newImgDataList)
    }
    
    @objc func targrtAdd(sender: UIButton) {
        ImgSquareEditCell.goAddImg(view: sender, oldOssKeyList: nil, newImgDataList: newImgDataList,
                                   limit: UDHelper.getLimit().picturePushCount, gif: true, compress: !UDHelper.getVipLimit().pictureOriginal, crop: false,
                                   dataChange: { (datas) in
                                    self.newImgDataList = datas
        },
                                   complete: { () in
                                    self.vHappenAt.frame.origin.y = self.collectImgList.frame.origin.y + self.collectImgList.frame.size.height + ScreenUtils.heightFit(30)
                                    self.vAddress.frame.origin.y = self.vHappenAt.frame.origin.y + self.vHappenAt.frame.size.height
                                    self.vAlbum.frame.origin.y = self.vAddress.frame.origin.y + self.vAddress.frame.size.height
                                    self.scroll.contentSize.height = self.vAlbum.frame.origin.y + self.view.frame.height - RootVC.get().getTopBarHeight()
        })
    }
    
    @objc func targrtDel(sender: UIButton) {
        ImgSquareEditCell.showDelAlert(sender: sender, oldOssKeyList: nil, newImgDataList: newImgDataList,
                                       limit: UDHelper.getLimit().picturePushCount,
                                       dataChange: { (_, datas) in
                                        self.newImgDataList = datas
        },
                                       complete: { () in
                                        self.vHappenAt.frame.origin.y = self.collectImgList.frame.origin.y + self.collectImgList.frame.size.height + ScreenUtils.heightFit(30)
                                        self.vAddress.frame.origin.y = self.vHappenAt.frame.origin.y + self.vHappenAt.frame.size.height
                                        self.vAlbum.frame.origin.y = self.vAddress.frame.origin.y + self.vAddress.frame.size.height
                                        self.scroll.contentSize.height = self.vAlbum.frame.origin.y + self.view.frame.height - RootVC.get().getTopBarHeight()
        })
    }
    
    @objc func showDatePicker() {
        AlertHelper.showDateTimePicker(date: picture?.happenAt, actionHandler: { (_, _, _, picker) in
            self.picture?.happenAt = DateUtils.getInt64(picker.date)
            self.refreshDateView()
        }, cancelHandler: nil)
    }
    
    func refreshDateView() {
        let happen = TimeHelper.getTimeShowLine_HM_MDHM_YMDHM_ByGo(picture?.happenAt ?? DateUtils.getCurrentInt64())
        lHappenAt.text = StringUtils.getString("time_colon_space_holder", arguments: [happen])
    }
    
    @objc func selectLocation() {
        MapSelectVC.pushVC(address: picture?.address, lon: picture?.longitude, lat: picture?.latitude)
    }
    
    func refreshLocationView() {
        let address = StringUtils.isEmpty(picture?.address) ? StringUtils.getString("now_no") : (picture?.address ?? "")
        lAddress.text = StringUtils.getString("address_colon_space_holder", arguments: [address])
    }
    
    @objc func selectAlbum() {
        NoteAlbumVC.pushVC(select: true)
    }
    
    func refreshAlbumView() {
        if album == nil || album?.id == 0 {
            lAlbum.text = StringUtils.getString("please_select_album")
        } else {
            lAlbum.text = StringUtils.getString("album_colon_space_holder", arguments: [album!.title])
        }
    }
    
    @objc func checkPush() {
        if picture == nil {
            return
        }
        if newImgDataList.count <= 0 {
            ToastUtils.show(StringUtils.getString("picture_where"))
            return
        }
        if album == nil || album!.id == 0 {
            ToastUtils.show(StringUtils.getString("please_select_album"))
            return
        }
        picture?.albumId = album!.id
        ossUploadImages(datas: newImgDataList)
    }
    
    func ossUploadImages(datas: [Data]?) {
        if picture == nil {
            return
        }
        OssHelper.uploadPicture(dataList: datas, success: { (_, _, successList) in
            self.addApi(ossKeyList: successList)
        }, failure: nil)
    }
    
    func addApi(ossKeyList: [String]) {
        if picture == nil {
            return
        }
        if ossKeyList.count <= 0 {
            return
        }
        var pictureList = [Picture]()
        for ossKey in ossKeyList {
            let p = Picture()
            p.albumId = picture!.albumId
            p.happenAt = picture!.happenAt
            p.contentImage = ossKey
            p.address = picture!.address
            p.longitude = picture!.longitude
            p.latitude = picture!.latitude
            p.cityId = picture!.cityId
            pictureList.append(p)
        }
        let body = Album()
        body.pictureList = pictureList
        let api = Api.request(.notePictureListAdd(album: body.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                let total = data.pictureList?.count ?? 0
                                ToastUtils.show(StringUtils.getString("success_push_holder_paper_picture", arguments: [total]))
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_ALBUM_LIST_REFRESH, obj: nil)
                                NotifyHelper.post(NotifyHelper.TAG_ALBUM_DETAIL_REFRESH, obj: self.album)
                                NotifyHelper.post(NotifyHelper.TAG_PICTURE_LIST_REFRESH, obj: nil)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
}
