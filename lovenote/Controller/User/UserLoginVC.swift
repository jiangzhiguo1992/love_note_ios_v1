//
//  UserLoginVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2018/12/9.
//  Copyright © 2018年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class UserLoginVC: BaseVC {
    
    // const
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var margin = ScreenUtils.widthFit(30)
    lazy var marginTF = ScreenUtils.widthFit(15)
    lazy var padding = ScreenUtils.heightFit(15)
    lazy var maxWidth = screenWidth - margin * 2
    lazy var tfWidth = maxWidth - marginTF * 2
    
    // view
    private var scLoginType: UISegmentedControl!
    private var tfPhone: UITextField!
    private var vPwd: UIView!
    private var vVerify: UIView!
    private var tfPwd: UITextField!
    private var tfVerify: UITextField!
    private var btnVerifySend: UIButton!
    
    // var
    lazy var logType = ApiHelper.LOG_PWD
    private var codeTimer: DispatchSourceTimer?
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(UserLoginVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "login")
        let bar = UIBarButtonItem(title: StringUtils.getString("user_protocol"), style: .plain, target: self, action: #selector(targetGoProtocol))
        bar.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        self.navigationItem.rightBarButtonItem = bar
        
        // img
        let ivAppName = ViewHelper.getImageView(img: UIImage(named: "ic_launcher_shadow"), width: screenWidth, height: ScreenUtils.heightFit(80), mode: .scaleAspectFit)
        ivAppName.frame.origin = CGPoint(x: 0, y: margin)
        
        // login-type
        scLoginType = ViewHelper.getSegmentedControl(items: [StringUtils.getString("pwd_login"), StringUtils.getString("verify_login")])
        scLoginType.frame.size.width += ScreenUtils.widthFit(10)
        scLoginType.frame.size.height += ScreenUtils.heightFit(3)
        scLoginType.center.x = self.view.center.x
        scLoginType.frame.origin.y = ivAppName.frame.origin.y + ivAppName.frame.size.height + ScreenUtils.heightFit(30)
        
        // username-tf
        tfPhone = ViewHelper.getTextField(width: tfWidth, paddingV: padding, placeholder: StringUtils.getString("input_hint_phone"), keyboardType: .numberPad)
        tfPhone.frame.origin = CGPoint(x: marginTF, y: 0)
        ViewUtils.addTextFiledLeftView(tfPhone, left: "ic_phone_iphone_grey_24dp")
        
        let vPhone = UIView(frame: CGRect(x: margin, y: scLoginType.frame.origin.y + scLoginType.frame.size.height + margin, width: maxWidth, height: tfPhone.frame.size.height))
        vPhone.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadiusCircle(vPhone)
        ViewUtils.setViewShadow(vPhone, offset: ViewHelper.SHADOW_SMALL, color: ThemeHelper.getColorPrimary())
        vPhone.addSubview(tfPhone)
        
        // pwd-tf
        tfPwd = ViewHelper.getTextField(width: tfWidth, paddingV: padding, placeholder: StringUtils.getString("input_hint_pwd"), pwd: true)
        tfPwd.frame.origin = CGPoint(x: marginTF, y: 0)
        ViewUtils.addTextFiledLeftView(tfPwd, left: "ic_lock_grey_24dp")
        
        vPwd = UIView(frame: CGRect(x: margin, y: vPhone.frame.origin.y + vPhone.frame.size.height + margin / 2, width: maxWidth, height: tfPwd.frame.size.height))
        vPwd.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadiusCircle(vPwd)
        ViewUtils.setViewShadow(vPwd, offset: ViewHelper.SHADOW_SMALL, color: ThemeHelper.getColorPrimary())
        vPwd.addSubview(tfPwd)
        
        // verify
        tfVerify = ViewHelper.getTextField(width: tfWidth, paddingV: padding, placeholder: StringUtils.getString("input_hint_verify"), keyboardType: .numberPad)
        tfVerify.frame.origin = CGPoint(x: marginTF, y: 0)
        ViewUtils.addTextFiledLeftView(tfVerify, left: "ic_verified_user_grey_24dp")
        
        btnVerifySend = ViewHelper.getBtnTextPrimary(type: .custom, height: tfVerify.frame.size.height, paddingH: padding, title: StringUtils.getString("send_validate_code"), circle: true)
        ViewUtils.addTextFiledRightView(tfVerify, right: btnVerifySend)
        
        vVerify = UIView(frame: CGRect(x: margin, y: vPhone.frame.origin.y + vPhone.frame.size.height + margin / 2, width: maxWidth, height: tfVerify.frame.size.height))
        vVerify.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadiusCircle(vVerify)
        ViewUtils.setViewShadow(vVerify, offset: ViewHelper.SHADOW_SMALL, color: ThemeHelper.getColorPrimary())
        vVerify.addSubview(tfVerify)
        
        // btnForget
        let lForget = ViewHelper.getLabelPrimarySmall(text: StringUtils.getString("forget_pwd"))
        lForget.frame.origin.x = screenWidth - margin - lForget.frame.size.width
        lForget.frame.origin.y = vPwd.frame.origin.y + vPwd.frame.size.height + padding
        ViewHelper.addViewLineBottom(lForget, height: 1, color: ThemeHelper.getColorPrimary())
        
        // login-btn
        let btnLogin = ViewHelper.getBtnBGPrimary(width: maxWidth, paddingV: padding / 2, title: StringUtils.getString("login"), circle: true)
        btnLogin.center.x = self.view.center.x
        btnLogin.frame.origin.y = lForget.frame.origin.y + lForget.frame.size.height + margin
        
        // register-btn
        let btnRegister = ViewHelper.getBtnTextPrimary(width: maxWidth, paddingV: padding / 2, title: StringUtils.getString("register"))
        btnRegister.center.x = self.view.center.x
        btnRegister.frame.origin.y = btnLogin.frame.origin.y + btnLogin.frame.size.height
        
        // user-protocol
        let lProtocol = ViewHelper.getLabelBlackSmall(text: StringUtils.getString("login_register_agree_protocol"))
        lProtocol.center.x = self.view.center.x
        lProtocol.frame.origin.y = self.view.frame.size.height - lProtocol.frame.size.height - RootVC.get().getTopBarHeight() - ScreenUtils.heightFit(20)
        
        // view
        self.view.addSubview(ivAppName)
        self.view.addSubview(scLoginType)
        self.view.addSubview(vPhone)
        self.view.addSubview(vPwd)
        self.view.addSubview(vVerify)
        self.view.addSubview(lForget)
        self.view.addSubview(btnLogin)
        self.view.addSubview(btnRegister)
        self.view.addSubview(lProtocol)
        
        // target
        scLoginType.addTarget(self, action: #selector(targetOnToggleLoginType), for: .valueChanged)
        btnVerifySend.addTarget(self, action: #selector(targetSendCode), for: .touchUpInside)
        btnLogin.addTarget(self, action: #selector(targetLogin), for: .touchUpInside)
        btnRegister.addTarget(self, action: #selector(targetGoRegister), for: .touchUpInside)
        ViewUtils.addViewTapTarget(target: self, view: lForget, action: #selector(targetGoForget))
    }
    
    override func onReview(_ animated: Bool) {
        // loginType
        targetOnToggleLoginType(sender: scLoginType)
    }
    
    override func onDestroy() {
        stopCodeCountDown()
    }
    
    @objc private func targetOnToggleLoginType(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            logType = ApiHelper.LOG_PWD
            vPwd.isHidden = false
            vVerify.isHidden = true
        } else {
            logType = ApiHelper.LOG_VER
            vPwd.isHidden = true
            vVerify.isHidden = false
        }
    }
    
    @objc private func targetGoProtocol() {
        UserProtocolVC.pushVC()
    }
    
    @objc private func targetGoForget() {
        UserForgetVC.pushVC()
    }
    
    @objc private func targetSendCode(sender: UIButton) {
        if StringUtils.isEmpty(tfPhone.text) {
            ToastUtils.show(tfPhone.placeholder)
            return
        }
        // 发送验证码
        let phone = tfPhone.text!.trimmingCharacters(in: .whitespaces)
        let body = ApiHelper.getSmsLoginBody(phone: phone)
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
    
    @objc private func targetLogin(sender: UIButton) {
        let phone = tfPhone.text
        let pwd = tfPwd.text
        let code = tfVerify.text
        if StringUtils.isEmpty(phone) {
            ToastUtils.show(tfPhone.placeholder)
            return
        }
        if logType == ApiHelper.LOG_PWD {
            if StringUtils.isEmpty(pwd) {
                ToastUtils.show(tfPwd.placeholder)
                return
            }
        } else if logType == ApiHelper.LOG_VER {
            if StringUtils.isEmpty(code) {
                ToastUtils.show(tfVerify.placeholder)
                return
            }
        } else {
            return
        }
        
        // api
        let body = ApiHelper.getUserBody(phone: phone, pwd: pwd)
        let api = Api.request(.userLogin(type: logType, code: code, user: body.toJSON()),
                              loading: true, success: { code, msg, data in
                                // 停止倒计时
                                self.stopCodeCountDown()
                                UDHelper.setMe(data.user)
                                ApiHelper.postEntry()
        })
        self.pushApi(api)
    }
    
    @objc private func targetGoRegister(sender: UIButton) {
        UserRegisterVC.pushVC()
    }
    
}
