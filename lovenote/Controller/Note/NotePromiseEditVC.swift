//
//  NotePromiseEditVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/25.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NotePromiseEditVC: BaseVC {
    
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
    private var vUser: UIView!
    private var lUser: UILabel!
    
    // var
    private var promise: Promise?
    private var promiseOld: Promise!
    
    public static func pushVC(promise: Promise? = nil) {
        AppDelegate.runOnMainAsync {
            let vc = NotePromiseEditVC(nibName: nil, bundle: nil)
            if promise == nil {
                vc.actFrom = ACT_EDIT_FROM_ADD
            } else {
                if promise!.isMine() {
                    vc.actFrom = ACT_EDIT_FROM_UPDATE
                    vc.promise = promise
                    // 需要拷贝可编辑的数据
                    vc.promiseOld = Promise()
                    vc.promiseOld.happenAt = promise!.happenAt
                    vc.promiseOld.happenId = promise!.happenId
                    vc.promiseOld.contentText = promise!.contentText
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
        initNavBar(title: "promise")
        let barItemCommit = UIBarButtonItem(title: StringUtils.getString("commit"), style: .plain, target: self, action: #selector(checkPush))
        barItemCommit.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        self.navigationItem.setRightBarButtonItems([barItemCommit], animated: true)
        
        // content
        tvContent = ViewHelper.getTextView(width: maxWidth, height: ViewHelper.FONT_NORMAL_LINE_HEIGHT * 5, text: "", textSize: ViewHelper.FONT_SIZE_NORMAL, textColor: ColorHelper.getFontGrey(), placeholder: StringUtils.getString("please_input_promise_content"), limitLength: UDHelper.getLimit().promiseContentLength)
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
        
        scroll.addSubview(tvContent)
        scroll.addSubview(vHappenAt)
        scroll.addSubview(vUser)
        
        // view
        self.view.backgroundColor = ColorHelper.getWhite()
        self.view.addSubview(scroll)
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vHappenAt, action: #selector(showDatePicker))
        ViewUtils.addViewTapTarget(target: self, view: vUser, action: #selector(showUserPicker))
    }
    
    override func initData() {
        // init
        if promise == nil {
            promise = Promise()
        }
        if promise?.happenAt == 0 {
            promise?.happenAt = DateUtils.getCurrentInt64()
        }
        
        promise?.happenId = UDHelper.getMe()?.id ?? 0
        // content
        ExtensionTextView.setTextViewTextWithPlaceholder(tvContent, text: promise?.contentText)
        // date
        refreshDateView()
        // user
        refreshUserView()
    }
    
    override func canPop() -> Bool {
        // 更新，返还原来的值
        if isFromUpdate() {
            promise?.happenAt = promiseOld.happenAt
            promise?.happenId = promiseOld.happenId
            promise?.contentText = promiseOld.contentText
        }
        return true
    }
    
    func isFromUpdate() -> Bool {
        return actFrom == BaseVC.ACT_EDIT_FROM_UPDATE
    }
    
    @objc func showDatePicker() {
        AlertHelper.showDateTimePicker(date: promise?.happenAt, actionHandler: { (_, _, _, picker) in
            self.promise?.happenAt = DateUtils.getInt64(picker.date)
            self.refreshDateView()
        }, cancelHandler: nil)
    }
    
    func refreshDateView() {
        let happen = TimeHelper.getTimeShowLine_HM_MD_YMD_ByGo(promise?.happenAt ?? DateUtils.getCurrentInt64())
        lHappenAt.text = StringUtils.getString("time_colon_space_holder", arguments: [happen])
    }
    
    @objc func showUserPicker() {
        let me = UDHelper.getMe()
        let ta = UDHelper.getTa()
        if promise == nil || me == nil || ta == nil {
            return
        }
        _ = AlertHelper.showAlert(title: StringUtils.getString("select_user"),
                                  confirms: [StringUtils.getString("me_de"), StringUtils.getString("ta_de")],
                                  cancel: StringUtils.getString("cancel"),
                                  canCancel: true,
                                  actionHandler: { (_, index, _) in
                                    self.promise?.happenId = (index == 0) ? me!.id : ta!.id
                                    self.refreshUserView()
        }, cancelHandler: nil)
    }
    
    func refreshUserView() {
        let me = UDHelper.getMe()
        let ta = UDHelper.getTa()
        if promise == nil || me == nil || ta == nil {
            return
        }
        if promise!.happenId == ta!.id {
            lUser.text = StringUtils.getString("belong_colon_space_holder", arguments: [StringUtils.getString("ta_de")])
        } else {
            lUser.text = StringUtils.getString("belong_colon_space_holder", arguments: [StringUtils.getString("me_de")])
        }
    }
    
    @objc func checkPush() {
        if promise == nil {
            return
        }
        if StringUtils.isEmpty(tvContent.text) {
            ToastUtils.show(tvContent.placeholder)
            return
        }
        promise?.contentText = tvContent.text
        if isFromUpdate() {
            updateApi()
        } else {
            addApi()
        }
    }
    
    func updateApi() {
        if promise == nil {
            return
        }
        let api = Api.request(.notePromiseUpdate(promise: promise?.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // notify
                                let promise = data.promise
                                NotifyHelper.post(NotifyHelper.TAG_PROMISE_LIST_ITEM_REFRESH, obj: promise)
                                NotifyHelper.post(NotifyHelper.TAG_PROMISE_DETAIL_REFRESH, obj: promise)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
    func addApi() {
        if promise == nil {
            return
        }
        let api = Api.request(.notePromiseAdd(promise: promise?.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_PROMISE_LIST_REFRESH, obj: nil)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
}
