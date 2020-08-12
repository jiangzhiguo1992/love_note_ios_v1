//
//  BaseNaviVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/9.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation

import UIKit

class BaseNaviVC: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UINavigationBarDelegate {
    
    public static func get(root: UIViewController? = nil) -> BaseNaviVC {
        let nav: BaseNaviVC
        if root != nil {
            nav = BaseNaviVC(rootViewController: root!)
        } else {
            nav = BaseNaviVC()
        }
        return nav
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigationBar
        self.navigationBar.barTintColor = ThemeHelper.getColorPrimary()
        self.navigationBar.tintColor = ColorHelper.getFontWhite()
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: CGFloat(ViewHelper.FONT_SIZE_BIG)), NSAttributedString.Key.foregroundColor: ColorHelper.getFontWhite()]
        
        // 添加手势代理
        self.interactivePopGestureRecognizer?.delegate = self
        self.delegate = self
    }
    
    // 销毁
    deinit {
        // notify
        NotifyHelper.removeObserver(self)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            //添加手势识别
            self.interactivePopGestureRecognizer?.isEnabled = true
        }
        //是否开启动画由传入决定，不会造成冲突
        super.pushViewController(viewController, animated: animated)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if navigationController.viewControllers.count == 1 {
            self.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
    
    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if self.viewControllers.count < (navigationBar.items?.count ?? 0) {
            return true
        }
        if let vc = self.topViewController as? BaseVC {
            if vc.canPop() {
                self.popBack()
            } else {
                AppDelegate.runOnMainAsync {
                    for subview in navigationBar.subviews {
                        if (0.0 < subview.alpha && subview.alpha < 1.0) {
                            UIView.animate(withDuration: 0.25, animations: {
                                subview.alpha = 1.0
                            })
                        }
                    }
                }
            }
        } else {
            self.popBack()
            return true
        }
        return false
    }
    
    public func pushNext(_ viewController: UIViewController) {
        AppDelegate.runOnMainAsync {
            self.pushViewController(viewController, animated: true)
        }
    }
    
    public func popBack() {
        AppDelegate.runOnMainAsync {
            if let vc = self.topViewController as? BaseVC {
                vc.willDestroy()
            }
            self.popViewController(animated: true)
        }
    }
    
    public func popTo(_ viewController: UIViewController) {
        AppDelegate.runOnMainAsync {
            self.popToViewController(viewController, animated: true)
        }
    }
    
    public func popRoot() {
        AppDelegate.runOnMainAsync {
            self.popToRootViewController(animated: true)
        }
    }
    
    public func newRoot(_ viewControllers: [UIViewController]) {
        AppDelegate.runOnMainAsync {
            self.setViewControllers(viewControllers, animated: true)
        }
    }
    
    public func getNaviBarHeight() -> CGFloat {
        return self.navigationBar.frame.size.height
    }
    
    public func getTopBarHeight() -> CGFloat {
        return getNaviBarHeight() + ScreenUtils.getTopStatusHeight()
    }
    
}
