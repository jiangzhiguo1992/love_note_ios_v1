//
//  NotePictureCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/8.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NotePictureCell: BaseCollectCell {
    
    // const
    private static let SCROLL_MARGIN = ScreenUtils.widthFit(5)
    private static let CELL_MARGIN = ScreenUtils.widthFit(5)
    private static let MARGIN_H = ScreenUtils.widthFit(10)
    private static let MARGIN_V = ScreenUtils.heightFit(5)
    
    // view
    private var ivBG: UIImageView!
    private var btnDel: UIButton!
    private var vHappenAt: UIView!
    private var lHappenAt: UILabel!
    private var vLine: UIView!
    private var btnAddress: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let maxWidth = frame.size.width
        let maxHeight = frame.size.height
        
        // bg
        ivBG = ViewHelper.getImageViewUrl(width: maxWidth, height: maxHeight, indicator: true, radius: ViewHelper.RADIUS_SMALL)
        ivBG.frame.origin = CGPoint(x: 0, y: 0)
        ivBG.layer.masksToBounds = true // 不加会超出frame
        let shadow = ViewUtils.getViewShadow(ivBG, bgColor: ColorHelper.getWhite(), offset: ViewHelper.SHADOW_SMALL)
        
        // del
        let imgDel = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_remove_circle_white_24dp"), color: ColorHelper.getRedDark())
        btnDel = ViewHelper.getBtnImgCenter(paddingH: ScreenUtils.widthFit(5), paddingV: ScreenUtils.heightFit(5), bgImg: imgDel)
        btnDel.frame.origin = CGPoint(x: maxWidth - btnDel.frame.size.width, y: 0)
        
        // happenAt
        lHappenAt = ViewHelper.getLabelWhiteSmall(width: maxWidth - NotePictureCell.MARGIN_H * 2, text: "-", lines: 1, align: .left, mode: .byTruncatingMiddle)
        lHappenAt.frame.origin = CGPoint(x: NotePictureCell.MARGIN_H, y: NotePictureCell.MARGIN_V)
        
        vHappenAt = UIView()
        vHappenAt.frame.size = CGSize(width: maxWidth, height: lHappenAt.frame.origin.y * 2 + lHappenAt.frame.size.height)
        vHappenAt.frame.origin = CGPoint(x: 0, y: maxHeight - vHappenAt.frame.size.height)
        vHappenAt.backgroundColor = ThemeHelper.getColorPrimary()
        vHappenAt.addSubview(lHappenAt)
        
        // line
        vLine = ViewHelper.getViewLine(width: maxWidth, color: ColorHelper.getWhite())
        vLine.frame.origin = CGPoint(x: 0, y: vHappenAt.frame.origin.y - vLine.frame.size.height)
        
        btnAddress = ViewHelper.getBtnBGPrimary(width: maxWidth, height: vHappenAt.frame.size.height, HAlign: .left, VAlign: .center, title: "-", titleSize: ViewHelper.FONT_SIZE_SMALL, titleColor: ColorHelper.getFontWhite(), titleLines: 1, titleAlign: .left, titleMode: .byTruncatingMiddle, titleEdgeInsets: UIEdgeInsets(top: 0, left: NotePictureCell.MARGIN_H, bottom: 0, right: NotePictureCell.MARGIN_H), circle: false, shadow: false)
        btnAddress.frame.origin = CGPoint(x: 0, y: vLine.frame.origin.y - btnAddress.frame.size.height)
        
        // view
        self.addSubview(shadow)
        self.addSubview(ivBG)
        self.addSubview(btnDel)
        self.addSubview(vHappenAt)
        self.addSubview(vLine)
        self.addSubview(btnAddress)
        
        // hide
        btnDel.isHidden = true
        vHappenAt.isHidden = true
        vLine.isHidden = true
        btnAddress.isHidden = true
    }
    
    public static func getLayout(maxWidth: CGFloat = ScreenUtils.getScreenWidth() - SCROLL_MARGIN * 2, margin: CGFloat = CELL_MARGIN, spanCount: Int = SPAN_COUNT_3) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = getItemSize(maxWidth: maxWidth, margin: margin, spanCount: spanCount)
        // collect间隙的margin
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        // collect本身的margin
        layout.sectionInset = UIEdgeInsets.init(top: margin, left: margin, bottom: margin, right: margin)
        return layout
    }
    
    private static func getItemSize(maxWidth: CGFloat = ScreenUtils.getScreenWidth() - SCROLL_MARGIN * 2, margin: CGFloat = CELL_MARGIN, spanCount: Int = SPAN_COUNT_3) -> CGSize {
        let itemWidth = spanCount > 1 ? ((maxWidth - margin * CGFloat(spanCount - 1)) / CGFloat(spanCount)) : maxWidth
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    public static func getCellWithData(view: UICollectionView, indexPath: IndexPath, dataList: [Picture]?,
                                       delete: Bool = false, detail: Bool = false,
                                       target: Any?, actionDelete: Selector, actionAddress: Selector) -> NotePictureCell {
        let cell = view.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath) as! NotePictureCell
        cell.tag = indexPath.item
        // data
        if dataList == nil || dataList!.count <= cell.tag {
            return cell
        }
        let picture = dataList![cell.tag]
        // view
        cell.ivBG.image = nil
        KFHelper.setImgUrl(iv: cell.ivBG, objKey: picture.contentImage)
        cell.setModelDelete(open: delete)
        cell.setModelDetail(open: detail, picture: picture)
        // target
        cell.btnDel.addTarget(target, action: actionDelete, for: .touchUpInside)
        cell.btnAddress.addTarget(target, action: actionAddress, for: .touchUpInside)
        return cell
    }
    
    public func setModelDelete(open: Bool = false) {
        self.btnDel.isHidden = !open
    }
    
    public func setModelDetail(open: Bool = false, picture: Picture?) {
        if !open {
            self.vHappenAt.isHidden = true
            self.vLine.isHidden = true
            self.btnAddress.isHidden = true
        } else {
            self.vHappenAt.isHidden = false
            self.vLine.isHidden = StringUtils.isEmpty(picture?.address)
            self.btnAddress.isHidden = StringUtils.isEmpty(picture?.address)
            self.lHappenAt.text = DateUtils.getStr(picture?.happenAt, DateUtils.FORMAT_H_M)
            self.btnAddress.setTitle(picture?.address, for: .normal)
        }
    }
    
    public static func goMap(picture: Picture?) {
        MapShowVC.pushVC(address: picture?.address, lon: picture?.longitude ?? 0, lat: picture?.latitude ?? 0)
    }
    
}
