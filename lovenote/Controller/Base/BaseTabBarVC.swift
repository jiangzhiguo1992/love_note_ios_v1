//
//  BaseTabBarVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/9.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class BaseTabBarVC: UITabBarController {
    
    public static func getHomeTabVC(dateSource: [UIViewController] = [UIViewController]()) -> BaseTabBarVC {
        let tabBarVC = BaseTabBarVC()
        tabBarVC.tabBar.barTintColor = ColorHelper.getWhite()
        tabBarVC.tabBar.unselectedItemTintColor = ColorHelper.getIconGrey()
        tabBarVC.tabBar.tintColor = ThemeHelper.getColorPrimary()
        return tabBarVC
    }
    
    // 销毁
    deinit {
        // notify
        NotifyHelper.removeObserver(self)
    }
    
}
