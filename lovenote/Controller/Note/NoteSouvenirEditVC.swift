//
//  NoteSouvenirEditVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/6.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteSouvenirEditVC: BaseVC {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    lazy var barVerticalMargin = ScreenUtils.heightFit(15)
    lazy var barIconMargin = ScreenUtils.widthFit(5)
    
    // view
    private var scroll: UIScrollView!
    private var tfTitle: UITextField!
    private var vHappenAt: UIView!
    private var lHappenAt: UILabel!
    private var vAddress: UIView!
    private var lAddress: UILabel!
    private var vType: UIView!
    private var lType: UILabel!
    
    // var
    private var souvenir: Souvenir?
    private var souvenirOld: Souvenir!
    
    public static func pushVC(souvenir: Souvenir? = nil) {
        AppDelegate.runOnMainAsync {
            let vc = NoteSouvenirEditVC(nibName: nil, bundle: nil)
            vc.souvenir = souvenir
            if souvenir == nil {
                vc.actFrom = ACT_EDIT_FROM_ADD
            } else {
                if souvenir!.isMine() {
                    vc.actFrom = ACT_EDIT_FROM_UPDATE
                    vc.souvenir = souvenir
                    // 需要拷贝可编辑的数据
                    vc.souvenirOld = Souvenir()
                    vc.souvenirOld.title = souvenir!.title
                    vc.souvenirOld.happenAt = souvenir!.happenAt
                    vc.souvenirOld.address = souvenir!.address
                    vc.souvenirOld.longitude = souvenir!.longitude
                    vc.souvenirOld.latitude = souvenir!.latitude
                    vc.souvenirOld.cityId = souvenir!.cityId
                    vc.souvenirOld.done = souvenir!.done
                    vc.souvenirOld.souvenirTravelList = souvenir!.souvenirTravelList
                    vc.souvenirOld.souvenirGiftList = souvenir!.souvenirGiftList
                    vc.souvenirOld.souvenirAlbumList = souvenir!.souvenirAlbumList
                    vc.souvenirOld.souvenirVideoList = souvenir!.souvenirVideoList
                    vc.souvenirOld.souvenirFoodList = souvenir!.souvenirFoodList
                    vc.souvenirOld.souvenirMovieList = souvenir!.souvenirMovieList
                    vc.souvenirOld.souvenirDiaryList = souvenir!.souvenirDiaryList
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
        initNavBar(title: souvenir == nil ? "souvenir" : (souvenir!.done ? "souvenir" : "wish_list"))
        let barItemCommit = UIBarButtonItem(title: StringUtils.getString("commit"), style: .plain, target: self, action: #selector(checkPush))
        barItemCommit.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        self.navigationItem.setRightBarButtonItems([barItemCommit], animated: true)
        
        // title
        tfTitle = ViewHelper.getTextField(width: maxWidth, paddingV: ScreenUtils.heightFit(10), textSize: ViewHelper.FONT_SIZE_NORMAL, textColor: ColorHelper.getFontGrey(), placeholder: StringUtils.getString("please_input_title"), placeColor: ColorHelper.getFontHint())
        tfTitle.frame.origin = CGPoint(x: margin, y: margin * 2)
        
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
        
        // type
        let vLineType = ViewHelper.getViewLine(width: maxWidth)
        vLineType.frame.origin = CGPoint(x: margin, y: 0)
        lType = ViewHelper.getLabelGreyNormal(width: maxWidth, text: StringUtils.getString("type_colon_space_holder"), lines: 1, align: .left, mode: .byTruncatingMiddle)
        let ivType = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_note_souvenir_24dp"), color: ColorHelper.getFontGrey()), width: lType.frame.size.height, height: lType.frame.size.height, mode: .scaleAspectFit)
        ivType.frame.origin = CGPoint(x: margin, y: barVerticalMargin)
        lType.frame.size.width = screenWidth - ivType.frame.origin.x - ivType.frame.size.width - barIconMargin - margin
        lType.frame.origin = CGPoint(x: ivType.frame.origin.x + ivType.frame.size.width + barIconMargin, y: barVerticalMargin)
        vType = UIView(frame: CGRect(x: 0, y: vAddress.frame.origin.y + vAddress.frame.size.height, width: screenWidth, height: ivType.frame.size.height + barVerticalMargin * 2))
        
        vType.addSubview(vLineType)
        vType.addSubview(ivType)
        vType.addSubview(lType)
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = vType.frame.origin.y + vType.frame.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight()
        scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        
        scroll.addSubview(tfTitle)
        scroll.addSubview(vHappenAt)
        scroll.addSubview(vAddress)
        scroll.addSubview(vType)
        
        // view
        self.view.backgroundColor = ColorHelper.getWhite()
        self.view.addSubview(scroll)
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vHappenAt, action: #selector(showDatePicker))
        ViewUtils.addViewTapTarget(target: self, view: vAddress, action: #selector(selectLocation))
        ViewUtils.addViewTapTarget(target: self, view: vType, action: #selector(showTypeAlert))
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyLocationSelect), name: NotifyHelper.TAG_MAP_SELECT)
        // init
        if souvenir == nil {
            souvenir = Souvenir()
            souvenir?.done = true
        }
        if souvenir!.happenAt == 0 {
            souvenir?.happenAt = DateUtils.getCurrentInt64()
        }
        // title
        let placeholder = StringUtils.getString("please_input_title_no_over_holder_text", arguments: [UDHelper.getLimit().souvenirTitleLength])
        ViewUtils.setTextFiledPlaceholder(textField: tfTitle, placeholder: placeholder)
        tfTitle.text = souvenir?.title
        // view
        refreshDateView()
        refreshLocationView()
        refreshTypeView()
    }
    
    @objc func notifyLocationSelect(notify: NSNotification) {
        let locationInfo = (notify.object as? LocationInfo)
        if locationInfo == nil || (StringUtils.isEmpty(locationInfo?.address) && locationInfo?.longitude == 0 && locationInfo?.latitude == 0) {
            return
        }
        souvenir?.address = locationInfo!.address
        souvenir?.longitude = locationInfo!.longitude ?? 0
        souvenir?.latitude = locationInfo!.latitude ?? 0
        souvenir?.cityId = locationInfo!.cityId
        refreshLocationView()
    }
    
    override func canPop() -> Bool {
        // 更新，返还原来的值
        if isFromUpdate() {
            souvenir?.title = souvenirOld.title
            souvenir?.happenAt = souvenirOld.happenAt
            souvenir?.address = souvenirOld.address
            souvenir?.longitude = souvenirOld.longitude
            souvenir?.latitude = souvenirOld.latitude
            souvenir?.cityId = souvenirOld.cityId
            souvenir?.done = souvenirOld.done
            souvenir?.souvenirTravelList = souvenirOld.souvenirTravelList
            souvenir?.souvenirGiftList = souvenirOld.souvenirGiftList
            souvenir?.souvenirAlbumList = souvenirOld.souvenirAlbumList
            souvenir?.souvenirVideoList = souvenirOld.souvenirVideoList
            souvenir?.souvenirFoodList = souvenirOld.souvenirFoodList
            souvenir?.souvenirMovieList = souvenirOld.souvenirMovieList
            souvenir?.souvenirDiaryList = souvenirOld.souvenirDiaryList
        }
        return true
    }
    
    func isFromUpdate() -> Bool {
        return actFrom == BaseVC.ACT_EDIT_FROM_UPDATE
    }
    
    @objc func showDatePicker() {
        AlertHelper.showDateTimePicker(date: souvenir?.happenAt, actionHandler: { (_, _, _, picker) in
            self.souvenir?.happenAt = DateUtils.getInt64(picker.date)
            self.refreshDateView()
        }, cancelHandler: nil)
    }
    
    func refreshDateView() {
        let happen = DateUtils.getStr(souvenir?.happenAt, DateUtils.FORMAT_LINE_Y_M_D_H_M)
        lHappenAt.text = StringUtils.getString("time_colon_space_holder", arguments: [happen])
    }
    
    @objc func selectLocation() {
        MapSelectVC.pushVC(address: souvenir?.address, lon: souvenir?.longitude, lat: souvenir?.latitude)
    }
    
    func refreshLocationView() {
        let address = StringUtils.isEmpty(souvenir?.address) ? StringUtils.getString("now_no") : (souvenir?.address ?? "")
        lAddress.text = StringUtils.getString("address_colon_space_holder", arguments: [address])
    }
    
    @objc func showTypeAlert() {
        if souvenir == nil {
            return
        }
        _ = AlertHelper.showAlert(title: StringUtils.getString("please_select_classify"),
                                  confirms: [StringUtils.getString("souvenir"), StringUtils.getString("wish_list")],
                                  cancel: StringUtils.getString("cancel"),
                                  canCancel: true,
                                  actionHandler: { (_, index, _) in
                                    self.souvenir?.done = (index == 0)
                                    self.refreshTypeView()
        }, cancelHandler: nil)
    }
    
    func refreshTypeView() {
        if souvenir == nil {
            return
        }
        if souvenir!.done {
            lType.text = StringUtils.getString("type_colon_space_holder", arguments: [StringUtils.getString("souvenir")])
        } else {
            lType.text = StringUtils.getString("type_colon_space_holder", arguments: [StringUtils.getString("wish_list")])
        }
    }
    
    @objc func checkPush() {
        if souvenir == nil {
            return
        }
        // title
        if StringUtils.isEmpty(tfTitle.text) {
            ToastUtils.show(tfTitle.placeholder)
            return
        } else if (tfTitle.text?.count ?? 0) > UDHelper.getLimit().souvenirTitleLength {
            ToastUtils.show(tfTitle.placeholder)
            return
        }
        souvenir?.title = tfTitle.text ?? ""
        if isFromUpdate() {
            updateApi()
        } else {
            addApi()
        }
    }
    
    func updateApi() {
        if souvenir == nil {
            return
        }
        let api = Api.request(.noteSouvenirUpdateBody(souvenir: souvenir?.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // notify
                                let souvenir = data.souvenir
                                NotifyHelper.post(NotifyHelper.TAG_SOUVENIR_LIST_ITEM_REFRESH, obj: souvenir)
                                NotifyHelper.post(NotifyHelper.TAG_SOUVENIR_DETAIL_REFRESH, obj: souvenir)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
    func addApi() {
        if souvenir == nil {
            return
        }
        let api = Api.request(.noteSouvenirAdd(souvenir: souvenir?.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_SOUVENIR_LIST_REFRESH, obj: nil)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
}
