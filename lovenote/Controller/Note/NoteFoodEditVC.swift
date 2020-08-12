//
//  NoteFoodEditVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/21.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteFoodEditVC: BaseVC, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    lazy var barVerticalMargin = ScreenUtils.heightFit(15)
    lazy var barIconMargin = ScreenUtils.widthFit(5)
    
    // view
    private var scroll: UIScrollView!
    private var tfTitle: UITextField!
    private var tvContent: UITextView!
    private var collectImgList: UICollectionView!
    private var vHappenAt: UIView!
    private var lHappenAt: UILabel!
    private var vAddress: UIView!
    private var lAddress: UILabel!
    
    // var
    private var food: Food?
    private var foodOld: Food!
    private var newImgDataList = [Data]()
    
    public static func pushVC(food: Food? = nil) {
        AppDelegate.runOnMainAsync {
            let vc = NoteFoodEditVC(nibName: nil, bundle: nil)
            if food == nil {
                vc.actFrom = ACT_EDIT_FROM_ADD
            } else {
                if food!.isMine() {
                    vc.actFrom = ACT_EDIT_FROM_UPDATE
                    vc.food = food
                    // 需要拷贝可编辑的数据
                    vc.foodOld = Food()
                    vc.foodOld.title = food!.title
                    vc.foodOld.happenAt = food!.happenAt
                    vc.foodOld.address = food!.address
                    vc.foodOld.longitude = food!.longitude
                    vc.foodOld.latitude = food!.latitude
                    vc.foodOld.cityId = food!.cityId
                    vc.foodOld.contentText = food!.contentText
                    vc.foodOld.contentImageList = food!.contentImageList
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
        initNavBar(title: "food")
        let barItemCommit = UIBarButtonItem(title: StringUtils.getString("commit"), style: .plain, target: self, action: #selector(checkPush))
        let barItemDel = UIBarButtonItem(title: StringUtils.getString("delete"), style: .plain, target: self, action: #selector(showDeleteAlert))
        barItemCommit.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        barItemDel.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        self.navigationItem.setRightBarButtonItems(isFromUpdate() ? [barItemCommit, barItemDel] : [barItemCommit], animated: true)
        
        // title
        tfTitle = ViewHelper.getTextField(width: maxWidth, paddingV: ScreenUtils.heightFit(10), textSize: ViewHelper.FONT_SIZE_NORMAL, textColor: ColorHelper.getFontGrey(), placeholder: StringUtils.getString("please_input_title"), placeColor: ColorHelper.getFontHint())
        tfTitle.frame.origin = CGPoint(x: margin, y: margin * 2)
        
        // content
        tvContent = ViewHelper.getTextView(width: maxWidth, height: ViewHelper.FONT_NORMAL_LINE_HEIGHT * 5, text: "", textSize: ViewHelper.FONT_SIZE_NORMAL, textColor: ColorHelper.getFontGrey(), placeholder: StringUtils.getString("please_input_remark"), limitLength: UDHelper.getLimit().foodContentLength)
        tvContent.frame.origin = CGPoint(x: margin, y: tfTitle.frame.origin.y + tfTitle.frame.size.height + margin * 2)
        
        // imgList
        let layoutImgList = ImgSquareEditCell.getLayout(maxWidth: maxWidth)
        let marginImgList = layoutImgList.sectionInset
        let collectImgListWidth = maxWidth + marginImgList.left + marginImgList.right
        let collectImgListX = margin - marginImgList.left
        let collectImgListY = tvContent.frame.origin.y + tvContent.frame.size.height + ScreenUtils.heightFit(20) - marginImgList.top
        collectImgList = ViewUtils.getCollectionView(target: self, frame: CGRect(x: collectImgListX, y: collectImgListY, width: collectImgListWidth, height: 0), layout: layoutImgList, cellCls: ImgSquareEditCell.self, id: ImgSquareEditCell.ID)
        
        // happenAt
        let vLineHappenAt = ViewHelper.getViewLine(width: maxWidth)
        vLineHappenAt.frame.origin = CGPoint(x: margin, y: 0)
        lHappenAt = ViewHelper.getLabelGreyNormal(width: maxWidth, text: StringUtils.getString("time_colon_space_holder"), lines: 1, align: .left, mode: .byTruncatingMiddle)
        let ivHappenAt = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_access_time_grey_18dp"), color: ColorHelper.getFontGrey()), width: lHappenAt.frame.size.height, height: lHappenAt.frame.size.height, mode: .scaleAspectFit)
        ivHappenAt.frame.origin = CGPoint(x: margin, y: barVerticalMargin)
        lHappenAt.frame.size.width = screenWidth - ivHappenAt.frame.origin.x - ivHappenAt.frame.size.width - barIconMargin - margin
        lHappenAt.frame.origin = CGPoint(x: ivHappenAt.frame.origin.x + ivHappenAt.frame.size.width + barIconMargin, y: barVerticalMargin)
        vHappenAt = UIView(frame: CGRect(x: 0, y: tvContent.frame.origin.y + tvContent.frame.size.height + ScreenUtils.heightFit(30), width: screenWidth, height: ivHappenAt.frame.size.height + barVerticalMargin * 2))
        
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
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = vAddress.frame.origin.y + self.view.frame.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight()
        scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        
        scroll.addSubview(tfTitle)
        scroll.addSubview(tvContent)
        scroll.addSubview(collectImgList)
        scroll.addSubview(vHappenAt)
        scroll.addSubview(vAddress)
        
        // view
        self.view.backgroundColor = ColorHelper.getWhite()
        self.view.addSubview(scroll)
        
        // hide
        collectImgList.isHidden = true
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vHappenAt, action: #selector(showDatePicker))
        ViewUtils.addViewTapTarget(target: self, view: vAddress, action: #selector(selectLocation))
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyLocationSelect), name: NotifyHelper.TAG_MAP_SELECT)
        // init
        if food == nil {
            food = Food()
        }
        if food?.happenAt == 0 {
            food?.happenAt = DateUtils.getCurrentInt64()
        }
        // title
        let placeholder = StringUtils.getString("please_input_title_no_over_holder_text", arguments: [UDHelper.getLimit().foodTitleLength])
        ViewUtils.setTextFiledPlaceholder(textField: tfTitle, placeholder: placeholder)
        tfTitle.text = food?.title
        // content
        ExtensionTextView.setTextViewTextWithPlaceholder(tvContent, text: food?.contentText)
        // imgList
        let limitImagesCount = UDHelper.getVipLimit().foodImageCount
        if isFromUpdate() {
            // 编辑
            if food!.contentImageList.count <= 0 {
                // 旧数据没有图片
                setCollectImgListView(hidden: limitImagesCount <= 0, childCount: limitImagesCount)
            } else {
                // 旧数据有图片
                let imgCount = CountHelper.getMax(limitImagesCount, food!.contentImageList.count)
                setCollectImgListView(hidden: imgCount <= 0, childCount: imgCount)
            }
        } else {
            // 添加
            setCollectImgListView(hidden: limitImagesCount <= 0, childCount: limitImagesCount)
        }
        // date
        refreshDateView()
        // location
        refreshLocationView()
    }
    
    @objc func notifyLocationSelect(notify: NSNotification) {
        let locationInfo = (notify.object as? LocationInfo)
        if locationInfo == nil || (StringUtils.isEmpty(locationInfo?.address) && locationInfo?.longitude == 0 && locationInfo?.latitude == 0) {
            return
        }
        food?.address = locationInfo!.address
        food?.longitude = locationInfo!.longitude ?? 0
        food?.latitude = locationInfo!.latitude ?? 0
        food?.cityId = locationInfo!.cityId
        refreshLocationView()
    }
    
    override func canPop() -> Bool {
        // 更新，返还原来的值
        if isFromUpdate() {
            food?.title = foodOld.title
            food?.happenAt = foodOld.happenAt
            food?.address = foodOld.address
            food?.longitude = foodOld.longitude
            food?.latitude = foodOld.latitude
            food?.cityId = foodOld.cityId
            food?.contentText = foodOld.contentText
            food?.contentImageList = foodOld.contentImageList
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImgSquareEditCell.getNumberOfItems(oldOssKeyList: food?.contentImageList, newImgDataList: newImgDataList,
                                                  limit: UDHelper.getVipLimit().foodImageCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return ImgSquareEditCell.getCellWithData(view: collectionView, indexPath: indexPath,
                                                 oldOssKeyList: food?.contentImageList, newImgDataList: newImgDataList,
                                                 limit: UDHelper.getVipLimit().foodImageCount, target: self,
                                                 actionGoBig: #selector(targrtGoBigImg), actionAdd: #selector(targrtAdd), actionDel: #selector(targrtDel))
    }
    
    @objc func targrtGoBigImg(sender: UIGestureRecognizer) {
        ImgSquareEditCell.goBigImg(view: sender.view, oldOssKeyList: food?.contentImageList, newImgDataList: newImgDataList)
    }
    
    @objc func targrtAdd(sender: UIButton) {
        ImgSquareEditCell.goAddImg(view: sender, oldOssKeyList: food?.contentImageList, newImgDataList: newImgDataList,
                                   limit: UDHelper.getVipLimit().foodImageCount, gif: true, compress: true, crop: false,
                                   dataChange: { (datas) in
                                    self.newImgDataList = datas
        },
                                   complete: { () in
                                    self.vHappenAt.frame.origin.y = self.collectImgList.frame.origin.y + self.collectImgList.frame.size.height + ScreenUtils.heightFit(30)
                                    self.vAddress.frame.origin.y = self.vHappenAt.frame.origin.y + self.vHappenAt.frame.size.height
                                    self.scroll.contentSize.height = self.vAddress.frame.origin.y + self.view.frame.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight()
        })
    }
    
    @objc func targrtDel(sender: UIButton) {
        ImgSquareEditCell.showDelAlert(sender: sender, oldOssKeyList: food?.contentImageList, newImgDataList: newImgDataList,
                                       limit: UDHelper.getVipLimit().foodImageCount,
                                       dataChange: { (keys, datas) in
                                        self.food?.contentImageList = keys
                                        self.newImgDataList = datas
        },
                                       complete: { () in
                                        self.vHappenAt.frame.origin.y = self.collectImgList.frame.origin.y + self.collectImgList.frame.size.height + ScreenUtils.heightFit(30)
                                        self.vAddress.frame.origin.y = self.vHappenAt.frame.origin.y + self.vHappenAt.frame.size.height
                                        self.scroll.contentSize.height = self.vAddress.frame.origin.y + self.view.frame.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight()
        })
    }
    
    func isFromUpdate() -> Bool {
        return actFrom == BaseVC.ACT_EDIT_FROM_UPDATE
    }
    
    func setCollectImgListView(hidden: Bool = true, childCount: Int = 0) {
        if hidden {
            collectImgList.isHidden = true
            vHappenAt.frame.origin.y = tvContent.frame.origin.y + tvContent.frame.size.height + ScreenUtils.heightFit(30)
            vAddress.frame.origin.y = vHappenAt.frame.origin.y + vHappenAt.frame.size.height
            scroll.contentSize.height = vAddress.frame.origin.y + view.frame.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight()
            return
        }
        collectImgList.isHidden = false
        // size
        collectImgList.frame.size.height = ImgSquareEditCell.getCollectHeight(collect: collectImgList, oldOssKeyList: food?.contentImageList, newImgDataList: newImgDataList, limit: UDHelper.getVipLimit().foodImageCount)
        collectImgList.reloadData()
        vHappenAt.frame.origin.y = collectImgList.frame.origin.y + collectImgList.frame.size.height + ScreenUtils.heightFit(30)
        vAddress.frame.origin.y = vHappenAt.frame.origin.y + vHappenAt.frame.size.height
        scroll.contentSize.height = vAddress.frame.origin.y + view.frame.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight()
    }
    
    @objc func showDatePicker() {
        AlertHelper.showDateTimePicker(date: food?.happenAt, actionHandler: { (_, _, _, picker) in
            self.food?.happenAt = DateUtils.getInt64(picker.date)
            self.refreshDateView()
        }, cancelHandler: nil)
    }
    
    func refreshDateView() {
        let happen = TimeHelper.getTimeShowLine_HM_MDHM_YMDHM_ByGo(food?.happenAt ?? DateUtils.getCurrentInt64())
        lHappenAt.text = StringUtils.getString("time_colon_space_holder", arguments: [happen])
    }
    
    @objc func selectLocation() {
        MapSelectVC.pushVC(address: food?.address, lon: food?.longitude, lat: food?.latitude)
    }
    
    func refreshLocationView() {
        let address = StringUtils.isEmpty(food?.address) ? StringUtils.getString("now_no") : (food?.address ?? "")
        lAddress.text = StringUtils.getString("address_colon_space_holder", arguments: [address])
    }
    
    @objc func checkPush() {
        if food == nil {
            return
        }
        // title
        if StringUtils.isEmpty(tfTitle.text) {
            ToastUtils.show(tfTitle.placeholder)
            return
        } else if (tfTitle.text?.count ?? 0) > UDHelper.getLimit().foodTitleLength {
            ToastUtils.show(tfTitle.placeholder)
            return
        }
        food?.title = tfTitle.text ?? ""
        // img
        if newImgDataList.count > 0 {
            ossUploadImages(datas: newImgDataList)
        } else {
            checkApi()
        }
    }
    
    func ossUploadImages(datas: [Data]?) {
        if food == nil {
            return
        }
        OssHelper.uploadFood(dataList: datas, success: { (_, _, successList) in
            self.food?.contentImageList += successList
            self.checkApi()
        }, failure: nil)
    }
    
    func checkApi() {
        food?.contentText = tvContent.text
        if isFromUpdate() {
            updateApi()
        } else {
            addApi()
        }
    }
    
    func updateApi() {
        if food == nil {
            return
        }
        let api = Api.request(.noteFoodUpdate(food: food?.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // notify
                                let food = data.food
                                NotifyHelper.post(NotifyHelper.TAG_FOOD_LIST_ITEM_REFRESH, obj: food)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
    func addApi() {
        if food == nil {
            return
        }
        let api = Api.request(.noteFoodAdd(food: food?.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_FOOD_LIST_REFRESH, obj: nil)
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
                                    self.delFood()
        },
                                  cancelHandler: nil)
    }
    
    private func delFood() {
        if food == nil {
            return
        }
        // api
        let api = Api.request(.noteFoodDel(fid: food!.id),
                              loading: true, cancel: true, success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_FOOD_LIST_ITEM_DELETE, obj: self.food!)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
}
