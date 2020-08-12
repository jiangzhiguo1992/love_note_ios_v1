//
//  CoupleInfoVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/16.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class CoupleInfoVC: BaseVC {
    
    // const
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var marginH = ScreenUtils.widthFit(20)
    lazy var marginV = ScreenUtils.heightFit(20)
    lazy var avatarWidth = ScreenUtils.widthFit(80)
    lazy var avatarMarginTop = ScreenUtils.heightFit(30)
    lazy var marginVertical = ScreenUtils.heightFit(20)
    lazy var labelWidth = (screenWidth - marginH * 3) / 2
    lazy var labelPadding = ScreenUtils.heightFit(10)
    lazy var togetherWidth = screenWidth - marginH * 2
    lazy var togetherIconMargin = ScreenUtils.widthFit(10)
    lazy var togetherContentWidth = togetherWidth - marginH * 2
    lazy var togetherInnerMargin = ScreenUtils.widthFit(5)
    lazy var lineWidth = ScreenUtils.widthFit(1.5)
    
    // view
    private var barItemState: UIBarButtonItem!
    private var ivAvatarLeft: UIImageView!
    private var ivAvatarRight: UIImageView!
    private var btnNameLeft: UIButton!
    private var btnNameRight: UIButton!
    private var btnPhoneLeft: UIButton!
    private var btnPhoneRight: UIButton!
    private var btnBirthLeft: UIButton!
    private var btnBirthRight: UIButton!
    private var vTogether: UIView!
    private var lTogetherLeft: UILabel!
    private var lTogetherDay: UILabel!
    private var lTogetherRight: UILabel!
    private var lTogetherTimer: UILabel!
    
    // var
    private var togetherTimer: Timer?
    
    public static func pushVC() {
        if UserHelper.isCoupleBreak(couple: UDHelper.getCouple()) {
            CouplePairVC.pushVC()
            return
        }
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(CoupleInfoVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "pair_info")
        hideNavigationBarShadow()
        let barItemHelp = UIBarButtonItem(image: UIImage(named: "ic_help_outline_white_24dp"), style: .plain, target: self, action: #selector(targetGoHelp))
        barItemState = UIBarButtonItem(title: StringUtils.getString("dissolve"), style: .plain, target: self, action: #selector(targetUpdateState))
        barItemState.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        self.navigationItem.setRightBarButtonItems([barItemState, barItemHelp], animated: true)
        
        // avatar
        ivAvatarLeft = ViewHelper.getImageViewAvatar(width: avatarWidth, height: avatarWidth)
        ivAvatarLeft.center.x = screenWidth / 4
        ivAvatarLeft.frame.origin.y = avatarMarginTop
        
        ivAvatarRight = ViewHelper.getImageViewAvatar(width: avatarWidth, height: avatarWidth)
        ivAvatarRight.center.x = screenWidth / 4 * 3
        ivAvatarRight.frame.origin.y = avatarMarginTop
        
        // name
        btnNameLeft = ViewHelper.getBtnBold(width: labelWidth, paddingV: CGFloat(labelPadding / 2), bgColor: ColorHelper.getTrans(), title: "-", titleColor: ColorHelper.getFontWhite(), circle: true, shadow: false)
        btnNameLeft.center.x = ivAvatarLeft.center.x
        btnNameLeft.frame.origin.y = ivAvatarLeft.frame.origin.y + ivAvatarLeft.frame.size.height + marginVertical
        ViewUtils.setViewBorder(btnNameLeft, width: lineWidth, color: ColorHelper.getFontWhite())
        
        btnNameRight = ViewHelper.getBtnBold(width: labelWidth, paddingV: CGFloat(labelPadding / 2), bgColor: ColorHelper.getTrans(), title: "-", titleColor: ColorHelper.getFontWhite(), circle: true, shadow: false)
        btnNameRight.center.x = ivAvatarRight.center.x
        btnNameRight.frame.origin.y = ivAvatarRight.frame.origin.y + ivAvatarRight.frame.size.height + marginVertical
        ViewUtils.setViewBorder(btnNameRight, width: lineWidth, color: ColorHelper.getFontWhite())
        
        // phone
        btnPhoneLeft = ViewHelper.getBtnBold(width: labelWidth, paddingV: CGFloat(labelPadding / 2), bgColor: ColorHelper.getTrans(), title: "-", titleColor: ColorHelper.getFontWhite(), circle: true, shadow: false)
        ViewUtils.setViewBorder(btnPhoneLeft, width: lineWidth, color: ColorHelper.getFontWhite())
        btnPhoneLeft.center.x = ivAvatarLeft.center.x
        btnPhoneLeft.frame.origin.y = btnNameLeft.frame.origin.y + btnNameLeft.frame.size.height + marginVertical
        
        btnPhoneRight = ViewHelper.getBtnBold(width: labelWidth, paddingV: CGFloat(labelPadding / 2), bgColor: ColorHelper.getTrans(), title: "-", titleColor: ColorHelper.getFontWhite(), circle: true, shadow: false)
        btnPhoneRight.center.x = ivAvatarRight.center.x
        btnPhoneRight.frame.origin.y = btnNameRight.frame.origin.y + btnNameRight.frame.size.height + marginVertical
        ViewUtils.setViewBorder(btnPhoneRight, width: lineWidth, color: ColorHelper.getFontWhite())
        
        // birth
        btnBirthLeft = ViewHelper.getBtnBold(width: labelWidth, paddingV: CGFloat(labelPadding / 2), bgColor: ColorHelper.getTrans(), title: "-", titleColor: ColorHelper.getFontWhite(), circle: true, shadow: false)
        btnBirthLeft.center.x = ivAvatarLeft.center.x
        btnBirthLeft.frame.origin.y = btnPhoneLeft.frame.origin.y + btnPhoneLeft.frame.size.height + marginVertical
        ViewUtils.setViewBorder(btnBirthLeft, width: lineWidth, color: ColorHelper.getFontWhite())
        
        btnBirthRight = ViewHelper.getBtnBold(width: labelWidth, paddingV: CGFloat(labelPadding / 2), bgColor: ColorHelper.getTrans(), title: "-", titleColor: ColorHelper.getFontWhite(), circle: true, shadow: false)
        btnBirthRight.center.x = ivAvatarRight.center.x
        btnBirthRight.frame.origin.y = btnPhoneRight.frame.origin.y + btnPhoneRight.frame.size.height + marginVertical
        ViewUtils.setViewBorder(btnBirthRight, width: lineWidth, color: ColorHelper.getFontWhite())
        
        // together-iv
        let ivTogetherLeft = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_favorite_grey_18dp"), color: ThemeHelper.getColorPrimary()))
        ivTogetherLeft.frame.origin = CGPoint(x: togetherIconMargin, y: togetherIconMargin)
        let ivTogetherRight = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_favorite_grey_18dp"), color: ThemeHelper.getColorPrimary()))
        ivTogetherRight.frame.origin = CGPoint(x: togetherWidth - togetherIconMargin - ivTogetherRight.frame.size.width, y: togetherIconMargin)
        
        // together-day
        lTogetherLeft = ViewHelper.getLabelBold(text: StringUtils.getString("in_together"), size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary())
        lTogetherRight = ViewHelper.getLabelBold(text: StringUtils.getString("dayT"), size: ViewHelper.FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary())
        lTogetherDay = ViewHelper.getLabelBold(text: "-", size: ScreenUtils.fontFit(45), color: ThemeHelper.getColorPrimary(), lines: 1, align: .center, mode: .byTruncatingMiddle)
        lTogetherDay.frame.origin.x = (togetherWidth / 2) - (lTogetherDay.frame.width / 2) + ((lTogetherLeft.frame.size.width - lTogetherRight.frame.size.width) / 2)
        lTogetherDay.frame.origin.y = marginV
        lTogetherLeft.frame.origin.x = lTogetherDay.frame.origin.x - togetherInnerMargin - lTogetherLeft.frame.size.width
        lTogetherLeft.frame.origin.y = lTogetherDay.frame.origin.y + lTogetherDay.frame.size.height - lTogetherLeft.frame.size.height - ScreenUtils.heightFit(9)
        lTogetherRight.frame.origin.x = lTogetherDay.frame.origin.x + lTogetherDay.frame.size.width + togetherInnerMargin
        lTogetherRight.frame.origin.y = lTogetherDay.frame.origin.y + lTogetherDay.frame.size.height - lTogetherRight.frame.size.height - ScreenUtils.heightFit(9)
        
        // together-timer
        lTogetherTimer = ViewHelper.getLabelPrimaryHuge(width: togetherContentWidth, text: "-", lines: 1, align: .center, mode: .byTruncatingMiddle)
        lTogetherTimer.frame.origin.x = marginH
        lTogetherTimer.frame.origin.y = lTogetherDay.frame.origin.y + lTogetherDay.frame.size.height
        
        // together-view
        let togetherHeight = lTogetherTimer.frame.origin.y + lTogetherTimer.frame.size.height + ScreenUtils.heightFit(10)
        let togetherBottomHeight = self.view.frame.size.height - RootVC.get().getTopBarHeight() - (btnBirthLeft.frame.origin.y + btnBirthLeft.frame.size.height)
        let togetherBottomY = togetherBottomHeight / 2 - togetherHeight / 2
        let togetherY = btnBirthLeft.frame.origin.y + btnBirthLeft.frame.size.height + togetherBottomY
        vTogether = UIView(frame: CGRect(x: marginH, y: togetherY, width: togetherWidth, height: togetherHeight))
        vTogether.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vTogether, radius: ViewHelper.RADIUS_HUGE)
        ViewUtils.setViewShadow(vTogether, offset: ViewHelper.SHADOW_HUGE)
        vTogether.addSubview(ivTogetherLeft)
        vTogether.addSubview(ivTogetherRight)
        vTogether.addSubview(lTogetherLeft)
        vTogether.addSubview(lTogetherDay)
        vTogether.addSubview(lTogetherRight)
        vTogether.addSubview(lTogetherTimer)
        
        // bg
        let bgTopHeight = btnBirthLeft.frame.origin.y + btnBirthLeft.frame.size.height
        let bgTop = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: bgTopHeight))
        bgTop.backgroundColor = ThemeHelper.getColorPrimary()
        
        let bottomHeight = self.view.frame.size.height - bgTopHeight - RootVC.get().getTopBarHeight()
        let bgBottom = UIView(frame: CGRect(x: 0, y: bgTopHeight, width: screenWidth, height: bottomHeight))
        let gradientBottom = ViewHelper.getGradientPrimaryWhite(frame: CGRect(x: 0, y: 0, width: screenWidth, height: bottomHeight))
        bgBottom.layer.insertSublayer(gradientBottom, at: 0)
        
        // view
        self.view.backgroundColor = ColorHelper.getWhite()
        self.view.addSubview(bgTop)
        self.view.addSubview(bgBottom)
        self.view.addSubview(ivAvatarLeft)
        self.view.addSubview(ivAvatarRight)
        self.view.addSubview(btnNameLeft)
        self.view.addSubview(btnNameRight)
        self.view.addSubview(btnPhoneLeft)
        self.view.addSubview(btnPhoneRight)
        self.view.addSubview(btnBirthLeft)
        self.view.addSubview(btnBirthRight)
        self.view.addSubview(vTogether)
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: ivAvatarLeft, action: #selector(targetOnAvatarLeft))
        ViewUtils.addViewTapTarget(target: self, view: ivAvatarRight, action: #selector(targetOnAvatarRight))
        btnNameLeft.addTarget(self, action: #selector(targetOnNameLeft), for: .touchUpInside)
        btnPhoneLeft.addTarget(self, action: #selector(targetOnPhoneLeft), for: .touchUpInside)
        btnPhoneRight.addTarget(self, action: #selector(targetOnPhoneRight), for: .touchUpInside)
        btnBirthLeft.addTarget(self, action: #selector(targetOnBirthLeft), for: .touchUpInside)
        btnBirthRight.addTarget(self, action: #selector(targetOnBirthRight), for: .touchUpInside)
        ViewUtils.addViewTapTarget(target: self, view: vTogether, action: #selector(targetOnTogether))
    }
    
    override func initData() {
        initStateView()
        setViewData()
    }
    
    override func onDestroy() {
        stopBreakTimer()
    }
    
    private func initStateView() {
        var show = ""
        if canCoupleBreak() {
            show = StringUtils.getString("dissolve")
        } else {
            show = StringUtils.getString("complex")
        }
        barItemState.title = show
    }
    
    private func setViewData() {
        let me = UDHelper.getMe()
        let ta = UDHelper.getTa()
        let couple = me?.couple
        // avatar
        let taAvatar = UserHelper.getTaAvatar(user: me)
        let myAvatar = UserHelper.getMyAvatar(user: me)
        KFHelper.setImgAvatarUrl(iv: ivAvatarLeft, objKey: taAvatar, user: ta)
        KFHelper.setImgAvatarUrl(iv: ivAvatarRight, objKey: myAvatar, user: me)
        // name + phone + birth
        btnNameLeft.setTitle(UserHelper.getTaName(user: me), for: .normal)
        btnNameRight.setTitle(UserHelper.getMyName(user: me), for: .normal)
        btnPhoneLeft.setTitle(ta?.phone ?? "", for: .normal)
        btnPhoneRight.setTitle(me?.phone ?? "", for: .normal)
        btnBirthLeft.setTitle(DateUtils.getStr(ta?.birthday ?? 0, DateUtils.FORMAT_POINT_Y_M_D), for: .normal)
        btnBirthRight.setTitle(DateUtils.getStr(me?.birthday ?? 0, DateUtils.FORMAT_POINT_Y_M_D), for: .normal)
        // together
        lTogetherDay.text = String(UserHelper.getCoupleTogetherDay(couple: couple))
        let odlWidth = lTogetherDay.frame.size.width
        lTogetherDay.sizeToFit()
        let offset = lTogetherDay.frame.size.width - odlWidth
        lTogetherDay.frame.origin.x -= offset / 2
        lTogetherLeft.frame.origin.x -= offset / 2
        lTogetherRight.frame.origin.x += offset / 2
        // timer
        startTogetherTimer()
    }
    
    private func canCoupleBreak() -> Bool {
        let me = UDHelper.getMe()
        let canComplex = UserHelper.isCoupleBreaking(couple: me?.couple) && me?.couple?.state?.userId == me?.id
        return !canComplex
    }
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC(HelpVC.INDEX_COUPLE_INFO)
    }
    
    @objc private func targetUpdateState() {
        if canCoupleBreak() {
            showBreakAlert()
        } // 解散
        else {
            coupleStatus(type: ApiHelper.COUPLE_UPDATE_GOOD)
        } // 复合
    }
    
    @objc private func targetOnPhoneLeft() {
        URLUtils.openDial(phone: UDHelper.getTa()?.phone.trimmingCharacters(in: .whitespaces))
    }
    
    @objc private func targetOnPhoneRight() {
        UserPhoneVC.pushVC()
    }
    
    @objc private func targetOnBirthLeft() {
        //NoteSouvenirVC.pushVC()
    }
    
    @objc private func targetOnBirthRight() {
    }
    
    @objc private func targetOnAvatarLeft() {
        _ = AlertHelper.showAlert(confirms: [StringUtils.getString("change_image"), StringUtils.getString("look_big_image")],
                                  cancel: StringUtils.getString("cancel"),
                                  actionHandler: { (_, index, _) in
                                    if index == 0 {
                                        // 选取照片
                                        PickerHelper.selectImage(target: self, maxCount: 1, gif: false, compress: true, crop: true, complete: nil)
                                    } else {
                                        // 查看大图
                                        let ossKey = UserHelper.getTaAvatar(user: UDHelper.getMe())
                                        BrowserHelper.goBrowserImage(delegate: self, ossKeyList: [ossKey])
                                    }
        }, cancelHandler: nil)
    }
    
    override func onImageCropSuccess(data: Data?) {
        OssHelper.uploadAvatar(data: data, success: { (_, ossKey) in
            self.updateCoupleInfo(togetherAt: 0, avatar: ossKey, name: "")
        }, failure: nil)
    }
    
    @objc private func targetOnAvatarRight() {
        let ossKey = UserHelper.getMyAvatar(user: UDHelper.getMe())
        BrowserHelper.goBrowserImage(delegate: self, ossKeyList: [ossKey])
    }
    
    @objc private func targetOnNameLeft() {
        let name = UserHelper.getTaName(user: UDHelper.getMe()).trimmingCharacters(in: .whitespaces)
        _ = AlertHelper.showEdit(title: StringUtils.getString("modify_ta_name"),
                                 msg: nil,
                                 text: name,
                                 placeHolder: StringUtils.getString("please_input_nickname"),
                                 keyboard: .default,
                                 confirms: [StringUtils.getString("confirm_no_wrong")],
                                 cancel: StringUtils.getString("i_think_again"),
                                 canCancel: true,
                                 actionHandler: { (_, _, _, input) in
                                    // 开始修改
                                    if !StringUtils.isEmpty(input) {
                                        self.updateCoupleInfo(togetherAt: 0, avatar: "", name: input!)
                                    }
        },
                                 cancelHandler: nil)
    }
    
    @objc private func targetOnTogether() {
        let togetherAt = (UDHelper.getCouple()?.togetherAt) ?? DateUtils.getCurrentInt64()
        AlertHelper.showDateTimePicker(date: togetherAt, actionHandler: { (_, _, _, picker) in
            let togetherTime = DateUtils.getInt64(picker.date)
            self.updateCoupleInfo(togetherAt: togetherTime, avatar: "", name: "")
        }, cancelHandler: nil)
    }
    
    private func updateCoupleInfo(togetherAt: Int64, avatar: String, name: String) {
        let me = UDHelper.getMe()
        if me == nil {
            return
        }
        var body = me?.couple
        if body == nil {
            body = Couple()
        }
        body?.togetherAt = togetherAt
        if body?.creatorId == me?.id {
            body?.inviteeAvatar = avatar
            body?.inviteeName = name
        } else {
            body?.creatorAvatar = avatar
            body?.creatorName = name
        }
        // api
        let api = Api.request(.coupleUpdate(type: ApiHelper.COUPLE_UPDATE_INFO, couple: body?.toJSON()),
                              loading: true, success: { (_, _, data) in
                                let couple = data.couple
                                UDHelper.setCouple(couple)
                                NotifyHelper.post(NotifyHelper.TAG_COUPLE_REFRESH, obj: couple)
                                self.setViewData()
        }, failure: nil)
        pushApi(api)
    }
    
    private func showBreakAlert() {
        _ = AlertHelper.showAlert(title: StringUtils.getString("u_confirm_break"),
                                  msg: StringUtils.getString("impulse_is_devil_3"),
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  actionHandler: { (_, _, _) in
                                    self.coupleStatus(type: ApiHelper.COUPLE_UPDATE_BAD)
        }, cancelHandler: nil)
    }
    
    private func coupleStatus(type: Int) {
        let couple = UDHelper.getCouple()
        // api
        let api = Api.request(.coupleUpdate(type: type, couple: couple?.toJSON()),
                              loading: true, success: { (_, _, data) in
                                let couple = data.couple
                                UDHelper.setCouple(couple)
                                NotifyHelper.post(NotifyHelper.TAG_COUPLE_REFRESH, obj: couple)
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
    private func startTogetherTimer() {
        // 先停止，避免重复
        stopBreakTimer()
        // 创建任务，会先执行一次
        togetherTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: true, block: { (_) in
            let couple = UDHelper.getCouple()
            if couple == nil {
                return
            }
            let timeGo = (DateUtils.getCurrentInt64() - couple!.togetherAt) % DateUtils.UNIT_DAY
            if timeGo <= 0 {
                self.lTogetherDay.text  = "\(UserHelper.getCoupleTogetherDay(couple: couple))"
                NotifyHelper.post(NotifyHelper.TAG_COUPLE_REFRESH, obj: couple)
            }
            self.lTogetherTimer.text = self.getTogetherCountDownShow(countDown: timeGo)
        })
        // 立刻启动
        togetherTimer?.fire()
    }
    
    private func stopBreakTimer() {
        togetherTimer?.invalidate()
        togetherTimer = nil
    }
    
    private func getTogetherCountDownShow(countDown: Int64) -> String {
        let hour = countDown / DateUtils.UNIT_HOUR
        let hourF = hour >= 10 ? "" : "0"
        let min = (countDown - hour * DateUtils.UNIT_HOUR) / DateUtils.UNIT_MIN
        let minF = min >= 10 ? ":" : ":0"
        let sec = countDown - hour * DateUtils.UNIT_HOUR - min * DateUtils.UNIT_MIN
        let secF = sec >= 10 ? ":" : ":0"
        return hourF + String(hour) + minF + String(min) + secF + String(sec)
    }
    
}
