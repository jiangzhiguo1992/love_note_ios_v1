//
//  MoreMatchLetterAddVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/5/8.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class MoreMatchLetterAddVC: BaseVC {
    
    // const
    lazy var margin = ScreenUtils.widthFit(10)
    lazy var screenHeight = ScreenUtils.getScreenHeight()
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var maxWidth = screenWidth - margin * 2
    
    // view
    private var tvContent: UITextView!
    
    // var
    private var pid: Int64 = 0
    
    public static func pushVC(pid: Int64) {
        if pid == 0 {
            return
        }
        AppDelegate.runOnMainAsync {
            let vc = MoreMatchLetterAddVC(nibName: nil, bundle: nil)
            vc.pid = pid
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "nav_letter")
        let barItemCommit = UIBarButtonItem(title: StringUtils.getString("commit"), style: .plain, target: self, action: #selector(checkPush))
        barItemCommit.setTitleTextAttributes([NSAttributedString.Key.font : ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)], for: .normal)
        self.navigationItem.setRightBarButtonItems([barItemCommit], animated: true)
        
        // content
        tvContent = ViewHelper.getTextView(width: maxWidth, height: screenHeight / 2, text: "", textSize: ViewHelper.FONT_SIZE_BIG, textColor: ColorHelper.getFontGrey(), placeholder: StringUtils.getString("please_input_content"), limitLength: UDHelper.getLimit().matchWorkTitleLength)
        tvContent.frame.origin = CGPoint(x: margin, y: margin * 2)
        
        // view
        self.view.backgroundColor = ColorHelper.getWhite()
        self.view.addSubview(tvContent)
    }
    
    override func initData() {
        // content
        ExtensionTextView.setTextViewTextWithPlaceholder(tvContent, text: "")
    }
    
    @objc func checkPush() {
        if StringUtils.isEmpty(tvContent.text) {
            ToastUtils.show(tvContent.placeholder)
            return
        }
        let body = MatchWork()
        body.matchPeriodId = pid
        body.title = tvContent.text ?? ""
        // api
        let api = Api.request(.moreMatchWorkAdd(matchWork: body.toJSON()),
                              loading: true, cancel: true,
                              success: { (_, _, data) in
                                // pop
                                RootVC.get().popBack()
        }, failure: nil)
        pushApi(api)
    }
    
}
