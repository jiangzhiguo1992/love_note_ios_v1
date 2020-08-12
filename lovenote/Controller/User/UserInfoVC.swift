//
//  UserInfoVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/7.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class UserInfoVC: BaseVC {
    
    // const
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var marginLeft = ScreenUtils.widthFit(30)
    lazy var marginRight = ScreenUtils.widthFit(30)
    lazy var maxWidth = screenWidth - marginLeft - marginRight
    lazy var sexWidth = (maxWidth - marginLeft / 2 - marginRight / 2) / 2
    
    // view
    private var btnGirl: UIButton!
    private var btnGirlOk: UIButton!
    private var btnBoy: UIButton!
    private var btnBoyOk: UIButton!
    private var birthPicker: UIDatePicker!
    
    // var
    private var me: User?
    private var userSex = 0
    
    public static func pushVC(user: User?) {
        AppDelegate.runOnMainAsync {
            let vc = UserInfoVC(nibName: nil, bundle: nil)
            vc.me = user
            RootVC.get().newRoot([vc])
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "user_info")
        self.navigationItem.leftBarButtonItem = nil
        
        // sex-btn
        let lSex = ViewHelper.getLabelPrimaryNormal(text: StringUtils.getString("please_select_sex"))
        lSex.center.x = self.view.center.x
        lSex.frame.origin.y = ScreenUtils.heightFit(20)
        
        btnGirl = ViewHelper.getBtnImgFit(type: .custom, width: sexWidth, height: sexWidth, bgImg: UIImage(named: "img_girl_rect"), shadow: true)
        ViewUtils.setViewRadius(btnGirl, radius: ViewHelper.RADIUS_BIG)
        btnGirl.frame.origin.x = marginLeft
        btnGirl.frame.origin.y = lSex.frame.origin.y + lSex.frame.size.height + ScreenUtils.heightFit(20)
        
        btnGirlOk = ViewHelper.getBtnImgFit(type: .custom, width: sexWidth, height: sexWidth, bgColor: ColorHelper.getBlack50(), bgImg: UIImage(named: "ic_done_white_48dp"))
        ViewUtils.setViewRadius(btnGirlOk, radius: ViewHelper.RADIUS_BIG)
        btnGirlOk.frame.origin = btnGirl.frame.origin
        
        btnBoy = ViewHelper.getBtnImgFit(type: .custom, width: sexWidth, height: sexWidth, bgImg: UIImage(named: "img_boy_rect"), shadow: true)
        ViewUtils.setViewRadius(btnBoy, radius: ViewHelper.RADIUS_BIG)
        btnBoy.frame.origin.x = marginLeft + btnGirl.frame.size.width + marginLeft
        btnBoy.frame.origin.y = btnGirl.frame.origin.y
        
        btnBoyOk = ViewHelper.getBtnImgFit(type: .custom, width: sexWidth, height: sexWidth, bgColor: ColorHelper.getBlack50(), bgImg: UIImage(named: "ic_done_white_48dp"))
        ViewUtils.setViewRadius(btnBoyOk, radius: ViewHelper.RADIUS_BIG)
        btnBoyOk.frame.origin = btnBoy.frame.origin
        
        // birthday-datePicker
        let lBirth = ViewHelper.getLabelPrimaryNormal(text: StringUtils.getString("please_select_birth"))
        lBirth.center.x = self.view.center.x
        lBirth.frame.origin.y = btnGirl.frame.origin.y + btnGirl.frame.size.height + ScreenUtils.heightFit(30)
        
        birthPicker = ViewUtils.getDatePicker(width: maxWidth, height: nil, mode: .date)
        birthPicker.frame.origin.x = marginLeft
        birthPicker.frame.origin.y = lBirth.frame.origin.y + lBirth.frame.size.height + ScreenUtils.heightFit(10)
        
        // ok-btn
        let btnOK = ViewHelper.getBtnBGPrimary(paddingH: ScreenUtils.widthFit(75), paddingV: ScreenUtils.heightFit(5), title: StringUtils.getString("set_ok"), circle: true)
        btnOK.center.x = self.view.center.x
        btnOK.frame.origin.y = birthPicker.frame.origin.y + birthPicker.frame.size.height + ScreenUtils.heightFit(20)
        
        // view
        self.view.addSubview(lSex)
        self.view.addSubview(btnGirl)
        self.view.addSubview(btnGirlOk)
        self.view.addSubview(btnBoy)
        self.view.addSubview(btnBoyOk)
        self.view.addSubview(lBirth)
        self.view.addSubview(birthPicker)
        self.view.addSubview(btnOK)
        
        // target
        btnGirl.addTarget(self, action: #selector(targetOnGirl), for: .touchUpInside)
        btnGirlOk.addTarget(self, action: #selector(targetOnGirlOk), for: .touchUpInside)
        btnBoy.addTarget(self, action: #selector(targetOnBoy), for: .touchUpInside)
        btnBoyOk.addTarget(self, action: #selector(targetOnBoyOk), for: .touchUpInside)
        btnOK.addTarget(self, action: #selector(targetOk), for: .touchUpInside)
    }
    
    override func onReview(_ animated: Bool) {
        // 清除数据，防止打开app卡在这个界面
        UDHelper.clearMe()
        // sex
        initSexView()
        // date
        var dc = DateUtils.getCurrentDC()
        dc.year = (dc.year ?? 2019) - 21
        birthPicker.date = DateUtils.getDate(dc)
    }
    
    private func initSexView() {
        if userSex == User.SEX_GIRL {
            self.view.sendSubviewToBack(btnGirl)
            self.view.sendSubviewToBack(btnBoyOk)
        } else if userSex == User.SEX_BOY {
            self.view.sendSubviewToBack(btnBoy)
            self.view.sendSubviewToBack(btnGirlOk)
        } else {
            self.view.sendSubviewToBack(btnBoyOk)
            self.view.sendSubviewToBack(btnGirlOk)
        }
    }
    
    @objc private func targetOnGirl(sender: UIButton) {
        self.userSex = User.SEX_GIRL
        initSexView()
    }
    
    @objc private func targetOnGirlOk(sender: UIButton) {
        self.userSex = 0
        initSexView()
    }
    
    @objc private func targetOnBoy(sender: UIButton) {
        self.userSex = User.SEX_BOY
        initSexView()
    }
    
    @objc private func targetOnBoyOk(sender: UIButton) {
        self.userSex = 0
        initSexView()
    }
    
    @objc private func targetOk(sender: UIButton) {
        if userSex != User.SEX_GIRL && userSex != User.SEX_BOY {
            ToastUtils.show(StringUtils.getString("please_select_sex"))
            return
        }
        
        var birthDC = DateUtils.getDC(birthPicker.date)
        if (birthDC.year ?? 1) == 0 && (birthDC.month ?? 1) == 0 && (birthDC.day ?? 1) == 0 {
            ToastUtils.show(StringUtils.getString("please_select_birth"))
            return
        }
        
        let sexShow = StringUtils.getString((userSex == User.SEX_GIRL) ? "girl" : "boy")
        let birthShow = DateUtils.getStr(birthDC, DateUtils.FORMAT_CHINA_Y_M_D)
        let msg = StringUtils.getString("sex_colon_sapce") + sexShow + "\n" + StringUtils.getString("birthday_colon_space") + birthShow
        
        _ = AlertHelper.showAlert(title: StringUtils.getString("once_push_never_modify"),
                                  msg: msg,
                                  confirms: [StringUtils.getString("confirm_no_wrong")],
                                  cancel: StringUtils.getString("i_think_again"),
                                  actionHandler: { (_, _, _) in
                                    birthDC.hour = 0
                                    birthDC.minute = 0
                                    birthDC.second = 0
                                    self.pushUserInfo(sex: self.userSex, birth: DateUtils.getInt64(birthDC))
        }, cancelHandler: nil)
    }
    
    func pushUserInfo(sex: Int, birth: Int64) {
        let user = User()
        user.sex = sex
        user.birthday = birth
        UDHelper.setMe(me) // api要用token
        // api
        let api = Api.request(.userModify(type: ApiHelper.MODIFY_INFO, code: "", oldPwd: "", user: user.toJSON()),
                              loading: true, success: { (code, msg, data) in
                                UDHelper.setMe(data.user)
                                ApiHelper.postEntry()
        }, failure: { (_, _, _) in
            UDHelper.clearMe()
        })
        self.pushApi(api)
    }
    
}
