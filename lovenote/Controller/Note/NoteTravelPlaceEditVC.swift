//
//  NoteTravelPlaceEditVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/2.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteTravelPlaceEditVC: BaseVC {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    lazy var barVerticalMargin = ScreenUtils.heightFit(15)
    lazy var barIconMargin = ScreenUtils.widthFit(5)
    
    // view
    private var scroll: UIScrollView!
    private var tvContent: UITextView!
    private var vHappenAt: UIView!
    private var lHappenAt: UILabel!
    private var vAddress: UIView!
    private var lAddress: UILabel!
    
    // var
    private var place: TravelPlace?
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(NoteTravelPlaceEditVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "track")
        let barItemCommit = UIBarButtonItem(title: StringUtils.getString("commit"), style: .plain, target: self, action: #selector(checkPush))
        barItemCommit.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        self.navigationItem.setRightBarButtonItems([barItemCommit], animated: true)
        
        // content
        tvContent = ViewHelper.getTextView(width: maxWidth, height: ViewHelper.FONT_NORMAL_LINE_HEIGHT * 5, text: "", textSize: ViewHelper.FONT_SIZE_NORMAL, textColor: ColorHelper.getFontGrey(), placeholder: StringUtils.getString("please_input_track_content"), limitLength: UDHelper.getLimit().travelPlaceContentLength)
        tvContent.frame.origin = CGPoint(x: margin, y: margin * 2)
        
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
        
        scroll.addSubview(tvContent)
        scroll.addSubview(vHappenAt)
        scroll.addSubview(vAddress)
        
        // view
        self.view.backgroundColor = ColorHelper.getWhite()
        self.view.addSubview(scroll)
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vHappenAt, action: #selector(showDatePicker))
        ViewUtils.addViewTapTarget(target: self, view: vAddress, action: #selector(selectLocation))
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyLocationSelect), name: NotifyHelper.TAG_MAP_SELECT)
        // init
        if place == nil {
            place = TravelPlace()
        }
        if place?.happenAt == 0 {
            place?.happenAt = DateUtils.getCurrentInt64()
        }
        // content
        ExtensionTextView.setTextViewTextWithPlaceholder(tvContent, text: place?.contentText)
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
        place?.address = locationInfo!.address
        place?.longitude = locationInfo!.longitude ?? 0
        place?.latitude = locationInfo!.latitude ?? 0
        place?.cityId = locationInfo!.cityId
        refreshLocationView()
    }
    
    @objc func showDatePicker() {
        AlertHelper.showDateTimePicker(date: place?.happenAt, actionHandler: { (_, _, _, picker) in
            self.place?.happenAt = DateUtils.getInt64(picker.date)
            self.refreshDateView()
        }, cancelHandler: nil)
    }
    
    func refreshDateView() {
        let happen = TimeHelper.getTimeShowLine_HM_MDHM_YMDHM_ByGo(place?.happenAt ?? DateUtils.getCurrentInt64())
        lHappenAt.text = StringUtils.getString("time_colon_space_holder", arguments: [happen])
    }
    
    @objc func selectLocation() {
        MapSelectVC.pushVC(address: place?.address, lon: place?.longitude, lat: place?.latitude)
    }
    
    func refreshLocationView() {
        let address = StringUtils.isEmpty(place?.address) ? StringUtils.getString("now_no") : (place?.address ?? "")
        lAddress.text = StringUtils.getString("address_colon_space_holder", arguments: [address])
    }
    
    @objc func checkPush() {
        if place == nil {
            return
        }
        if StringUtils.isEmpty(tvContent.text) {
            ToastUtils.show(tvContent.placeholder)
            return
        }
        place?.contentText = tvContent.text
        // notify
        NotifyHelper.post(NotifyHelper.TAG_TRAVEL_EDIT_ADD_PLACE, obj: place)
        // pop
        RootVC.get().popBack()
    }
    
}
