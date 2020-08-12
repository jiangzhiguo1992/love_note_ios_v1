//
//  BroadcastVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/22.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class MoreBroadcastVC: BaseVC {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var maxWidth = ScreenUtils.getScreenWidth() - margin * 2
    
    // var
    private var broadcast: Broadcast!
    
    public static func pushVC(broadcast: Broadcast?) {
        if broadcast == nil {
            return
        }
        AppDelegate.runOnMainAsync {
            let vc = MoreBroadcastVC(nibName: nil, bundle: nil)
            vc.broadcast = broadcast!
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "broadcast")
        
        // title
        let lTitle = ViewHelper.getLabelBold(width: maxWidth, text: broadcast.title, size: ViewHelper.FONT_SIZE_BIG,
                                             color: ColorHelper.getFontBlack(), lines: 0, align: .center)
        lTitle.frame.origin = CGPoint(x: margin, y: margin * 2)
        
        // time
        let startAt = broadcast.startAt == 0 ? StringUtils.getString("nil") : DateUtils.getStr(broadcast.startAt, DateUtils.FORMAT_CHINA_Y_M_D)
        let startShow = StringUtils.getString("start_time_colon_holder", arguments: [startAt])
        let lStart = ViewHelper.getLabelGreySmall(width: maxWidth / 2, text: startShow, lines: 1, align: .left)
        lStart.frame.origin = CGPoint(x: margin, y: lTitle.frame.origin.y + lTitle.frame.size.height + margin)
        
        let endAt = broadcast.startAt == 0 ? StringUtils.getString("nil") : DateUtils.getStr(broadcast.endAt, DateUtils.FORMAT_CHINA_Y_M_D)
        let endShow = StringUtils.getString("end_time_colon_holder", arguments: [endAt])
        let lEnd = ViewHelper.getLabelGreySmall(width: maxWidth / 2, text: endShow, lines: 1, align: .right)
        lEnd.frame.origin = CGPoint(x: margin + maxWidth / 2, y: lTitle.frame.origin.y + lTitle.frame.size.height + margin)
        
        // content
        let lContent = ViewHelper.getLabelBlackNormal(width: maxWidth, text: broadcast.contentText, lines: 0, align: .left)
        lContent.frame.origin = CGPoint(x: margin, y: lEnd.frame.origin.y + lEnd.frame.size.height + margin * 2)
        lContent.sizeToFit()
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = lContent.frame.origin.y + lContent.frame.size.height + ScreenUtils.heightFit(20)
        let scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        
        scroll.addSubview(lTitle)
        scroll.addSubview(lStart)
        scroll.addSubview(lEnd)
        scroll.addSubview(lContent)
        
        // view
        self.view.addSubview(scroll)
    }
    
}
