//
//  NoticeDetailVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/2/12.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoticeDetailVC: BaseVC {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var maxWidth = ScreenUtils.getScreenWidth() - margin * 2
    
    // var
    private var notice: Notice!
    
    public static func pushVC(notice: Notice?) {
        if notice == nil {
            return
        }
        AppDelegate.runOnMainAsync {
            let vc = NoticeDetailVC(nibName: nil, bundle: nil)
            vc.notice = notice!
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "new_notice")
        
        // title
        let lTitle = ViewHelper.getLabelBold(width: maxWidth, text: notice.title, size: ViewHelper.FONT_SIZE_BIG,
                                             color: ColorHelper.getFontBlack(), lines: 0, align: .center)
        lTitle.frame.origin = CGPoint(x: margin, y: margin * 2)
        
        // time
        let timeShow = TimeHelper.getTimeShowLine_HM_MD_YMD_ByGo(notice.createAt)
        let lTime = ViewHelper.getLabelGreySmall(width: maxWidth, text: timeShow, lines: 1, align: .right)
        lTime.frame.origin = CGPoint(x: margin, y: lTitle.frame.origin.y + lTitle.frame.size.height + margin)
        
        // content
        let lContent = ViewHelper.getLabelBlackNormal(width: maxWidth, text: notice.contentText, lines: 0, align: .left)
        lContent.frame.origin = CGPoint(x: margin, y: lTime.frame.origin.y + lTime.frame.size.height + margin * 2)
        lContent.sizeToFit()
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = lContent.frame.origin.y + lContent.frame.size.height + ScreenUtils.heightFit(20)
        let scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        
        scroll.addSubview(lTitle)
        scroll.addSubview(lTime)
        scroll.addSubview(lContent)
        
        // view
        self.view.addSubview(scroll)
    }
    
}
