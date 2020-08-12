//
//  TopicHomeKindCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/28.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class TopicHomeKindCell: BaseCollectCell {
    
    // const
    private static let CELL_MARGIN = ScreenUtils.widthFit(5)
    private static let ITEM_MARGIN = ScreenUtils.widthFit(5)
    
    // view
    private var ivKind: UIImageView!
    private var lName: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let maxWidth = frame.size.width
        let maxHeight = frame.size.height
        let maxContentWidth = maxWidth - TopicHomeKindCell.ITEM_MARGIN * 2
        let maxContentHeight = maxHeight - TopicHomeKindCell.ITEM_MARGIN * 2
        
        // name
        lName = ViewHelper.getLabelBold(width: maxContentWidth, text: "-", size: ViewHelper.FONT_SIZE_NORMAL, color: ColorHelper.getFontGrey(), lines: 1, align: .center, mode: .byTruncatingMiddle)
        
        // kind
        let kindHeight = maxContentHeight - lName.frame.size.height - TopicHomeKindCell.ITEM_MARGIN
        ivKind = ViewHelper.getImageView(img: nil, width: maxContentWidth, height: kindHeight, mode: .scaleAspectFit)
        ivKind.frame.origin = CGPoint(x: TopicHomeKindCell.ITEM_MARGIN, y: TopicHomeKindCell.ITEM_MARGIN)
        lName.frame.origin = CGPoint(x: TopicHomeKindCell.ITEM_MARGIN, y: ivKind.frame.origin.y + ivKind.frame.size.height + TopicHomeKindCell.ITEM_MARGIN)
        
        // card
        let vCard = UIView()
        vCard.frame.size = CGSize(width: maxWidth, height: maxHeight)
        vCard.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vCard, radius: ViewHelper.RADIUS_BIG)
        vCard.addSubview(ivKind)
        vCard.addSubview(lName)
        
        // view
        self.addSubview(vCard)
    }
    
    public static func getLayout(maxWidth: CGFloat = ScreenUtils.getScreenWidth() - ScreenUtils.widthFit(20), margin: CGFloat = CELL_MARGIN, spanCount: Int = SPAN_COUNT_4) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = getItemSize(maxWidth: maxWidth - 1, margin: margin, spanCount: spanCount)
        // collect间隙的margin
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        // collect本身的margin
        layout.sectionInset = UIEdgeInsets.init(top: margin, left: margin, bottom: margin, right: margin)
        return layout
    }
    
    private static func getItemSize(maxWidth: CGFloat = ScreenUtils.getScreenWidth() - ScreenUtils.widthFit(20), margin: CGFloat = CELL_MARGIN, spanCount: Int = SPAN_COUNT_4) -> CGSize {
        let itemWidth = spanCount > 1 ? ((maxWidth - margin * CGFloat(spanCount - 1)) / CGFloat(spanCount)) : maxWidth
        return CGSize(width: itemWidth, height: ScreenUtils.widthFit(70))
    }
    
    public static func getMuliCellHeight(dataList: [PostKindInfo]?, spanCount: Int = SPAN_COUNT_4) -> CGFloat {
        if dataList == nil || dataList!.count <= 0 {
            return CGFloat(0)
        }
        let layout = getLayout(spanCount: spanCount)
        var totalHeight = CGFloat(dataList!.count / spanCount) * (layout.itemSize.height + layout.sectionInset.top + layout.sectionInset.bottom)
        totalHeight += (dataList!.count % spanCount) > 0 ? (layout.itemSize.height + layout.sectionInset.top + layout.sectionInset.bottom) : 0
        return totalHeight
    }
    
    public static func getCellWithData(view: UICollectionView, indexPath: IndexPath, dataList: [PostKindInfo]?) -> TopicHomeKindCell {
        let cell = view.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath) as! TopicHomeKindCell
        cell.tag = indexPath.item
        // data
        if dataList == nil || dataList!.count <= cell.tag {
            return cell
        }
        let kindInfo = dataList![cell.tag]
        // view
        cell.lName.text = kindInfo.name
        cell.ivKind.image = UIImage(named: getKindIcon(position: cell.tag))
        return cell
    }
    
    public static func goPostList(view: UICollectionView, indexPath: IndexPath, dataList: [PostKindInfo]?) {
        if dataList == nil || dataList!.count <= indexPath.item {
            return
        }
        let kindInfo = dataList![indexPath.item]
        TopicPostKindListVC.pushVC(kindInfo: kindInfo)
    }
    
    private static func getKindIcon(position: Int) -> String {
        switch position {
        case 0:
            return "ic_topic_kind_life_36dp"
        case 1:
            return "ic_topic_kind_star_36dp"
        case 2:
            return "ic_topic_kind_anim_36dp"
        case 3:
            return "ic_topic_kind_unknow_36dp"
        default:
            return "ic_nav_topic_black_24dp"
        }
    }
    
}
