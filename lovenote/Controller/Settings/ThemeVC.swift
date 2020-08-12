//
//  ThemeVC.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/10.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class ThemeVC: BaseVC {
    
    // const
    lazy var screenWidth = ScreenUtils.getScreenWidth()
    lazy var padding = ScreenUtils.widthFit(16)
    lazy var maxWidth = screenWidth - padding * 2
    
    // view
    private var ivRed: UIImageView!
    private var ivPink: UIImageView!
    private var ivPurple: UIImageView!
    private var ivIndigo: UIImageView!
    private var ivBlue: UIImageView!
    private var ivTeal: UIImageView!
    private var ivGreen: UIImageView!
    private var ivYellow: UIImageView!
    private var ivOrange: UIImageView!
    private var ivBrown: UIImageView!
    private var ivGrey: UIImageView!
    
    public static func pushVC() {
        AppDelegate.runOnMainAsync {
            RootVC.get().pushNext(ThemeVC(nibName: nil, bundle: nil))
        }
    }
    
    override func initView() {
        // navigationBar
        initNavBar(title: "theme")
        
        // Red
        ivRed = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_brightness_1_grey_24dp"), color: ColorHelper.getRedPrimary()), mode: .scaleAspectFit)
        ivRed.frame.origin = CGPoint(x: 0, y: 0)
        let lRed = ViewHelper.getLabel(width: maxWidth, height: padding, text: StringUtils.getString("menses_red"), color: ColorHelper.getRedPrimary())
        lRed.frame.origin = CGPoint(x: ivRed.frame.origin.x + ivRed.frame.size.width + padding, y: 0)
        
        let vRed = UIView(frame: CGRect(x: padding, y: 0, width: maxWidth, height: padding * 2 + ivRed.frame.size.height))
        ivRed.center.y = vRed.frame.size.height / 2
        lRed.center.y = vRed.frame.size.height / 2
        ViewHelper.addViewLineBottom(vRed)
        vRed.addSubview(ivRed)
        vRed.addSubview(lRed)
        
        // Pink
        ivPink = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_brightness_1_grey_24dp"), color: ColorHelper.getPinkPrimary()), mode: .scaleAspectFit)
        ivPink.frame.origin = CGPoint(x: 0, y: 0)
        let lPink = ViewHelper.getLabel(width: maxWidth, height: padding, text: StringUtils.getString("girl_pink"), color: ColorHelper.getPinkPrimary())
        lPink.frame.origin = CGPoint(x: ivPink.frame.origin.x + ivPink.frame.size.width + padding, y: 0)
        
        let vPink = UIView(frame: CGRect(x: padding, y: vRed.frame.origin.y + vRed.frame.size.height, width: maxWidth, height: padding * 2 + ivPink.frame.size.height))
        ivPink.center.y = vPink.frame.size.height / 2
        lPink.center.y = vPink.frame.size.height / 2
        ViewHelper.addViewLineBottom(vPink)
        vPink.addSubview(ivPink)
        vPink.addSubview(lPink)
        
        // Purple
        ivPurple = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_brightness_1_grey_24dp"), color: ColorHelper.getPurplePrimary()), mode: .scaleAspectFit)
        ivPurple.frame.origin = CGPoint(x: 0, y: 0)
        let lPurple = ViewHelper.getLabel(width: maxWidth, height: padding, text: StringUtils.getString("gay_purple"), color: ColorHelper.getPurplePrimary())
        lPurple.frame.origin = CGPoint(x: ivPurple.frame.origin.x + ivPurple.frame.size.width + padding, y: 0)
        
        let vPurple = UIView(frame: CGRect(x: padding, y: vPink.frame.origin.y + vPink.frame.size.height, width: maxWidth, height: padding * 2 + ivPurple.frame.size.height))
        ivPurple.center.y = vPurple.frame.size.height / 2
        lPurple.center.y = vPurple.frame.size.height / 2
        ViewHelper.addViewLineBottom(vPurple)
        vPurple.addSubview(ivPurple)
        vPurple.addSubview(lPurple)
        
        // Indigo
        ivIndigo = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_brightness_1_grey_24dp"), color: ColorHelper.getIndigoPrimary()), mode: .scaleAspectFit)
        ivIndigo.frame.origin = CGPoint(x: 0, y: 0)
        let lIndigo = ViewHelper.getLabel(width: maxWidth, height: padding, text: StringUtils.getString("indigo_blue"), color: ColorHelper.getIndigoPrimary())
        lIndigo.frame.origin = CGPoint(x: ivIndigo.frame.origin.x + ivIndigo.frame.size.width + padding, y: 0)
        
        let vIndigo = UIView(frame: CGRect(x: padding, y: vPurple.frame.origin.y + vPurple.frame.size.height, width: maxWidth, height: padding * 2 + ivIndigo.frame.size.height))
        ivIndigo.center.y = vIndigo.frame.size.height / 2
        lIndigo.center.y = vIndigo.frame.size.height / 2
        ViewHelper.addViewLineBottom(vIndigo)
        vIndigo.addSubview(ivIndigo)
        vIndigo.addSubview(lIndigo)
        
        // Blue
        ivBlue = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_brightness_1_grey_24dp"), color: ColorHelper.getBluePrimary()), mode: .scaleAspectFit)
        ivBlue.frame.origin = CGPoint(x: 0, y: 0)
        let lBlue = ViewHelper.getLabel(width: maxWidth, height: padding, text: StringUtils.getString("briefs_blue"), color: ColorHelper.getBluePrimary())
        lBlue.frame.origin = CGPoint(x: ivBlue.frame.origin.x + ivBlue.frame.size.width + padding, y: 0)
        
        let vBlue = UIView(frame: CGRect(x: padding, y: vIndigo.frame.origin.y + vIndigo.frame.size.height, width: maxWidth, height: padding * 2 + ivBlue.frame.size.height))
        ivBlue.center.y = vBlue.frame.size.height / 2
        lBlue.center.y = vBlue.frame.size.height / 2
        ViewHelper.addViewLineBottom(vBlue)
        vBlue.addSubview(ivBlue)
        vBlue.addSubview(lBlue)
        
        // Teal
        ivTeal = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_brightness_1_grey_24dp"), color: ColorHelper.getTealPrimary()), mode: .scaleAspectFit)
        ivTeal.frame.origin = CGPoint(x: 0, y: 0)
        let lTeal = ViewHelper.getLabel(width: maxWidth, height: padding, text: StringUtils.getString("teal_green"), color: ColorHelper.getTealPrimary())
        lTeal.frame.origin = CGPoint(x: ivTeal.frame.origin.x + ivTeal.frame.size.width + padding, y: 0)
        
        let vTeal = UIView(frame: CGRect(x: padding, y: vBlue.frame.origin.y + vBlue.frame.size.height, width: maxWidth, height: padding * 2 + ivTeal.frame.size.height))
        ivTeal.center.y = vTeal.frame.size.height / 2
        lTeal.center.y = vTeal.frame.size.height / 2
        ViewHelper.addViewLineBottom(vTeal)
        vTeal.addSubview(ivTeal)
        vTeal.addSubview(lTeal)
        
        // Green
        ivGreen = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_brightness_1_grey_24dp"), color: ColorHelper.getGreenPrimary()), mode: .scaleAspectFit)
        ivGreen.frame.origin = CGPoint(x: 0, y: 0)
        let lGreen = ViewHelper.getLabel(width: maxWidth, height: padding, text: StringUtils.getString("sapling_green"), color: ColorHelper.getGreenPrimary())
        lGreen.frame.origin = CGPoint(x: ivGreen.frame.origin.x + ivGreen.frame.size.width + padding, y: 0)
        
        let vGreen = UIView(frame: CGRect(x: padding, y: vTeal.frame.origin.y + vTeal.frame.size.height, width: maxWidth, height: padding * 2 + ivGreen.frame.size.height))
        ivGreen.center.y = vGreen.frame.size.height / 2
        lGreen.center.y = vGreen.frame.size.height / 2
        ViewHelper.addViewLineBottom(vGreen)
        vGreen.addSubview(ivGreen)
        vGreen.addSubview(lGreen)
        
        // Yellow
        ivYellow = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_brightness_1_grey_24dp"), color: ColorHelper.getYellowPrimary()), mode: .scaleAspectFit)
        ivYellow.frame.origin = CGPoint(x: 0, y: 0)
        let lYellow = ViewHelper.getLabel(width: maxWidth, height: padding, text: StringUtils.getString("egg_yellow"), color: ColorHelper.getYellowPrimary())
        lYellow.frame.origin = CGPoint(x: ivYellow.frame.origin.x + ivYellow.frame.size.width + padding, y: 0)
        
        let vYellow = UIView(frame: CGRect(x: padding, y: vGreen.frame.origin.y + vGreen.frame.size.height, width: maxWidth, height: padding * 2 + ivYellow.frame.size.height))
        ivYellow.center.y = vYellow.frame.size.height / 2
        lYellow.center.y = vYellow.frame.size.height / 2
        ViewHelper.addViewLineBottom(vYellow)
        vYellow.addSubview(ivYellow)
        vYellow.addSubview(lYellow)
        
        // Orange
        ivOrange = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_brightness_1_grey_24dp"), color: ColorHelper.getOrangePrimary()), mode: .scaleAspectFit)
        ivOrange.frame.origin = CGPoint(x: 0, y: 0)
        let lOrange = ViewHelper.getLabel(width: maxWidth, height: padding, text: StringUtils.getString("fruit_orange"), color: ColorHelper.getOrangePrimary())
        lOrange.frame.origin = CGPoint(x: ivOrange.frame.origin.x + ivOrange.frame.size.width + padding, y: 0)
        
        let vOrange = UIView(frame: CGRect(x: padding, y: vYellow.frame.origin.y + vYellow.frame.size.height, width: maxWidth, height: padding * 2 + ivOrange.frame.size.height))
        ivOrange.center.y = vOrange.frame.size.height / 2
        lOrange.center.y = vOrange.frame.size.height / 2
        ViewHelper.addViewLineBottom(vOrange)
        vOrange.addSubview(ivOrange)
        vOrange.addSubview(lOrange)
        
        // Brown
        ivBrown = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_brightness_1_grey_24dp"), color: ColorHelper.getBrownPrimary()), mode: .scaleAspectFit)
        ivBrown.frame.origin = CGPoint(x: 0, y: 0)
        let lBrown = ViewHelper.getLabel(width: maxWidth, height: padding, text: StringUtils.getString("coffee_brown"), color: ColorHelper.getBrownPrimary())
        lBrown.frame.origin = CGPoint(x: ivBrown.frame.origin.x + ivBrown.frame.size.width + padding, y: 0)
        
        let vBrown = UIView(frame: CGRect(x: padding, y: vOrange.frame.origin.y + vOrange.frame.size.height, width: maxWidth, height: padding * 2 + ivBrown.frame.size.height))
        ivBrown.center.y = vBrown.frame.size.height / 2
        lBrown.center.y = vBrown.frame.size.height / 2
        ViewHelper.addViewLineBottom(vBrown)
        vBrown.addSubview(ivBrown)
        vBrown.addSubview(lBrown)
        
        // Grey
        ivGrey = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_brightness_1_grey_24dp"), color: ColorHelper.getGreyPrimary()), mode: .scaleAspectFit)
        ivGrey.frame.origin = CGPoint(x: 0, y: 0)
        let lGrey = ViewHelper.getLabel(width: maxWidth, height: padding, text: StringUtils.getString("egg_grey"), color: ColorHelper.getGreyPrimary())
        lGrey.frame.origin = CGPoint(x: ivGrey.frame.origin.x + ivGrey.frame.size.width + padding, y: 0)
        
        let vGrey = UIView(frame: CGRect(x: padding, y: vBrown.frame.origin.y + vBrown.frame.size.height, width: maxWidth, height: padding * 2 + ivGrey.frame.size.height))
        ivGrey.center.y = vGrey.frame.size.height / 2
        lGrey.center.y = vGrey.frame.size.height / 2
        ViewHelper.addViewLineBottom(vGrey)
        vGrey.addSubview(ivGrey)
        vGrey.addSubview(lGrey)
        
        // scroll
        let scrollHeight = self.view.frame.height - RootVC.get().getTopBarHeight()
        let scrollReact = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollHeight)
        let scrollContentHeight = vGrey.frame.origin.y + vGrey.frame.size.height + ScreenUtils.heightFit(30)
        let scroll = ViewUtils.getScroll(frame: scrollReact, contentSize: CGSize(width: self.view.frame.size.width, height: scrollContentHeight))
        scroll.addSubview(vRed)
        scroll.addSubview(vPink)
        scroll.addSubview(vPurple)
        scroll.addSubview(vIndigo)
        scroll.addSubview(vBlue)
        scroll.addSubview(vTeal)
        scroll.addSubview(vGreen)
        scroll.addSubview(vYellow)
        scroll.addSubview(vOrange)
        scroll.addSubview(vBrown)
        scroll.addSubview(vGrey)
        
        // view
        self.view.addSubview(scroll)
        
        // target
        ViewUtils.addViewTapTarget(target: self, view: vRed, action: #selector(targetThemeRed))
        ViewUtils.addViewTapTarget(target: self, view: vPink, action: #selector(targetThemePink))
        ViewUtils.addViewTapTarget(target: self, view: vPurple, action: #selector(targetThemePurple))
        ViewUtils.addViewTapTarget(target: self, view: vIndigo, action: #selector(targetThemeIndigo))
        ViewUtils.addViewTapTarget(target: self, view: vBlue, action: #selector(targetThemeBlue))
        ViewUtils.addViewTapTarget(target: self, view: vTeal, action: #selector(targetThemeTeal))
        ViewUtils.addViewTapTarget(target: self, view: vGreen, action: #selector(targetThemeGreen))
        ViewUtils.addViewTapTarget(target: self, view: vYellow, action: #selector(targetThemeYellow))
        ViewUtils.addViewTapTarget(target: self, view: vOrange, action: #selector(targetThemeOrange))
        ViewUtils.addViewTapTarget(target: self, view: vBrown, action: #selector(targetThemeBrown))
        ViewUtils.addViewTapTarget(target: self, view: vGrey, action: #selector(targetThemeGrey))
    }
    
    override func initData() {
        // theme
        initTheme()
    }
    
    private func initTheme() {
        ivRed.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_brightness_1_grey_24dp"), color: ColorHelper.getRedPrimary())
        ivPink.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_brightness_1_grey_24dp"), color: ColorHelper.getPinkPrimary())
        ivPurple.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_brightness_1_grey_24dp"), color: ColorHelper.getPurplePrimary())
        ivIndigo.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_brightness_1_grey_24dp"), color: ColorHelper.getIndigoPrimary())
        ivBlue.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_brightness_1_grey_24dp"), color: ColorHelper.getBluePrimary())
        ivTeal.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_brightness_1_grey_24dp"), color: ColorHelper.getTealPrimary())
        ivGreen.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_brightness_1_grey_24dp"), color: ColorHelper.getGreenPrimary())
        ivYellow.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_brightness_1_grey_24dp"), color: ColorHelper.getYellowPrimary())
        ivOrange.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_brightness_1_grey_24dp"), color: ColorHelper.getOrangePrimary())
        ivBrown.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_brightness_1_grey_24dp"), color: ColorHelper.getBrownPrimary())
        ivGrey.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_brightness_1_grey_24dp"), color: ColorHelper.getGreyPrimary())
        switch UDHelper.getTheme() {
        case ThemeHelper.THEME_RED:
            ivRed.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ColorHelper.getRedPrimary())
        case ThemeHelper.THEME_PINK:
            ivPink.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ColorHelper.getPinkPrimary())
        case ThemeHelper.THEME_PURPLE:
            ivPurple.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ColorHelper.getPurplePrimary())
        case ThemeHelper.THEME_INDIGO:
            ivIndigo.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ColorHelper.getIndigoPrimary())
        case ThemeHelper.THEME_BLUE:
            ivBlue.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ColorHelper.getBluePrimary())
        case ThemeHelper.THEME_TEAL:
            ivTeal.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ColorHelper.getTealPrimary())
        case ThemeHelper.THEME_GREEN:
            ivGreen.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ColorHelper.getGreenPrimary())
        case ThemeHelper.THEME_YELLOW:
            ivYellow.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ColorHelper.getYellowPrimary())
        case ThemeHelper.THEME_ORANGE:
            ivOrange.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ColorHelper.getOrangePrimary())
        case ThemeHelper.THEME_BROWN:
            ivBrown.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ColorHelper.getBrownPrimary())
        case ThemeHelper.THEME_GREY:
            ivGrey.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ColorHelper.getGreyPrimary())
        default:
            ivPink.image = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_check_circle_grey_24dp"), color: ColorHelper.getPinkPrimary())
        }
    }
    
    @objc private func targetThemeRed() {
        ThemeHelper.setTheme(ThemeHelper.THEME_RED)
        initTheme()
    }
    
    @objc private func targetThemePink() {
        ThemeHelper.setTheme(ThemeHelper.THEME_PINK)
        initTheme()
    }
    
    @objc private func targetThemePurple() {
        ThemeHelper.setTheme(ThemeHelper.THEME_PURPLE)
        initTheme()
    }
    
    @objc private func targetThemeIndigo() {
        ThemeHelper.setTheme(ThemeHelper.THEME_INDIGO)
        initTheme()
    }
    
    @objc private func targetThemeBlue() {
        ThemeHelper.setTheme(ThemeHelper.THEME_BLUE)
        initTheme()
    }
    
    @objc private func targetThemeTeal() {
        ThemeHelper.setTheme(ThemeHelper.THEME_TEAL)
        initTheme()
    }
    
    @objc private func targetThemeGreen() {
        ThemeHelper.setTheme(ThemeHelper.THEME_GREEN)
        initTheme()
    }
    
    @objc private func targetThemeYellow() {
        ThemeHelper.setTheme(ThemeHelper.THEME_YELLOW)
        initTheme()
    }
    
    @objc private func targetThemeOrange() {
        ThemeHelper.setTheme(ThemeHelper.THEME_ORANGE)
        initTheme()
    }
    
    @objc private func targetThemeBrown() {
        ThemeHelper.setTheme(ThemeHelper.THEME_BROWN)
        initTheme()
    }
    
    @objc private func targetThemeGrey() {
        ThemeHelper.setTheme(ThemeHelper.THEME_GREY)
        initTheme()
    }
    
}
