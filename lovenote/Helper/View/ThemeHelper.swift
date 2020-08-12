//
// Created by 蒋治国 on 2018-12-16.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class ThemeHelper {

    public static let THEME_RED = 1
    public static let THEME_PINK = 2
    public static let THEME_PURPLE = 3
    public static let THEME_INDIGO = 4
    public static let THEME_BLUE = 5
    public static let THEME_TEAL = 6
    public static let THEME_GREEN = 7
    public static let THEME_YELLOW = 8
    public static let THEME_ORANGE = 9
    public static let THEME_BROWN = 10
    public static let THEME_GREY = 11

    public static func setTheme(_ theme: Int) {
        // userDefault
        UDHelper.setTheme(theme)
        // notification
        NotifyHelper.post(NotifyHelper.TAG_THEME_UPDATE, obj: theme)
    }

    public static func getColorDark() -> UIColor {
        switch UDHelper.getTheme() {
        case THEME_RED:
            return ColorHelper.getRedDark()
        case THEME_PINK:
            return ColorHelper.getPinkDark()
        case THEME_PURPLE:
            return ColorHelper.getPurpleDark()
        case THEME_INDIGO:
            return ColorHelper.getIndigoDark()
        case THEME_BLUE:
            return ColorHelper.getBlueDark()
        case THEME_TEAL:
            return ColorHelper.getTealDark()
        case THEME_GREEN:
            return ColorHelper.getGreenDark()
        case THEME_YELLOW:
            return ColorHelper.getYellowDark()
        case THEME_ORANGE:
            return ColorHelper.getOrangeDark()
        case THEME_BROWN:
            return ColorHelper.getBrownDark()
        case THEME_GREY:
            return ColorHelper.getGreyDark()
        default:
            return ColorHelper.getPinkDark()
        }
    }

    public static func getColorPrimary() -> UIColor {
        switch UDHelper.getTheme() {
        case THEME_RED:
            return ColorHelper.getRedPrimary()
        case THEME_PINK:
            return ColorHelper.getPinkPrimary()
        case THEME_PURPLE:
            return ColorHelper.getPurplePrimary()
        case THEME_INDIGO:
            return ColorHelper.getIndigoPrimary()
        case THEME_BLUE:
            return ColorHelper.getBluePrimary()
        case THEME_TEAL:
            return ColorHelper.getTealPrimary()
        case THEME_GREEN:
            return ColorHelper.getGreenPrimary()
        case THEME_YELLOW:
            return ColorHelper.getYellowPrimary()
        case THEME_ORANGE:
            return ColorHelper.getOrangePrimary()
        case THEME_BROWN:
            return ColorHelper.getBrownPrimary()
        case THEME_GREY:
            return ColorHelper.getGreyPrimary()
        default:
            return ColorHelper.getPinkPrimary()
        }
    }

    public static func getColorAccent() -> UIColor {
        switch UDHelper.getTheme() {
        case THEME_RED:
            return ColorHelper.getRedAccent()
        case THEME_PINK:
            return ColorHelper.getPinkAccent()
        case THEME_PURPLE:
            return ColorHelper.getPurpleAccent()
        case THEME_INDIGO:
            return ColorHelper.getIndigoAccent()
        case THEME_BLUE:
            return ColorHelper.getBlueAccent()
        case THEME_TEAL:
            return ColorHelper.getTealAccent()
        case THEME_GREEN:
            return ColorHelper.getGreenAccent()
        case THEME_YELLOW:
            return ColorHelper.getYellowAccent()
        case THEME_ORANGE:
            return ColorHelper.getOrangeAccent()
        case THEME_BROWN:
            return ColorHelper.getBrownAccent()
        case THEME_GREY:
            return ColorHelper.getGreyAccent()
        default:
            return ColorHelper.getPinkAccent()
        }
    }

    public static func getColorLight() -> UIColor {
        switch UDHelper.getTheme() {
        case THEME_RED:
            return ColorHelper.getRedLight()
        case THEME_PINK:
            return ColorHelper.getPinkLight()
        case THEME_PURPLE:
            return ColorHelper.getPurpleLight()
        case THEME_INDIGO:
            return ColorHelper.getIndigoLight()
        case THEME_BLUE:
            return ColorHelper.getBlueLight()
        case THEME_TEAL:
            return ColorHelper.getTealLight()
        case THEME_GREEN:
            return ColorHelper.getGreenLight()
        case THEME_YELLOW:
            return ColorHelper.getYellowLight()
        case THEME_ORANGE:
            return ColorHelper.getOrangeLight()
        case THEME_BROWN:
            return ColorHelper.getBrownLight()
        case THEME_GREY:
            return ColorHelper.getGreyLight()
        default:
            return ColorHelper.getPinkLight()
        }
    }

    public static func getPrimaryRandom() -> UIColor {
        let colors = [UIColor](arrayLiteral: ColorHelper.getRedPrimary(),
                ColorHelper.getPinkPrimary(),
                ColorHelper.getPurplePrimary(),
                ColorHelper.getIndigoPrimary(),
                ColorHelper.getBluePrimary(),
                ColorHelper.getTealPrimary(),
                ColorHelper.getGreenPrimary(),
                ColorHelper.getYellowPrimary(),
                ColorHelper.getOrangePrimary(),
                ColorHelper.getBrownPrimary(),
                ColorHelper.getGreyPrimary())
        let index = Int.random(in: Range(0...(colors.count - 1)))
        return colors[index]
    }


}
