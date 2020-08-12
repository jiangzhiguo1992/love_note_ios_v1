//
//  MoreMatchWifeCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/5/8.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class MoreMatchWifeCell: BaseCollectCell {
    
    // const
    public static let CELL_HEIGHT = ScreenUtils.getScreenHeight() / 3
    private static let CELL_MARGIN = ScreenUtils.widthFit(10)
    private static let ITEM_MARGIN = ScreenUtils.widthFit(10)
    private static let ITEM_MARGIN_SMALL = ITEM_MARGIN / 2
    private static let ITEM_MARGIN_SMALL_SMALL = ScreenUtils.widthFit(2)
    private static let BOTTOM_HEIGHT = ScreenUtils.widthFit(55)
    private static let AVATAR_WIDTH = BOTTOM_HEIGHT - ITEM_MARGIN * 2
    
    // view
    private var vCard: UIView!
    private var ivWork: UIImageView!
    private var lCover: UILabel!
    private var vBottom: UIView!
    private var ivAvatar: UIImageView!
    private var lName: UILabel!
    private var vCoin: UIView!
    private var ivCoin: UIImageView!
    private var lCoin: UILabel!
    private var vPoint: UIView!
    private var ivPoint: UIImageView!
    private var lPoint: UILabel!
    private var btnMore: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let maxWidth = frame.size.width
        let maxHeight = frame.size.height
        
        // avatar
        ivAvatar = ViewHelper.getImageViewAvatar(width: MoreMatchWifeCell.AVATAR_WIDTH, height: MoreMatchWifeCell.AVATAR_WIDTH)
        ivAvatar.frame.origin = CGPoint(x: MoreMatchWifeCell.ITEM_MARGIN_SMALL, y: MoreMatchWifeCell.ITEM_MARGIN)
        
        // name
        let nameX = ivAvatar.frame.origin.x + ivAvatar.frame.size.width + MoreMatchWifeCell.ITEM_MARGIN_SMALL
        let nameWidth = maxWidth - nameX - MoreMatchWifeCell.ITEM_MARGIN_SMALL
        lName = ViewHelper.getLabelGreySmall(width: nameWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lName.frame.origin = CGPoint(x: nameX, y: MoreMatchWifeCell.ITEM_MARGIN)
        
        // coin
        lCoin = ViewHelper.getLabel(text: "-", size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontHint(), lines: 1, align: .left, mode: .byTruncatingTail)
        let imgWidth = lCoin.frame.size.height
        ivCoin = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_monetization_on_grey_18dp"), color: ColorHelper.getFontHint()), width: imgWidth, height: imgWidth, mode: .scaleAspectFit)
        ivCoin.frame.origin.x = 0
        ivCoin.center.y = imgWidth / 2
        lCoin.frame.origin.x = ivCoin.frame.origin.x + ivCoin.frame.size.width + MoreMatchWifeCell.ITEM_MARGIN_SMALL_SMALL
        lCoin.center.y = imgWidth / 2
        let coinWidth = (nameWidth - MoreMatchWifeCell.ITEM_MARGIN_SMALL_SMALL * 2 - imgWidth) / 2
        lCoin.frame.size.width = coinWidth - imgWidth -  MoreMatchWifeCell.ITEM_MARGIN_SMALL_SMALL
        vCoin = UIView()
        vCoin.frame.size = CGSize(width: coinWidth, height: imgWidth)
        vCoin.frame.origin = CGPoint(x: nameX, y: ivAvatar.frame.origin.y + ivAvatar.frame.size.height - imgWidth)
        vCoin.addSubview(ivCoin)
        vCoin.addSubview(lCoin)
        
        // point
        lPoint = ViewHelper.getLabel(width: coinWidth - imgWidth -  MoreMatchWifeCell.ITEM_MARGIN_SMALL_SMALL, text: "-", size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontHint(), lines: 1, align: .left, mode: .byTruncatingTail)
        ivPoint = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_thumb_up_grey_18dp"), color: ColorHelper.getFontHint()), width: imgWidth, height: imgWidth, mode: .scaleAspectFit)
        ivPoint.frame.origin.x = 0
        ivPoint.center.y = imgWidth / 2
        lPoint.frame.origin.x = ivPoint.frame.origin.x + ivPoint.frame.size.width + MoreMatchWifeCell.ITEM_MARGIN_SMALL_SMALL
        lPoint.center.y = imgWidth / 2
        vPoint = UIView()
        vPoint.frame.size = CGSize(width: coinWidth, height: imgWidth)
        vPoint.frame.origin = CGPoint(x: vCoin.frame.origin.x + vCoin.frame.size.width + MoreMatchWifeCell.ITEM_MARGIN_SMALL_SMALL, y: vCoin.frame.origin.y)
        vPoint.addSubview(ivPoint)
        vPoint.addSubview(lPoint)
        
        // more
        btnMore = ViewHelper.getBtnImgFit(width: imgWidth, height: imgWidth, bgImg: UIImage(named: "ic_more_horiz_grey_18dp"))
        btnMore.frame.origin.x = vPoint.frame.origin.x + vPoint.frame.size.width + MoreMatchWifeCell.ITEM_MARGIN_SMALL_SMALL
        btnMore.center.y = vPoint.center.y
        
        // bottom
        let topHeight = maxHeight - MoreMatchWifeCell.BOTTOM_HEIGHT
        vBottom = UIView(frame: CGRect(x: 0, y: topHeight, width: maxWidth, height: MoreMatchWifeCell.BOTTOM_HEIGHT))
        ViewUtils.setViewCorner(vBottom, corner: ViewHelper.RADIUS_BIG, round: [.bottomLeft, .bottomRight])
        vBottom.addSubview(ivAvatar)
        vBottom.addSubview(lName)
        vBottom.addSubview(vCoin)
        vBottom.addSubview(vPoint)
        vBottom.addSubview(btnMore)
        
        // work
        ivWork = ViewHelper.getImageViewUrl(width: maxWidth, height: topHeight, radius: 0)
        ivWork.frame.origin = CGPoint(x: 0, y: 0)
        ivWork.layer.masksToBounds = true // 不加会超出frame
        ViewUtils.setViewCorner(ivWork, corner: ViewHelper.RADIUS_BIG, round: [.topLeft, .topRight])
        
        // cover
        lCover = ViewHelper.getLabelBlackNormal(width: maxWidth, height: topHeight, text: "-", lines: 0, align: .center)
        lCover.frame.origin = CGPoint(x: 0, y: 0)
        lCover.layer.masksToBounds = true // 不加会超出frame
        ViewUtils.setViewCorner(lCover, corner: ViewHelper.RADIUS_BIG, round: [.topLeft, .topRight])
        
        // card
        vCard = UIView()
        vCard.frame.size = CGSize(width: maxWidth, height: maxHeight)
        vCard.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vCard, radius: ViewHelper.RADIUS_BIG)
        ViewUtils.setViewShadow(vCard, offset: ViewHelper.SHADOW_BIG)
        vCard.addSubview(ivWork)
        vCard.addSubview(lCover)
        vCard.addSubview(vBottom)
        
        // view
        self.addSubview(vCard)
        
        // hide
        ivWork.isHidden = true
        lCover.isHidden = true
    }
    
    public static func getLayout(maxWidth: CGFloat = ScreenUtils.getScreenWidth() - CELL_MARGIN * 2, margin: CGFloat = CELL_MARGIN, spanCount: Int = SPAN_COUNT_2) -> WifeFlowLayout {
        let layout = WifeFlowLayout()
        layout.scrollDirection = .vertical
        // collect间隙的margin
        layout.minimumLineSpacing = margin * 2
        layout.minimumInteritemSpacing = margin * 2
        // collect本身的margin
        layout.sectionInset = UIEdgeInsets.init(top: margin, left: margin, bottom: margin, right: margin)
        // size 这里最后执行
        layout.itemSize = getItemSize(maxWidth: maxWidth - 1, margin: margin * 2, spanCount: spanCount, index: 1)
        return layout
    }
    
    public static func getItemSize(maxWidth: CGFloat = ScreenUtils.getScreenWidth() - CELL_MARGIN * 2, margin: CGFloat = CELL_MARGIN * 2, spanCount: Int = SPAN_COUNT_2, index: Int = 1) -> CGSize {
        let itemWidth = spanCount > 1 ? ((maxWidth - margin * CGFloat(spanCount - 1)) / CGFloat(spanCount)) : maxWidth
        let itemHeight = (index == 0) ? CELL_HEIGHT + getFirstOffset() : CELL_HEIGHT
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    public static func getFirstOffset() -> CGFloat {
        return CELL_HEIGHT / 3
    }
    
    public static func getCellWithData(view: UICollectionView, indexPath: IndexPath, dataList: [MatchWork]?, target: Any?, actionImg: Selector, actionCoin: Selector, actionPoint: Selector, actionMore: Selector) -> MoreMatchWifeCell {
        let cell = view.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath) as! MoreMatchWifeCell
        cell.tag = indexPath.item
        // data
        if dataList == nil || dataList!.count <= cell.tag {
            return cell
        }
        let work = dataList![cell.tag]
        // delete + screen
        if work.isDelete() || work.screen {
            cell.lCover.isHidden = false
            cell.ivWork.isHidden = true
            cell.lCover.text = work.screen ? StringUtils.getString("work_already_be_screen") : StringUtils.getString("work_already_be_delete")
        } else {
            cell.lCover.isHidden = true
            cell.ivWork.isHidden = false
            KFHelper.setImgUrl(iv: cell.ivWork, objKey: work.contentImage)
        }
        // view
        let couple = work.couple
        KFHelper.setImgAvatarUrl(iv: cell.ivAvatar, objKey: UserHelper.getAvatar(couple: couple, uid: work.userId))
        cell.lName.text = UserHelper.getName(couple: couple, uid: work.userId, empty: true)
        cell.lCoin.text = ShowHelper.getShowCount2Thousand(work.coinCount)
        cell.lPoint.text = ShowHelper.getShowCount2Thousand(work.pointCount)
        cell.ivCoin.image = ViewUtils.getImageWithTintColor(img: cell.ivCoin.image, color: work.coin ? ThemeHelper.getColorPrimary() : ColorHelper.getFontHint())
        cell.ivPoint.image = ViewUtils.getImageWithTintColor(img: cell.ivPoint.image, color: work.point ? ThemeHelper.getColorPrimary() : ColorHelper.getFontHint())
        
        // size (不设置的话，缓存会乱)
        AppDelegate.runOnMainAsync {
            let size = getItemSize(index: indexPath.item)
            let vCardHeight = size.height
            if cell.vCard.frame.size.height != vCardHeight {
                cell.vCard.frame.size.height = vCardHeight
            }
            ViewUtils.setViewShadow(cell.vCard, offset: ViewHelper.SHADOW_BIG)
            let topHeight = vCardHeight - BOTTOM_HEIGHT
            if work.isDelete() || work.screen {
                if cell.lCover.frame.size.height != topHeight {
                    cell.lCover.frame.size.height = topHeight
                    ViewUtils.setViewCorner(cell.lCover, corner: ViewHelper.RADIUS_BIG, round: [.topLeft, .topRight])
                }
            } else {
                if cell.ivWork.frame.size.height != topHeight {
                    cell.ivWork.frame.size.height = topHeight
                    ViewUtils.setViewCorner(cell.ivWork, corner: ViewHelper.RADIUS_BIG, round: [.topLeft, .topRight])
                }
            }
            if cell.vBottom.frame.origin.y != topHeight {
                cell.vBottom.frame.origin.y = topHeight
            }
        }
        
        // target
        ViewUtils.addViewTapTarget(target: target, view: cell.ivWork, action: actionImg)
        ViewUtils.addViewTapTarget(target: target, view: cell.vCoin, action: actionCoin)
        ViewUtils.addViewTapTarget(target: target, view: cell.vPoint, action: actionPoint)
        cell.btnMore.addTarget(target, action: actionMore, for: .touchUpInside)
        return cell
    }
    
    public static func goBigImg(view: UIView?, dataList: [MatchWork]?) {
        if let indexPath = ViewUtils.findCollectIndexPath(view: view) {
            if dataList == nil || dataList!.count <= indexPath.item {
                return
            }
            let work = dataList![indexPath.item]
            let ossKeyList = [String](arrayLiteral: work.contentImage)
            BrowserHelper.goBrowserImage(view: view, index: 0, ossKeyList: ossKeyList)
        }
    }
    
}

class WifeFlowLayout: UICollectionViewFlowLayout {
    
    private var layoutAttributes: Array<UICollectionViewLayoutAttributes>!
    
    override func prepare() {
        super.prepare()
        let totalNum = collectionView?.numberOfItems(inSection: 0) ?? 0
        layoutAttributes = []
        for index in 0 ..< totalNum {
            let indexpath = IndexPath(item: index, section: 0)
            let attributes = layoutAttributesForItem(at: indexpath)
            layoutAttributes.append(attributes!)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var attr = super.layoutAttributesForItem(at: indexPath)
        if attr == nil {
            attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        }
        attr?.size = MoreMatchWifeCell.getItemSize(index: indexPath.item)
        if indexPath.item == 0 {
            attr?.frame.origin.y = self.sectionInset.top
        } else if indexPath.item % BaseCollectCell.SPAN_COUNT_2 == 0 {
            attr?.frame.origin.y += MoreMatchWifeCell.getFirstOffset()
        }
        return attr
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes
    }
    
    override var collectionViewContentSize: CGSize {
        get {
            return CGSize(width: collectionView?.bounds.width ?? 0, height: getCollectHeight())
        }
        set {
            self.collectionViewContentSize = newValue
        }
    }
    
    private func getCollectHeight() -> CGFloat {
        let layout = MoreMatchWifeCell.getLayout()
        if layoutAttributes.count <= 0 {
            return ScreenUtils.getScreenHeight() // 防止首次加载没高度
        }
        let flow = layoutAttributes.count / BaseCollectCell.SPAN_COUNT_2
        let singelHeight = layout.itemSize.height + layout.minimumLineSpacing
        var totalHeight = singelHeight * CGFloat(flow) + layout.minimumLineSpacing
        if layoutAttributes.count % BaseCollectCell.SPAN_COUNT_2 == 0 {
            totalHeight += MoreMatchWifeCell.getFirstOffset()
        } else if layoutAttributes.count % BaseCollectCell.SPAN_COUNT_2 == 1 {
            totalHeight += singelHeight + MoreMatchWifeCell.getFirstOffset()
        }
        return totalHeight
    }
    
}
