//
//  AboutVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/10.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class AboutVC: BaseVC {
    
    // const
    let screenWidth = ScreenUtils.getScreenWidth()
    let padding = ScreenUtils.widthFit(16)
    
    // view
    private var lVersionDesc: UILabel!
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(AboutVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "about_app")
        let bar = UIBarButtonItem(title: StringUtils.getString("user_protocol"), style: .plain, target: self, action: #selector(targetGoProtocol))
        bar.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        self.navigationItem.rightBarButtonItem = bar
        
        // top
        let ivAppName = ViewHelper.getImageView(img: UIImage(named: "ic_launcher_shadow"), width: screenWidth, height: ScreenUtils.heightFit(60), mode: .scaleAspectFit)
        ivAppName.frame.origin = CGPoint(x: 0, y: ScreenUtils.heightFit(30))
        
        let lTitle = ViewHelper.getLabelGreyNormal(text: AppUtils.getAppDisplayName() + " " + AppUtils.getAppVersion())
        lTitle.center.x = self.view.center.x
        lTitle.frame.origin.y = ivAppName.frame.origin.y + ivAppName.frame.size.height + ScreenUtils.heightFit(10)
        
        // Market
        let lMarketName = ViewHelper.getLabelBlackNormal(text: StringUtils.getString("give_good_comment"))
        lMarketName.frame.origin = CGPoint(x: padding, y: padding)
        let lMarketDesc = ViewHelper.getLabelGreyNormal(text: StringUtils.getString("good_comment_in_my_heart"))
        lMarketDesc.frame.origin = CGPoint(x: screenWidth - padding - lMarketDesc.frame.size.width, y: padding)
        let vMarket = UIView(frame: CGRect(x: 0, y: lTitle.frame.origin.y + lTitle.frame.size.height + ScreenUtils.heightFit(30), width: screenWidth, height: padding * 2 + CountHelper.getMax(lMarketName.frame.size.height, lMarketDesc.frame.size.height)))
        vMarket.backgroundColor = ColorHelper.getWhite()
        ViewHelper.addViewLineTop(vMarket)
        ViewHelper.addViewLineBottom(vMarket)
        vMarket.addSubview(lMarketName)
        vMarket.addSubview(lMarketDesc)

        // Custom
        let lCustomName = ViewHelper.getLabelBlackNormal(text: StringUtils.getString("customer_qq"))
        lCustomName.frame.origin = CGPoint(x: padding, y: padding)
        let lCustomDesc = ViewHelper.getLabelGreyNormal(text: UDHelper.getCommonConst().customerQQ)
        lCustomDesc.frame.origin = CGPoint(x: screenWidth - padding - lCustomDesc.frame.size.width, y: padding)
        let vCustom = UIView(frame: CGRect(x: 0, y: vMarket.frame.origin.y + vMarket.frame.size.height + ScreenUtils.heightFit(30), width: screenWidth, height: padding * 2 + CountHelper.getMax(lCustomName.frame.size.height, lCustomDesc.frame.size.height)))
        vCustom.backgroundColor = ColorHelper.getWhite()
        ViewHelper.addViewLineTop(vCustom)
        ViewHelper.addViewLineBottom(vCustom)
        vCustom.addSubview(lCustomName)
        vCustom.addSubview(lCustomDesc)
        
        // WeiBo
        let lWeiBoName = ViewHelper.getLabelBlackNormal(text: StringUtils.getString("official_weibo"))
        lWeiBoName.frame.origin = CGPoint(x: padding, y: padding)
        let lWeiBoDesc = ViewHelper.getLabelGreyNormal(text: UDHelper.getCommonConst().officialWeibo)
        lWeiBoDesc.frame.origin = CGPoint(x: screenWidth - padding - lWeiBoDesc.frame.size.width, y: padding)
        let vWeiBo = UIView(frame: CGRect(x: 0, y: vCustom.frame.origin.y + vCustom.frame.size.height, width: screenWidth, height: padding * 2 + CountHelper.getMax(lWeiBoName.frame.size.height, lWeiBoDesc.frame.size.height)))
        vWeiBo.backgroundColor = ColorHelper.getWhite()
        ViewHelper.addViewLineBottom(vWeiBo)
        vWeiBo.addSubview(lWeiBoName)
        vWeiBo.addSubview(lWeiBoDesc)
        
        // Web
        let lWebName = ViewHelper.getLabelBlackNormal(text: StringUtils.getString("official_web"))
        lWebName.frame.origin = CGPoint(x: padding, y: padding)
        let lWebDesc = ViewHelper.getLabelGreyNormal(text: UDHelper.getCommonConst().officialWeb)
        lWebDesc.frame.origin = CGPoint(x: screenWidth - padding - lWebDesc.frame.size.width, y: padding)
        let vWeb = UIView(frame: CGRect(x: 0, y: vWeiBo.frame.origin.y + vWeiBo.frame.size.height, width: screenWidth, height: padding * 2 + CountHelper.getMax(lWebName.frame.size.height, lWebDesc.frame.size.height)))
        vWeb.backgroundColor = ColorHelper.getWhite()
        ViewHelper.addViewLineBottom(vWeb)
        vWeb.addSubview(lWebName)
        vWeb.addSubview(lWebDesc)
        
        // Contact
        let lContactName = ViewHelper.getLabelBlackNormal(text: StringUtils.getString("contact_us"))
        lContactName.frame.origin = CGPoint(x: padding, y: padding)
        let lContactDesc = ViewHelper.getLabelGreyNormal(text: UDHelper.getCommonConst().contactEmail)
        lContactDesc.frame.origin = CGPoint(x: screenWidth - padding - lContactDesc.frame.size.width, y: padding)
        let vContact = UIView(frame: CGRect(x: 0, y: vWeb.frame.origin.y + vWeb.frame.size.height, width: screenWidth, height: padding * 2 + CountHelper.getMax(lContactName.frame.size.height, lContactDesc.frame.size.height)))
        vContact.backgroundColor = ColorHelper.getWhite()
        ViewHelper.addViewLineBottom(vContact)
        vContact.addSubview(lContactName)
        vContact.addSubview(lContactDesc)
        
        // companyName
        let lCompanyName = ViewHelper.getLabelGreySmall(width: screenWidth, text: UDHelper.getCommonConst().companyName, lines: 1, align: .center, mode: .byTruncatingMiddle)
        lCompanyName.frame.origin.x = 0
        lCompanyName.frame.origin.y = self.view.frame.height - RootVC.get().getTopBarHeight() - lCompanyName.frame.size.height - ScreenUtils.heightFit(10)
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = lCompanyName.frame.origin.y + lCompanyName.frame.size.height + ScreenUtils.heightFit(10)
        let scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        scroll.addSubview(ivAppName)
        scroll.addSubview(lTitle)
        scroll.addSubview(vMarket)
        scroll.addSubview(vCustom)
        scroll.addSubview(vWeiBo)
        scroll.addSubview(vWeb)
        scroll.addSubview(vContact)
        //scroll.addSubview(lCompanyName) // 版权问题
        
        // view
        self.view.addSubview(scroll)
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vMarket, action: #selector(targetGoMarket))
        ViewUtils.addViewTapTarget(target: self, view: vWeiBo, action: #selector(targetGoWeiBo))
        ViewUtils.addViewTapTarget(target: self, view: vWeb, action: #selector(targetGoWeb))
    }
    
    @objc private func targetGoProtocol() {
        UserProtocolVC.pushVC()
    }
    
    @objc private func targetGoMarket() {
        URLUtils.openAPPStore(id: UDHelper.getCommonConst().iosAppId)
    }
    
    @objc private func targetGoWeiBo() {
    }
    
    @objc private func targetGoWeb() {
        var web = UDHelper.getCommonConst().officialWeb
        if !web.starts(with: "http") {
            web = "http://" + web
        }
        URLUtils.openURL(URL(string: web))
    }
    
}
