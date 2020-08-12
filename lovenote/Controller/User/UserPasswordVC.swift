//
//  UserPasswordVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/10.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class UserPasswordVC: BaseVC {
    
    // const
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var margin = ScreenUtils.widthFit(30)
    lazy var marginTF = ScreenUtils.widthFit(15)
    lazy var padding = ScreenUtils.heightFit(15)
    lazy var maxWidth = screenWidth - margin * 2
    lazy var tfWidth = maxWidth - marginTF * 2
    
    // view
    private var tfPwd: UITextField!
    private var tfPwd2: UITextField!
    private var tfPwd3: UITextField!
    private var btnVerifySend: UIButton!
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(UserPasswordVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "modify_password")
        
        // img
        let ivAppName = ViewHelper.getImageView(img: UIImage(named: "ic_launcher_shadow"), width: screenWidth, height: ScreenUtils.heightFit(80), mode: .scaleAspectFit)
        ivAppName.frame.origin = CGPoint(x: 0, y: margin)
        
        // pwd-tf
        tfPwd = ViewHelper.getTextField(width: tfWidth, paddingV: padding, placeholder: StringUtils.getString("input_hint_old_pwd"), pwd: true)
        tfPwd.frame.origin = CGPoint(x: marginTF, y: 0)
        ViewUtils.addTextFiledLeftView(tfPwd, left: "ic_lock_grey_24dp")
        
        let vPwd = UIView(frame: CGRect(x: margin, y: ivAppName.frame.origin.y + ivAppName.frame.size.height + margin, width: maxWidth, height: tfPwd.frame.size.height))
        vPwd.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadiusCircle(vPwd)
        ViewUtils.setViewShadow(vPwd, offset: ViewHelper.SHADOW_SMALL, color: ThemeHelper.getColorPrimary())
        vPwd.addSubview(tfPwd)
        
        // pwd2-tf
        tfPwd2 = ViewHelper.getTextField(width: tfWidth, paddingV: padding, placeholder: StringUtils.getString("input_hint_new_pwd"), pwd: true)
        tfPwd2.frame.origin = CGPoint(x: marginTF, y: 0)
        ViewUtils.addTextFiledLeftView(tfPwd2, left: "ic_lock_grey_24dp")
        
        let vPwd2 = UIView(frame: CGRect(x: margin, y: vPwd.frame.origin.y + vPwd.frame.size.height + margin / 2, width: maxWidth, height: tfPwd2.frame.size.height))
        vPwd2.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadiusCircle(vPwd2)
        ViewUtils.setViewShadow(vPwd2, offset: ViewHelper.SHADOW_SMALL, color: ThemeHelper.getColorPrimary())
        vPwd2.addSubview(tfPwd2)
        
        // pwd2-tf
        tfPwd3 = ViewHelper.getTextField(width: tfWidth, paddingV: padding, placeholder: StringUtils.getString("input_hint_new_pwd_confirm"), pwd: true)
        tfPwd3.frame.origin = CGPoint(x: marginTF, y: 0)
        ViewUtils.addTextFiledLeftView(tfPwd3, left: "ic_lock_grey_24dp")
        
        let vPwd3 = UIView(frame: CGRect(x: margin, y: vPwd2.frame.origin.y + vPwd2.frame.size.height + margin / 2, width: maxWidth, height: tfPwd3.frame.size.height))
        vPwd3.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadiusCircle(vPwd3)
        ViewUtils.setViewShadow(vPwd3, offset: ViewHelper.SHADOW_SMALL, color: ThemeHelper.getColorPrimary())
        vPwd3.addSubview(tfPwd3)
        
        // ok-btn
        let btnOK = ViewHelper.getBtnBGPrimary(width: maxWidth / 2, paddingV: padding / 2, title: StringUtils.getString("modify"), circle: true)
        btnOK.center.x = self.view.center.x
        btnOK.frame.origin.y = vPwd3.frame.origin.y + vPwd3.frame.size.height + margin
        
        // view
        self.view.addSubview(ivAppName)
        self.view.addSubview(vPwd)
        self.view.addSubview(vPwd2)
        self.view.addSubview(vPwd3)
        self.view.addSubview(btnOK)
        
        // target
        btnOK.addTarget(self, action: #selector(targetOK), for: .touchUpInside)
    }
    
    @objc private func targetOK(sender: UIButton) {
        let pwd = tfPwd.text
        let pwd2 = tfPwd2.text
        let pwd3 = tfPwd3.text
        if StringUtils.isEmpty(pwd2) {
            ToastUtils.show(tfPwd2.placeholder)
            return
        } else if StringUtils.isEmpty(pwd3) {
            ToastUtils.show(tfPwd3.placeholder)
            return
        } else if pwd2 != pwd3 {
            ToastUtils.show(StringUtils.getString("twice_pwd_no_equals"))
            return
        }
        
        // api
        let md5OldPwd = EncryptUtils.md5String(pwd!).uppercased()
        let body = ApiHelper.getUserBody(phone: "", pwd: pwd2)
        let api = Api.request(.userModify(type: ApiHelper.MODIFY_PASSWORD, code: "", oldPwd: md5OldPwd, user: body.toJSON()),
                              loading: true, success: { code, msg, data in
                                UDHelper.setMe(data.user)
                                RootVC.get().popBack()
        })
        self.pushApi(api)
    }
    
}
