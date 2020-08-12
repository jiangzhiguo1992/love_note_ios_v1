//
//  SplashVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2018/11/29.
//  Copyright © 2018年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class SplashVC: BaseVC {
    
    // const
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var screenHeight = ScreenUtils.getScreenHeight()
    lazy var marginLeft = ScreenUtils.widthFit(10)
    lazy var marginRight = ScreenUtils.widthFit(10)
    lazy var maxWidth = screenWidth - marginLeft - marginRight
    lazy var btnWidth = maxWidth / 2 - ScreenUtils.widthFit(40)
    lazy var paddingV = ScreenUtils.heightFit(30)
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().newRoot([SplashVC(nibName: nil, bundle: nil)])
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "")
        
        let imgWidth = self.view.frame.size.height / 2 - ScreenUtils.heightFit(40)
        
        // 第一页
        let pageSub1: UIViewController = UIViewController()
        pageSub1.view.backgroundColor = ColorHelper.getRedDark()
        
        let lSubTitle1 = ViewHelper.getLabelBold(width: maxWidth, text: StringUtils.getString("splash_sub_title_1"), size: ViewHelper.FONT_SIZE_HUGE, color: ColorHelper.getFontWhite(), lines: 0, align: .center)
        lSubTitle1.center = pageSub1.view.center
        
        let ivBG1 = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "bg_splash_1"), color: ColorHelper.getWhite()), width: imgWidth, height: imgWidth, mode: .scaleAspectFit)
        ivBG1.center.x = pageSub1.view.center.x
        ivBG1.frame.origin.y = lSubTitle1.frame.origin.y - ivBG1.frame.size.height - paddingV
        
        let lContent1 = ViewHelper.getLabelWhiteNormal(width: maxWidth, text: StringUtils.getString("splash_content_1"), align: .center)
        lContent1.center.x = pageSub1.view.center.x
        lContent1.frame.origin.y = lSubTitle1.frame.origin.y + lSubTitle1.frame.size.height + paddingV
        
        pageSub1.view.addSubview(lSubTitle1)
        pageSub1.view.addSubview(ivBG1)
        pageSub1.view.addSubview(lContent1)
        
        // 第二页
        let pageSub2: UIViewController = UIViewController()
        pageSub2.view.backgroundColor = ColorHelper.getTealDark()
        
        let lSubTitle2 = ViewHelper.getLabelBold(width: maxWidth, text: StringUtils.getString("splash_sub_title_2"), size: ViewHelper.FONT_SIZE_HUGE, color: ColorHelper.getFontWhite(), lines: 0, align: .center)
        lSubTitle2.center = pageSub2.view.center
        
        let ivBG2 = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "bg_splash_2"), color: ColorHelper.getWhite()), width: imgWidth, height: imgWidth, mode: .scaleAspectFit)
        ivBG2.center.x = pageSub2.view.center.x
        ivBG2.frame.origin.y = lSubTitle2.frame.origin.y - ivBG2.frame.size.height - paddingV
        
        let lContent2 = ViewHelper.getLabelWhiteNormal(width: maxWidth, text: StringUtils.getString("splash_content_2"), align: .center)
        lContent2.center.x = pageSub2.view.center.x
        lContent2.frame.origin.y = lSubTitle2.frame.origin.y + lSubTitle2.frame.size.height + paddingV
        
        pageSub2.view.addSubview(lSubTitle2)
        pageSub2.view.addSubview(ivBG2)
        pageSub2.view.addSubview(lContent2)
        
        // 第三页
        let pageSub3: UIViewController = UIViewController()
        pageSub3.view.backgroundColor = ColorHelper.getOrangeDark()
        
        let lSubTitle3 = ViewHelper.getLabelBold(width: maxWidth, text: StringUtils.getString("splash_sub_title_3"), size: ViewHelper.FONT_SIZE_HUGE, color: ColorHelper.getFontWhite(), lines: 0, align: .center)
        lSubTitle3.center = pageSub3.view.center
        
        let ivBG3 = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "bg_splash_3"), color: ColorHelper.getWhite()), width: imgWidth, height: imgWidth, mode: .scaleAspectFit)
        ivBG3.center.x = pageSub3.view.center.x
        ivBG3.frame.origin.y = lSubTitle3.frame.origin.y - ivBG3.frame.size.height - paddingV
        
        let lContent3 = ViewHelper.getLabelWhiteNormal(width: maxWidth, text: StringUtils.getString("splash_content_3"), align: .center)
        lContent3.center.x = pageSub3.view.center.x
        lContent3.frame.origin.y = lSubTitle3.frame.origin.y + lSubTitle3.frame.size.height + paddingV
        
        pageSub3.view.addSubview(lSubTitle3)
        pageSub3.view.addSubview(ivBG3)
        pageSub3.view.addSubview(lContent3)
        
        // 第四页
        let pageSub4: UIViewController = UIViewController()
        pageSub4.view.backgroundColor = ColorHelper.getBlueDark()
        
        let lSubTitle4 = ViewHelper.getLabelBold(width: maxWidth, text: StringUtils.getString("splash_sub_title_4"), size: ViewHelper.FONT_SIZE_HUGE, color: ColorHelper.getFontWhite(), lines: 0, align: .center)
        lSubTitle4.center = pageSub4.view.center
        
        let ivBG4 = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "bg_splash_4"), color: ColorHelper.getWhite()), width: imgWidth, height: imgWidth, mode: .scaleAspectFit)
        ivBG4.center.x = pageSub4.view.center.x
        ivBG4.frame.origin.y = lSubTitle4.frame.origin.y - ivBG4.frame.size.height - paddingV
        
        let lContent4 = ViewHelper.getLabelWhiteNormal(width: maxWidth, text: StringUtils.getString("splash_content_4"), align: .center)
        lContent4.center.x = pageSub4.view.center.x
        lContent4.frame.origin.y = lSubTitle4.frame.origin.y + lSubTitle4.frame.size.height + paddingV
        
        pageSub4.view.addSubview(lSubTitle4)
        pageSub4.view.addSubview(ivBG4)
        pageSub4.view.addSubview(lContent4)
        
        // page
        let pageVC = BasePageVC.getSplashVC(dateSource: [pageSub1, pageSub2, pageSub3, pageSub4])
        pageVC.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        // btn-login
        let btnLogin = ViewHelper.getBtnBGWhite(width: btnWidth, paddingV: ScreenUtils.heightFit(5), title: StringUtils.getString("login"), titleColor: ColorHelper.getFontGrey(), circle: true)
        btnLogin.frame.origin = CGPoint(x: marginLeft + ScreenUtils.widthFit(20), y: screenHeight - btnLogin.frame.size.height - ScreenUtils.getBottomSafeHeight(xYes: ScreenUtils.heightFit(20), xNo: ScreenUtils.heightFit(50)))
        
        // btn-login
        let btnRegister = ViewHelper.getBtnBGWhite(width: btnWidth, paddingV: ScreenUtils.heightFit(5), title: StringUtils.getString("register"), titleColor: ColorHelper.getFontGrey(), circle: true)
        
        btnRegister.frame.origin = CGPoint(x: screenWidth - btnRegister.frame.size.width - marginRight - ScreenUtils.widthFit(20), y: screenHeight - btnRegister.frame.size.height - ScreenUtils.getBottomSafeHeight(xYes: ScreenUtils.heightFit(20), xNo: ScreenUtils.heightFit(50)))
        
        // view
        self.addChild(pageVC)
        self.view.addSubview(pageVC.view)
        self.view.addSubview(btnLogin)
        self.view.addSubview(btnRegister)
        
        // target
        btnLogin.addTarget(self, action: #selector(targetGoLogin), for: .touchUpInside)
        btnRegister.addTarget(self, action: #selector(targetGoRegister), for: .touchUpInside)
    }
    
    @objc private func targetGoLogin(sender: UIButton) {
        UserLoginVC.pushVC()
    }
    
    @objc private func targetGoRegister(sender: UIButton) {
        UserRegisterVC.pushVC()
    }
    
}
