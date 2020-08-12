//
//  CoupleWallPaperCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/19.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class CoupleWallPaperCell: BaseCollectCell {
    
    // const
    private static let ITEM_MARGIN = ScreenUtils.widthFit(5)
    private static let DEL_MARGIN = ScreenUtils.widthFit(5)
    
    // view
    private var ivBG: UIImageView!
    private var btnDel: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // bg
        ivBG = ViewHelper.getImageViewUrl(width: frame.size.width, height: frame.size.height, indicator: true)
        let shadow = ViewUtils.getViewShadow(ivBG, bgColor: ColorHelper.getWhite(), offset: ViewHelper.SHADOW_NORMAL)
        
        // del
        let imgDel = ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_remove_circle_white_24dp"), color: ColorHelper.getRedDark())
        btnDel = ViewHelper.getBtnImgCenter(paddingH: CoupleWallPaperCell.DEL_MARGIN, paddingV: CoupleWallPaperCell.DEL_MARGIN, bgImg: imgDel)
        btnDel.frame.origin = CGPoint(x: frame.size.width - btnDel.frame.size.width, y: 0)
        
        // view
        self.addSubview(shadow)
        self.addSubview(ivBG)
        self.addSubview(btnDel)
    }
    
    public static func getLayout(margin: CGFloat = ITEM_MARGIN, spanCount: Int = SPAN_COUNT_3) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = getItemSize(margin: margin)
        // collect间隙的margin
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        // collect本身的margin
        layout.sectionInset = UIEdgeInsets.init(top: margin, left: margin, bottom: margin, right: margin)
        return layout
    }
    
    public static func getItemSize(margin: CGFloat = ITEM_MARGIN, spanCount: Int = SPAN_COUNT_3) -> CGSize {
        let topBarHeight = RootVC.get().getTopBarHeight()
        let bottomNavHeight = ScreenUtils.getBottomNavHeight()
        let itemWidth = (ScreenUtils.getScreenWidth() - (margin * 2) - margin * CGFloat(spanCount - 1)) / CGFloat(spanCount)
        let itemHeight = (ScreenUtils.getScreenHeight() - topBarHeight - bottomNavHeight - margin * CGFloat(spanCount + 1)) / CGFloat(spanCount)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    public static func getCellWithData(view: UICollectionView, indexPath: IndexPath, dataList: [String]?, target: Any?, action: Selector) -> CoupleWallPaperCell {
        let cell = view.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath) as! CoupleWallPaperCell
        cell.tag = indexPath.item
        // data
        if dataList == nil || dataList!.count <= cell.tag {
            return cell
        }
        let ossKey = dataList![cell.tag]
        // view
        cell.ivBG.image = nil
        KFHelper.setImgUrl(iv: cell.ivBG, objKey: ossKey)
        cell.btnDel.isHidden = true
        // target
        cell.btnDel.addTarget(target, action: action, for: .touchUpInside)
        return cell
    }
    
    public func setEdit(del: Bool = false) {
        self.btnDel.isHidden = !del
    }
    
    public static func toggleModel(view: UICollectionView?, count: Int = 0, del: Bool) {
        if view == nil || count <= 0 { return }
        for index in 0...(count - 1) {
            if let cell = view?.cellForItem(at: IndexPath(item: index, section: 0)) as? CoupleWallPaperCell {
                cell.setEdit(del: del)
            }
        }
    }
    
}
