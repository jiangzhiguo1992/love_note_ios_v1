//
//  UserProtocolVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2018/12/28.
//  Copyright © 2018年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class UserProtocolVC: BaseVC {
    
    // const
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var padding = ScreenUtils.widthFit(15)
    lazy var maxWidth = screenWidth - padding * 2
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(UserProtocolVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "user_protocol")
        
        // content
        let company = UDHelper.getCommonConst().companyName
        let appShort = AppUtils.getAppDisplayName()
        let app = "\"" + appShort + "\""
        let companyApp = company + app
        // 重要须知
        let importKnow = StringUtils.getString("agreement_import_know", arguments: [company, company, company, app, app])
        // 使用规则
        let useRule = StringUtils.getString("agreement_use_rule", arguments: [companyApp, companyApp, company, companyApp, companyApp, company, company, companyApp, companyApp, company, companyApp, companyApp, company, company, companyApp, companyApp, companyApp, companyApp, companyApp, company, company, companyApp, companyApp, companyApp, company, companyApp, company, companyApp, companyApp, company, company, companyApp, company, companyApp])
        // 隐私保护
        let privateProtect = StringUtils.getString("agreement_private_protect", arguments: [company, company, company, company, company, company, company, company, company, company, companyApp, company, company])
        // 商标信息
        let iconInfo = StringUtils.getString("agreement_icon_info", arguments: [companyApp, companyApp, companyApp, companyApp, company, company, company, company])
        // 法律责任
        let lawResponse = StringUtils.getString("agreement_law_response", arguments: [company, company, company, company, company, company, company, company, company, company, company, companyApp, companyApp, company, companyApp, company])
        // 社区管理
        let socialManage = StringUtils.getString("agreement_social_manage", arguments: [app, app, company, companyApp, company, app])
        // 其他条款
        let otherClause = StringUtils.getString("agreement_other_clause", arguments: [company, company, company, company, company])
        // 全程
        let allName = StringUtils.getString("agreement_all_name", arguments: [appShort])
        // content
        let content = importKnow + "\n\n" + useRule + "\n\n" + privateProtect + "\n\n" + iconInfo + "\n\n" + lawResponse + "\n\n" + socialManage + "\n\n" + otherClause + "\n\n" + allName
        
        // content
        let lContent = ViewHelper.getLabelBlackNormal(width: maxWidth, text: content)
        lContent.frame.origin = CGPoint(x: padding, y: padding)
        lContent.sizeToFit()
        
        // scroll
        let scroll = ViewUtils.getScroll(frame: self.view.frame, contentSize: CGSize(width: self.view.frame.size.width, height: lContent.frame.origin.y + lContent.frame.size.height + RootVC.get().getTopBarHeight() + ScreenUtils.heightFit(20)))
        scroll.addSubview(lContent)
        
        // view
        self.view.addSubview(scroll)
    }
    
}
