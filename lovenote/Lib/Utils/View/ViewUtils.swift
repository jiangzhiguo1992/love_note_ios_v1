//
// Created by 蒋治国 on 2018-12-18.
// Copyright (c) 2018 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class ViewUtils {
    
    //-------------------------------------VC------------------------------------------------
    
    // 根据storyboard获取VC name是sb的名称 id是xib的名称
    public static func getVC(name: String, id: String) -> UIViewController {
        return UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: id)
    }
    
    public static func getVcView(name: String, id: String) -> UIView {
        return getVC(name: name, id: id).view
    }
    
    public static func showVC(root: UIViewController?, show: UIViewController?, completion: (() -> Void)? = nil) {
        if show == nil {
            return
        }
        root?.present(show!, animated: true, completion: completion)
    }
    
    public static func disVC(root: UIViewController?, completion: (() -> Void)? = nil) {
        root?.presentedViewController?.dismiss(animated: true, completion: completion)
    }
    
    public static func getSuperVC(view: UIView?) -> UIViewController? {
        if view == nil {
            return nil
        }
        var next = view!.superview
        while (next != nil) {
            let nextResponder = next?.next
            if (nextResponder is UIViewController) {
                return nextResponder as? UIViewController
            }
            next = next?.superview
        }
        return nil
    }
    
    //-------------------------------------View------------------------------------------------
    
    public static func getSubViews(subviews: [UIView]?) -> [UIView] {
        var returnViews = [UIView]()
        if subviews == nil {
            return returnViews
        }
        for sub in subviews! {
            // 检查当前view
            returnViews += [sub]
            // 遍历view的子view
            let sub2Views = sub.subviews
            if sub2Views.isEmpty {
                continue
            }
            returnViews += getSubViews(subviews: sub2Views)
        }
        return returnViews
    }
    
    // border
    public static func setViewBorder(_ view: UIView?, width: CGFloat = 1, color: UIColor = UIColor.black, isImg: Bool = false) {
        if isImg {
            view?.layer.masksToBounds = true
        }
        view?.layer.borderColor = color.cgColor
        view?.layer.borderWidth = width
    }
    
    // radius
    public static func setViewRadiusCircle(_ view: UIView?, bounds: Bool = false) {
        setViewRadius(view, radius: (view?.frame.size.height ?? 0) / 2, bounds: bounds)
    }
    
    public static func setViewRadius(_ view: UIView?, radius: CGFloat?, bounds: Bool = false) {
        if bounds {
            view?.layer.masksToBounds = true
        }
        view?.layer.cornerRadius = radius ?? 0
    }
    
    public static func setViewCorner(_ view: UIView?, corner: CGFloat?, round: UIRectCorner?) {
        if view == nil || corner == nil || round == nil {
            return
        }
        let maskPath = UIBezierPath(roundedRect: view!.bounds, byRoundingCorners: round!, cornerRadii: CGSize(width: corner!, height: corner!))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view!.bounds
        maskLayer.path = maskPath.cgPath
        view?.layer.mask = maskLayer
    }
    
    // shadow
    public static func getViewShadow(_ view: UIView?, radius: CGFloat? = nil, bgColor: UIColor? = nil,
                                     offset: CGSize = CGSize(width: 1, height: 1), color: UIColor = UIColor.black, opacity: Float = 0.2) -> UIView {
        let shadowView = UIView()
        if view == nil {
            return shadowView
        }
        shadowView.frame = view!.frame
        shadowView.layer.masksToBounds = false
        
        let corner = radius ?? view!.layer.cornerRadius
        shadowView.layer.backgroundColor = bgColor?.cgColor
        shadowView.layer.cornerRadius = corner
        
        if corner <= 0 {
            setViewShadow(layer: shadowView.layer, offset: offset, color: color, opacity: opacity)
        } else {
            setViewShadow(layer: shadowView.layer, round: [UIRectCorner.topLeft, UIRectCorner.bottomLeft, UIRectCorner.topRight, UIRectCorner.bottomRight], radius: corner, offset: offset, color: color, opacity: opacity)
        }
        return shadowView
    }
    
    public static func setViewShadow(_ view: UIView?, offset: CGSize = CGSize(width: 1, height: 1), color: UIColor = UIColor.black, opacity: Float = 0.2) {
        let radius = view?.layer.cornerRadius ?? 0
        if radius <= 0 {
            setViewShadow(layer: view?.layer, offset: offset, color: color, opacity: opacity)
        } else {
            setViewShadow(layer: view?.layer, round: [UIRectCorner.topLeft, UIRectCorner.bottomLeft, UIRectCorner.topRight, UIRectCorner.bottomRight], radius: radius, offset: offset, color: color, opacity: opacity)
        }
    }
    
    public static func setViewShadow(layer: CALayer?, round: UIRectCorner? = nil, radius: CGFloat? = 0,
                                     offset: CGSize = CGSize(width: 1, height: 1), color: UIColor = UIColor.black, opacity: Float = 0.2) {
        if layer == nil { return }
        if round == nil {
            if radius == nil {
                layer?.shadowPath = UIBezierPath(rect: layer!.bounds).cgPath
            } else {
                layer?.shadowPath = UIBezierPath(roundedRect: layer!.bounds, cornerRadius: radius!).cgPath
            }
        } else {
            layer?.shadowPath = UIBezierPath(roundedRect: layer!.bounds, byRoundingCorners: round!, cornerRadii: CGSize(width: radius ?? 3, height: radius ?? 3)).cgPath
        }
        layer?.shadowOffset = offset
        // layer?.shadowRadius = radius ?? 0 // 这里再用会失效
        layer?.shadowColor = color.cgColor
        layer?.shadowOpacity = opacity
    }
    
    // other
    public static func addViewLineTop(_ view: UIView?, height: CGFloat = 0.2, color: UIColor = UIColor.black) {
        if view == nil {
            return
        }
        let line = UIView(frame: CGRect(x: 0, y: 0, width: view!.frame.size.width, height: height))
        line.backgroundColor = color
        view?.addSubview(line)
    }
    
    public static func addViewLineBottom(_ view: UIView?, height: CGFloat = 0.2, color: UIColor = UIColor.black) {
        if view == nil {
            return
        }
        let line = UIView(frame: CGRect(x: 0, y: view!.frame.size.height - height, width: view!.frame.size.width, height: height))
        line.backgroundColor = color
        view?.addSubview(line)
    }
    
    public static func addViewTapTarget(target: Any?, view: UIView?, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        tapGesture.numberOfTapsRequired = 1
        view?.isUserInteractionEnabled = true
        view?.addGestureRecognizer(tapGesture)
    }
    
    public static func getGradientLayer(frame: CGRect? = nil, colors: [Any]?) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        if frame != nil {
            gradientLayer.frame = frame!
        }
        gradientLayer.colors = colors
        return gradientLayer
    }
    
    //-------------------------------------Font------------------------------------------------
    
    public static func getFont(size: CGFloat, weight: UIFont.Weight? = nil) -> UIFont {
        if weight == nil {
            return UIFont.systemFont(ofSize: size)
        } else {
            return UIFont.systemFont(ofSize: size, weight: weight!)
        }
    }
    
    public static func getFontBold(size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size)
    }
    
    public static func getFontItalic(size: CGFloat) -> UIFont {
        return UIFont.italicSystemFont(ofSize: size)
    }
    
    public static func getFontHeight(font: UIFont?, width: CGFloat?, text: String?) -> CGFloat {
        if font == nil || width == nil || StringUtils.isEmpty(text) {
            return 0
        }
        let size = text!.boundingRect(with: CGSize(width: width!, height: CGFloat(MAXFLOAT)),
                                      options: .usesLineFragmentOrigin,
                                      attributes: [NSAttributedString.Key.font: font!],
                                      context: nil).size
        return size.height + 0.1 // 这是为啥
    }
    
    public static func getFontWidth(font: UIFont?, text: String?) -> CGFloat {
        if font == nil || StringUtils.isEmpty(text) {
            return 0
        }
        let size = text!.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)),
                                      options: .usesLineFragmentOrigin,
                                      attributes: [NSAttributedString.Key.font: font!],
                                      context: nil).size
        return size.width + 0.1 // 这是为啥
    }
    
    //-------------------------------------Image------------------------------------------------
    
    public static func getImageWithTintColor(img: UIImage?, color: UIColor?) -> UIImage {
        if img == nil {
            return UIImage()
        } else if color == nil {
            return img!
        }
        UIGraphicsBeginImageContextWithOptions(img!.size, false, img!.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: img!.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(.normal)
        let rect = CGRect(x: 0, y: 0, width: img!.size.width, height: img!.size.height)
        context?.clip(to: rect, mask: img!.cgImage!);
        color!.setFill()
        context?.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? img!
    }
    
    public static func getImageByView(_ view: UIView) -> UIImage? {
        UIGraphicsBeginImageContext(view.bounds.size)
        let ctx = UIGraphicsGetCurrentContext()
        if ctx == nil {
            return nil
        }
        view.layer.render(in: ctx!)
        let tImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tImage
    }
    
    public static func fixImageOrientation(_ aImage: UIImage) -> (Bool, UIImage) {
        if (aImage.imageOrientation == .up) {
            return (false, aImage)
        }
        var transform = CGAffineTransform.identity
        switch (aImage.imageOrientation) {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: aImage.size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: aImage.size.height)
            transform = transform.rotated(by: -(CGFloat.pi / 2))
        default:
            break
        }
        switch (aImage.imageOrientation) {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: aImage.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        if aImage.cgImage == nil {
            return (false, aImage)
        }
        let cgImage = aImage.cgImage!
        let ctx = CGContext(data: nil,
                            width: Int(aImage.size.width),
                            height: Int(aImage.size.height),
                            bitsPerComponent: cgImage.bitsPerComponent,
                            bytesPerRow: 0,
                            space: cgImage.colorSpace!,
                            bitmapInfo: cgImage.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        switch (aImage.imageOrientation) {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(cgImage, in: CGRect(x: 0, y: 0, width: aImage.size.height, height: aImage.size.width))
        default:
            ctx?.draw(cgImage, in: CGRect(x: 0, y: 0, width: aImage.size.width, height: aImage.size.height))
        }
        // And now we just create a new UIImage from the drawing context
        let cgImg = ctx?.makeImage()
        if cgImg == nil {
            return (false, aImage)
        }
        return (true, UIImage(cgImage: cgImg!))
    }
    
    //-------------------------------------Alert------------------------------------------------
    
    public static func getAlert(style: UIAlertController.Style = .alert, title: String? = nil, msg: String? = nil,
                                cancel: String?, confirm: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: style)
        addAlertAction(alert: alert, title: cancel, style: .cancel)
        addAlertAction(alert: alert, title: confirm, style: .default, handler: handler)
        return alert
    }
    
    public static func showAlert(root: UIViewController?, style: UIAlertController.Style = .alert, title: String? = nil, msg: String? = nil,
                                 cancel: String?, confirm: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = getAlert(style: style, title: title, msg: msg, cancel: cancel, confirm: confirm, handler: handler)
        ViewUtils.showVC(root: root, show: alert)
        return alert
    }
    
    public static func addAlertEdit(alert: UIAlertController?, config: ((UITextField) -> Void)? = nil) {
        alert?.addTextField(configurationHandler: config)
    }
    
    public static func addAlertAction(alert: UIAlertController?, title: String?, style: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> Void)? = nil) {
        if StringUtils.isEmpty(title) {
            return
        }
        let action = UIAlertAction(title: title, style: style, handler: handler)
        alert?.addAction(action)
    }
    
    //-------------------------------------Indicator------------------------------------------------
    
    public static func getIndicator(style: UIActivityIndicatorView.Style = .gray, width: CGFloat? = nil, height: CGFloat? = nil,
                                    color: UIColor? = nil, bgColor: UIColor? = nil, radius: CGFloat? = nil) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: style)
        if width == nil || height == nil {
            indicator.sizeToFit()
        }
        if width != nil {
            indicator.frame.size.width = width!
        }
        if height != nil {
            indicator.frame.size.height = height!
        }
        if color != nil {
            indicator.color = color!
        }
        if bgColor != nil {
            indicator.backgroundColor = bgColor!
        }
        indicator.hidesWhenStopped = true // 停止转圈圈时，隐藏
        setViewRadius(indicator, radius: radius)
        return indicator
    }
    
    public static func showIndicator(_ view: UIActivityIndicatorView?) {
        if !(view?.isAnimating ?? false) {
            view?.startAnimating()
        }
    }
    
    public static func disIndicator(_ view: UIActivityIndicatorView?) {
        if view?.isAnimating ?? true {
            view?.stopAnimating()
        }
    }
    
    //-------------------------------------Label------------------------------------------------
    
    public static func getLabel(width: CGFloat? = nil, height: CGFloat? = nil,
                                text: String?, size: CGFloat? = nil, color: UIColor? = nil,
                                lines: Int = 0, align: NSTextAlignment = .left, mode: NSLineBreakMode = .byCharWrapping) -> UILabel {
        var font: UIFont?
        if size == nil {
            font = nil
        } else {
            font = getFont(size: size!)
        }
        return getLabel(width: width, height: height, text: text, font: font, color: color, lines: lines, align: align, mode: mode)
    }
    
    public static func getLabelBold(width: CGFloat? = nil, height: CGFloat? = nil,
                                    text: String?, size: CGFloat? = nil, color: UIColor? = nil,
                                    lines: Int = 0, align: NSTextAlignment = .left, mode: NSLineBreakMode = .byCharWrapping) -> UILabel {
        var font: UIFont?
        if size == nil {
            font = nil
        } else {
            font = getFontBold(size: size!)
        }
        return getLabel(width: width, height: height, text: text, font: font, color: color, lines: lines, align: align, mode: mode)
    }
    
    public static func getLabelItalic(width: CGFloat? = nil, height: CGFloat? = nil,
                                      text: String?, size: CGFloat? = nil, color: UIColor? = nil,
                                      lines: Int = 0, align: NSTextAlignment = .left, mode: NSLineBreakMode = .byCharWrapping) -> UILabel {
        var font: UIFont?
        if size == nil {
            font = nil
        } else {
            font = getFontItalic(size: size!)
        }
        return getLabel(width: width, height: height, text: text, font: font, color: color, lines: lines, align: align, mode: mode)
    }
    
    public static func getLabel(width: CGFloat? = nil, height: CGFloat? = nil,
                                text: String?, font: UIFont? = nil, color: UIColor? = nil,
                                lines: Int = 0, align: NSTextAlignment = .left, mode: NSLineBreakMode = .byCharWrapping) -> UILabel {
        let label = UILabel()
        label.text = text
        if font != nil {
            label.font = font
        }
        if color != nil {
            label.textColor = color
        }
        label.numberOfLines = lines
        label.textAlignment = align
        label.lineBreakMode = mode
        // size
        if width != nil && height != nil {
            label.frame.size = CGSize(width: width!, height: height!)
        } else if width != nil && height == nil {
            label.frame.size.width = width!
            label.frame.size.height = getFontHeight(font: label.font, width: label.frame.size.width, text: label.text)
        } else if width == nil && height != nil {
            label.frame.size.width = getFontWidth(font: label.font, text: label.text)
            label.frame.size.height = height!
        } else {
            label.sizeToFit()
        }
        return label
    }
    
    public static func addLabelLineBottom(label: UILabel?) {
        if label == nil || label?.text == nil {
            return
        }
        let attributedString = NSMutableAttributedString(string: label!.text!)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        label?.attributedText = attributedString
    }
    
    //-------------------------------------Button------------------------------------------------
    
    public static func getButton(type: UIButton.ButtonType = .system,
                                 width: CGFloat? = nil, height: CGFloat? = nil, paddingH: CGFloat? = nil, paddingV: CGFloat? = nil,
                                 HAlign: UIControl.ContentHorizontalAlignment = .center, VAlign: UIControl.ContentVerticalAlignment = .center,
                                 bgColor: UIColor? = nil, bgImg: UIImage? = nil, imgMode: UIView.ContentMode = .center,
                                 title: String? = nil, titleSize: CGFloat? = nil, titleColor: UIColor? = nil,
                                 titleLines: Int = 1, titleAlign: NSTextAlignment = .center, titleMode: NSLineBreakMode = .byCharWrapping,
                                 titleEdgeInsets: UIEdgeInsets? = nil) -> UIButton {
        var font: UIFont?
        if titleSize == nil {
            font = nil
        } else {
            font = getFont(size: titleSize!)
        }
        return getButton(type: type, width: width, height: height, paddingH: paddingH, paddingV: paddingV, HAlign: HAlign, VAlign: VAlign, bgColor: bgColor, bgImg: bgImg, imgMode: imgMode, title: title, font: font, titleColor: titleColor, titleLines: titleLines, titleAlign: titleAlign, titleMode: titleMode, titleEdgeInsets: titleEdgeInsets)
    }
    
    public static func getButtonBold(type: UIButton.ButtonType = .system,
                                     width: CGFloat? = nil, height: CGFloat? = nil, paddingH: CGFloat? = nil, paddingV: CGFloat? = nil,
                                     HAlign: UIControl.ContentHorizontalAlignment = .center, VAlign: UIControl.ContentVerticalAlignment = .center,
                                     bgColor: UIColor? = nil, bgImg: UIImage? = nil, imgMode: UIView.ContentMode = .center,
                                     title: String? = nil, titleSize: CGFloat? = nil, titleColor: UIColor? = nil,
                                     titleLines: Int = 1, titleAlign: NSTextAlignment = .center, titleMode: NSLineBreakMode = .byCharWrapping,
                                     titleEdgeInsets: UIEdgeInsets? = nil) -> UIButton {
        var font: UIFont?
        if titleSize == nil {
            font = nil
        } else {
            font = getFontBold(size: titleSize!)
        }
        return getButton(type: type, width: width, height: height, paddingH: paddingH, paddingV: paddingV, HAlign: HAlign, VAlign: VAlign, bgColor: bgColor, bgImg: bgImg, imgMode: imgMode, title: title, font: font, titleColor: titleColor, titleLines: titleLines, titleAlign: titleAlign, titleMode: titleMode, titleEdgeInsets: titleEdgeInsets)
    }
    
    public static func getButtonItalic(type: UIButton.ButtonType = .system,
                                       width: CGFloat? = nil, height: CGFloat? = nil, paddingH: CGFloat? = nil, paddingV: CGFloat? = nil,
                                       HAlign: UIControl.ContentHorizontalAlignment = .center, VAlign: UIControl.ContentVerticalAlignment = .center,
                                       bgColor: UIColor? = nil, bgImg: UIImage? = nil, imgMode: UIView.ContentMode = .center,
                                       title: String? = nil, titleSize: CGFloat? = nil, titleColor: UIColor? = nil,
                                       titleLines: Int = 1, titleAlign: NSTextAlignment = .center, titleMode: NSLineBreakMode = .byCharWrapping,
                                       titleEdgeInsets: UIEdgeInsets? = nil) -> UIButton {
        var font: UIFont?
        if titleSize == nil {
            font = nil
        } else {
            font = getFontItalic(size: titleSize!)
        }
        return getButton(type: type, width: width, height: height, paddingH: paddingH, paddingV: paddingV, HAlign: HAlign, VAlign: VAlign, bgColor: bgColor, bgImg: bgImg, imgMode: imgMode, title: title, font: font, titleColor: titleColor, titleLines: titleLines, titleAlign: titleAlign, titleMode: titleMode, titleEdgeInsets: titleEdgeInsets)
    }
    
    public static func getButton(type: UIButton.ButtonType = .system,
                                 width: CGFloat? = nil, height: CGFloat? = nil, paddingH: CGFloat? = nil, paddingV: CGFloat? = nil,
                                 HAlign: UIControl.ContentHorizontalAlignment = .center, VAlign: UIControl.ContentVerticalAlignment = .center,
                                 bgColor: UIColor? = nil, bgImg: UIImage? = nil, imgMode: UIView.ContentMode = .center,
                                 title: String? = nil, font: UIFont? = nil, titleColor: UIColor? = nil,
                                 titleLines: Int = 1, titleAlign: NSTextAlignment = .center, titleMode: NSLineBreakMode = .byCharWrapping,
                                 titleEdgeInsets: UIEdgeInsets? = nil) -> UIButton {
        let btn = UIButton(type: type)
        if bgColor != nil {
            btn.backgroundColor = bgColor
        }
        btn.contentHorizontalAlignment = HAlign
        btn.contentVerticalAlignment = VAlign
        // img
        if bgImg != nil {
            btn.setImage(bgImg?.withRenderingMode(.alwaysOriginal), for: .normal)
            btn.imageView?.contentMode = imgMode
            btn.adjustsImageWhenHighlighted = false
            btn.adjustsImageWhenDisabled = false
        }
        // title
        btn.setTitle(title, for: .normal)
        if font != nil {
            btn.titleLabel?.font = font
        }
        if titleColor != nil {
            btn.setTitleColor(titleColor, for: .normal)
        }
        btn.titleLabel?.numberOfLines = titleLines
        btn.titleLabel?.textAlignment = titleAlign
        btn.titleLabel?.lineBreakMode = titleMode
        if titleEdgeInsets != nil {
            btn.titleEdgeInsets = titleEdgeInsets!
        }
        // size
        if width != nil && height != nil {
            btn.frame.size = CGSize(width: width! + (paddingH ?? 0) * 2, height: height! + (paddingV ?? 0) * 2)
        } else if width != nil && height == nil {
            btn.frame.size.width = width! + (paddingH ?? 0) * 2
            btn.frame.size.height = btn.sizeThatFits(CGSize(width: btn.frame.size.width, height: CGFloat(MAXFLOAT))).height + (paddingV ?? 0) * 2
        } else if width == nil && height != nil {
            btn.frame.size.height = height! + (paddingV ?? 0) * 2
            btn.frame.size.width = btn.sizeThatFits(CGSize(width: CGFloat(MAXFLOAT), height: btn.frame.size.height)).width + (paddingH ?? 0) * 2
        } else {
            btn.sizeToFit()
            btn.frame.size.width += (paddingH ?? 0) * 2
            btn.frame.size.height += (paddingV ?? 0) * 2
        }
        return btn
    }
    
    //-------------------------------------ImageView------------------------------------------------
    
    public static func getImageView(width: CGFloat? = nil, height: CGFloat? = nil,
                                    mode: UIView.ContentMode = .center, bg: UIColor? = UIColor.clear) -> UIImageView {
        let imgView = UIImageView()
        if width != nil {
            imgView.frame.size.width = width!
        }
        if height != nil {
            imgView.frame.size.height = height!
        }
        imgView.contentMode = mode
        imgView.backgroundColor = bg
        return imgView
    }
    
    public static func getImageView(img: UIImage?, width: CGFloat? = nil, height: CGFloat? = nil,
                                    mode: UIView.ContentMode = .center, bg: UIColor? = UIColor.clear) -> UIImageView {
        if img == nil {
            return getImageView(width: width, height: height, mode: mode, bg: bg)
        }
        let imgView = UIImageView(image: img)
        imgView.contentMode = mode
        imgView.backgroundColor = bg
        // size
        if width != nil && height != nil {
            imgView.frame.size = CGSize(width: width!, height: height!)
        } else if width != nil && height == nil {
            imgView.frame.size.width = width!
            imgView.frame.size.height = imgView.sizeThatFits(CGSize(width: width!, height: CGFloat(MAXFLOAT))).height
        } else if width == nil && height != nil {
            imgView.frame.size.width = imgView.sizeThatFits(CGSize(width: CGFloat(MAXFLOAT), height: height!)).width
            imgView.frame.size.height = height!
        } else {
            imgView.sizeToFit()
        }
        return imgView
    }
    
    public static func getImageView(url: String?, width: CGFloat? = nil, height: CGFloat? = nil,
                                    mode: UIView.ContentMode = .scaleAspectFill, bg: UIColor? = UIColor.white) -> UIImageView {
        if StringUtils.isEmpty(url) {
            return getImageView(width: width, height: height, mode: mode, bg: bg)
        }
        let data = try! Data(contentsOf: URL(string: url!)!)
        let smallImage = UIImage(data: data)
        return getImageView(img: smallImage, width: width, height: height, mode: mode, bg: bg)
    }
    
    //-------------------------------------TextFiled------------------------------------------------
    
    public static func getTextField(width: CGFloat? = nil, height: CGFloat? = nil, paddingH: CGFloat? = nil, paddingV: CGFloat? = nil,
                                    text: String? = nil, textSize: CGFloat? = nil, textColor: UIColor? = nil,
                                    placeholder: String? = nil, placeColor: UIColor? = nil,
                                    horizontalAlign: NSTextAlignment = .left, verticalAlign: UIControl.ContentVerticalAlignment = .center,
                                    keyboardType: UIKeyboardType = .default, pwd: Bool = false, borderStyle: UITextField.BorderStyle = .none) -> UITextField {
        var font: UIFont?
        if textSize == nil {
            font = nil
        } else {
            font = getFont(size: textSize!)
        }
        return getTextField(width: width, height: height, paddingH: paddingH, paddingV: paddingV, text: text, font: font, textColor: textColor, placeholder: placeholder, placeColor: placeColor, horizontalAlign: horizontalAlign, verticalAlign: verticalAlign, keyboardType: keyboardType, pwd: pwd, borderStyle: borderStyle)
    }
    
    public static func getTextField(width: CGFloat? = nil, height: CGFloat? = nil, paddingH: CGFloat? = nil, paddingV: CGFloat? = nil,
                                    text: String? = nil, font: UIFont? = nil, textColor: UIColor? = nil,
                                    placeholder: String? = nil, placeColor: UIColor? = nil,
                                    horizontalAlign: NSTextAlignment = .left, verticalAlign: UIControl.ContentVerticalAlignment = .center,
                                    keyboardType: UIKeyboardType = .default, pwd: Bool = false, borderStyle: UITextField.BorderStyle = .none) -> UITextField {
        let textField = UITextField()
        textField.text = text
        if font != nil {
            textField.font = font
        }
        if textColor != nil {
            textField.textColor = textColor!
        }
        // placeHolder
        setTextFiledPlaceholder(textField: textField, placeholder: placeholder, placeColor: placeColor)
        // size
        if width != nil && height != nil {
            textField.frame.size = CGSize(width: width! + (paddingH ?? 0) * 2, height: height! + (paddingV ?? 0) * 2)
        } else if width != nil && height == nil {
            textField.frame.size.width = width! + (paddingH ?? 0) * 2
            textField.frame.size.height = textField.sizeThatFits(CGSize(width: textField.frame.size.width, height: CGFloat(MAXFLOAT))).height + (paddingV ?? 0) * 2
        } else if width == nil && height != nil {
            textField.frame.size.height = height! + (paddingV ?? 0) * 2
            textField.frame.size.width = textField.sizeThatFits(CGSize(width: CGFloat(MAXFLOAT), height: textField.frame.size.height)).width + (paddingH ?? 0) * 2
        } else {
            textField.sizeToFit()
            textField.frame.size.width += (paddingH ?? 0) * 2
            textField.frame.size.height += (paddingV ?? 0) * 2
        }
        // other
        textField.textAlignment = horizontalAlign
        textField.contentVerticalAlignment = verticalAlign
        textField.adjustsFontSizeToFitWidth = false
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = pwd
        textField.borderStyle = borderStyle
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.keyboardAppearance = .default
        textField.spellCheckingType = .default
        textField.autocorrectionType = .default
        textField.autocapitalizationType = .sentences
        return textField
    }
    
    public static func setTextFiledPlaceholder(textField: UITextField?, placeholder: String? = nil, placeColor: UIColor? = nil) {
        if textField == nil {
            return
        }
        if placeholder != nil {
            if placeColor != nil {
                textField!.attributedPlaceholder = NSAttributedString.init(string: placeholder!, attributes: [NSAttributedString.Key.foregroundColor: placeColor!])
            } else {
                textField!.attributedPlaceholder = NSAttributedString.init(string: placeholder!)
            }
        }
    }
    
    public static func addTextFiledLeftView(_ view: UITextField?, left: UIView?) {
        view?.leftViewMode = .always
        view?.leftView = left
    }
    
    public static func addTextFiledLeftView(_ view: UITextField?, left: String) {
        addTextFiledLeftView(view, left: UIImageView(image: UIImage(named: left)))
    }
    
    public static func addTextFiledRightView(_ view: UITextField?, right: UIView?) {
        view?.rightViewMode = .always
        view?.rightView = right
    }
    
    public static func addTextFiledRightView(_ view: UITextField?, right: String) {
        addTextFiledRightView(view, right: UIImageView(image: UIImage(named: right)))
    }
    
    //-------------------------------------TextView------------------------------------------------
    
    public static func getTextView(width: CGFloat? = nil, height: CGFloat? = nil, paddingH: CGFloat? = nil, paddingV: CGFloat? = nil,
                                   text: String? = nil, textSize: CGFloat? = nil, textColor: UIColor? = nil,
                                   placeholder: String = "", placeColor: UIColor? = nil,
                                   limitLength: Int = -1, limitSize: CGFloat? = nil, limitColor: UIColor? = nil,
                                   align: NSTextAlignment = .left, keyboardType: UIKeyboardType = .default, pwd: Bool = false,
                                   radius: CGFloat = 0, borderWidth: CGFloat = 0, boredrColor: UIColor = UIColor.lightGray) -> UITextView {
        var font: UIFont?
        if textSize == nil {
            font = nil
        } else {
            font = getFont(size: textSize!)
        }
        var limitFont: UIFont?
        if limitSize == nil {
            limitFont = nil
        } else {
            limitFont = getFont(size: limitSize!)
        }
        return ViewUtils.getTextView(width: width, height: height, paddingH: paddingH, paddingV: paddingV, text: text, font: font, textColor: textColor, placeholder: placeholder, placeColor: placeColor, limitLength: limitLength, limitFont: limitFont, limitColor: limitColor, align: align, keyboardType: keyboardType, pwd: pwd, radius: radius, borderWidth: borderWidth, boredrColor: boredrColor)
    }
    
    public static func getTextView(width: CGFloat? = nil, height: CGFloat? = nil, paddingH: CGFloat? = nil, paddingV: CGFloat? = nil,
                                   text: String? = nil, font: UIFont? = nil, textColor: UIColor? = nil,
                                   placeholder: String = "", placeColor: UIColor? = nil,
                                   limitLength: Int = -1, limitFont: UIFont? = nil, limitColor: UIColor? = nil,
                                   align: NSTextAlignment = .left, keyboardType: UIKeyboardType = .default, pwd: Bool = false,
                                   radius: CGFloat = 0, borderWidth: CGFloat = 0, boredrColor: UIColor = UIColor.lightGray) -> UITextView {
        let textView = UITextView()
        textView.text = text
        if font != nil {
            textView.font = font
        }
        if textColor != nil {
            textView.textColor = textColor!
        }
        
        if width != nil && height != nil {
            textView.frame.size = CGSize(width: width!, height: height!)
        } else if width != nil && height == nil {
            textView.frame.size.width = width!
            textView.frame.size.height = textView.sizeThatFits(CGSize(width: width!, height: CGFloat(MAXFLOAT))).height
        } else if width == nil && height != nil {
            textView.frame.size.width = textView.sizeThatFits(CGSize(width: CGFloat(MAXFLOAT), height: height!)).width
            textView.frame.size.height = height!
        } else {
            textView.sizeToFit()
        }
        
        // placeholder
        textView.placeholder = placeholder + "   "
        if font != nil {
            textView.placeholdFont = font
        }
        textView.placeholdColor = placeColor
        
        // limit
        if limitLength > 0 {
            textView.limitLength = NSNumber(value: limitLength)
        }
        if limitFont != nil {
            textView.limitLabelFont = limitFont
        }
        textView.limitLabelColor = limitColor
        
        // base
        textView.textAlignment = align
        textView.keyboardType = keyboardType
        textView.isSecureTextEntry = pwd
        textView.textContainer.lineFragmentPadding = paddingH ?? 0
        textView.textContainerInset = UIEdgeInsets(top: paddingV ?? 0, left: paddingH ?? 0, bottom: paddingV ?? 0, right: paddingH ?? 0)
        
        // border
        textView.layer.cornerRadius = radius
        textView.layer.borderWidth = borderWidth
        textView.layer.borderColor = boredrColor.cgColor
        
        // other
        textView.isEditable = true
        textView.isSelectable = true
        textView.isScrollEnabled = true
        textView.dataDetectorTypes = []
        textView.returnKeyType = .next
        textView.keyboardAppearance = .default
        textView.spellCheckingType = .default
        textView.autocorrectionType = .default
        textView.autocapitalizationType = .sentences
        return textView
    }
    
    //-------------------------------------Picker------------------------------------------------
    
    // Picker
    public static func getPicker(target: UIPickerViewDelegate & UIPickerViewDataSource,  width: CGFloat? = nil, height: CGFloat? = nil, tintColor: UIColor? = nil) -> UIPickerView {
        let picker = UIPickerView()
        picker.delegate = target
        picker.dataSource = target
        if width != nil && height != nil {
            picker.frame.size = CGSize(width: width!, height: height!)
        } else if width != nil && height == nil {
            picker.frame.size.width = width!
            picker.frame.size.height = picker.sizeThatFits(CGSize(width: width!, height: CGFloat(MAXFLOAT))).height
        } else if width == nil && height != nil {
            picker.frame.size.width = picker.sizeThatFits(CGSize(width: CGFloat(MAXFLOAT), height: height!)).width
            picker.frame.size.height = height!
        } else {
            picker.sizeToFit()
        }
        picker.tintColor = tintColor
        return picker
    }
    
    // DatePicker
    public static func getDatePicker(width: CGFloat? = nil, height: CGFloat? = nil, mode: UIDatePicker.Mode = .date, date: Date? = nil) -> UIDatePicker {
        let picker = UIDatePicker()
        
        if width != nil && height != nil {
            picker.frame.size = CGSize(width: width!, height: height!)
        } else if width != nil && height == nil {
            picker.frame.size.width = width!
            picker.frame.size.height = picker.sizeThatFits(CGSize(width: width!, height: CGFloat(MAXFLOAT))).height
        } else if width == nil && height != nil {
            picker.frame.size.width = picker.sizeThatFits(CGSize(width: CGFloat(MAXFLOAT), height: height!)).width
            picker.frame.size.height = height!
        } else {
            picker.sizeToFit()
        }
        
        picker.datePickerMode = mode
        picker.calendar = Calendar.current
        picker.timeZone = TimeZone.current
        if date != nil {
            picker.date = date!
        }
        return picker
    }
    
    //-------------------------------------Switch-----------------------------------------------
    
    public static func getSwitch(tintColor: UIColor? = nil) -> UISwitch {
        let s = UISwitch()
        s.tintColor = tintColor
        s.onTintColor = tintColor
        return s
    }
    
    //----------------------------------SegmentedControl--------------------------------------------
    
    public static func getSegmentedControl(width: CGFloat? = nil, height: CGFloat? = nil, items: [Any]? = [], tintColor: UIColor? = nil,
                                           titleSize: CGFloat? = nil, multiLine: Bool = false) -> UISegmentedControl {
        var font: UIFont?
        if titleSize == nil {
            font = nil
        } else {
            font = getFont(size: titleSize!)
        }
        return getSegmentedControl(width: width, height: height, items: items, tintColor: tintColor, font: font, multiLine: multiLine)
    }
    
    public static func getSegmentedControl(width: CGFloat? = nil, height: CGFloat? = nil, items: [Any]? = [], tintColor: UIColor? = nil,
                                           font: UIFont? = nil, multiLine: Bool = false) -> UISegmentedControl {
        let sc = UISegmentedControl(items: items)
        if font != nil {
            sc.setTitleTextAttributes([NSAttributedString.Key.font: font!], for: .normal)
        }
        
        if width != nil && height != nil {
            sc.frame.size = CGSize(width: width!, height: height!)
        } else if width != nil && height == nil {
            sc.frame.size.width = width!
            sc.frame.size.height = sc.sizeThatFits(CGSize(width: width!, height: CGFloat(MAXFLOAT))).height
        } else if width == nil && height != nil {
            sc.frame.size.width = sc.sizeThatFits(CGSize(width: CGFloat(MAXFLOAT), height: height!)).width
            sc.frame.size.height = height!
        } else {
            sc.sizeToFit()
        }
        
        if tintColor != nil {
            sc.tintColor = tintColor!
        }
        sc.selectedSegmentIndex = 0
        if multiLine {
            for subView in sc.subviews {
                if NSStringFromClass(subView.classForCoder).contains("UISegment") {
                    for segmentSubview in subView.subviews {
                        if NSStringFromClass(segmentSubview.classForCoder).contains("UISegmentLabel") {
                            let label = segmentSubview as? UILabel
                            label?.numberOfLines = 0
                        }
                    }
                }
            }
        }
        return sc
    }
    
    //-------------------------------------SearchBar------------------------------------------------
    
    public static func getSearchBar(delegate: UISearchBarDelegate? = nil, frame: CGRect? = nil, barColor: UIColor? = nil, btnColor: UIColor? = nil, placeholder: String? = nil) -> UISearchBar {
        let search: UISearchBar!
        if frame == nil {
            search = UISearchBar()
        } else {
            search = UISearchBar(frame: frame!)
            if search.frame.size.height <= 0 {
                search.sizeToFit()
            }
        }
        if delegate != nil {
            search.delegate  = delegate
        }
        // search.barPosition
        search.barStyle = .default
        search.searchBarStyle = .default
        search.barTintColor = barColor
        search.tintColor = btnColor
        search.placeholder = placeholder
        // search.prompt = "提示"
        
        search.enablesReturnKeyAutomatically = true
        search.isSecureTextEntry = false
        search.isTranslucent = true
        
        search.showsCancelButton = true
        //search.showsScopeBar = false
        //search.showsBookmarkButton = false
        //search.showsSearchResultsButton = false
        return search
    }
    
    //-------------------------------------Scroll------------------------------------------------
    
    public static func getScroll(frame: CGRect? = nil, contentSize: CGSize? = nil,
                                 page: Bool = false,
                                 indicator: Bool = false, indicatorStyle: UIScrollView.IndicatorStyle = .black) -> UIScrollView {
        let scroll: UIScrollView!
        if frame == nil {
            scroll = UIScrollView()
        } else {
            scroll = UIScrollView(frame: frame!)
        }
        //内容大小
        if contentSize != nil {
            scroll.contentSize = contentSize!
        }
        //可以上下滚动
        scroll.isScrollEnabled = true
        //点状态栏回到最上方
        scroll.scrollsToTop = true
        //反弹效果
        scroll.bounces = true
        //分页显示
        scroll.isPagingEnabled = page
        //水平/垂直滚动条是否可见
        scroll.showsVerticalScrollIndicator = indicator
        scroll.showsHorizontalScrollIndicator = indicator
        //滚动条颜色
        scroll.indicatorStyle = indicatorStyle
        //如果正显示着键盘，拖动，则键盘撤回
        scroll.keyboardDismissMode = .onDrag
        //内容就算小于它，也能拖
        //                scroll.alwaysBounceVertical = true
        //                scroll.alwaysBounceHorizontal = true
        //实现两指缩放与扩大
        //        scroll.minimumZoomScale = 0.5
        //        scroll.maximumZoomScale = 1.6
        //超过放大范围再弹回来
        //        scroll.bouncesZoom = true
        return scroll
    }
    
    public static func beginScrollRefresh(_ scroll: UIScrollView?) {
        if scroll == nil {
            return
        }
        if !(scroll!.refreshControl?.isRefreshing ?? false) {
            scroll!.refreshControl?.beginRefreshing()
        }
    }
    
    public static func endScrollRefresh(_ scroll: UIScrollView?) {
        if scroll == nil {
            return
        }
        if (scroll!.refreshControl?.isRefreshing ?? true) {
            scroll!.refreshControl?.endRefreshing()
        }
    }
    
    //-------------------------------------TableView------------------------------------------------
    
    public static func getTableView(target: UITableViewDelegate & UITableViewDataSource,
                                    frame: CGRect, style: UITableView.Style = .plain, bgColor: UIColor = UIColor.clear,
                                    cellCls: AnyClass?, id: String) -> UITableView {
        let tableView = UITableView(frame: frame, style: style)
        tableView.delegate = target
        tableView.dataSource = target
        tableView.backgroundColor = bgColor
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.register(cellCls, forCellReuseIdentifier: id)
        
        //可以上下滚动
        tableView.isScrollEnabled = true
        //点状态栏回到最上方
        tableView.scrollsToTop = true
        //反弹效果
        tableView.bounces = true
        //分页显示
        tableView.isPagingEnabled = false
        //水平/垂直滚动条是否可见
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        //如果正显示着键盘，拖动，则键盘撤回
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }
    
    public static func findSuperTableCell(view: UIView?) -> UITableViewCell? {
        var cell: UITableViewCell? = nil
        var cellSuperView = view
        while let superview = cellSuperView?.superview {
            cellSuperView = superview
            if let cellOK = cellSuperView as? UITableViewCell {
                cellSuperView = cellOK
                cell = cellOK
                break
            }
        }
        return cell
    }
    
    public static func findSuperTable(view: UIView?) -> UITableView? {
        var tableView : UITableView? = nil
        var tableSuperView = view
        while let superview = tableSuperView?.superview {
            tableSuperView = superview
            if let tableOK = superview as? UITableView {
                tableView = tableOK
                break
            }
        }
        return tableView
    }
    
    public static func findTableIndexPath(view: UIView?) -> IndexPath? {
        if let cell = findSuperTableCell(view: view) {
            if let table = findSuperTable(view: cell) {
                return table.indexPath(for: cell)
            }
        }
        return nil
    }
    
    //-------------------------------------CollectView------------------------------------------------
    
    public static func getCollectionView(target: UICollectionViewDelegate & UICollectionViewDataSource,
                                         frame: CGRect, layout: UICollectionViewLayout, bgColor: UIColor = UIColor.clear,
                                         cellCls: AnyClass?, id: String = "cell") -> UICollectionView {
        let collectView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectView.delegate = target
        collectView.dataSource = target
        collectView.backgroundColor = bgColor
        collectView.register(cellCls, forCellWithReuseIdentifier: id)
        
        //可以上下滚动
        collectView.isScrollEnabled = true
        //点状态栏回到最上方
        collectView.scrollsToTop = true
        //反弹效果
        collectView.bounces = true
        //分页显示
        collectView.isPagingEnabled = false
        //水平/垂直滚动条是否可见
        collectView.showsVerticalScrollIndicator = false
        collectView.showsHorizontalScrollIndicator = false
        //如果正显示着键盘，拖动，则键盘撤回
        collectView.keyboardDismissMode = .onDrag
        return collectView
    }
    
    public static func findSuperCollectCell(view: UIView?) -> UICollectionViewCell? {
        var cell: UICollectionViewCell? = nil
        var cellSuperView = view
        while let superview = cellSuperView?.superview {
            cellSuperView = superview
            if let cellOK = cellSuperView as? UICollectionViewCell {
                cellSuperView = cellOK
                cell = cellOK
                break
            }
        }
        return cell
    }
    
    public static func findSuperCollect(view: UIView?) -> UICollectionView? {
        var tableView : UICollectionView? = nil
        var tableSuperView = view
        while let superview = tableSuperView?.superview {
            tableSuperView = superview
            if let tableOK = superview as? UICollectionView {
                tableView = tableOK
                break
            }
        }
        return tableView
    }
    
    public static func findCollectIndexPath(view: UIView?) -> IndexPath? {
        if let cell = findSuperCollectCell(view: view) {
            if let collect = findSuperCollect(view: cell) {
                return collect.indexPath(for: cell)
            }
        }
        return nil
    }
    
}
