//
//  NoteAwardEditVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/23.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteAwardEditVC: BaseVC {
    
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
    private var vRule: UIView!
    private var lRule: UILabel!
    
    // var
    private var award: Award?
    private var awardRule: AwardRule?
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(NoteAwardEditVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "award")
        let barItemCommit = UIBarButtonItem(title: StringUtils.getString("commit"), style: .plain, target: self, action: #selector(addApi))
        barItemCommit.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        self.navigationItem.setRightBarButtonItems([barItemCommit], animated: true)
        
        // content
        tvContent = ViewHelper.getTextView(width: maxWidth, height: ViewHelper.FONT_NORMAL_LINE_HEIGHT * 5, text: "", textSize: ViewHelper.FONT_SIZE_NORMAL, textColor: ColorHelper.getFontGrey(), placeholder: StringUtils.getString("please_input_trigger_rule"), limitLength: UDHelper.getLimit().awardContentLength)
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
        
        // rule
        let vLineRule = ViewHelper.getViewLine(width: maxWidth)
        vLineRule.frame.origin = CGPoint(x: margin, y: 0)
        lRule = ViewHelper.getLabelGreyNormal(width: maxWidth, text: StringUtils.getString("rule_colon_space_holder"), lines: 1, align: .left, mode: .byTruncatingMiddle)
        let ivRule = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_exposure_grey_18dp"), color: ColorHelper.getFontGrey()), width: lRule.frame.size.height, height: lRule.frame.size.height, mode: .scaleAspectFit)
        ivRule.frame.origin = CGPoint(x: margin, y: barVerticalMargin)
        lRule.frame.size.width = screenWidth - ivRule.frame.origin.x - ivRule.frame.size.width - barIconMargin - margin
        lRule.frame.origin = CGPoint(x: ivRule.frame.origin.x + ivRule.frame.size.width + barIconMargin, y: barVerticalMargin)
        vRule = UIView(frame: CGRect(x: 0, y: vUser.frame.origin.y + vUser.frame.size.height, width: screenWidth, height: ivRule.frame.size.height + barVerticalMargin * 2))
        
        vRule.addSubview(vLineRule)
        vRule.addSubview(ivRule)
        vRule.addSubview(lRule)
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = vRule.frame.origin.y + self.view.frame.height - RootVC.get().getTopBarHeight() - ScreenUtils.getBottomNavHeight()
        scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        
        scroll.addSubview(tvContent)
        scroll.addSubview(vHappenAt)
        scroll.addSubview(vUser)
        scroll.addSubview(vRule)
        
        // view
        self.view.backgroundColor = ColorHelper.getWhite()
        self.view.addSubview(scroll)
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vHappenAt, action: #selector(showDatePicker))
        ViewUtils.addViewTapTarget(target: self, view: vUser, action: #selector(showUserPicker))
        ViewUtils.addViewTapTarget(target: self, view: vRule, action: #selector(goSelectRule))
    }
    
    override func initData() {
        // notify
        NotifyHelper.addObserver(self, selector: #selector(notifyRuleSelect), name: NotifyHelper.TAG_AWARD_RULE_SELECT)
        // init
        if award == nil {
            award = Award()
        }
        if award?.happenAt == 0 {
            award?.happenAt = DateUtils.getCurrentInt64()
        }
        award?.happenId = UDHelper.getMe()?.id ?? 0
        // content
        ExtensionTextView.setTextViewTextWithPlaceholder(tvContent, text: award?.contentText)
        // date
        refreshDateView()
        // user
        refreshUserView()
        // rule
        refreshRuleView()
    }
    
    @objc func notifyRuleSelect(notify: NSNotification) {
        if let rule = notify.object as? AwardRule {
            award?.awardRuleId = rule.id
            awardRule = rule
            refreshRuleView()
        }
    }
    
    @objc func showDatePicker() {
        AlertHelper.showDateTimePicker(date: award?.happenAt, actionHandler: { (_, _, _, picker) in
            self.award?.happenAt = DateUtils.getInt64(picker.date)
            self.refreshDateView()
        }, cancelHandler: nil)
    }
    
    func refreshDateView() {
        let happen = TimeHelper.getTimeShowLine_HM_MDHM_YMDHM_ByGo(award?.happenAt ?? DateUtils.getCurrentInt64())
        lHappenAt.text = StringUtils.getString("time_colon_space_holder", arguments: [happen])
    }
    
    @objc func showUserPicker() {
        let me = UDHelper.getMe()
        let ta = UDHelper.getTa()
        if award == nil || me == nil || ta == nil {
            return
        }
        _ = AlertHelper.showAlert(title: StringUtils.getString("select_user"),
                                  confirms: [StringUtils.getString("me_de"), StringUtils.getString("ta_de")],
                                  cancel: StringUtils.getString("cancel"),
                                  canCancel: true,
                                  actionHandler: { (_, index, _) in
                                    self.award?.happenId = (index == 0) ? me!.id : ta!.id
                                    self.refreshUserView()
        }, cancelHandler: nil)
    }
    
    func refreshUserView() {
        let me = UDHelper.getMe()
        let ta = UDHelper.getTa()
        if award == nil || me == nil || ta == nil {
            return
        }
        if award!.happenId == ta!.id {
            lUser.text = StringUtils.getString("belong_colon_space_holder", arguments: [StringUtils.getString("ta_de")])
        } else {
            lUser.text = StringUtils.getString("belong_colon_space_holder", arguments: [StringUtils.getString("me_de")])
        }
    }
    
    @objc func goSelectRule() {
        NoteAwardRuleVC.pushVC(select: true)
    }
    
    func refreshRuleView() {
        if award == nil {
            return
        }
        if StringUtils.isEmpty(tvContent.text) {
            ExtensionTextView.setTextViewTextWithPlaceholder(tvContent, text: awardRule?.title ?? "")
        }
        let score = (awardRule?.score ?? 0 > 0) ? "+\(awardRule?.score ?? 0)" : "\(awardRule?.score ?? 0)"
        lRule.text = StringUtils.getString("rule_colon_space_holder", arguments: [score])
    }
    
    @objc func addApi() {
        if award == nil {
            return
        }
        if award!.awardRuleId == 0 {
            ToastUtils.show(StringUtils.getString("please_select_rule"))
            return
        } else if StringUtils.isEmpty(tvContent.text) {
            ToastUtils.show(tvContent.placeholder)
            return
        }
        award?.contentText = tvContent.text
        let api = Api.request(.noteAwardAdd(award: award!.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_AWARD_LIST_REFRESH, obj: nil)
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
}
