//
//  NoteGiftEditVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/25.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteGiftEditVC: BaseVC, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    lazy var barVerticalMargin = ScreenUtils.heightFit(15)
    lazy var barIconMargin = ScreenUtils.widthFit(5)
    
    // view
    private var scroll: UIScrollView!
    private var tfTitle: UITextField!
    private var collectImgList: UICollectionView!
    private var vHappenAt: UIView!
    private var lHappenAt: UILabel!
    private var vUser: UIView!
    private var lUser: UILabel!
    
    // var
    private var gift: Gift?
    private var giftOld: Gift!
    private var newImgDataList = [Data]()
    
    public static func pushVC(gift: Gift? = nil) {
        AppDelegate.runOnMainAsync {
            let vc = NoteGiftEditVC(nibName: nil, bundle: nil)
            if gift == nil {
                vc.actFrom = ACT_EDIT_FROM_ADD
            } else {
                if gift!.isMine() {
                    vc.actFrom = ACT_EDIT_FROM_UPDATE
                    vc.gift = gift
                    // 需要拷贝可编辑的数据
                    vc.giftOld = Gift()
                    vc.giftOld.title = gift!.title
                    vc.giftOld.happenAt = gift!.happenAt
                    vc.giftOld.receiveId = gift!.receiveId
                    vc.giftOld.contentImageList = gift!.contentImageList
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
        initNavBar(title: "gift")
        let barItemCommit = UIBarButtonItem(title: StringUtils.getString("commit"), style: .plain, target: self, action: #selector(checkPush))
        let barItemDel = UIBarButtonItem(title: StringUtils.getString("delete"), style: .plain, target: self, action: #selector(showDeleteAlert))
        barItemCommit.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        barItemDel.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        self.navigationItem.setRightBarButtonItems(isFromUpdate() ? [barItemCommit, barItemDel] : [barItemCommit], animated: true)
        
        // title
        tfTitle = ViewHelper.getTextField(width: maxWidth, paddingV: ScreenUtils.heightFit(10), textSize: ViewHelper.FONT_SIZE_NORMAL, textColor: ColorHelper.getFontGrey(), placeholder: StringUtils.getString("please_input_title"), placeColor: ColorHelper.getFontHint())
        tfTitle.frame.origin = CGPoint(x: margin, y: margin * 2)
        
        // imgList
        let layoutImgList = ImgSquareEditCell.getLayout(maxWidth: maxWidth)
        let marginImgList = layoutImgList.sectionInset
        let collectImgListWidth = maxWidth + marginImgList.left + marginImgList.right
        let collectImgListX = margin - marginImgList.left
        let collectImgListY = tfTitle.frame.origin.y + tfTitle.frame.size.height + ScreenUtils.heightFit(20) - marginImgList.top
        collectImgList = ViewUtils.getCollectionView(target: self, frame: CGRect(x: collectImgListX, y: collectImgListY, width: collectImgListWidth, height: 0), layout: layoutImgList, cellCls: ImgSquareEditCell.self, id: ImgSquareEditCell.ID)
        
        // happenAt
        let vLineHappenAt = ViewHelper.getViewLine(width: maxWidth)
        vLineHappenAt.frame.origin = CGPoint(x: margin, y: 0)
        lHappenAt = ViewHelper.getLabelGreyNormal(width: maxWidth, text: StringUtils.getString("time_colon_space_holder"), lines: 1, align: .left, mode: .byTruncatingMiddle)
        let ivHappenAt = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_access_time_grey_18dp"), color: ColorHelper.getFontGrey()), width: lHappenAt.frame.size.height, height: lHappenAt.frame.size.height, mode: .scaleAspectFit)
        ivHappenAt.frame.origin = CGPoint(x: margin, y: barVerticalMargin)
        lHappenAt.frame.size.width = screenWidth - ivHappenAt.frame.origin.x - ivHappenAt.frame.size.width - barIconMargin - margin
        lHappenAt.frame.origin = CGPoint(x: ivHappenAt.frame.origin.x + ivHappenAt.frame.size.width + barIconMargin, y: barVerticalMargin)
        vHappenAt = UIView(frame: CGRect(x: 0, y: tfTitle.frame.origin.y + tfTitle.frame.size.height + ScreenUtils.heightFit(30), width: screenWidth, height: ivHappenAt.frame.size.height + barVerticalMargin * 2))
        
        vHappenAt.addSubview(vLineHappenAt)
        vHappenAt.addSubview(ivHappenAt)
        vHappenAt.addSubview(lHappenAt)
        
        // user
        let vLineUser = ViewHelper.getViewLine(width: maxWidth)
        vLineUser.frame.origin = CGPoint(x: margin, y: 0)
        lUser = ViewHelper.getLabelGreyNormal(width: maxWidth, text: StringUtils.getString("belong_colon_space_holder"), lines: 1, align: .left, mode: .byTruncatingMiddle)
        let ivUser = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_account_circle_grey_18dp"), color: ColorHelper.getFontGrey()), width: lUser.frame.size.height, height: lUser.frame.size.height, mode: .scaleAspectFit)
        ivUser.frame.origin = CGPoint(x: margin, y: barVerticalMargin)
        lUser.frame.size.width = screenWidth - ivUser.frame.origin.x - ivUser.frame.size.width - barIconMargin - margin
        lUser.frame.origin = CGPoint(x: ivUser.frame.origin.x + ivUser.frame.size.width + barIconMargin, y: barVerticalMargin)
        vUser = UIView(frame: CGRect(x: 0, y: vHappenAt.frame.origin.y + vHappenAt.frame.size.height, width: screenWidth, height: ivUser.frame.size.height + barVerticalMargin * 2))
        
        vUser.addSubview(vLineUser)
        vUser.addSubview(ivUser)
        vUser.addSubview(lUser)
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = vUser.frame.origin.y + self.view.frame.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight()
        scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        
        scroll.addSubview(tfTitle)
        scroll.addSubview(collectImgList)
        scroll.addSubview(vHappenAt)
        scroll.addSubview(vUser)
        
        // view
        self.view.backgroundColor = ColorHelper.getWhite()
        self.view.addSubview(scroll)
        
        // hide
        collectImgList.isHidden = true
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vHappenAt, action: #selector(showDatePicker))
        ViewUtils.addViewTapTarget(target: self, view: vUser, action: #selector(showUserPicker))
    }
    
    override func initData() {
        // init
        if gift == nil {
            gift = Gift()
        }
        if gift?.happenAt == 0 {
            gift?.happenAt = DateUtils.getCurrentInt64()
        }
        gift?.receiveId = UDHelper.getMe()?.id ?? 0
        // title
        let placeholder = StringUtils.getString("please_input_title_no_over_holder_text", arguments: [UDHelper.getLimit().giftTitleLength])
        ViewUtils.setTextFiledPlaceholder(textField: tfTitle, placeholder: placeholder)
        tfTitle.text = gift?.title
        // imgList
        let limitImagesCount = UDHelper.getVipLimit().giftImageCount
        if isFromUpdate() {
            // 编辑
            if gift!.contentImageList.count <= 0 {
                // 旧数据没有图片
                setCollectImgListView(hidden: limitImagesCount <= 0, childCount: limitImagesCount)
            } else {
                // 旧数据有图片
                let imgCount = CountHelper.getMax(limitImagesCount, gift!.contentImageList.count)
                setCollectImgListView(hidden: imgCount <= 0, childCount: imgCount)
            }
        } else {
            // 添加
            setCollectImgListView(hidden: limitImagesCount <= 0, childCount: limitImagesCount)
        }
        // date
        refreshDateView()
        // user
        refreshUserView()
    }
    
    override func canPop() -> Bool {
        // 更新，返还原来的值
        if isFromUpdate() {
            gift?.title = giftOld.title
            gift?.happenAt = giftOld.happenAt
            gift?.receiveId = giftOld.receiveId
            gift?.contentImageList = giftOld.contentImageList
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImgSquareEditCell.getNumberOfItems(oldOssKeyList: gift?.contentImageList, newImgDataList: newImgDataList,
                                                  limit: UDHelper.getVipLimit().giftImageCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return ImgSquareEditCell.getCellWithData(view: collectionView, indexPath: indexPath,
                                                 oldOssKeyList: gift?.contentImageList, newImgDataList: newImgDataList,
                                                 limit: UDHelper.getVipLimit().giftImageCount, target: self,
                                                 actionGoBig: #selector(targrtGoBigImg), actionAdd: #selector(targrtAdd), actionDel: #selector(targrtDel))
    }
    
    @objc func targrtGoBigImg(sender: UIGestureRecognizer) {
        ImgSquareEditCell.goBigImg(view: sender.view, oldOssKeyList: gift?.contentImageList, newImgDataList: newImgDataList)
    }
    
    @objc func targrtAdd(sender: UIButton) {
        ImgSquareEditCell.goAddImg(view: sender, oldOssKeyList: gift?.contentImageList, newImgDataList: newImgDataList,
                                   limit: UDHelper.getVipLimit().giftImageCount, gif: true, compress: true, crop: false,
                                   dataChange: { (datas) in
                                    self.newImgDataList = datas
        },
                                   complete: { () in
                                    self.vHappenAt.frame.origin.y = self.collectImgList.frame.origin.y + self.collectImgList.frame.size.height + ScreenUtils.heightFit(30)
                                    self.vUser.frame.origin.y = self.vHappenAt.frame.origin.y + self.vHappenAt.frame.size.height
                                    self.scroll.contentSize.height = self.vUser.frame.origin.y + self.view.frame.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight()
        })
    }
    
    @objc func targrtDel(sender: UIButton) {
        ImgSquareEditCell.showDelAlert(sender: sender, oldOssKeyList: gift?.contentImageList, newImgDataList: newImgDataList,
                                       limit: UDHelper.getVipLimit().giftImageCount,
                                       dataChange: { (keys, datas) in
                                        self.gift?.contentImageList = keys
                                        self.newImgDataList = datas
        },
                                       complete: { () in
                                        self.vHappenAt.frame.origin.y = self.collectImgList.frame.origin.y + self.collectImgList.frame.size.height + ScreenUtils.heightFit(30)
                                        self.vUser.frame.origin.y = self.vHappenAt.frame.origin.y + self.vHappenAt.frame.size.height
                                        self.scroll.contentSize.height = self.vUser.frame.origin.y + self.view.frame.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight()
        })
    }
    
    func isFromUpdate() -> Bool {
        return actFrom == BaseVC.ACT_EDIT_FROM_UPDATE
    }
    
    func setCollectImgListView(hidden: Bool = true, childCount: Int = 0) {
        if hidden {
            collectImgList.isHidden = true
            vHappenAt.frame.origin.y = tfTitle.frame.origin.y + tfTitle.frame.size.height + ScreenUtils.heightFit(30)
            vUser.frame.origin.y = vHappenAt.frame.origin.y + vHappenAt.frame.size.height
            scroll.contentSize.height = vUser.frame.origin.y + view.frame.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight()
            return
        }
        collectImgList.isHidden = false
        // size
        collectImgList.frame.size.height = ImgSquareEditCell.getCollectHeight(collect: collectImgList, oldOssKeyList: gift?.contentImageList, newImgDataList: newImgDataList, limit: UDHelper.getVipLimit().giftImageCount)
        collectImgList.reloadData()
        vHappenAt.frame.origin.y = collectImgList.frame.origin.y + collectImgList.frame.size.height + ScreenUtils.heightFit(30)
        vUser.frame.origin.y = vHappenAt.frame.origin.y + vHappenAt.frame.size.height
        scroll.contentSize.height = vUser.frame.origin.y + view.frame.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight()
    }
    
    @objc func showDatePicker() {
        _ = AlertHelper.showDatePicker(mode: .date, date: gift?.happenAt, actionHandler: { (_, _, _, picker) in
            self.gift?.happenAt = DateUtils.getInt64(picker.date)
            self.refreshDateView()
        }, cancelHandler: nil)
    }
    
    func refreshDateView() {
        let happen = TimeHelper.getTimeShowLine_HM_MD_YMD_ByGo(gift?.happenAt ?? DateUtils.getCurrentInt64())
        lHappenAt.text = StringUtils.getString("time_colon_space_holder", arguments: [happen])
    }
    
    @objc func showUserPicker() {
        let me = UDHelper.getMe()
        let ta = UDHelper.getTa()
        if gift == nil || me == nil || ta == nil {
            return
        }
        _ = AlertHelper.showAlert(title: StringUtils.getString("select_user"),
                                  confirms: [StringUtils.getString("me_de"), StringUtils.getString("ta_de")],
                                  cancel: StringUtils.getString("cancel"),
                                  canCancel: true,
                                  actionHandler: { (_, index, _) in
                                    self.gift?.receiveId = (index == 0) ? me!.id : ta!.id
                                    self.refreshUserView()
        }, cancelHandler: nil)
    }
    
    func refreshUserView() {
        let me = UDHelper.getMe()
        let ta = UDHelper.getTa()
        if gift == nil || me == nil || ta == nil {
            return
        }
        if gift!.receiveId == ta!.id {
            lUser.text = StringUtils.getString("belong_colon_space_holder", arguments: [StringUtils.getString("ta_de")])
        } else {
            lUser.text = StringUtils.getString("belong_colon_space_holder", arguments: [StringUtils.getString("me_de")])
        }
    }
    
    @objc func checkPush() {
        if gift == nil {
            return
        }
        // title
        if StringUtils.isEmpty(tfTitle.text) {
            ToastUtils.show(tfTitle.placeholder)
            return
        } else if (tfTitle.text?.count ?? 0) > UDHelper.getLimit().giftTitleLength {
            ToastUtils.show(tfTitle.placeholder)
            return
        }
        gift?.title = tfTitle.text ?? ""
        // img
        if newImgDataList.count > 0 {
            ossUploadImages(datas: newImgDataList)
        } else {
            checkApi()
        }
    }
    
    func ossUploadImages(datas: [Data]?) {
        if gift == nil {
            return
        }
        OssHelper.uploadGift(dataList: datas, success: { (_, _, successList) in
            self.gift?.contentImageList += successList
            self.checkApi()
        }, failure: nil)
    }
    
    func checkApi() {
        if isFromUpdate() {
            updateApi()
        } else {
            addApi()
        }
    }
    
    func updateApi() {
        if gift == nil {
            return
        }
        let api = Api.request(.noteGiftUpdate(gift: gift?.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // notify
                                let gift = data.gift
                                NotifyHelper.post(NotifyHelper.TAG_GIFT_LIST_ITEM_REFRESH, obj: gift)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
    func addApi() {
        if gift == nil {
            return
        }
        let api = Api.request(.noteGiftAdd(gift: gift?.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_GIFT_LIST_REFRESH, obj: nil)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
    @objc func showDeleteAlert() {
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_delete_this_note"),
                                  msg: nil,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  canCancel: true,
                                  actionHandler: { (_, _, _) in
                                    self.delGift()
        },
                                  cancelHandler: nil)
    }
    
    private func delGift() {
        if gift == nil {
            return
        }
        // api
        let api = Api.request(.noteGiftDel(gid: gift!.id),
                              loading: true, cancel: true, success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_GIFT_LIST_ITEM_DELETE, obj: self.gift!)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
}
