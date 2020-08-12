//
// Created by 蒋治国 on 2018-12-10.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class RootVC: BaseNaviVC {
    
    // 获取根VC
    public static func get() -> RootVC {
        let rootVC = AppDelegate.getAppWindow().rootViewController
        return rootVC as! RootVC
        //        return ViewUtils.get(name: "main", id: "RootVC") as! RootVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // launch
        LaunchVC.pushVC()
    }
    
    // 状态栏文字颜色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
