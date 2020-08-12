//
//  MoreMatchLetterCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/5/8.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class MoreMatchLetterCell: BaseCollectCell {
    
    // const
    public static let CELL_MARGIN = ScreenUtils.widthFit(20)
    private static let ITEM_MARGIN = ScreenUtils.widthFit(10)
    private static let ITEM_MARGIN_SMALL = ITEM_MARGIN / 2
    private static let ITEM_MARGIN_SMALL_SMALL = ScreenUtils.widthFit(2)
    private static let BOTTOM_HEIGHT = ScreenUtils.widthFit(55)
    private static let AVATAR_WIDTH = BOTTOM_HEIGHT - ITEM_MARGIN * 2
    
    // view
    private var vCard: UIView!
    private var vTop: UIView!
    private var lTitle: UILabel!
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
        ivAvatar = ViewHelper.getImageViewAvatar(width: MoreMatchLetterCell.AVATAR_WIDTH, height: MoreMatchLetterCell.AVATAR_WIDTH)
        ivAvatar.frame.origin = CGPoint(x: MoreMatchLetterCell.ITEM_MARGIN_SMALL, y: MoreMatchLetterCell.ITEM_MARGIN)
        
        // name
        let nameX = ivAvatar.frame.origin.x + ivAvatar.frame.size.width + MoreMatchLetterCell.ITEM_MARGIN_SMALL
        let nameWidth = maxWidth - nameX - MoreMatchLetterCell.ITEM_MARGIN_SMALL
        lName = ViewHelper.getLabelGreySmall(width: nameWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lName.frame.origin = CGPoint(x: nameX, y: MoreMatchLetterCell.ITEM_MARGIN)
        
        // coin
        lCoin = ViewHelper.getLabel(text: "-", size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontHint(), lines: 1, align: .left, mode: .byTruncatingTail)
        let imgWidth = lCoin.frame.size.height
        ivCoin = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_monetization_on_grey_18dp"), color: ColorHelper.getFontHint()), width: imgWidth, height: imgWidth, mode: .scaleAspectFit)
        ivCoin.frame.origin.x = 0
        ivCoin.center.y = imgWidth / 2
        lCoin.frame.origin.x = ivCoin.frame.origin.x + ivCoin.frame.size.width + MoreMatchLetterCell.ITEM_MARGIN_SMALL_SMALL
        lCoin.center.y = imgWidth / 2
        let coinWidth = (nameWidth - MoreMatchLetterCell.ITEM_MARGIN_SMALL_SMALL * 2 - imgWidth) / 2
        lCoin.frame.size.width = coinWidth - imgWidth -  MoreMatchLetterCell.ITEM_MARGIN_SMALL_SMALL
        vCoin = UIView()
        vCoin.frame.size = CGSize(width: coinWidth, height: imgWidth)
        vCoin.frame.origin = CGPoint(x: nameX, y: ivAvatar.frame.origin.y + ivAvatar.frame.size.height - imgWidth)
        vCoin.addSubview(ivCoin)
        vCoin.addSubview(lCoin)
        
        // point
        lPoint = ViewHelper.getLabel(width: coinWidth - imgWidth -  MoreMatchLetterCell.ITEM_MARGIN_SMALL_SMALL, text: "-", size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontHint(), lines: 1, align: .left, mode: .byTruncatingTail)
        ivPoint = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_thumb_up_grey_18dp"), color: ColorHelper.getFontHint()), width: imgWidth, height: imgWidth, mode: .scaleAspectFit)
        ivPoint.frame.origin.x = 0
        ivPoint.center.y = imgWidth / 2
        lPoint.frame.origin.x = ivPoint.frame.origin.x + ivPoint.frame.size.width + MoreMatchLetterCell.ITEM_MARGIN_SMALL_SMALL
        lPoint.center.y = imgWidth / 2
        vPoint = UIView()
        vPoint.frame.size = CGSize(width: coinWidth, height: imgWidth)
        vPoint.frame.origin = CGPoint(x: vCoin.frame.origin.x + vCoin.frame.size.width + MoreMatchLetterCell.ITEM_MARGIN_SMALL_SMALL, y: vCoin.frame.origin.y)
        vPoint.addSubview(ivPoint)
        vPoint.addSubview(lPoint)
        
        // more
        btnMore = ViewHelper.getBtnImgFit(width: imgWidth, height: imgWidth, bgImg: UIImage(named: "ic_more_horiz_grey_18dp"))
        btnMore.frame.origin.x = vPoint.frame.origin.x + vPoint.frame.size.width + MoreMatchLetterCell.ITEM_MARGIN_SMALL_SMALL
        btnMore.center.y = vPoint.center.y
        
        // bottom
        let topHeight = maxHeight - MoreMatchLetterCell.BOTTOM_HEIGHT
        vBottom = UIView(frame: CGRect(x: 0, y: topHeight, width: maxWidth, height: MoreMatchLetterCell.BOTTOM_HEIGHT))
        ViewUtils.setViewCorner(vBottom, corner: ViewHelper.RADIUS_BIG, round: [.bottomLeft, .bottomRight])
        vBottom.addSubview(ivAvatar)
        vBottom.addSubview(lName)
        vBottom.addSubview(vCoin)
        vBottom.addSubview(vPoint)
        vBottom.addSubview(btnMore)
        
        // title
        let titleWidth = maxWidth - MoreMatchLetterCell.ITEM_MARGIN
        let titleHeight = topHeight - MoreMatchLetterCell.CELL_MARGIN * 2
        lTitle = ViewHelper.getLabelBold(width: titleWidth, height: titleHeight, text: "-", size: ViewHelper.FONT_SIZE_NORMAL, color: ColorHelper.getFontWhite(), lines: 0, align: .center)
        lTitle.frame.origin = CGPoint(x: MoreMatchLetterCell.ITEM_MARGIN / 2, y: MoreMatchLetterCell.CELL_MARGIN)
        
        // cover
        lCover = ViewHelper.getLabelBlackNormal(width: titleWidth, height: titleHeight, text: "-", lines: 0, align: .center)
        lCover.frame.origin = CGPoint(x: MoreMatchLetterCell.ITEM_MARGIN / 2, y: MoreMatchLetterCell.CELL_MARGIN)
        
        // top
        vTop = UIView(frame: CGRect(x: 0, y: 0, width: maxWidth, height: topHeight))
        ViewUtils.setViewCorner(vTop, corner: ViewHelper.RADIUS_BIG, round: [.topLeft, .topRight])
        vTop.addSubview(lTitle)
        vTop.addSubview(lCover)
        
        // card
        vCard = UIView()
        vCard.frame.size = CGSize(width: maxWidth, height: maxHeight)
        vCard.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vCard, radius: ViewHelper.RADIUS_BIG)
        ViewUtils.setViewShadow(vCard, offset: ViewHelper.SHADOW_BIG)
        vCard.addSubview(vTop)
        vCard.addSubview(vBottom)
        
        // view
        self.addSubview(vCard)
        
        // hide
        lTitle.isHidden = true
        lCover.isHidden = true
    }
    
    public static func getLayout(maxWidth: CGFloat = ScreenUtils.getScreenWidth() - CELL_MARGIN, margin: CGFloat = CELL_MARGIN, spanCount: Int = SPAN_COUNT_2, dataList: [MatchWork]? = nil) -> LetterFlowLayout {
        let layout = LetterFlowLayout(dataList: dataList)
        layout.scrollDirection = .vertical
        // collect间隙的margin
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        // collect本身的margin
        layout.sectionInset = UIEdgeInsets.init(top: margin / 2, left: margin / 2, bottom: margin / 2, right: margin / 2)
        // size 这里最后执行
        layout.itemSize = getItemSize(maxWidth: maxWidth, margin: margin, spanCount: spanCount)
        return layout
    }
    
    public static func getItemSize(maxWidth: CGFloat = ScreenUtils.getScreenWidth() - CELL_MARGIN, margin: CGFloat = CELL_MARGIN, spanCount: Int = SPAN_COUNT_2, dataList: [MatchWork]? = nil, index: Int = -1) -> CGSize {
        let itemWidth = spanCount > 1 ? ((maxWidth - margin * CGFloat(spanCount - 1)) / CGFloat(spanCount)) : maxWidth
        if dataList == nil || dataList!.count <= index || index < 0 {
            return CGSize(width: itemWidth, height: BOTTOM_HEIGHT)
        }
        let work = dataList![index]
        var titleHeight = CGFloat(0)
        if work.isDelete() || work.screen {
            let font = ViewUtils.getFont(size: ViewHelper.FONT_SIZE_NORMAL)
            let content = work.screen ? StringUtils.getString("work_already_be_screen") : StringUtils.getString("work_already_be_delete")
            titleHeight = ViewUtils.getFontHeight(font: font, width: itemWidth - ITEM_MARGIN / 2, text: content)
        } else {
            let font = ViewUtils.getFontBold(size: ViewHelper.FONT_SIZE_NORMAL)
            let content = work.title
            titleHeight = ViewUtils.getFontHeight(font: font, width: itemWidth - ITEM_MARGIN / 2, text: content)
        }
        let itemHeight = BOTTOM_HEIGHT + titleHeight + CELL_MARGIN * 2
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    public static func getCellWithData(view: UICollectionView, indexPath: IndexPath, dataList: [MatchWork]?, target: Any?, actionCoin: Selector, actionPoint: Selector, actionMore: Selector) -> MoreMatchLetterCell {
        let cell = view.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath) as! MoreMatchLetterCell
        cell.tag = indexPath.item
        // data
        if dataList == nil || dataList!.count <= cell.tag {
            return cell
        }
        let work = dataList![cell.tag]
        // delete + screen
        if work.isDelete() || work.screen {
            cell.lCover.isHidden = false
            cell.lTitle.isHidden = true
            cell.lCover.text = work.screen ? StringUtils.getString("work_already_be_screen") : StringUtils.getString("work_already_be_delete")
        } else {
            cell.lCover.isHidden = true
            cell.lTitle.isHidden = false
            cell.lTitle.text = work.title
        }
        cell.vTop.backgroundColor = ThemeHelper.getPrimaryRandom()
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
            let size = getItemSize(dataList: dataList, index: cell.tag)
            let vCardHeight = size.height
            if cell.vCard.frame.size.height != vCardHeight {
                cell.vCard.frame.size.height = vCardHeight
            }
            ViewUtils.setViewShadow(cell.vCard, offset: ViewHelper.SHADOW_BIG)
            let topHeight = vCardHeight - BOTTOM_HEIGHT
            if cell.vTop.frame.size.height != topHeight {
                cell.vTop.frame.size.height = topHeight
                ViewUtils.setViewCorner(cell.vTop, corner: ViewHelper.RADIUS_BIG, round: [.topLeft, .topRight])
            }
            if cell.vBottom.frame.origin.y != topHeight {
                cell.vBottom.frame.origin.y = topHeight
            }
            let contentHeight = topHeight - CELL_MARGIN * 2
            if work.isDelete() || work.screen {
                if cell.lCover.frame.size.height != contentHeight {
                    cell.lCover.frame.size.height = contentHeight
                }
            } else {
                if cell.lTitle.frame.size.height != contentHeight {
                    cell.lTitle.frame.size.height = contentHeight
                }
            }
        }
        
        // target
        ViewUtils.addViewTapTarget(target: target, view: cell.vCoin, action: actionCoin)
        ViewUtils.addViewTapTarget(target: target, view: cell.vPoint, action: actionPoint)
        cell.btnMore.addTarget(target, action: actionMore, for: .touchUpInside)
        return cell
    }
    
}

class LetterFlowLayout: UICollectionViewFlowLayout {
    
    private var workList: [MatchWork]?
    private var layoutAttributes: Array<UICollectionViewLayoutAttributes>!
    private var leftHeight: CGFloat = 0
    private var rightHeight: CGFloat = 0
    private var leftCenterX = (ScreenUtils.getScreenWidth() - MoreMatchLetterCell.CELL_MARGIN / 2) / 4
    private var rightCenterX = (ScreenUtils.getScreenWidth() - MoreMatchLetterCell.CELL_MARGIN / 2) / 4 * 3 + (MoreMatchLetterCell.CELL_MARGIN / 2)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(dataList: [MatchWork]?) {
        super.init()
        setDataList(dataList: dataList)
    }
    
    public func setDataList(dataList: [MatchWork]?) {
        self.workList = dataList
        //prepare()
    }
    
    override func prepare() {
        super.prepare()
        refreshAttrs()
    }
    
    func refreshAttrs() {
        self.leftHeight = ScreenUtils.getScreenHeight() // 防止首次加载没高度
        self.rightHeight = ScreenUtils.getScreenHeight() // 防止首次加载没高度
        let totalNum = collectionView?.numberOfItems(inSection: 0) ?? 0
        layoutAttributes = []
        for index in 0 ..< totalNum {
            let indexpath = IndexPath(item: index, section: 0)
            let attributes = layoutAttributesForItem(at: indexpath)
            layoutAttributes.append(attributes!)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.item < layoutAttributes.count {
            // 防止重复计算
            return layoutAttributes[indexPath.item]
        }
        var attr = super.layoutAttributesForItem(at: indexPath)
        if attr == nil {
            attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        }
        attr?.size = MoreMatchLetterCell.getItemSize(dataList: workList, index: indexPath.item)
        if indexPath.item == 0 {
            // 第一个
            attr?.center.x = leftCenterX
            attr?.frame.origin.y = MoreMatchLetterCell.CELL_MARGIN / 2
            leftHeight = (attr?.frame.origin.y ?? 0) + (attr?.size.height ?? 0) + MoreMatchLetterCell.CELL_MARGIN
        } else if indexPath.item == 1 {
            // 第二个
            attr?.center.x = rightCenterX
            attr?.frame.origin.y = MoreMatchLetterCell.CELL_MARGIN / 2
            rightHeight = (attr?.frame.origin.y ?? 0) + (attr?.size.height ?? 0) + MoreMatchLetterCell.CELL_MARGIN
        } else {
            // 从第三个开始
            if leftHeight <= rightHeight {
                // 左面
                attr?.center.x = leftCenterX
                attr?.frame.origin.y = leftHeight
                leftHeight += (attr?.size.height ?? 0) + MoreMatchLetterCell.CELL_MARGIN
            } else {
                // 右面
                attr?.center.x = rightCenterX
                attr?.frame.origin.y = rightHeight
                rightHeight += (attr?.size.height ?? 0) + MoreMatchLetterCell.CELL_MARGIN
            }
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
        return CountHelper.getMax(leftHeight, rightHeight)
    }
    
}
