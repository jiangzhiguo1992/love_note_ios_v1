//
//  SettingsVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/9.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class SettingsVC: BaseVC {
    
    // const
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var padding = ScreenUtils.widthFit(16)
    lazy var maxWidth = screenWidth - padding * 2
    
    // view
    private var lBase: UILabel!
    private var lPush: UILabel!
    private var lAccount: UILabel!
    private var lOther: UILabel!
    
    private var lCacheDesc: UILabel!
    private var lPushCheck: UILabel!
    private var swPushSystem: UISwitch!
    private var swPushSocial: UISwitch!
    private var vNotice: UIView!
    private var vNoticePoint: UIView!
    private var vAbout: UIView!
    private var vAboutPoint: UIView!
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(SettingsVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "settings")
        
        // base
        lBase = ViewHelper.getLabelBold(width: maxWidth, text: StringUtils.getString("base_settings"), color: ThemeHelper.getColorPrimary())
        lBase.frame.size.height += padding * 2
        lBase.frame.origin = CGPoint(x: padding, y: 0)
        
        // theme
        let lTheme = ViewHelper.getLabelBlackNormal(width: maxWidth, text: StringUtils.getString("theme"))
        lTheme.frame.size.height += padding * 2
        lTheme.frame.origin = CGPoint(x: padding, y: lBase.frame.origin.y + lBase.frame.size.height)
        ViewHelper.addViewLineBottom(lTheme)
        
        // cache
        let lCache = ViewHelper.getLabelBlackNormal(width: maxWidth, text: StringUtils.getString("clear_cache"))
        lCache.frame.origin = CGPoint(x: 0, y: padding)
        lCacheDesc = ViewHelper.getLabelGreySmall(width: maxWidth, text: StringUtils.getString("contain_image_audio_video_total_colon_holder"))
        lCacheDesc.frame.origin = CGPoint(x: 0, y: lCache.frame.origin.y + lCache.frame.size.height + ScreenUtils.heightFit(2))
        
        let vCache = UIView()
        vCache.frame.size.width = maxWidth
        vCache.frame.size.height = lCache.frame.size.height + lCacheDesc.frame.size.height + ScreenUtils.heightFit(2) + padding * 2
        vCache.frame.origin = CGPoint(x: padding, y: lTheme.frame.origin.y + lTheme.frame.size.height)
        ViewHelper.addViewLineBottom(vCache)
        vCache.addSubview(lCache)
        vCache.addSubview(lCacheDesc)
        
        // push
        lPush = ViewHelper.getLabelBold(width: maxWidth, text: StringUtils.getString("notice_settings"), color: ThemeHelper.getColorPrimary())
        lPush.frame.size.height += padding * 2
        lPush.frame.origin = CGPoint(x: padding, y: vCache.frame.origin.y + vCache.frame.size.height)
        
        // push-check
        lPushCheck = ViewHelper.getLabelBlackNormal(width: maxWidth, text: StringUtils.getString("notice_yes_open"))
        lPushCheck.frame.size.height += padding * 2
        lPushCheck.frame.origin = CGPoint(x: padding, y: lPush.frame.origin.y + lPush.frame.size.height)
        ViewHelper.addViewLineBottom(lPushCheck)
        
        // push-system
        let lPushSystem = ViewHelper.getLabelBlackNormal(width: maxWidth, text: StringUtils.getString("system_notice"))
        lPushSystem.frame.origin = CGPoint(x: 0, y: padding)
        let lPushSystemDesc = ViewHelper.getLabelGreySmall(width: maxWidth, text: StringUtils.getString("receive_system_send_import_notice"))
        lPushSystemDesc.frame.origin = CGPoint(x: 0, y: lPushSystem.frame.origin.y + lPushSystem.frame.size.height + ScreenUtils.heightFit(2))
        
        let vPushSystem = UIView()
        vPushSystem.frame.size.width = maxWidth
        vPushSystem.frame.size.height = lPushSystem.frame.size.height + lPushSystemDesc.frame.size.height + ScreenUtils.heightFit(2) + padding * 2
        vPushSystem.frame.origin = CGPoint(x: padding, y: lPushCheck.frame.origin.y + lPushCheck.frame.size.height)
        ViewHelper.addViewLineBottom(vPushSystem)
        vPushSystem.addSubview(lPushSystem)
        vPushSystem.addSubview(lPushSystemDesc)
        
        swPushSystem = ViewHelper.getSwitch()
        swPushSystem.frame.origin.x = maxWidth - swPushSystem.frame.size.width + padding
        swPushSystem.center.y = vPushSystem.center.y
        
        // push-social
        let lPushSocial = ViewHelper.getLabelBlackNormal(width: maxWidth, text: StringUtils.getString("social_notice"))
        lPushSocial.frame.origin = CGPoint(x: 0, y: padding)
        let lPushSocialDesc = ViewHelper.getLabelGreySmall(width: maxWidth, text: StringUtils.getString("receive_from_social_notice"))
        lPushSocialDesc.frame.origin = CGPoint(x: 0, y: lPushSocial.frame.origin.y + lPushSocial.frame.size.height + ScreenUtils.heightFit(2))
        
        let vPushSocial = UIView()
        vPushSocial.frame.size.width = maxWidth
        vPushSocial.frame.size.height = lPushSystem.frame.size.height + lPushSystemDesc.frame.size.height + ScreenUtils.heightFit(2) + padding * 2
        vPushSocial.frame.origin = CGPoint(x: padding, y: vPushSystem.frame.origin.y + vPushSystem.frame.size.height)
        ViewHelper.addViewLineBottom(vPushSocial)
        vPushSocial.addSubview(lPushSocial)
        vPushSocial.addSubview(lPushSocialDesc)
        
        swPushSocial = ViewHelper.getSwitch()
        swPushSocial.frame.origin.x = maxWidth - swPushSocial.frame.size.width + padding
        swPushSocial.center.y = vPushSocial.center.y
        
        // account
        lAccount = ViewHelper.getLabelBold(width: maxWidth, text: StringUtils.getString("account_settings"), color: ThemeHelper.getColorPrimary())
        lAccount.frame.size.height += padding * 2
        lAccount.frame.origin = CGPoint(x: padding, y: vPushSocial.frame.origin.y + vPushSocial.frame.size.height)
        
        // phone
        let lAccountPhone = ViewHelper.getLabelBlackNormal(width: maxWidth, text: StringUtils.getString("change_phone"))
        lAccountPhone.frame.size.height += padding * 2
        lAccountPhone.frame.origin = CGPoint(x: padding, y: lAccount.frame.origin.y + lAccount.frame.size.height)
        ViewHelper.addViewLineBottom(lAccountPhone)
        
        // pwd
        let lAccountPwd = ViewHelper.getLabelBlackNormal(width: maxWidth, text: StringUtils.getString("modify_password"))
        lAccountPwd.frame.size.height += padding * 2
        lAccountPwd.frame.origin = CGPoint(x: padding, y: lAccountPhone.frame.origin.y + lAccountPhone.frame.size.height)
        ViewHelper.addViewLineBottom(lAccountPwd)
        
        // other
        lOther = ViewHelper.getLabelBold(width: maxWidth, text: StringUtils.getString("about_and_help"), color: ThemeHelper.getColorPrimary())
        lOther.frame.size.height += padding * 2
        lOther.frame.origin = CGPoint(x: padding, y: lAccountPwd.frame.origin.y + lAccountPwd.frame.size.height)
        
        // notice
        let lNotice = ViewHelper.getLabelBlackNormal(text: StringUtils.getString("new_notice"))
        lNotice.frame.origin = CGPoint(x: 0, y: padding)
        
        vNoticePoint = UIView()
        vNoticePoint.frame.size = CGSize(width: ScreenUtils.widthFit(7), height: ScreenUtils.widthFit(7))
        vNoticePoint.frame.origin = CGPoint(x: lNotice.frame.origin.x + lNotice.frame.size.width + ScreenUtils.heightFit(3), y: padding)
        vNoticePoint.backgroundColor = ColorHelper.getRedDark()
        ViewUtils.setViewRadiusCircle(vNoticePoint)
        
        vNotice = UIView()
        vNotice.frame.size = CGSize(width: maxWidth, height: lNotice.frame.size.height + padding * 2)
        vNotice.frame.origin = CGPoint(x: padding, y: lOther.frame.origin.y + lOther.frame.size.height)
        ViewHelper.addViewLineBottom(vNotice)
        vNotice.addSubview(lNotice)
        vNotice.addSubview(vNoticePoint)
        
        // help
        let lHelp = ViewHelper.getLabelBlackNormal(width: maxWidth, text: StringUtils.getString("help_document"))
        lHelp.frame.size.height += padding * 2
        lHelp.frame.origin = CGPoint(x: padding, y: vNotice.frame.origin.y + vNotice.frame.size.height)
        ViewHelper.addViewLineBottom(lHelp)
        
        // suggest
        let lSuggest = ViewHelper.getLabelBlackNormal(width: maxWidth, text: StringUtils.getString("suggest_feedback"))
        lSuggest.frame.size.height += padding * 2
        lSuggest.frame.origin = CGPoint(x: padding, y: lHelp.frame.origin.y + lHelp.frame.size.height)
        ViewHelper.addViewLineBottom(lSuggest)
        
        // about
        let lAbout = ViewHelper.getLabelBlackNormal(text: StringUtils.getString("about_app"))
        lAbout.frame.origin = CGPoint(x: 0, y: padding)
        
        vAboutPoint = UIView()
        vAboutPoint.frame.size = CGSize(width: ScreenUtils.widthFit(7), height: ScreenUtils.widthFit(7))
        vAboutPoint.frame.origin = CGPoint(x: lAbout.frame.origin.x + lAbout.frame.size.width + ScreenUtils.heightFit(3), y: padding)
        vAboutPoint.backgroundColor = ColorHelper.getRedDark()
        ViewUtils.setViewRadiusCircle(vAboutPoint)
        
        vAbout = UIView()
        vAbout.frame.size = CGSize(width: maxWidth, height: lAbout.frame.size.height + padding * 2)
        vAbout.frame.origin = CGPoint(x: padding, y: lSuggest.frame.origin.y + lSuggest.frame.size.height)
        ViewHelper.addViewLineBottom(vAbout)
        vAbout.addSubview(lAbout)
        vAbout.addSubview(vAboutPoint)
        
        // exit
        let btnExit = ViewHelper.getBtnBGTrans(paddingH: ScreenUtils.widthFit(5), paddingV: ScreenUtils.heightFit(5), title: StringUtils.getString("exist_account"), titleColor: ThemeHelper.getColorDark())
        btnExit.center.x = self.view.center.x
        btnExit.frame.origin.y = vAbout.frame.origin.y + vAbout.frame.size.height + ScreenUtils.heightFit(20)
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = btnExit.frame.origin.y + btnExit.frame.size.height + ScreenUtils.heightFit(20)
        let scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        scroll.addSubview(lBase)
        scroll.addSubview(lTheme)
        scroll.addSubview(vCache)
        scroll.addSubview(lPush)
        scroll.addSubview(lPushCheck)
        scroll.addSubview(vPushSystem)
        scroll.addSubview(swPushSystem)
        scroll.addSubview(vPushSocial)
        scroll.addSubview(swPushSocial)
        scroll.addSubview(lAccount)
        scroll.addSubview(lAccountPhone)
        scroll.addSubview(lAccountPwd)
        scroll.addSubview(lOther)
        scroll.addSubview(vNotice)
        scroll.addSubview(lHelp)
        scroll.addSubview(lSuggest)
        scroll.addSubview(vAbout)
        scroll.addSubview(btnExit)
        
        // view
        self.view.addSubview(scroll)
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: lTheme, action: #selector(targetGoTheme))
        ViewUtils.addViewTapTarget(target: self, view: vCache, action: #selector(targetClearCache))
        ViewUtils.addViewTapTarget(target: self, view: lPushCheck, action: #selector(targetGoPush))
        ViewUtils.addViewTapTarget(target: self, view: lAccountPhone, action: #selector(targetGoPhone))
        ViewUtils.addViewTapTarget(target: self, view: lAccountPwd, action: #selector(targetGoPwd))
        ViewUtils.addViewTapTarget(target: self, view: vNotice, action: #selector(targetGoNotice))
        ViewUtils.addViewTapTarget(target: self, view: lHelp, action: #selector(targetGoHelp))
        ViewUtils.addViewTapTarget(target: self, view: lSuggest, action: #selector(targetGoSuggest))
        ViewUtils.addViewTapTarget(target: self, view: vAbout, action: #selector(targetGoAbout))
        swPushSystem.addTarget(self, action: #selector(targetTogglePushSystem), for: .valueChanged)
        swPushSocial.addTarget(self, action: #selector(targetTogglePushSocial), for: .valueChanged)
        btnExit.addTarget(self, action: #selector(targetExit), for: .touchUpInside)
    }
    
    override func initData() {
        // 缓存大小
        cacheShow()
        // 系统通知
        swPushSystem.setOn(UDHelper.getSettingsNoticeSystem(), animated: true)
        // 社交通知
        swPushSocial.setOn(UDHelper.getSettingsNoticeSocial(), animated: true)
    }
    
    override func onReview(_ animated: Bool) {
        let canPush = UIApplication.shared.isRegisteredForRemoteNotifications
        let commonCount = UDHelper.getCommonCount()
        // 推送刷新
        lPushCheck.text = StringUtils.getString(canPush ? "notice_yes_open" : "notice_no_open")
        // 最新公告
        vNoticePoint.removeFromSuperview()
        if commonCount.noticeNewCount > 0 {
            vNotice.addSubview(vNoticePoint)
        } else {
            vNoticePoint.removeFromSuperview()
        }
        // 关于软件
        vAboutPoint.removeFromSuperview()
        if commonCount.versionNewCount > 0 {
            vAbout.addSubview(vAboutPoint)
        } else {
            vAboutPoint.removeFromSuperview()
        }
    }
    
    override func onThemeUpdate(theme: Int?) {
        lBase.textColor = ThemeHelper.getColorPrimary()
        lPush.textColor = ThemeHelper.getColorPrimary()
        lAccount.textColor = ThemeHelper.getColorPrimary()
        lOther.textColor = ThemeHelper.getColorPrimary()
        swPushSystem.tintColor = ThemeHelper.getColorPrimary()
        swPushSystem.onTintColor = ThemeHelper.getColorPrimary()
        swPushSocial.tintColor = ThemeHelper.getColorPrimary()
        swPushSocial.onTintColor = ThemeHelper.getColorPrimary()
    }
    
    @objc private func targetGoTheme() {
        ThemeVC.pushVC()
    }
    
    @objc private func targetClearCache() {
        _ = AlertHelper.showAlert(title: StringUtils.getString("confirm_del_cache"),
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  actionHandler: { (_, _, _) in
                                    // 清除缓存
                                    let indicator = AlertHelper.showIndicator(canCancel: false, cancelHandler: nil)
                                    AppDelegate.getQueueGlobal().async {
                                        ResHelper.clearCache()
                                        AppDelegate.runOnMainAsync {
                                            AlertHelper.diss(indicator)
                                            ToastUtils.show(StringUtils.getString("cache_clear_success"))
                                            self.cacheShow(size: "0KB")
                                        }
                                    }
        }, cancelHandler: nil)
    }
    
    private func cacheShow(size: String? = nil) {
        let cachesSize = !StringUtils.isEmpty(size) ? size! : FileUtils.getSizeFormat(size: ResHelper.getCacheSize())
        lCacheDesc.text = StringUtils.getString("contain_image_audio_video_total_colon_holder", arguments: [cachesSize])
    }
    
    @objc private func targetGoPush() {
        URLUtils.openSettings()
    }
    
    @objc private func targetTogglePushSystem(sender: UISwitch) {
        UDHelper.setSettingsNoticeSystem(swPushSystem.isOn)
        PushHelper.checkTagBind()
    }
    
    @objc private func targetTogglePushSocial(sender: UISwitch) {
        UDHelper.setSettingsNoticeSocial(swPushSocial.isOn)
        PushHelper.checkAccountBind()
    }
    
    @objc private func targetGoPhone() {
        UserPhoneVC.pushVC()
    }
    
    @objc private func targetGoPwd() {
        UserPasswordVC.pushVC()
    }
    
    @objc private func targetGoNotice() {
        NoticeListVC.pushVC()
    }
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC()
    }
    
    @objc private func targetGoSuggest() {
        SuggestHomeVC.pushVC()
    }
    
    @objc private func targetGoAbout() {
        AboutVC.pushVC()
    }
    
    @objc private func targetExit(sender: UIButton) {
        _ = AlertHelper.showAlert(title: StringUtils.getString("exist_account"),
                                  msg: StringUtils.getString("confirm_exist_account"),
                                  confirms: [StringUtils.getString("confirm")],
                                  cancel: StringUtils.getString("cancel"),
                                  actionHandler: { (_, _, _) in
                                    UDHelper.clearAll()
                                    PushHelper.unBindAccount()
                                    NotifyHelper.post(NotifyHelper.TAG_USER_REFRESH, obj: nil)
                                    SplashVC.pushVC()
        }, cancelHandler: nil)
    }
    
}
