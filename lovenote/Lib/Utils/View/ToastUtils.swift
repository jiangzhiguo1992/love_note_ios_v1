//
// Created by 蒋治国 on 2018/12/6.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class ToastUtils {
    
    // 弹窗图片文字
    public static func show(_ content: String?, duration: CFTimeInterval = 3) {
        if StringUtils.isEmpty(content) {
            return
        }
        if Thread.isMainThread {
            showNoCheckThreead(content, duration: duration)
        } else {
            DispatchQueue.main.async {
                showNoCheckThreead(content, duration: duration)
            }
        }
    }
    
    private static func showNoCheckThreead(_ content: String?, duration: CFTimeInterval = 3) {
        let rootView = UIApplication.shared.keyWindow?.subviews.first
        if rootView == nil {
            return
        }
        // 清除上一个
        // clear()
        
        // const
        let maxWidth = ScreenUtils.getScreenWidth() - ScreenUtils.widthFit(20)
        let maxHeight = ScreenUtils.getScreenHeight() - ScreenUtils.heightFit(20)
        
        // 内容view
        let lMessage = UILabel(frame: CGRect(x: 0, y: 0, width: maxWidth, height: maxHeight))
        lMessage.font = UIFont.systemFont(ofSize: ScreenUtils.fontFit(15))
        lMessage.textColor = UIColor.white
        lMessage.text = content
        lMessage.lineBreakMode = NSLineBreakMode.byWordWrapping
        lMessage.numberOfLines = 0
        lMessage.textAlignment = NSTextAlignment.center
        lMessage.sizeToFit()
        lMessage.frame.size.width += 40
        lMessage.frame.size.height += 15
        if lMessage.frame.size.width >= ScreenUtils.getScreenWidth() - ScreenUtils.widthFit(20) {
            lMessage.frame.size.width = ScreenUtils.getScreenWidth() - ScreenUtils.widthFit(20)
        }
        if lMessage.frame.size.height >= ScreenUtils.getScreenHeight() - ScreenUtils.heightFit(20) {
            lMessage.frame.size.height = ScreenUtils.getScreenHeight() - ScreenUtils.heightFit(20)
        }
        
        // 背景view
        let bgView = UIView(frame: lMessage.frame)
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
        bgView.addSubview(lMessage)
        
        // 弹窗
        let window = UIWindow(frame: bgView.frame)
        window.backgroundColor = UIColor.clear
        window.windowLevel = UIWindow.Level.alert
        window.center = CGPoint(x: rootView!.center.x, y: rootView!.center.y)
        window.isHidden = false
        window.addSubview(bgView)
        window.bringSubviewToFront(bgView)
        
        // 主窗口
        var appWindows = UIApplication.shared.windows
        appWindows.append(window)
        
        // 动画
        UIView.animate(withDuration: duration, animations: {
            // 透明度
            bgView.alpha = 0
        }) { (finished) in
            // 移除 clear()
            if finished {
                window.removeFromSuperview()
            }
        }
    }
    
    //清除所有弹窗
    private static func clear() {
        var appWindows = UIApplication.shared.windows
        appWindows.removeAll(keepingCapacity: false)
    }
    
}
