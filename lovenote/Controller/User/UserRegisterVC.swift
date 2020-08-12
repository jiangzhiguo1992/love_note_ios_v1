//
//  UserRegisterVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2018/12/20.
//  Copyright © 2018年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class UserRegisterVC: BaseVC {
    
    // const
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var margin = ScreenUtils.widthFit(30)
    lazy var marginTF = ScreenUtils.widthFit(15)
    lazy var padding = ScreenUtils.heightFit(15)
    lazy var maxWidth = screenWidth - margin * 2
    lazy var tfWidth = maxWidth - marginTF * 2
    
    // view
    private var tfPhone: UITextField!
    private var tfPwd: UITextField!
    private var tfPwd2: UITextField!
    private var tfVerify: UITextField!
    private var btnVerifySend: UIButton!
    
    // var
    private var codeTimer: DispatchSourceTimer?
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(UserRegisterVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "register")
        let bar = UIBarButtonItem(title: StringUtils.getString("user_protocol"), style: .plain, target: self, action: #selector(targetGoProtocol))
        bar.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        self.navigationItem.rightBarButtonItem = bar
        
        // img
        let ivAppName = ViewHelper.getImageView(img: UIImage(named: "ic_launcher_shadow"), width: screenWidth, height: ScreenUtils.heightFit(80), mode: .scaleAspectFit)
        ivAppName.frame.origin = CGPoint(x: 0, y: margin)
        
        // username-tf
        tfPhone = ViewHelper.getTextField(width: tfWidth, paddingV: padding, placeholder: StringUtils.getString("input_hint_phone"), keyboardType: .numberPad)
        tfPhone.frame.origin = CGPoint(x: marginTF, y: 0)
        ViewUtils.addTextFiledLeftView(tfPhone, left: "ic_phone_iphone_grey_24dp")
        
        let vPhone = UIView(frame: CGRect(x: margin, y: ivAppName.frame.origin.y + ivAppName.frame.size.height + margin, width: maxWidth, height: tfPhone.frame.size.height))
        vPhone.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadiusCircle(vPhone)
        ViewUtils.setViewShadow(vPhone, offset: ViewHelper.SHADOW_SMALL, color: ThemeHelper.getColorPrimary())
        vPhone.addSubview(tfPhone)
        
        // pwd-tf
        tfPwd = ViewHelper.getTextField(width: tfWidth, paddingV: padding, placeholder: StringUtils.getString("input_hint_pwd"), pwd: true)
        tfPwd.frame.origin = CGPoint(x: marginTF, y: 0)
        ViewUtils.addTextFiledLeftView(tfPwd, left: "ic_lock_grey_24dp")
        
        let vPwd = UIView(frame: CGRect(x: margin, y: vPhone.frame.origin.y + vPhone.frame.size.height + margin / 2, width: maxWidth, height: tfPwd.frame.size.height))
        vPwd.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadiusCircle(vPwd)
        ViewUtils.setViewShadow(vPwd, offset: ViewHelper.SHADOW_SMALL, color: ThemeHelper.getColorPrimary())
        vPwd.addSubview(tfPwd)
        
        // pwd2-tf
        tfPwd2 = ViewHelper.getTextField(width: tfWidth, paddingV: padding, placeholder: StringUtils.getString("input_hint_pwd_confirm"), pwd: true)
        tfPwd2.frame.origin = CGPoint(x: marginTF, y: 0)
        ViewUtils.addTextFiledLeftView(tfPwd2, left: "ic_lock_grey_24dp")
        
        let vPwd2 = UIView(frame: CGRect(x: margin, y: vPwd.frame.origin.y + vPwd.frame.size.height + margin / 2, width: maxWidth, height: tfPwd2.frame.size.height))
        vPwd2.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadiusCircle(vPwd2)
        ViewUtils.setViewShadow(vPwd2, offset: ViewHelper.SHADOW_SMALL, color: ThemeHelper.getColorPrimary())
        vPwd2.addSubview(tfPwd2)
        
        // verify
        tfVerify = ViewHelper.getTextField(width: tfWidth, paddingV: padding, placeholder: StringUtils.getString("input_hint_verify"), keyboardType: .numberPad)
        tfVerify.frame.origin = CGPoint(x: marginTF, y: 0)
        ViewUtils.addTextFiledLeftView(tfVerify, left: "ic_verified_user_grey_24dp")
        
        btnVerifySend = ViewHelper.getBtnTextPrimary(type: .custom, height: tfVerify.frame.size.height, paddingH: padding, title: StringUtils.getString("send_validate_code"), circle: true)
        ViewUtils.addTextFiledRightView(tfVerify, right: btnVerifySend)
        
        let vVerify = UIView(frame: CGRect(x: margin, y: vPwd2.frame.origin.y + vPwd2.frame.size.height + margin / 2, width: maxWidth, height: tfVerify.frame.size.height))
        vVerify.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadiusCircle(vVerify)
        ViewUtils.setViewShadow(vVerify, offset: ViewHelper.SHADOW_SMALL, color: ThemeHelper.getColorPrimary())
        vVerify.addSubview(tfVerify)
        
        // register-btn
        let btnRegister = ViewHelper.getBtnBGPrimary(width: maxWidth / 2, paddingV: padding / 2, title: StringUtils.getString("register"), circle: true)
        btnRegister.center.x = self.view.center.x
        btnRegister.frame.origin.y = vVerify.frame.origin.y + vVerify.frame.size.height + margin
        
        // view
        self.view.addSubview(ivAppName)
        self.view.addSubview(vPhone)
        self.view.addSubview(vPwd)
        self.view.addSubview(vPwd2)
        self.view.addSubview(vVerify)
        self.view.addSubview(btnRegister)
        
        // target
        btnVerifySend.addTarget(self, action: #selector(targetSendCode), for: .touchUpInside)
        btnRegister.addTarget(self, action: #selector(targetRegister), for: .touchUpInside)
    }
    
    override func onDestroy() {
        stopCodeCountDown()
    }
    
    @objc private func targetGoProtocol() {
        UserProtocolVC.pushVC()
    }
    
    @objc private func targetSendCode(sender: UIButton) {
        if StringUtils.isEmpty(tfPhone.text) {
            ToastUtils.show(tfPhone.placeholder)
            return
        }
        // 发送验证码
        let phone = tfPhone.text!.trimmingCharacters(in: .whitespaces)
        let body = ApiHelper.getSmsRegisterBody(phone: phone)
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
    
    @objc private func targetRegister(sender: UIButton) {
        let phone = tfPhone.text
        let pwd = tfPwd.text
        let pwd2 = tfPwd2.text
        let code = tfVerify.text
        if StringUtils.isEmpty(phone) {
            ToastUtils.show(tfPhone.placeholder)
            return
        } else if StringUtils.isEmpty(pwd) {
            ToastUtils.show(tfPwd.placeholder)
            return
        } else if StringUtils.isEmpty(pwd2) {
            ToastUtils.show(tfPwd2.placeholder)
            return
        } else if pwd != pwd2 {
            ToastUtils.show(StringUtils.getString("twice_pwd_no_equals"))
            return
        } else if StringUtils.isEmpty(code) {
            ToastUtils.show(tfVerify.placeholder)
            return
        }
        
        // api
        let body = ApiHelper.getUserBody(phone: phone, pwd: pwd)
        let api = Api.request(.userRegister(code: code, user: body.toJSON()),
                              loading: true, success: { code, msg, data in
                                // 停止倒计时
                                self.stopCodeCountDown()
                                let user = data.user
                                if code == ApiResult.CODE_NO_USER_INFO {
                                    // 一般是会进到这个页面，不排除以后后台会控制
                                    UserInfoVC.pushVC(user: user)
                                } else {
                                    UDHelper.setMe(user)
                                    ApiHelper.postEntry()
                                }
        })
        self.pushApi(api)
    }
    
}
