//
//  CouplePairVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/7.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class CouplePairVC: BaseVC {
    
    // const
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var marginH = ScreenUtils.widthFit(20)
    lazy var marginV = ScreenUtils.heightFit(20)
    lazy var marginCardH = ScreenUtils.widthFit(10)
    lazy var marginCardV = ScreenUtils.heightFit(10)
    lazy var maxWidth = screenWidth - marginH * 2
    
    // view
    private var vInput: UIView!
    private var tfPhone: UITextField!
    
    private var vCard: UIView!
    private var lCardPhone: UILabel!
    private var lCardTitle: UILabel!
    private var lCardMessage: UILabel!
    private var btnCardBad: UIButton!
    private var btnCardGood: UIButton!
    
    private var scroll: UIScrollView!
    
    // var
    private var coupleId: Int64 = 0
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(CouplePairVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "pair")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_help_outline_white_24dp"), style: .plain, target: self, action: #selector(targetGoHelp))
        
        // input
        tfPhone = ViewHelper.getTextField(width: maxWidth, paddingV: ScreenUtils.heightFit(10), placeholder: StringUtils.getString("please_input_ta_phone"), keyboardType: .numberPad)
        tfPhone.frame.origin = CGPoint(x: 0, y: marginV)
        ViewUtils.addTextFiledLeftView(tfPhone, left: "ic_phone_iphone_grey_24dp")
        ViewHelper.addViewLineBottom(tfPhone, height: ScreenUtils.heightFit(1), color: ThemeHelper.getColorLight())
        
        let btnInvitee = ViewHelper.getBtnBGPrimary(width: maxWidth, paddingV: ScreenUtils.heightFit(7.5), title: StringUtils.getString("i_want_pair_with_ta"), circle: true)
        btnInvitee.frame.origin = CGPoint(x: 0, y: tfPhone.frame.origin.y + tfPhone.frame.size.height + marginV)
        
        vInput = UIView(frame: CGRect(x: 0, y: 0, width: maxWidth, height: btnInvitee.frame.origin.y + btnInvitee.frame.size.height + ScreenUtils.heightFit(10)))
        vInput.frame.origin = CGPoint(x: marginH, y: 0)
        vInput.addSubview(tfPhone)
        vInput.addSubview(btnInvitee)
        
        // card
        lCardPhone = ViewHelper.getLabelBold(width: maxWidth - marginCardH * 2, text: "-", color: ThemeHelper.getColorPrimary(), lines: 0, align: .center)
        lCardPhone.frame.origin = CGPoint(x: marginCardH, y: marginV)
        
        lCardTitle = ViewHelper.getLabelBold(width: maxWidth - marginCardH * 2, text: "-", size: ViewHelper.FONT_SIZE_BIG, color: ThemeHelper.getColorPrimary(), lines: 0, align: .center)
        lCardTitle.frame.origin = CGPoint(x: marginCardH, y: lCardPhone.frame.origin.y + lCardPhone.frame.size.height + marginCardH)
        
        lCardMessage = ViewHelper.getLabelPrimaryNormal(width: maxWidth - marginCardH * 2, text: "-", lines: 0, align: .center)
        lCardMessage.frame.origin = CGPoint(x: marginCardH, y: lCardTitle.frame.origin.y + lCardTitle.frame.size.height + marginCardH)
        
        btnCardBad = ViewHelper.getBtnBGPrimary(width: (maxWidth - marginCardH * 3) / 2, paddingV: CGFloat(5), title: "-", circle: true)
        btnCardBad.frame.origin = CGPoint(x: marginCardH, y: lCardMessage.frame.origin.y + lCardMessage.frame.size.height + marginV)
        
        btnCardGood = ViewHelper.getBtnBGPrimary(width: (maxWidth - marginCardH * 3) / 2, paddingV: CGFloat(5), title: "-", circle: true)
        btnCardGood.frame.origin = CGPoint(x: marginCardH * 2 + btnCardBad.frame.size.width, y: lCardMessage.frame.origin.y + lCardMessage.frame.size.height + marginV)
        
        vCard = UIView()
        vCard.frame.size = CGSize(width: maxWidth, height: btnCardGood.frame.origin.y + btnCardGood.frame.size.height + marginV)
        vCard.frame.origin = CGPoint(x: marginH, y: marginV)
        vCard.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vCard, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vCard, offset: ViewHelper.SHADOW_BIG, color: ThemeHelper.getColorPrimary())
        vCard.addSubview(lCardPhone)
        vCard.addSubview(lCardTitle)
        vCard.addSubview(lCardMessage)
        vCard.addSubview(btnCardBad)
        vCard.addSubview(btnCardGood)
        
        // scroll
        scroll = ViewUtils.getScroll(frame: self.view.bounds, contentSize: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
        scroll.backgroundColor = ColorHelper.getWhite()
        scroll.refreshControl = UIRefreshControl()
        scroll.refreshControl?.tintColor = ThemeHelper.getColorPrimary()
        //        scroll.addSubview(vInput) 动态控制
        //        scroll.addSubview(vCard) 动态控制
        
        // view
        self.view.addSubview(scroll)
        
        // target
        scroll.refreshControl?.addTarget(self, action: #selector(coupleGetVisible), for: .valueChanged)
        btnInvitee.addTarget(self, action: #selector(inviteeTa), for: .touchUpInside)
        btnCardBad.addTarget(self, action: #selector(updateCouple2Bad), for: .touchUpInside)
        btnCardGood.addTarget(self, action: #selector(updateCouple2Good), for: .touchUpInside)
    }
    
    override func initData() {
        coupleGetVisible()
    }
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC(HelpVC.INDEX_COUPLE_PAIR)
    }
    
    private func allViewGone() {
        vInput.removeFromSuperview()
        vCard.removeFromSuperview()
    }
    
    @objc private func refreshSelfCouple() {
        allViewGone()
        // api 获取自身可见的cp
        let api = Api.request(.coupleSelfGet,
                              loading: true, success: { (_, _, data) in
                                ViewUtils.endScrollRefresh(self.scroll)
                                self.refreshSelfCoupleView(data)
        }) { (_, _, _) in
            ViewUtils.endScrollRefresh(self.scroll)
            self.refreshSelfCoupleView(nil)
        }
        pushApi(api)
    }
    
    @objc private func inviteeTa() {
        let phone = tfPhone.text ?? ""
        if StringUtils.isEmpty(phone) {
            ToastUtils.show(tfPhone.placeholder)
            return
        }
        allViewGone()
        // api 邀请
        let body = User()
        body.phone = phone
        let api = Api.request(.coupleInvitee(user: body.toJSON()),
                              loading: true, success: { (_, _, data) in
                                // 邀请成功，重新获取等待的cp
                                self.refreshSelfCouple()
        }) { (_, _, _) in
            self.refreshSelfCoupleView(nil)
        }
        pushApi(api)
    }
    
    private func refreshSelfCoupleView(_ data: ApiData?) {
        if data == nil || UserHelper.isEmpty(couple: data?.couple) || data?.pairCard == nil {
            // 没有等待处理的
            coupleId = 0
            scroll.addSubview(vInput)
            vCard.removeFromSuperview()
            return
        }
        // 有等待处理的
        coupleId = data!.couple!.id
        vInput.removeFromSuperview()
        scroll.addSubview(vCard)
        var subHeight = CGFloat(0)
        let pairCard = data!.pairCard!
        // phone
        lCardPhone.removeFromSuperview()
        if StringUtils.isEmpty(pairCard.taPhone) {
            subHeight += lCardPhone.frame.size.height + marginCardV
        } else {
            let taPhone = StringUtils.getString("ta_colon_space_holder", arguments: [pairCard.taPhone])
            lCardPhone.text = taPhone
            vCard.addSubview(lCardPhone)
        }
        // title
        lCardTitle.removeFromSuperview()
        if StringUtils.isEmpty(pairCard.title) {
            subHeight += lCardTitle.frame.size.height + marginCardV
        } else {
            lCardTitle.frame.origin.y -= subHeight
            lCardTitle.text = pairCard.title
            vCard.addSubview(lCardTitle)
        }
        // message
        lCardMessage.removeFromSuperview()
        if StringUtils.isEmpty(pairCard.message) {
            subHeight += lCardMessage.frame.size.height + marginCardV
        } else {
            lCardMessage.frame.origin.y -= subHeight
            lCardMessage.text = pairCard.message
            vCard.addSubview(lCardMessage)
        }
        // btn
        btnCardBad.removeFromSuperview()
        btnCardGood.removeFromSuperview()
        let noBad = StringUtils.isEmpty(pairCard.btnBad)
        let noGood = StringUtils.isEmpty(pairCard.btnGood)
        if noBad && noGood {
            subHeight += btnCardBad.frame.size.height
        } else if noBad {
            btnCardGood.frame.origin.x = btnCardBad.frame.origin.x
            btnCardGood.frame.origin.y -= subHeight
            btnCardGood.frame.size.width = vCard.frame.size.width - marginCardH * 2
            btnCardGood.setTitle(pairCard.btnGood, for: .normal)
            vCard.addSubview(btnCardGood)
        } else if noGood {
            btnCardBad.frame.origin.y -= subHeight
            btnCardBad.frame.size.width = vCard.frame.size.width - marginCardH * 2
            btnCardBad.setTitle(pairCard.btnBad, for: .normal)
            vCard.addSubview(btnCardBad)
        } else {
            btnCardBad.frame.origin.y -= subHeight
            btnCardBad.setTitle(pairCard.btnBad, for: .normal)
            btnCardGood.frame.origin.y -= subHeight
            btnCardGood.setTitle(pairCard.btnGood, for: .normal)
            vCard.addSubview(btnCardBad)
            vCard.addSubview(btnCardGood)
        }
        vCard.frame.size.height -= subHeight
        // shadow
        ViewUtils.setViewShadow(vCard, offset: ViewHelper.SHADOW_BIG, color: ThemeHelper.getColorPrimary())
    }
    
    @objc private func updateCouple2Bad() {
        coupleUpdate(type: ApiHelper.COUPLE_UPDATE_BAD, cid: coupleId)
    }
    
    @objc private func updateCouple2Good() {
        coupleUpdate(type: ApiHelper.COUPLE_UPDATE_GOOD, cid: coupleId)
    }
    
    private func coupleUpdate(type: Int, cid: Int64) {
        allViewGone()
        let body = Couple()
        body.id = cid
        // api 提交状态更新
        let api = Api.request(.coupleUpdate(type: type, couple: body.toJSON()),
                              loading: true, success: { (_, _, _) in
                                self.coupleGetVisible()
        }) { (_, _, _) in
            self.refreshSelfCoupleView(nil)
        }
        pushApi(api)
    }
    
    @objc private func coupleGetVisible() {
        let me = UDHelper.getMe()
        if UserHelper.isEmpty(user: me) {
            return
        }
        // api 查看是否有配对成功的
        let api = Api.request(.coupleGet(uid: me!.id),
                              loading: true, success: { (_, _, data) in
                                if !UserHelper.isCoupleBreak(couple: data.couple) {
                                    // 有配对成功的，退出本界面
                                    UDHelper.setCouple(data.couple)
                                    NotifyHelper.post(NotifyHelper.TAG_COUPLE_REFRESH, obj: data.couple)
                                    RootVC.get().popBack()
                                } else {
                                    // 没有则刷新数据和view
                                    self.refreshSelfCouple()
                                }
        }) { (_, _, _) in
            self.refreshSelfCoupleView(nil)
        }
        pushApi(api)
    }
    
}
