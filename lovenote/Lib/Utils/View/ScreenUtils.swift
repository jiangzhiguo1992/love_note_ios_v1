//
// Created by 蒋治国 on 2018/12/3.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation
import UIKit


class ScreenUtils {
    
    // 获取主屏幕
    public static func getScreen() -> UIScreen {
        return UIScreen.main
    }
    
    public static func getScreenRect() -> CGRect {
        return getScreen().bounds
    }
    
    public static func getScreenSize() -> CGSize {
        return getScreenRect().size
    }
    
    public static func getScreenWidth() -> CGFloat {
        return getScreenSize().width
    }
    
    public static func getScreenHeight() -> CGFloat {
        return getScreenSize().height
    }
    
    public static func getTopStatusHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    public static func getBottomNavHeight() -> CGFloat {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0
        } else {
            return 0
        }
    }
    
    public static func getBottomSafeHeight(xYes: CGFloat, xNo: CGFloat) -> CGFloat {
        return (getBottomNavHeight() != 0) ? getBottomNavHeight() + xYes : xNo
    }
    
    public static func isIphoneX() -> Bool {
        return UIScreen.main.nativeBounds.size.height-2436 == 0 ? true : false
    }
    
    public static func isSmallIphone() -> Bool {
        return UIScreen.main.bounds.size.height == 480 ? true : false
    }
    
    public static let ADAPTED_HEIGHT = 667
    public static let ADAPTED_WIDTH = 375
    
    public static func heightFit(_ height: CGFloat?) -> CGFloat {
        if (height ?? 0) == 0 {
            return 0
        }
        var fitRadio = CGFloat(0)
        if isIphoneX() {
            fitRadio = (getScreenHeight() - 145) / CGFloat(ADAPTED_HEIGHT)
        } else {
            fitRadio = getScreenHeight() / CGFloat(ADAPTED_HEIGHT)
        }
        return fitRadio * (height ?? 0)
    }
    
    public static func widthFit(_ width: CGFloat?) -> CGFloat {
        if (width ?? 0) == 0 {
            return 0
        }
        let fitRadio = getScreenWidth() / CGFloat(ADAPTED_WIDTH)
        return fitRadio * (width ?? 0)
    }
    
    public static func fontFit(_ size: CGFloat?) -> CGFloat {
        return ScreenUtils.widthFit(size)
    }
    
}
