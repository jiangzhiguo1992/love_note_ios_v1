//
// Created by 蒋治国 on 2018/12/3.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class ViewHelper {
    
    public static let FONT_SIZE_SMALL: CGFloat = ScreenUtils.fontFit(11)
    public static let FONT_SIZE_NORMAL: CGFloat = ScreenUtils.fontFit(14)
    public static let FONT_SIZE_BIG: CGFloat = ScreenUtils.fontFit(17)
    public static let FONT_SIZE_HUGE: CGFloat = ScreenUtils.fontFit(20)
    
    public static let RADIUS_SMALL: CGFloat = ScreenUtils.widthFit(2)
    public static let RADIUS_NORMAL: CGFloat = ScreenUtils.widthFit(5)
    public static let RADIUS_BIG: CGFloat = ScreenUtils.widthFit(10)
    public static let RADIUS_HUGE: CGFloat = ScreenUtils.widthFit(20)
    
    public static let SHADOW_SMALL: CGSize = CGSize(width: 0.5, height: 0.5)
    public static let SHADOW_NORMAL: CGSize = CGSize(width: 1, height: 1)
    public static let SHADOW_BIG: CGSize = CGSize(width: 3, height: 3)
    public static let SHADOW_HUGE: CGSize = CGSize(width: 7, height: 7)
    
    public static let LINE_WEIGHT = 1 / UIScreen.main.scale
    
    public static let FONT_SMALL_LINE_HEIGHT = ViewUtils.getFontHeight(font: ViewUtils.getFont(size: FONT_SIZE_SMALL), width: CGFloat(100), text: "-")
    public static let FONT_NORMAL_LINE_HEIGHT = ViewUtils.getFontHeight(font: ViewUtils.getFont(size: FONT_SIZE_NORMAL), width: CGFloat(100), text: "-")
    public static let FONT_BIG_LINE_HEIGHT = ViewUtils.getFontHeight(font: ViewUtils.getFont(size: FONT_SIZE_BIG), width: CGFloat(100), text: "-")
    public static let FONT_HUGE_LINE_HEIGHT = ViewUtils.getFontHeight(font: ViewUtils.getFont(size: FONT_SIZE_HUGE), width: CGFloat(100), text: "-")
    
    public static let FAB_SIZE = ScreenUtils.widthFit(50)
    public static let FAB_MARGIN = ScreenUtils.widthFit(15)
    
    //-------------------------------------View------------------------------------------------
    
    public static func getViewLine(width: CGFloat = LINE_WEIGHT, height: CGFloat = LINE_WEIGHT, color: UIColor = ColorHelper.getLineGrey()) -> UIView {
        let vLine = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        vLine.backgroundColor = color
        return vLine
    }
    
    public static func addViewLineTop(_ view: UIView?, height: CGFloat = LINE_WEIGHT, color: UIColor = ColorHelper.getLineGrey()) {
        ViewUtils.addViewLineTop(view, height: height, color: color)
    }
    
    public static func addViewLineBottom(_ view: UIView?, height: CGFloat = LINE_WEIGHT, color: UIColor = ColorHelper.getLineGrey()) {
        ViewUtils.addViewLineBottom(view, height: height, color: color)
    }
    
    public static func getGradientPrimaryTrans(frame: CGRect? = nil) -> CAGradientLayer {
        return ViewUtils.getGradientLayer(frame: frame, colors: [ThemeHelper.getColorPrimary().cgColor, ColorHelper.getTrans().cgColor])
    }
    
    public static func getGradientTransPrimary(frame: CGRect? = nil) -> CAGradientLayer {
        return ViewUtils.getGradientLayer(frame: frame, colors: [ColorHelper.getTrans().cgColor, ThemeHelper.getColorPrimary().cgColor])
    }
    
    public static func getGradientPrimaryWhite(frame: CGRect? = nil) -> CAGradientLayer {
        return ViewUtils.getGradientLayer(frame: frame, colors: [ThemeHelper.getColorPrimary().cgColor, ColorHelper.getWhite().cgColor])
    }
    
    //-------------------------------------Label------------------------------------------------
    
    public static func getLabel(width: CGFloat? = nil, height: CGFloat? = nil, text: String?, size: CGFloat? = FONT_SIZE_NORMAL, color: UIColor? = ColorHelper.getFontGrey(), lines: Int = 0, align: NSTextAlignment = .left, mode: NSLineBreakMode = .byCharWrapping) -> UILabel {
        return ViewUtils.getLabel(width: width, height: height, text: text, size: size, color: color, lines: lines, align: align, mode: mode)
    }
    
    public static func getLabelBold(width: CGFloat? = nil, height: CGFloat? = nil, text: String?, size: CGFloat? = FONT_SIZE_NORMAL, color: UIColor? = ColorHelper.getFontGrey(), lines: Int = 0, align: NSTextAlignment = .left, mode: NSLineBreakMode = .byCharWrapping) -> UILabel {
        return ViewUtils.getLabelBold(width: width, height: height, text: text, size: size, color: color, lines: lines, align: align, mode: mode)
    }
    
    public static func getLabelItalic(width: CGFloat? = nil, height: CGFloat? = nil, text: String?, size: CGFloat? = FONT_SIZE_NORMAL, color: UIColor? = ColorHelper.getFontGrey(), lines: Int = 0, align: NSTextAlignment = .left, mode: NSLineBreakMode = .byCharWrapping) -> UILabel {
        return ViewUtils.getLabelItalic(width: width, height: height, text: text, size: size, color: color, lines: lines, align: align, mode: mode)
    }
    
    public static func getLabelPrimarySmall(width: CGFloat? = nil, height: CGFloat? = nil, text: String?, lines: Int = 0, align: NSTextAlignment = .left, mode: NSLineBreakMode = .byCharWrapping) -> UILabel {
        return ViewUtils.getLabel(width: width, height: height, text: text, size: FONT_SIZE_SMALL, color: ThemeHelper.getColorPrimary(), lines: lines, align: align, mode: mode)
    }
    
    public static func getLabelPrimaryNormal(width: CGFloat? = nil, height: CGFloat? = nil, text: String?, lines: Int = 0, align: NSTextAlignment = .left, mode: NSLineBreakMode = .byCharWrapping) -> UILabel {
        return ViewUtils.getLabel(width: width, height: height, text: text, size: FONT_SIZE_NORMAL, color: ThemeHelper.getColorPrimary(), lines: lines, align: align, mode: mode)
    }
    
    public static func getLabelPrimaryBig(width: CGFloat? = nil, height: CGFloat? = nil, text: String?, lines: Int = 0, align: NSTextAlignment = .left, mode: NSLineBreakMode = .byCharWrapping) -> UILabel {
        return ViewUtils.getLabel(width: width, height: height, text: text, size: FONT_SIZE_BIG, color: ThemeHelper.getColorPrimary(), lines: lines, align: align, mode: mode)
    }
    
    public static func getLabelPrimaryHuge(width: CGFloat? = nil, height: CGFloat? = nil, text: String?, lines: Int = 0, align: NSTextAlignment = .left, mode: NSLineBreakMode = .byCharWrapping) -> UILabel {
        return ViewUtils.getLabel(width: width, height: height, text: text, size: FONT_SIZE_HUGE, color: ThemeHelper.getColorPrimary(), lines: lines, align: align, mode: mode)
    }
    
    public static func getLabelBlackSmall(width: CGFloat? = nil, height: CGFloat? = nil, text: String?, lines: Int = 0, align: NSTextAlignment = .left, mode: NSLineBreakMode = .byCharWrapping) -> UILabel {
        return ViewUtils.getLabel(width: width, height: height, text: text, size: FONT_SIZE_SMALL, color: ColorHelper.getFontBlack(), lines: lines, align: align, mode: mode)
    }
    
    public static func getLabelBlackNormal(width: CGFloat? = nil, height: CGFloat? = nil, text: String?, lines: Int = 0, align: NSTextAlignment = .left, mode: NSLineBreakMode = .byCharWrapping) -> UILabel {
        return ViewUtils.getLabel(width: width, height: height, text: text, size: FONT_SIZE_NORMAL, color: ColorHelper.getFontBlack(), lines: lines, align: align, mode: mode)
    }
    
    public static func getLabelBlackBig(width: CGFloat? = nil, height: CGFloat? = nil, text: String?, lines: Int = 0, align: NSTextAlignment = .left, mode: NSLineBreakMode = .byCharWrapping) -> UILabel {
        return ViewUtils.getLabel(width: width, height: height, text: text, size: FONT_SIZE_BIG, color: ColorHelper.getFontBlack(), lines: lines, align: align, mode: mode)
    }
    
    public static func getLabelBlackHuge(width: CGFloat? = nil, height: CGFloat? = nil, text: String?, lines: Int = 0, align: NSTextAlignment = .left, mode: NSLineBreakMode = .byCharWrapping) -> UILabel {
        return ViewUtils.getLabel(width: width, height: height, text: text, size: FONT_SIZE_HUGE, color: ColorHelper.getFontBlack(), lines: lines, align: align, mode: mode)
    }
    
    public static func getLabelGreySmall(width: CGFloat? = nil, height: CGFloat? = nil, text: String?, lines: Int = 0, align: NSTextAlignment = .left, mode: NSLineBreakMode = .byCharWrapping) -> UILabel {
        return ViewUtils.getLabel(width: width, height: height, text: text, size: FONT_SIZE_SMALL, color: ColorHelper.getFontGrey(), lines: lines, align: align, mode: mode)
    }
    
    public static func getLabelGreyNormal(width: CGFloat? = nil, height: CGFloat? = nil, text: String?, lines: Int = 0, align: NSTextAlignment = .left, mode: NSLineBreakMode = .byCharWrapping) -> UILabel {
        return ViewUtils.getLabel(width: width, height: height, text: text, size: FONT_SIZE_NORMAL, color: ColorHelper.getFontGrey(), lines: lines, align: align, mode: mode)
    }
    
    public static func getLabelGreyBig(width: CGFloat? = nil, height: CGFloat? = nil, text: String?, lines: Int = 0, align: NSTextAlignment = .left, mode: NSLineBreakMode = .byCharWrapping) -> UILabel {
        return ViewUtils.getLabel(width: width, height: height, text: text, size: FONT_SIZE_BIG, color: ColorHelper.getFontGrey(), lines: lines, align: align, mode: mode)
    }
    
    public static func getLabelGreyHuge(width: CGFloat? = nil, height: CGFloat? = nil, text: String?, lines: Int = 0, align: NSTextAlignment = .left, mode: NSLineBreakMode = .byCharWrapping) -> UILabel {
        return ViewUtils.getLabel(width: width, height: height, text: text, size: FONT_SIZE_HUGE, color: ColorHelper.getFontGrey(), lines: lines, align: align, mode: mode)
    }
    
    public static func getLabelWhiteSmall(width: CGFloat? = nil, height: CGFloat? = nil, text: String?, lines: Int = 0, align: NSTextAlignment = .left, mode: NSLineBreakMode = .byCharWrapping) -> UILabel {
        return ViewUtils.getLabel(width: width, height: height, text: text, size: FONT_SIZE_SMALL, color: ColorHelper.getFontWhite(), lines: lines, align: align, mode: mode)
    }
    
    public static func getLabelWhiteNormal(width: CGFloat? = nil, height: CGFloat? = nil, text: String?, lines: Int = 0, align: NSTextAlignment = .left, mode: NSLineBreakMode = .byCharWrapping) -> UILabel {
        return ViewUtils.getLabel(width: width, height: height, text: text, size: FONT_SIZE_NORMAL, color: ColorHelper.getFontWhite(), lines: lines, align: align, mode: mode)
    }
    
    public static func getLabelWhiteBig(width: CGFloat? = nil, height: CGFloat? = nil, text: String?, lines: Int = 0, align: NSTextAlignment = .left, mode: NSLineBreakMode = .byCharWrapping) -> UILabel {
        return ViewUtils.getLabel(width: width, height: height, text: text, size: FONT_SIZE_BIG, color: ColorHelper.getFontWhite(), lines: lines, align: align, mode: mode)
    }
    
    public static func getLabelWhiteHuge(width: CGFloat? = nil, height: CGFloat? = nil, text: String?, lines: Int = 0, align: NSTextAlignment = .left, mode: NSLineBreakMode = .byCharWrapping) -> UILabel {
        return ViewUtils.getLabel(width: width, height: height, text: text, size: FONT_SIZE_HUGE, color: ColorHelper.getFontWhite(), lines: lines, align: align, mode: mode)
    }
    
    //-------------------------------------Button------------------------------------------------
    
    public static func getBtn(type: UIButton.ButtonType = .system,
                              width: CGFloat? = nil, height: CGFloat? = nil, paddingH: CGFloat? = nil, paddingV: CGFloat? = nil,
                              HAlign: UIControl.ContentHorizontalAlignment = .center, VAlign: UIControl.ContentVerticalAlignment = .center,
                              bgColor: UIColor = ColorHelper.getTrans(), bgImg: UIImage? = nil, imgMode: UIView.ContentMode = .center,
                              title: String? = nil, titleSize: CGFloat? = FONT_SIZE_NORMAL, titleColor: UIColor? = ThemeHelper.getColorPrimary(),
                              titleLines: Int = 1, titleAlign: NSTextAlignment = .center, titleMode: NSLineBreakMode = .byCharWrapping,
                              titleEdgeInsets: UIEdgeInsets? = nil, circle: Bool = false, shadow: Bool = false) -> UIButton {
        let btn = ViewUtils.getButton(type: type, width: width, height: height, paddingH: paddingH, paddingV: paddingV, HAlign: HAlign, VAlign: VAlign, bgColor: bgColor, bgImg: bgImg, imgMode: imgMode, title: title, titleSize: titleSize, titleColor: titleColor, titleLines: titleLines, titleAlign: titleAlign, titleMode: titleMode, titleEdgeInsets: titleEdgeInsets)
        if circle {
            ViewUtils.setViewRadiusCircle(btn)
        }
        if shadow {
            ViewUtils.setViewShadow(btn, offset: ViewHelper.SHADOW_NORMAL)
        }
        return btn
    }
    
    public static func getBtnImgCenter(type: UIButton.ButtonType = .system,
                                       width: CGFloat? = nil, height: CGFloat? = nil, paddingH: CGFloat? = nil, paddingV: CGFloat? = nil,
                                       bgColor: UIColor = ColorHelper.getTrans(), bgImg: UIImage? = nil,
                                       circle: Bool = false, shadow: Bool = false) -> UIButton {
        let btn = ViewUtils.getButton(type: type, width: width, height: height, paddingH: paddingH, paddingV: paddingV, HAlign: .center, VAlign: .center, bgColor: bgColor, bgImg: bgImg, imgMode: .center, font: nil)
        if circle {
            ViewUtils.setViewRadiusCircle(btn)
        }
        if shadow {
            ViewUtils.setViewShadow(btn, offset: ViewHelper.SHADOW_NORMAL)
        }
        return btn
    }
    
    public static func getBtnImgFit(type: UIButton.ButtonType = .system,
                                    width: CGFloat? = nil, height: CGFloat? = nil, paddingH: CGFloat? = nil, paddingV: CGFloat? = nil,
                                    bgColor: UIColor = ColorHelper.getTrans(), bgImg: UIImage? = nil,
                                    circle: Bool = false, shadow: Bool = false) -> UIButton {
        let btn = ViewUtils.getButton(type: type, width: width, height: height, paddingH: paddingH, paddingV: paddingV, HAlign: .fill, VAlign: .fill, bgColor: bgColor, bgImg: bgImg, imgMode: .scaleAspectFill, font: nil)
        if circle {
            ViewUtils.setViewRadiusCircle(btn)
        }
        if shadow {
            ViewUtils.setViewShadow(btn, offset: ViewHelper.SHADOW_NORMAL)
        }
        return btn
    }
    
    public static func getBtnBold(type: UIButton.ButtonType = .system,
                                  width: CGFloat? = nil, height: CGFloat? = nil, paddingH: CGFloat? = nil, paddingV: CGFloat? = nil,
                                  HAlign: UIControl.ContentHorizontalAlignment = .center, VAlign: UIControl.ContentVerticalAlignment = .center,
                                  bgColor: UIColor = ColorHelper.getTrans(), bgImg: UIImage? = nil, imgMode: UIView.ContentMode = .center,
                                  title: String? = nil, titleSize: CGFloat? = FONT_SIZE_NORMAL, titleColor: UIColor? = ThemeHelper.getColorPrimary(),
                                  titleLines: Int = 1, titleAlign: NSTextAlignment = .center, titleMode: NSLineBreakMode = .byCharWrapping,
                                  titleEdgeInsets: UIEdgeInsets? = nil, circle: Bool = false, shadow: Bool = false) -> UIButton {
        let btn = ViewUtils.getButtonBold(type: type, width: width, height: height, paddingH: paddingH, paddingV: paddingV, HAlign: HAlign, VAlign: VAlign, bgColor: bgColor, bgImg: bgImg, imgMode: imgMode, title: title, titleSize: titleSize, titleColor: titleColor, titleLines: titleLines, titleAlign: titleAlign, titleMode: titleMode, titleEdgeInsets: titleEdgeInsets)
        if circle {
            ViewUtils.setViewRadiusCircle(btn)
        }
        if shadow {
            ViewUtils.setViewShadow(btn, offset: ViewHelper.SHADOW_NORMAL)
        }
        return btn
    }
    
    public static func getButtonItalic(type: UIButton.ButtonType = .system,
                                       width: CGFloat? = nil, height: CGFloat? = nil, paddingH: CGFloat? = nil, paddingV: CGFloat? = nil,
                                       HAlign: UIControl.ContentHorizontalAlignment = .center, VAlign: UIControl.ContentVerticalAlignment = .center,
                                       bgColor: UIColor = ColorHelper.getTrans(), bgImg: UIImage? = nil, imgMode: UIView.ContentMode = .center,
                                       title: String? = nil, titleSize: CGFloat? = FONT_SIZE_NORMAL, titleColor: UIColor? = ThemeHelper.getColorPrimary(),
                                       titleLines: Int = 1, titleAlign: NSTextAlignment = .center, titleMode: NSLineBreakMode = .byCharWrapping,
                                       titleEdgeInsets: UIEdgeInsets? = nil, circle: Bool = false, shadow: Bool = false) -> UIButton {
        let btn = ViewUtils.getButtonItalic(type: type, width: width, height: height, paddingH: paddingH, paddingV: paddingV, HAlign: HAlign, VAlign: VAlign, bgColor: bgColor, bgImg: bgImg, imgMode: imgMode, title: title, titleSize: titleSize, titleColor: titleColor, titleLines: titleLines, titleAlign: titleAlign, titleMode: titleMode, titleEdgeInsets: titleEdgeInsets)
        if circle {
            ViewUtils.setViewRadiusCircle(btn)
        }
        if shadow {
            ViewUtils.setViewShadow(btn, offset: ViewHelper.SHADOW_NORMAL)
        }
        return btn
    }
    
    public static func getBtnTextPrimary(type: UIButton.ButtonType = .system,
                                         width: CGFloat? = nil, height: CGFloat? = nil, paddingH: CGFloat? = nil, paddingV: CGFloat? = nil,
                                         HAlign: UIControl.ContentHorizontalAlignment = .center, VAlign: UIControl.ContentVerticalAlignment = .center,
                                         title: String? = nil, titleSize: CGFloat? = FONT_SIZE_NORMAL,
                                         titleLines: Int = 1, titleAlign: NSTextAlignment = .center, titleMode: NSLineBreakMode = .byCharWrapping,
                                         titleEdgeInsets: UIEdgeInsets? = nil, circle: Bool = false, shadow: Bool = false) -> UIButton {
        let btn = ViewUtils.getButton(type: type, width: width, height: height, paddingH: paddingH, paddingV: paddingV, HAlign: HAlign, VAlign: VAlign, title: title, titleSize: titleSize, titleColor: ThemeHelper.getColorPrimary(), titleLines: titleLines, titleAlign: titleAlign, titleMode: titleMode, titleEdgeInsets: titleEdgeInsets)
        if circle {
            ViewUtils.setViewRadiusCircle(btn)
        }
        if shadow {
            ViewUtils.setViewShadow(btn, offset: ViewHelper.SHADOW_NORMAL)
        }
        return btn
    }
    
    public static func getBtnTextBlack(type: UIButton.ButtonType = .system,
                                       width: CGFloat? = nil, height: CGFloat? = nil, paddingH: CGFloat? = nil, paddingV: CGFloat? = nil,
                                       HAlign: UIControl.ContentHorizontalAlignment = .center, VAlign: UIControl.ContentVerticalAlignment = .center,
                                       title: String? = nil, titleSize: CGFloat? = FONT_SIZE_NORMAL,
                                       titleLines: Int = 1, titleAlign: NSTextAlignment = .center, titleMode: NSLineBreakMode = .byCharWrapping,
                                       titleEdgeInsets: UIEdgeInsets? = nil, circle: Bool = false, shadow: Bool = false) -> UIButton {
        let btn = ViewUtils.getButton(type: type, width: width, height: height, paddingH: paddingH, paddingV: paddingV, HAlign: HAlign, VAlign: VAlign, title: title, titleSize: titleSize, titleColor: ColorHelper.getFontBlack(), titleLines: titleLines, titleAlign: titleAlign, titleMode: titleMode, titleEdgeInsets: titleEdgeInsets)
        if circle {
            ViewUtils.setViewRadiusCircle(btn)
        }
        if shadow {
            ViewUtils.setViewShadow(btn, offset: ViewHelper.SHADOW_NORMAL)
        }
        return btn
    }
    
    public static func getBtnTextGrey(type: UIButton.ButtonType = .system,
                                      width: CGFloat? = nil, height: CGFloat? = nil, paddingH: CGFloat? = nil, paddingV: CGFloat? = nil,
                                      HAlign: UIControl.ContentHorizontalAlignment = .center, VAlign: UIControl.ContentVerticalAlignment = .center,
                                      title: String? = nil, titleSize: CGFloat? = FONT_SIZE_NORMAL,
                                      titleLines: Int = 1, titleAlign: NSTextAlignment = .center, titleMode: NSLineBreakMode = .byCharWrapping,
                                      titleEdgeInsets: UIEdgeInsets? = nil, circle: Bool = false, shadow: Bool = false) -> UIButton {
        let btn = ViewUtils.getButton(type: type, width: width, height: height, paddingH: paddingH, paddingV: paddingV, HAlign: HAlign, VAlign: VAlign, title: title, titleSize: titleSize, titleColor: ColorHelper.getFontGrey(), titleLines: titleLines, titleAlign: titleAlign, titleMode: titleMode, titleEdgeInsets: titleEdgeInsets)
        if circle {
            ViewUtils.setViewRadiusCircle(btn)
        }
        if shadow {
            ViewUtils.setViewShadow(btn, offset: ViewHelper.SHADOW_NORMAL)
        }
        return btn
    }
    
    public static func getBtnBGPrimary(type: UIButton.ButtonType = .system,
                                       width: CGFloat? = nil, height: CGFloat? = nil, paddingH: CGFloat? = nil, paddingV: CGFloat? = nil,
                                       HAlign: UIControl.ContentHorizontalAlignment = .center, VAlign: UIControl.ContentVerticalAlignment = .center,
                                       title: String? = nil, titleSize: CGFloat? = FONT_SIZE_NORMAL, titleColor: UIColor? = ColorHelper.getFontWhite(),
                                       titleLines: Int = 1, titleAlign: NSTextAlignment = .center, titleMode: NSLineBreakMode = .byCharWrapping,
                                       titleEdgeInsets: UIEdgeInsets? = nil, circle: Bool = false, shadow: Bool = true) -> UIButton {
        let btn = ViewUtils.getButton(type: type, width: width, height: height, paddingH: paddingH, paddingV: paddingV, HAlign: HAlign, VAlign: VAlign, bgColor: ThemeHelper.getColorPrimary(), title: title, titleSize: titleSize, titleColor: titleColor, titleLines: titleLines, titleAlign: titleAlign, titleMode: titleMode, titleEdgeInsets: titleEdgeInsets)
        if circle {
            ViewUtils.setViewRadiusCircle(btn)
        }
        if shadow {
            ViewUtils.setViewShadow(btn, offset: ViewHelper.SHADOW_NORMAL)
        }
        return btn
    }
    
    public static func getBtnBGWhite(type: UIButton.ButtonType = .system,
                                     width: CGFloat? = nil, height: CGFloat? = nil, paddingH: CGFloat? = nil, paddingV: CGFloat? = nil,
                                     HAlign: UIControl.ContentHorizontalAlignment = .center, VAlign: UIControl.ContentVerticalAlignment = .center,
                                     title: String? = nil, titleSize: CGFloat? = FONT_SIZE_NORMAL, titleColor: UIColor? = ThemeHelper.getColorPrimary(),
                                     titleLines: Int = 1, titleAlign: NSTextAlignment = .center, titleMode: NSLineBreakMode = .byCharWrapping,
                                     titleEdgeInsets: UIEdgeInsets? = nil, circle: Bool = false, shadow: Bool = true) -> UIButton {
        let btn = ViewUtils.getButton(type: type, width: width, height: height, paddingH: paddingH, paddingV: paddingV, HAlign: HAlign, VAlign: VAlign, bgColor: ColorHelper.getWhite(), title: title, titleSize: titleSize, titleColor: titleColor, titleLines: titleLines, titleAlign: titleAlign, titleMode: titleMode, titleEdgeInsets: titleEdgeInsets)
        if circle {
            ViewUtils.setViewRadiusCircle(btn)
        }
        if shadow {
            ViewUtils.setViewShadow(btn, offset: ViewHelper.SHADOW_NORMAL)
        }
        return btn
    }
    
    public static func getBtnBGTrans(type: UIButton.ButtonType = .system,
                                     width: CGFloat? = nil, height: CGFloat? = nil, paddingH: CGFloat? = nil, paddingV: CGFloat? = nil,
                                     HAlign: UIControl.ContentHorizontalAlignment = .center, VAlign: UIControl.ContentVerticalAlignment = .center,
                                     title: String? = nil, titleSize: CGFloat? = FONT_SIZE_NORMAL, titleColor: UIColor? = ColorHelper.getFontGrey(),
                                     titleLines: Int = 1, titleAlign: NSTextAlignment = .center, titleMode: NSLineBreakMode = .byCharWrapping,
                                     titleEdgeInsets: UIEdgeInsets? = nil, circle: Bool = false, shadow: Bool = false) -> UIButton {
        let btn = ViewUtils.getButton(type: type, width: width, height: height, paddingH: paddingH, paddingV: paddingV, HAlign: HAlign, VAlign: VAlign, bgColor: ColorHelper.getTrans(), title: title, titleSize: titleSize, titleColor: titleColor, titleLines: titleLines, titleAlign: titleAlign, titleMode: titleMode, titleEdgeInsets: titleEdgeInsets)
        if circle {
            ViewUtils.setViewRadiusCircle(btn)
        }
        if shadow {
            ViewUtils.setViewShadow(btn, offset: ViewHelper.SHADOW_NORMAL)
        }
        return btn
    }
    
    //-------------------------------------ImageView------------------------------------------------
    
    public static func getImageView(img: UIImage? = nil, width: CGFloat? = nil, height: CGFloat? = nil,
                                    mode: UIView.ContentMode = .center, bg: UIColor? = ColorHelper.getTrans()) -> UIImageView {
        return ViewUtils.getImageView(img: img, width: width, height: height, mode: mode, bg: bg)
    }
    
    public static func getImageViewUrl(width: CGFloat?, height: CGFloat?, indicator: Bool = true, radius: CGFloat = RADIUS_NORMAL) -> UIImageView {
        var iv = ViewUtils.getImageView(width: width, height: height, mode: .scaleAspectFill, bg: ColorHelper.getTrans())
        // indicator
        if indicator {
            let indicatorSize = CountHelper.getMin((width ?? ScreenUtils.widthFit(40)) / 4, (height ?? ScreenUtils.widthFit(40)) / 4)
            iv.kf.indicatorType = .custom(indicator: KFURLIndicator(size: CGSize(width: indicatorSize, height: indicatorSize)))
        }
        // radius
        if radius > 0 {
            ViewUtils.setViewRadius(iv, radius: radius, bounds: true)
        }
        return iv
    }
    
    public static func getImageViewAvatar(width: CGFloat?, height: CGFloat?) -> UIImageView {
        let iv = ViewUtils.getImageView(width: width, height: height, mode: .scaleAspectFill, bg: ColorHelper.getTrans())
        // radius
        ViewUtils.setViewRadiusCircle(iv, bounds: true)
        return iv
    }
    
    //-------------------------------------TextFiled------------------------------------------------
    
    public static func getTextField(width: CGFloat? = nil, height: CGFloat? = nil, paddingH: CGFloat? = nil, paddingV: CGFloat? = nil,
                                    text: String? = nil, textSize: CGFloat? = FONT_SIZE_NORMAL, textColor: UIColor? = ColorHelper.getFontBlack(),
                                    placeholder: String? = nil, placeColor: UIColor? = ColorHelper.getFontHint(),
                                    horizontalAlign: NSTextAlignment = .left, verticalAlign: UIControl.ContentVerticalAlignment = .center,
                                    keyboardType: UIKeyboardType = .default, pwd: Bool = false, borderStyle: UITextField.BorderStyle = .none) -> UITextField {
        return ViewUtils.getTextField(width: width, height: height, paddingH: paddingH, paddingV: paddingV, text: text, textSize: textSize, textColor: textColor, placeholder: placeholder, placeColor: placeColor, horizontalAlign: horizontalAlign, verticalAlign: verticalAlign, keyboardType: keyboardType, pwd: pwd, borderStyle: borderStyle)
    }
    
    //-------------------------------------TextView------------------------------------------------
    
    public static func getTextView(width: CGFloat? = nil, height: CGFloat? = nil, paddingH: CGFloat? = nil, paddingV: CGFloat? = nil,
                                   text: String? = nil, textSize: CGFloat? = FONT_SIZE_NORMAL, textColor: UIColor? = ColorHelper.getFontGrey(),
                                   placeholder: String = "", placeColor: UIColor? = ColorHelper.getFontHint(),
                                   limitLength: Int = -1, limitSize: CGFloat? = FONT_SIZE_SMALL, limitColor: UIColor? = ColorHelper.getFontGrey(),
                                   align: NSTextAlignment = .left, keyboardType: UIKeyboardType = .default, pwd: Bool = false,
                                   radius: CGFloat = 0, borderWidth: CGFloat = 0, boredrColor: UIColor = UIColor.lightGray) -> UITextView {
        return ViewUtils.getTextView(width: width, height: height, paddingH: paddingH, paddingV: paddingV, text: text, textSize: textSize, textColor: textColor, placeholder: placeholder, placeColor: placeColor, limitLength: limitLength, limitSize: limitSize, limitColor: limitColor, align: align, keyboardType: keyboardType, pwd: pwd, radius: radius, borderWidth: borderWidth, boredrColor: boredrColor)
    }
    
    //-------------------------------------Switch-----------------------------------------------
    
    public static func getSwitch(tintColor: UIColor? = ThemeHelper.getColorPrimary()) -> UISwitch {
        return ViewUtils.getSwitch(tintColor: tintColor)
    }
    
    //----------------------------------SegmentedControl--------------------------------------------
    
    public static func getSegmentedControl(width: CGFloat? = nil, height: CGFloat? = nil, items: [Any]?, tintColor: UIColor? = ThemeHelper.getColorPrimary(),
                                           titleSize: CGFloat? = FONT_SIZE_NORMAL,  multiLine: Bool = false) -> UISegmentedControl {
        return ViewUtils.getSegmentedControl(width: width, height: height, items: items, tintColor: tintColor, titleSize: titleSize, multiLine: multiLine)
    }
    
    //-------------------------------------SearchBar------------------------------------------------
    
    public static func getSearchBar(delegate: UISearchBarDelegate? = nil, frame: CGRect? = nil, barColor: UIColor? = ThemeHelper.getColorPrimary(), btnColor: UIColor? = ColorHelper.getWhite(), placeholder: String? = nil) -> UISearchBar {
        return ViewUtils.getSearchBar(delegate: delegate, frame: frame, barColor: barColor, btnColor: btnColor, placeholder: placeholder)
    }
    
}
