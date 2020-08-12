//
//  ColorUtils.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/16.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class ColorUtils {
    
    public static func RGB(_ rgb: Int, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgb & 0xFF)) / 255.0,
                       alpha: alpha)
    }
    
//    public static func RGB(_ rgb: String?) -> UIColor {
//        if StringUtils.isEmpty(rgb) || rgb!.count < 6 {
//            return UIColor.clear
//        }
//        var cstr: String = rgb!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
//
//        if (cstr.hasPrefix("0X")) {
//            cstr = (cstr as NSString).substring(from: 2)
//        }
//        if (cstr.hasPrefix("#")) {
//            cstr = (cstr as NSString).substring(from: 1)
//        }
//        if (cstr.count != 6) {
//            return UIColor.clear
//        }
//
//        let rStr = (cstr as NSString).substring(to: 2)
//        let gStr = ((cstr as NSString).substring(from: 2) as NSString).substring(to: 2)
//        let bStr = ((cstr as NSString).substring(from: 4) as NSString).substring(to: 2)
//
//        var r :UInt32 = 0x0
//        var g :UInt32 = 0x0
//        var b :UInt32 = 0x0
//        Scanner.init(string: rStr).scanHexInt32(&r)
//        Scanner.init(string: gStr).scanHexInt32(&g)
//        Scanner.init(string: bStr).scanHexInt32(&b)
//        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1)
//    }

    public static func getRed(_ color: UIColor) -> CGFloat? {
        return color.cgColor.components?[0]
    }

    public static func getGreen(_ color: UIColor) -> CGFloat? {
        let components = color.cgColor.components
        if components?.count == 2 {
            return components?[0]
        } else {
            return components?[1]
        }
    }

    public static func getBlue(_ color: UIColor) -> CGFloat? {
        let components = color.cgColor.components
        if components?.count == 2 {
            return components?[0]
        } else {
            return components?[2]
        }
    }

    public static func getAlpha(_ color: UIColor) -> CGFloat? {
        let components = color.cgColor.components
        return components?[((components?.count ?? 1) - 1)]
    }

}
