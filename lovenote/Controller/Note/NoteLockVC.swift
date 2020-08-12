//
//  NoteLockVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/2/22.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteLockVC: BaseVC {
    
    // const
    lazy var margin = ScreenUtils.widthFit(50)
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var lockWidth = screenWidth / 2
    lazy var maxWidth = screenWidth - margin * 2
    lazy var inputPadding = ScreenUtils.heightFit(10)
    lazy var btnPadding = ScreenUtils.heightFit(5)
    
    // view
    private var ivLockClose: UIImageView!
    private var ivLockOpen: UIImageView!
    private var tfPwd: UITextField!
    private var tfVerify: UITextField!
    private var btnVerifySend: UIButton!
    private var vOperate: UIView!
    private var btnCancel: UIButton!
    private var btnOk: UIButton!
    private var btnToggleLock: UIButton!
    private var btnPwd: UIButton!
    
    // var
    private var lock: Lock?
    private var open: Bool = true
    private var codeTimer: DispatchSourceTimer?
    
    public static func pushVC() {
        if UserHelper.isCoupleBreak(couple: UDHelper.getCouple()) {
            // 无效配对
            CouplePairVC.pushVC()
            return
        }
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(NoteLockVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "pwd_lock")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_help_outline_white_24dp"), style: .plain, target: self, action: #selector(targetGoHelp))
        
        ivLockClose = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_lock_outline_grey_48dp"), color: ThemeHelper.getColorPrimary()), width: lockWidth, height: lockWidth, mode: .scaleAspectFit)
        ivLockClose.center.x = screenWidth / 2
        ivLockClose.frame.origin.y = ScreenUtils.heightFit(20)
        ivLockOpen = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_lock_open_grey_48dp"), color: ThemeHelper.getColorPrimary()), width: lockWidth, height: lockWidth, mode: .scaleAspectFit)
        ivLockOpen.center.x = screenWidth / 2
        ivLockOpen.frame.origin.y = ScreenUtils.heightFit(20)
        
        let lockBottomY = ivLockClose.frame.origin.y + ivLockClose.frame.size.height + ScreenUtils.heightFit(20)
        
        // pwd-tf
        tfPwd = ViewHelper.getTextField(width: maxWidth, paddingV: CGFloat(inputPadding), placeholder: StringUtils.getString("input_hint_pwd"), keyboardType: .numberPad, pwd: true)
        tfPwd.center.x = screenWidth / 2
        tfPwd.frame.origin.y = lockBottomY
        ViewUtils.addTextFiledLeftView(tfPwd, left: "ic_lock_grey_24dp")
        ViewHelper.addViewLineBottom(tfPwd, height: 1, color: ThemeHelper.getColorLight())
        
        // verify-btn
        btnVerifySend = ViewHelper.getBtnTextPrimary(type: .custom, paddingH: ScreenUtils.heightFit(10), title: StringUtils.getString("send_validate_code"), circle: true)
        ViewUtils.setViewBorder(btnVerifySend, color: ThemeHelper.getColorPrimary())
        
        // verify-tf
        tfVerify = ViewHelper.getTextField(width: maxWidth, paddingV: CGFloat(inputPadding), placeholder: StringUtils.getString("input_hint_verify"), keyboardType: .numberPad)
        tfVerify.center.x = self.view.center.x
        tfVerify.frame.origin.y = tfPwd.frame.origin.y + tfPwd.frame.size.height + ScreenUtils.heightFit(15)
        ViewUtils.addTextFiledLeftView(tfVerify, left: "ic_verified_user_grey_24dp")
        ViewUtils.addTextFiledRightView(tfVerify, right: btnVerifySend)
        ViewHelper.addViewLineBottom(tfVerify, height: 1, color: ThemeHelper.getColorLight())
        
        // operate
        btnCancel = ViewHelper.getBtnBGPrimary(width: (maxWidth - ScreenUtils.widthFit(10)) / 2, paddingV: btnPadding, HAlign: .center, VAlign: .center, title: StringUtils.getString("cancel"), titleSize: ViewHelper.FONT_SIZE_NORMAL, titleColor: ColorHelper.getFontWhite(), circle: true, shadow: true)
        btnCancel.frame.origin = CGPoint(x: 0, y: 0)
        
        btnOk = ViewHelper.getBtnBGPrimary(width: (maxWidth - ScreenUtils.widthFit(10)) / 2, paddingV: btnPadding, HAlign: .center, VAlign: .center, title: StringUtils.getString("complete"), titleSize: ViewHelper.FONT_SIZE_NORMAL, titleColor: ColorHelper.getFontWhite(), circle: true, shadow: true)
        btnOk.frame.origin = CGPoint(x: maxWidth - btnOk.frame.size.width, y: 0)
        
        let operateY = (tfVerify.isHidden ? (tfPwd.frame.origin.y + tfPwd.frame.size.height) : (tfVerify.frame.origin.y + tfVerify.frame.size.height)) + ScreenUtils.heightFit(20)
        vOperate = UIView(frame: CGRect(x: margin, y: operateY, width: maxWidth, height: btnCancel.frame.origin.y + btnCancel.frame.size.height))
        vOperate.addSubview(btnCancel)
        vOperate.addSubview(btnOk)
        
        // lock
        btnToggleLock = ViewHelper.getBtnBGPrimary(width: maxWidth, paddingV: btnPadding, HAlign: .center, VAlign: .center, title: StringUtils.getString("-"), titleSize: ViewHelper.FONT_SIZE_BIG, titleColor: ColorHelper.getFontWhite(), circle: true, shadow: true)
        btnToggleLock.center.x = screenWidth / 2
        btnToggleLock.frame.origin.y = lockBottomY
        
        // pwd
        let pwdY = (btnToggleLock.isHidden ? lockBottomY : (btnToggleLock.frame.origin.y + btnToggleLock.frame.size.height)) + ScreenUtils.heightFit(20)
        btnPwd = ViewHelper.getBtnBGPrimary(width: maxWidth, paddingV: btnPadding, HAlign: .center, VAlign: .center, title: StringUtils.getString("-"), titleSize: ViewHelper.FONT_SIZE_BIG, titleColor: ColorHelper.getFontWhite(), circle: true, shadow: true)
        btnPwd.center.x = screenWidth / 2
        btnPwd.frame.origin.y = pwdY
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = vOperate.frame.origin.y + vOperate.frame.size.height + margin
        let scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        scroll.addSubview(ivLockClose)
        scroll.addSubview(ivLockOpen)
        scroll.addSubview(tfPwd)
        scroll.addSubview(tfVerify)
        scroll.addSubview(vOperate)
        scroll.addSubview(btnToggleLock)
        scroll.addSubview(btnPwd)
        
        // view
        self.view.addSubview(scroll)
        
        // target
        btnToggleLock.addTarget(self, action: #selector(targetToggleLock), for: .touchUpInside)
        btnPwd.addTarget(self, action: #selector(targetPwd), for: .touchUpInside)
        btnCancel.addTarget(self, action: #selector(targetCancel), for: .touchUpInside)
        btnOk.addTarget(self, action: #selector(push), for: .touchUpInside)
        btnVerifySend.addTarget(self, action: #selector(sendCode), for: .touchUpInside)
        
        // hide
        ivLockClose.isHidden = true
        ivLockOpen.isHidden = true
        tfPwd.isHidden = true
        tfVerify.isHidden = true
        vOperate.isHidden = true
        btnToggleLock.isHidden = true
        btnPwd.isHidden = true
    }
    
    override func initData() {
        open = true // 默认是要开锁
        refreshData()
    }
    
    override func onDestroy() {
        stopCodeCountDown()
    }
    
    @objc private func targetGoHelp() {
        HelpVC.pushVC(HelpVC.INDEX_NOTE_LOCK)
    }
    
    @objc func targetToggleLock() {
        open = true
        toggleLock() // 开锁/关锁
    }
    
    @objc func targetPwd() {
        open = false
        showOperaView() // 设置/修改密码
    }
    
    @objc func targetCancel() {
        refreshView()
    }
    
    func refreshData() {
        // api
        let api = Api.request(.noteLockGet, success: { code, msg, data in
            self.lock = data.lock
            self.refreshView()
            // notify
            NotifyHelper.post(NotifyHelper.TAG_LOCK_REFRESH, obj: self.lock)
        })
        self.pushApi(api)
    }
    
    func refreshView() {
        stopCodeCountDown() // 清空倒计时
        tfPwd.isHidden = true
        tfVerify.isHidden = true
        vOperate.isHidden = true
        btnPwd.isHidden = false
        if lock == nil {
            ivLockOpen.isHidden = false
            ivLockClose.isHidden = true
            btnToggleLock.isHidden = true
            btnPwd.setTitle(StringUtils.getString("set_password"), for: .normal)
        } else {
            btnToggleLock.isHidden = false
            btnPwd.setTitle(StringUtils.getString("modify_password"), for: .normal)
            if lock!.isLock {
                // 状态：关
                ivLockClose.isHidden = false
                ivLockOpen.isHidden = true
                btnToggleLock.setTitle(StringUtils.getString("open_lock"), for: .normal)
            } else {
                // 状态：开
                ivLockOpen.isHidden = false
                ivLockClose.isHidden = true
                btnToggleLock.setTitle(StringUtils.getString("close_lock"), for: .normal)
            }
        }
        // size
        let lockBottomY = ivLockClose.frame.origin.y + ivLockClose.frame.size.height + ScreenUtils.heightFit(20)
        btnPwd.frame.origin.y = (btnToggleLock.isHidden ? lockBottomY : (btnToggleLock.frame.origin.y + btnToggleLock.frame.size.height)) + ScreenUtils.heightFit(20)
    }
    
    func toggleLock() {
        if lock == nil { return }
        if lock!.isLock {
            // 需要开锁视图
            showOperaView()
        } else {
            // 直接关锁
            toggleLockData(pwd: "")
        }
    }
    
    func showOperaView() {
        tfPwd.isHidden = false
        if lock == nil || open {
            // 设置密码/开锁
            tfVerify.isHidden = true
        } else {
            // 修改密码
            tfVerify.isHidden = false
        }
        vOperate.isHidden = false
        btnToggleLock.isHidden = true
        btnPwd.isHidden = true
        // tfPwd
        let placeholder = StringUtils.getString("please_input_pwd_no_over_holder_text", arguments: [UDHelper.getLimit().noteLockLength])
        ViewUtils.setTextFiledPlaceholder(textField: tfPwd, placeholder: placeholder)
        tfPwd.text = ""
        // size
        vOperate.frame.origin.y = (tfVerify.isHidden ? (tfPwd.frame.origin.y + tfPwd.frame.size.height) : (tfVerify.frame.origin.y + tfVerify.frame.size.height)) + ScreenUtils.heightFit(20)
    }
    
    func toggleLockData(pwd: String?) {
        if lock == nil { return }
        let body = ApiHelper.getLockBody(pwd: pwd)
        // api
        let api = Api.request(.noteLockToggle(lock: body.toJSON()),
                              loading: true,
                              success: { code, msg, data in
                                self.lock = data.lock
                                self.refreshView()
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_LOCK_REFRESH, obj: self.lock)
                                // pop
                                if (self.lock != nil && !self.lock!.isLock) {
                                    RootVC.get().popBack()
                                }
        })
        self.pushApi(api)
    }
    
    @objc func push() {
        let pwd = tfPwd.text
        if lock == nil {
            // 设置密码
            addPwd(pwd: pwd)
        } else if !open {
            // 修改密码
            modifyPwd(pwd: pwd)
        } else {
            // 开锁
            toggleLockData(pwd: pwd)
        }
    }
    
    func addPwd(pwd: String?) {
        let body = ApiHelper.getLockBody(pwd: pwd)
        // api
        let api = Api.request(.noteLockAdd(lock: body.toJSON()),
                              loading: true,
                              success: { code, msg, data in
                                self.lock = data.lock
                                self.refreshView()
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_LOCK_REFRESH, obj: self.lock)
        })
        self.pushApi(api)
    }
    
    func modifyPwd(pwd: String?) {
        let code = tfVerify.text
        let body = ApiHelper.getLockBody(pwd: pwd)
        // api
        let api = Api.request(.noteLockUpdatePwd(code: code, lock: body.toJSON()),
                              loading: true,
                              success: { code, msg, data in
                                self.lock = data.lock
                                self.refreshView()
                                // notify
                                NotifyHelper.post(NotifyHelper.TAG_LOCK_REFRESH, obj: self.lock)
        })
        self.pushApi(api)
    }
    
    @objc func sendCode() {
        // 发送验证码
        let taPhone = UDHelper.getTa()?.phone
        if StringUtils.isEmpty(taPhone) {
            ToastUtils.show(StringUtils.getString("un_know_ta_phone"))
            return
        }
        let body = ApiHelper.getSmsLockBody(phone: taPhone)
        // api
        let api = Api.request(.smsSend(sms: body.toJSON()),
                              loading: true, success: { (code, msg, data) in
                                // 开始倒计时
                                self.startCodeCountDown()
        })
        self.pushApi(api)
    }
    
    private func startCodeCountDown() {
        var countDownSec = UDHelper.getLimit().smsBetweenSec
        // 创建global的timer
        codeTimer = DispatchSource.makeTimerSource(queue: AppDelegate.getQueueGlobal())
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer?.schedule(deadline: .now(), repeating: .seconds(1))
        // 设定时间源的触发事件
        codeTimer?.setEventHandler(handler: {
            // 返回主线程处理一些事件，更新UI等等
            AppDelegate.runOnMainAsync {
                if countDownSec <= 0 {
                    self.stopCodeCountDown()
                } else {
                    self.btnVerifySend.isEnabled = false
                    countDownSec = countDownSec - 1
                    self.btnVerifySend.setTitle(String(countDownSec) + "s", for: .normal)
                }
            }
        })
        codeTimer?.resume()
    }
    
    private func stopCodeCountDown() {
        if btnVerifySend.isEnabled {
            return
        }
        btnVerifySend.isEnabled = true
        btnVerifySend.setTitle(StringUtils.getString("send_validate_code"), for: .normal)
        codeTimer?.cancel()
    }
    
}

