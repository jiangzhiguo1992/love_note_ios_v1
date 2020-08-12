//
//  LaunchVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/9.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class LaunchVC: BaseVC {
    
    // view
    private var ivBG: UIImageView!
    private var ivWall: UIImageView!
    
    // var
    private let waitSecond = 2 // 过渡时间
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().newRoot([LaunchVC(nibName: nil, bundle: nil)])
        }
    }
    
    override func initView() {
        // bg
        ivBG = ViewHelper.getImageView(img: UIImage(named: "bg_welcome_1"), width: self.view.frame.size.width, height: self.view.frame.size.height, mode: .scaleAspectFill)
        ivBG.frame.origin = CGPoint(x: 0, y: 0)
        
        // wallpaper
        ivWall = ViewHelper.getImageViewUrl(width: self.view.frame.size.width, height: self.view.frame.size.height, indicator: false, radius: 0)
        ivWall.frame.origin = CGPoint(x: 0, y: 0)
        ivWall.alpha = 0
        
        // view
        self.view.addSubview(ivBG)
        self.view.addSubview(ivWall)
    }
    
    override func initData() {
        // wallPaper
        var imgList = UDHelper.getWallPaper().contentImageList
        if imgList.count > 0 {
            imgList.shuffle()
            let ossKey = imgList[0]
            KFHelper.setImgUrl(iv: ivWall, objKey: ossKey, resize: false)
            starAnim()
        }
        // ...非网络性init操作
        checkUser()
    }
    
    private func starAnim() {
        UIView.animate(withDuration: TimeInterval(1)) {
            self.ivWall.alpha = 1
        }
    }
    
    private func checkUser() {
        // 判断是否登录，进入不同页面
        if UserHelper.isEmpty(user: UDHelper.getMe()) {
            // 没有登录
            AppDelegate.getQueueMain().asyncAfter(deadline: DispatchTime.now() + .seconds(self.waitSecond)) {
                SplashVC.pushVC()
            }
        } else {
            // 有登录
            let start = DateUtils.getCurrentInt64()
            let body = ApiHelper.getEntryBody()
            let api = Api.request(.entryPush(entry: body.toJSON()),
                                  success: { (code, msg, data) in
                                    ApiHelper.onEntryFinish(startTime: start, totalWait: self.waitSecond, code: code, data: data)
            })
            self.pushApi(api)
        }
    }
    
}
