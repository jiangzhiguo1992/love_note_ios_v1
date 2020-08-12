//
//  ImgSquareShowCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/1.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit
import MWPhotoBrowser

class ImgSquareShowCell: BaseCollectCell {
    
    // const
    private static let SCROLL_MARGIN = ScreenUtils.widthFit(10)
    private static let CELL_MARGIN = ScreenUtils.widthFit(5)
    
    // view
    private var ivBG: UIImageView!
    private var vLimit: UIView!
    private var lLimit: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // bg
        ivBG = ViewHelper.getImageViewUrl(width: frame.size.width, height: frame.size.height, indicator: true)
        
        // limit
        lLimit = ViewHelper.getLabelWhiteSmall(text: StringUtils.getString("total_holder_paper", arguments: [0]), lines: 1)
        lLimit.frame.origin = CGPoint(x: ScreenUtils.widthFit(5), y: ScreenUtils.heightFit(3))
        
        vLimit = UIView()
        vLimit.frame.size = CGSize(width: lLimit.frame.size.width + lLimit.frame.origin.x * 2, height: lLimit.frame.size.height + lLimit.frame.origin.y * 2)
        vLimit.frame.origin = CGPoint(x: frame.size.width - vLimit.frame.size.width, y: frame.size.height - vLimit.frame.size.height)
        vLimit.backgroundColor = ColorHelper.getBlack50()
        ViewUtils.setViewCorner(vLimit, corner: ViewHelper.RADIUS_NORMAL, round: [UIRectCorner.bottomRight])
        vLimit.addSubview(lLimit)
        
        // view
        self.addSubview(ivBG)
        self.addSubview(vLimit)
        
        // hide
        vLimit.isHidden = true
    }
    
    public static func getLayout(maxWidth: CGFloat = (ScreenUtils.getScreenWidth() - SCROLL_MARGIN * 2), margin: CGFloat = CELL_MARGIN, spanCount: Int = SPAN_COUNT_3) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = getItemSize(maxWidth: maxWidth - 1, margin: margin, spanCount: spanCount) // 为啥要-1??
        // collect间隙的margin
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        // collect本身的margin
        layout.sectionInset = UIEdgeInsets.init(top: margin, left: margin, bottom: margin, right: margin)
        return layout
    }
    
    public static func getItemSize(maxWidth: CGFloat = (ScreenUtils.getScreenWidth() - SCROLL_MARGIN * 2), margin: CGFloat = CELL_MARGIN, spanCount: Int = SPAN_COUNT_3) -> CGSize {
        let itemWidth = spanCount > 1 ? ((maxWidth - margin * CGFloat(spanCount - 1)) / CGFloat(spanCount)) : maxWidth
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    public static func getCollectHeight(collect: UICollectionView?, dataList: [String]?, limit: Int = 0, spanCount: Int = SPAN_COUNT_3) -> CGFloat {
        if collect == nil || dataList == nil || dataList!.count <= 0 {
            return 0
        }
        let dataCount = limit > 0 ? CountHelper.getMin(dataList!.count, limit) : dataList!.count
        let fullLine = dataCount / spanCount
        let line = (dataCount % spanCount) > 0 ? fullLine + 1 : fullLine
        let layout = collect!.collectionViewLayout as! UICollectionViewFlowLayout
        return layout.sectionInset.top + layout.sectionInset.bottom + layout.itemSize.height * CGFloat(line) + layout.minimumLineSpacing * CGFloat(line - 1)
    }
    
    public static func getCellWithData(view: UICollectionView, indexPath: IndexPath, dataList: [String]?, limit: Int = 0) -> ImgSquareShowCell {
        let cell = view.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath) as! ImgSquareShowCell
        cell.tag = indexPath.item
        // data
        if dataList == nil || dataList!.count <= cell.tag {
            return cell
        }
        let ossKey = dataList![cell.tag]
        // view
        cell.ivBG.image = nil
        KFHelper.setImgUrl(iv: cell.ivBG, objKey: ossKey)
        if limit > 0 && dataList!.count > limit && (cell.tag + 1) >= limit {
            cell.vLimit.isHidden = false
            cell.lLimit.text = StringUtils.getString("total_holder_paper", arguments: [dataList!.count])
            AppDelegate.runOnMainAsync {
                let lLimitWidth = ViewUtils.getFontWidth(font: cell.lLimit.font, text: cell.lLimit.text)
                if cell.lLimit.frame.size.width != lLimitWidth {
                    cell.lLimit.frame.size.width = lLimitWidth
                }
                let vLimitWidth = cell.lLimit.frame.size.width + cell.lLimit.frame.origin.x * 2
                if cell.vLimit.frame.size.width != vLimitWidth {
                    cell.vLimit.frame.size.width = vLimitWidth
                }
                let vLimitX = cell.frame.size.width - cell.vLimit.frame.size.width
                if cell.vLimit.frame.origin.x != vLimitX {
                    cell.vLimit.frame.origin.x = vLimitX
                }
            }
        } else {
            cell.vLimit.isHidden = true
        }
        return cell
    }
    
}
