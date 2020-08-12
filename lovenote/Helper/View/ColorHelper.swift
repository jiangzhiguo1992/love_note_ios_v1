//
// Created by 蒋治国 on 2018/12/3.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class ColorHelper {
    
    /**
     * 常用颜色
     */
    public static func getWhite() -> UIColor {
        return ColorUtils.RGB(0xFFFFFF)
    }
    
    public static func getBlack() -> UIColor {
        return ColorUtils.RGB(0x000000)
    }
    
    public static func getWhite90() -> UIColor {
        return ColorUtils.RGB(0xFFFFFF, alpha: 0.9)
    }
    
    public static func getBlack90() -> UIColor {
        return ColorUtils.RGB(0x000000, alpha: 0.9)
    }
    
    public static func getWhite75() -> UIColor {
        return ColorUtils.RGB(0xFFFFFF, alpha: 0.75)
    }
    
    public static func getBlack75() -> UIColor {
        return ColorUtils.RGB(0x000000, alpha: 0.75)
    }
    
    public static func getWhite50() -> UIColor {
        return ColorUtils.RGB(0xFFFFFF, alpha: 0.5)
    }
    
    public static func getBlack50() -> UIColor {
        return ColorUtils.RGB(0x000000, alpha: 0.5)
    }
    
    public static func getWhite25() -> UIColor {
        return ColorUtils.RGB(0xFFFFFF, alpha: 0.25)
    }
    
    public static func getBlack25() -> UIColor {
        return ColorUtils.RGB(0x000000, alpha: 0.25)
    }
    
    public static func getTrans() -> UIColor {
        return ColorUtils.RGB(0xFFFFFF, alpha: 0) // 不能clear
    }
    
    /**
     * 通用颜色
     */
    public static func getBackground() -> UIColor {
        return ColorUtils.RGB(0xF8F8F8)
    }
    
    public static func getForeground() -> UIColor {
        return ColorUtils.RGB(0xDDDDDD)
    }
    
    public static func getLineGrey() -> UIColor {
        return ColorUtils.RGB(0xDDDDDD)
    }
    
    public static func getIconGrey() -> UIColor {
        return ColorUtils.RGB(0xDDDDDD)
    }
    
    public static func getImgGrey() -> UIColor {
        return ColorUtils.RGB(0xEEEEEE)
    }
    
    /**
     * 字体颜色
     */
    public static func getFontWhite() -> UIColor {
        return ColorUtils.RGB(0xFFFFFF)
    }
    
    public static func getFontHint() -> UIColor {
        return ColorUtils.RGB(0xCBCBCB)
    }
    
    public static func getFontGrey() -> UIColor {
        return ColorUtils.RGB(0x757575)
    }
    
    public static func getFontBlack() -> UIColor {
        return ColorUtils.RGB(0x212121)
    }
    
    /**
     * red
     */
    public static func getRedDark() -> UIColor {
        return ColorUtils.RGB(0xff5722)
    }
    
    public static func getRedPrimary() -> UIColor {
        return ColorUtils.RGB(0xff7043)
    }
    
    public static func getRedAccent() -> UIColor {
        return ColorUtils.RGB(0xff8a65)
    }
    
    public static func getRedLight() -> UIColor {
        return ColorUtils.RGB(0xffab91)
    }
    
    /**
     * pink
     */
    public static func getPinkDark() -> UIColor {
        return ColorUtils.RGB(0xff6096)
    }
    
    public static func getPinkPrimary() -> UIColor {
        return ColorUtils.RGB(0xff80ab)
    }
    
    public static func getPinkAccent() -> UIColor {
        return ColorUtils.RGB(0xffa2c1)
    }
    
    public static func getPinkLight() -> UIColor {
        return ColorUtils.RGB(0xfcc3d6)
    }
    
    /**
     * purple
     */
    public static func getPurpleDark() -> UIColor {
        return ColorUtils.RGB(0xab47bc)
    }
    
    public static func getPurplePrimary() -> UIColor {
        return ColorUtils.RGB(0xba68c8)
    }
    
    public static func getPurpleAccent() -> UIColor {
        return ColorUtils.RGB(0xce93d8)
    }
    
    public static func getPurpleLight() -> UIColor {
        return ColorUtils.RGB(0xe1bee7)
    }
    
    /**
     * indigo
     */
    public static func getIndigoDark() -> UIColor {
        return ColorUtils.RGB(0x3F51B5)
    }
    
    public static func getIndigoPrimary() -> UIColor {
        return ColorUtils.RGB(0x5c6bc0)
    }
    
    public static func getIndigoAccent() -> UIColor {
        return ColorUtils.RGB(0x7986cb)
    }
    
    public static func getIndigoLight() -> UIColor {
        return ColorUtils.RGB(0x9fa8da)
    }
    
    /**
     * blue
     */
    public static func getBlueDark() -> UIColor {
        return ColorUtils.RGB(0x03a9f4)
    }
    
    public static func getBluePrimary() -> UIColor {
        return ColorUtils.RGB(0x29b6f6)
    }
    
    public static func getBlueAccent() -> UIColor {
        return ColorUtils.RGB(0x4fc3f7)
    }
    
    public static func getBlueLight() -> UIColor {
        return ColorUtils.RGB(0x81d4fa)
    }
    
    /**
     * teal
     */
    public static func getTealDark() -> UIColor {
        return ColorUtils.RGB(0x009688)
    }
    
    public static func getTealPrimary() -> UIColor {
        return ColorUtils.RGB(0x26a69a)
    }
    
    public static func getTealAccent() -> UIColor {
        return ColorUtils.RGB(0x4db6ac)
    }
    
    public static func getTealLight() -> UIColor {
        return ColorUtils.RGB(0x80cbc4)
    }
    
    /**
     * green
     */
    public static func getGreenDark() -> UIColor {
        return ColorUtils.RGB(0x8bc34a)
    }
    
    public static func getGreenPrimary() -> UIColor {
        return ColorUtils.RGB(0x9ccc65)
    }
    
    public static func getGreenAccent() -> UIColor {
        return ColorUtils.RGB(0xaed581)
    }
    
    public static func getGreenLight() -> UIColor {
        return ColorUtils.RGB(0xc5e1a5)
    }
    
    /**
     * yellow
     */
    public static func getYellowDark() -> UIColor {
        return ColorUtils.RGB(0xcddc39)
    }
    
    public static func getYellowPrimary() -> UIColor {
        return ColorUtils.RGB(0xd4e157)
    }
    
    public static func getYellowAccent() -> UIColor {
        return ColorUtils.RGB(0xdce775)
    }
    
    public static func getYellowLight() -> UIColor {
        return ColorUtils.RGB(0xe6ee9c)
    }
    
    /**
     * orange
     */
    public static func getOrangeDark() -> UIColor {
        return ColorUtils.RGB(0xff9800)
    }
    
    public static func getOrangePrimary() -> UIColor {
        return ColorUtils.RGB(0xffa726)
    }
    
    public static func getOrangeAccent() -> UIColor {
        return ColorUtils.RGB(0xffb74d)
    }
    
    public static func getOrangeLight() -> UIColor {
        return ColorUtils.RGB(0xffcc80)
    }
    
    /**
     * brown
     */
    public static func getBrownDark() -> UIColor {
        return ColorUtils.RGB(0x8d6e63)
    }
    
    public static func getBrownPrimary() -> UIColor {
        return ColorUtils.RGB(0xa1887f)
    }
    
    public static func getBrownAccent() -> UIColor {
        return ColorUtils.RGB(0xbcaaa4)
    }
    
    public static func getBrownLight() -> UIColor {
        return ColorUtils.RGB(0xd7ccc8)
    }
    
    /**
     * grey
     */
    public static func getGreyDark() -> UIColor {
        return ColorUtils.RGB(0x607d8b)
    }
    
    public static func getGreyPrimary() -> UIColor {
        return ColorUtils.RGB(0x78909c)
    }
    
    public static func getGreyAccent() -> UIColor {
        return ColorUtils.RGB(0x90a4ae)
    }
    
    public static func getGreyLight() -> UIColor {
        return ColorUtils.RGB(0xb0bec5)
    }
    
}
