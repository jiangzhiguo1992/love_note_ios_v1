//
//  WebVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/11.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WebVC: BaseVC {
    
    // var
    lazy var WebTitle: String = ""
    lazy var webUrl: String = ""
    
    public static func pushVC(title: String?, url: String?) {
        AppDelegate.runOnMainAsync {
            let vc = WebVC(nibName: nil, bundle: nil)
            vc.WebTitle = title ?? ""
            vc.webUrl = url ?? ""
            RootVC.get().pushNext(vc)
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: self.WebTitle)
        
        // 检查url
        if (StringUtils.isEmpty(self.webUrl)) {
            RootVC.get().popBack()
            return
        }
        if (!self.webUrl.starts(with: "http")) {
            self.webUrl = "http://" + self.webUrl
        }
        
        // webview
        let webview = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - RootVC.get().getTopBarHeight()))
        // 创建请求
        let request = URLRequest(url: URL(string: self.webUrl)!)
        // 加载请求
        webview.load(request)
        // 添加wkWebView
        self.view.addSubview(webview)
    }
    
}
