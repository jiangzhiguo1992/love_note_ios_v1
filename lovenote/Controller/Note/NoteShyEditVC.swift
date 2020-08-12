//
//  NoteShyEditVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/16.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteShyEditVC: BaseVC {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    lazy var barVerticalMargin = ScreenUtils.heightFit(15)
    lazy var barIconMargin = ScreenUtils.widthFit(5)
    
    lazy var safeItems: [String] = [StringUtils.getString("nil"), StringUtils.getString("condom"), StringUtils.getString("acyeterion"), StringUtils.getString("out_shoot"), StringUtils.getString("other")]
    
    // view
    private var scroll: UIScrollView!
    private var tvContent: UITextView!
    private var vStartAt: UIView!
    private var lStartAt: UILabel!
    private var vEndAt: UIView!
    private var lEndAt: UILabel!
    private var vSafe: UIView!
    private var lSafe: UILabel!
    
    // var
    private var shy: Shy?
    private var safeIndex : Int = 0
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(NoteShyEditVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "shy")
        let barItemCommit = UIBarButtonItem(title: StringUtils.getString("commit"), style: .plain, target: self, action: #selector(addApi))
        barItemCommit.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        self.navigationItem.setRightBarButtonItems([barItemCommit], animated: true)
        
        // content
        tvContent = ViewHelper.getTextView(width: maxWidth, height: ViewHelper.FONT_NORMAL_LINE_HEIGHT * 5, text: "", textSize: ViewHelper.FONT_SIZE_NORMAL, textColor: ColorHelper.getFontGrey(), placeholder: StringUtils.getString("please_input_shy_desc"), limitLength: UDHelper.getLimit().shyDescLength)
        tvContent.frame.origin = CGPoint(x: margin, y: margin * 2)
        
        // startAt
        let vLineStartAt = ViewHelper.getViewLine(width: maxWidth)
        vLineStartAt.frame.origin = CGPoint(x: margin, y: 0)
        lStartAt = ViewHelper.getLabelGreyNormal(width: maxWidth, text: StringUtils.getString("start_time_colon_holder"), lines: 1, align: .left, mode: .byTruncatingMiddle)
        let ivStartAt = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_access_time_grey_18dp"), color: ColorHelper.getFontGrey()), width: lStartAt.frame.size.height, height: lStartAt.frame.size.height, mode: .scaleAspectFit)
        ivStartAt.frame.origin = CGPoint(x: margin, y: barVerticalMargin)
        lStartAt.frame.size.width = screenWidth - ivStartAt.frame.origin.x - ivStartAt.frame.size.width - barIconMargin - margin
        lStartAt.frame.origin = CGPoint(x: ivStartAt.frame.origin.x + ivStartAt.frame.size.width + barIconMargin, y: barVerticalMargin)
        vStartAt = UIView(frame: CGRect(x: 0, y: tvContent.frame.origin.y + tvContent.frame.size.height + ScreenUtils.heightFit(30), width: screenWidth, height: ivStartAt.frame.size.height + barVerticalMargin * 2))
        
        vStartAt.addSubview(vLineStartAt)
        vStartAt.addSubview(ivStartAt)
        vStartAt.addSubview(lStartAt)
        
        // endAt
        let vLineEndAt = ViewHelper.getViewLine(width: maxWidth)
        vLineEndAt.frame.origin = CGPoint(x: margin, y: 0)
        lEndAt = ViewHelper.getLabelGreyNormal(width: maxWidth, text: StringUtils.getString("end_time_colon_holder"), lines: 1, align: .left, mode: .byTruncatingMiddle)
        let ivEndAt = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_access_time_grey_18dp"), color: ColorHelper.getFontGrey()), width: lEndAt.frame.size.height, height: lEndAt.frame.size.height, mode: .scaleAspectFit)
        ivEndAt.frame.origin = CGPoint(x: margin, y: barVerticalMargin)
        lEndAt.frame.size.width = screenWidth - ivEndAt.frame.origin.x - ivEndAt.frame.size.width - barIconMargin - margin
        lEndAt.frame.origin = CGPoint(x: ivEndAt.frame.origin.x + ivEndAt.frame.size.width + barIconMargin, y: barVerticalMargin)
        vEndAt = UIView(frame: CGRect(x: 0, y: vStartAt.frame.origin.y + vStartAt.frame.size.height, width: screenWidth, height: ivEndAt.frame.size.height + barVerticalMargin * 2))
        
        vEndAt.addSubview(vLineEndAt)
        vEndAt.addSubview(ivEndAt)
        vEndAt.addSubview(lEndAt)
        
        // safe
        let vLineSafe = ViewHelper.getViewLine(width: maxWidth)
        vLineSafe.frame.origin = CGPoint(x: margin, y: 0)
        lSafe = ViewHelper.getLabelGreyNormal(width: maxWidth, text: StringUtils.getString("safe_method_colon_holder"), lines: 1, align: .left, mode: .byTruncatingMiddle)
        let ivSafe = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_verified_user_grey_18dp"), color: ColorHelper.getFontGrey()), width: lSafe.frame.size.height, height: lSafe.frame.size.height, mode: .scaleAspectFit)
        ivSafe.frame.origin = CGPoint(x: margin, y: barVerticalMargin)
        lSafe.frame.size.width = screenWidth - ivSafe.frame.origin.x - ivSafe.frame.size.width - barIconMargin - margin
        lSafe.frame.origin = CGPoint(x: ivSafe.frame.origin.x + ivSafe.frame.size.width + barIconMargin, y: barVerticalMargin)
        vSafe = UIView(frame: CGRect(x: 0, y: vEndAt.frame.origin.y + vEndAt.frame.size.height, width: screenWidth, height: ivSafe.frame.size.height + barVerticalMargin * 2))
        
        vSafe.addSubview(vLineSafe)
        vSafe.addSubview(ivSafe)
        vSafe.addSubview(lSafe)
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = vSafe.frame.origin.y + self.view.frame.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight()
        scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        
        scroll.addSubview(tvContent)
        scroll.addSubview(vStartAt)
        scroll.addSubview(vEndAt)
        scroll.addSubview(vSafe)
        
        // view
        self.view.backgroundColor = ColorHelper.getWhite()
        self.view.addSubview(scroll)
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vStartAt, action: #selector(showStartDatePicker))
        ViewUtils.addViewTapTarget(target: self, view: vEndAt, action: #selector(showEndDatePicker))
        ViewUtils.addViewTapTarget(target: self, view: vSafe, action: #selector(showSafePicker))
    }
    
    override func initData() {
        // init
        shy = Shy()
        shy?.happenAt = DateUtils.getCurrentInt64()
        shy?.endAt = DateUtils.getCurrentInt64() + DateUtils.UNIT_MIN * 10
        safeIndex = 0
        shy?.safe = safeItems[safeIndex]
        // content
        ExtensionTextView.setTextViewTextWithPlaceholder(tvContent, text: shy?.desc)
        // date
        refreshStartView()
        refreshEndView()
        // safe
        refreshSafeView()
    }
    
    @objc func showStartDatePicker() {
        AlertHelper.showDateTimePicker(date: shy?.happenAt, actionHandler: { (_, _, _, picker) in
            self.shy?.happenAt = DateUtils.getInt64(picker.date)
            self.refreshStartView()
        }, cancelHandler: nil)
    }
    
    func refreshStartView() {
        let happen = TimeHelper.getTimeShowLine_HM_MDHM_YMDHM_ByGo(shy?.happenAt ?? DateUtils.getCurrentInt64())
        lStartAt.text = StringUtils.getString("start_time_colon_holder", arguments: [happen])
    }
    
    @objc func showEndDatePicker() {
        AlertHelper.showDateTimePicker(date: shy?.endAt, actionHandler: { (_, _, _, picker) in
            self.shy?.endAt = DateUtils.getInt64(picker.date)
            self.refreshEndView()
        }, cancelHandler: nil)
    }
    
    func refreshEndView() {
        let end = TimeHelper.getTimeShowLine_HM_MDHM_YMDHM_ByGo(shy?.endAt ?? DateUtils.getCurrentInt64())
        lEndAt.text = StringUtils.getString("end_time_colon_holder", arguments: [end])
    }
    
    @objc func showSafePicker() {
        _ = AlertHelper.showAlert(title: StringUtils.getString("please_select_safe_method"),
                                  confirms: safeItems,
                                  cancel: StringUtils.getString("cancel"),
                                  canCancel: true,
                                  actionHandler: { (_, index, _) in
                                    self.safeIndex = Int(index)
                                    self.shy?.safe = self.safeItems[self.safeIndex]
                                    self.refreshSafeView()
        }, cancelHandler: nil)
    }
    
    func refreshSafeView() {
        lSafe.text = StringUtils.getString("safe_method_colon_holder", arguments: [shy?.safe ?? StringUtils.getString("nil")])
    }
    
    @objc func addApi() {
        if shy == nil {
            return
        }
        if StringUtils.isEmpty(shy?.safe) {
            ToastUtils.show(StringUtils.getString("please_select_safe_method"))
            return
        } else if StringUtils.isEmpty(tvContent.text) {
            ToastUtils.show(tvContent.placeholder)
            return
        }
        shy?.desc = tvContent.text
        let api = Api.request(.noteShyAdd(shy: shy!.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_SHY_LIST_REFRESH, obj: nil)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
}
