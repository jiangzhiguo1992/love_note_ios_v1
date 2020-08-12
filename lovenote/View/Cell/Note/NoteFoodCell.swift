//
//  NoteFoodCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/21.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteFoodCell: BaseTableCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // const
    private static var totalHeight: CGFloat?
    private static var contentFont: UIFont?
    
    private static let ITEM_MARGIN = ScreenUtils.widthFit(10)
    private static let AVATAR_WIDTH = ScreenUtils.widthFit(40)
    private static let AVATAR_END_MARGIN = ScreenUtils.widthFit(20)
    private static let CARD_WIDTH = ScreenUtils.getScreenWidth() - ITEM_MARGIN * 2
    private static let CARD_CONTENT_WIDTH = CARD_WIDTH - ITEM_MARGIN * 2
    
    // view
    private var vCard: UIView!
    private var ivAvatar: UIImageView!
    private var lTitle: UILabel!
    private var btnMore: UIButton!
    private var lHappenAt: UILabel!
    private var lAddress: UILabel!
    private var lContent: UILabel!
    private var collectImgList: UICollectionView!
    
    // var
    private static var heightMap: [Int: CGFloat] = [Int: CGFloat]()
    lazy var imgTop = CGFloat(0)
    lazy var imgList = [String]()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // avatar
        ivAvatar = ViewHelper.getImageViewAvatar(width: NoteFoodCell.AVATAR_WIDTH, height: NoteFoodCell.AVATAR_WIDTH)
        ivAvatar.frame.origin = CGPoint(x: NoteFoodCell.ITEM_MARGIN, y: NoteFoodCell.ITEM_MARGIN)
        let vAvatarShadow = ViewUtils.getViewShadow(ivAvatar, bgColor: ColorHelper.getWhite(), offset: ViewHelper.SHADOW_NORMAL)
        
        // more
        btnMore = ViewHelper.getBtnImgCenter(paddingH: NoteFoodCell.ITEM_MARGIN, paddingV: NoteFoodCell.ITEM_MARGIN, bgImg: UIImage(named: "ic_more_horiz_grey_18dp"))
        btnMore.frame.origin = CGPoint(x: NoteFoodCell.CARD_WIDTH - btnMore.frame.size.width, y: 0)
        
        // title
        let titleWidth = NoteFoodCell.CARD_CONTENT_WIDTH - NoteFoodCell.ITEM_MARGIN - NoteFoodCell.AVATAR_WIDTH - NoteFoodCell.AVATAR_END_MARGIN - btnMore.frame.size.width
        lTitle = ViewHelper.getLabelBold(width: titleWidth, text: "-", size: ViewHelper.FONT_SIZE_NORMAL, color: ColorHelper.getFontBlack(), lines: 1, align: .left, mode: .byTruncatingTail)
        lTitle.frame.origin = CGPoint(x: ivAvatar.frame.origin.x + ivAvatar.frame.size.width + NoteFoodCell.AVATAR_END_MARGIN, y: NoteFoodCell.ITEM_MARGIN)
        
        // happen
        let happenWidth = (NoteFoodCell.CARD_CONTENT_WIDTH - NoteFoodCell.ITEM_MARGIN - NoteFoodCell.AVATAR_WIDTH - NoteFoodCell.AVATAR_END_MARGIN) / 2
        lHappenAt = ViewHelper.getLabelGreySmall(width: happenWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingMiddle)
        lHappenAt.frame.origin = CGPoint(x: ivAvatar.frame.origin.x + ivAvatar.frame.size.width + NoteFoodCell.AVATAR_END_MARGIN, y: ivAvatar.frame.origin.y + ivAvatar.frame.size.height - lHappenAt.frame.size.height)
        
        // address
        lAddress = ViewHelper.getLabelGreySmall(width: happenWidth, text: "-", lines: 1, align: .right, mode: .byTruncatingMiddle)
        lAddress.frame.origin = CGPoint(x: lHappenAt.frame.origin.x + lHappenAt.frame.size.width + NoteFoodCell.ITEM_MARGIN, y: ivAvatar.frame.origin.y + ivAvatar.frame.size.height - lAddress.frame.size.height)
        
        // content
        lContent = ViewHelper.getLabelGreyNormal(width: NoteFoodCell.CARD_CONTENT_WIDTH, text: "-", lines: 0, align: .left)
        lContent.frame.origin = CGPoint(x: NoteFoodCell.ITEM_MARGIN, y: ivAvatar.frame.origin.y + ivAvatar.frame.size.height + NoteFoodCell.ITEM_MARGIN)
        
        // imgList
        let layoutImgList = ImgSquareShowCell.getLayout(maxWidth: NoteFoodCell.CARD_CONTENT_WIDTH)
        let marginImgList = layoutImgList.sectionInset
        let collectImgListWidth = NoteFoodCell.CARD_CONTENT_WIDTH + marginImgList.left + marginImgList.right
        let collectImgListX = marginImgList.left
        let collectImgListY = lContent.frame.origin.y + lContent.frame.size.height + NoteFoodCell.ITEM_MARGIN - marginImgList.top
        imgTop = marginImgList.top
        collectImgList = ViewUtils.getCollectionView(target: self, frame: CGRect(x: collectImgListX, y: collectImgListY, width: collectImgListWidth, height: 0), layout: layoutImgList, cellCls: ImgSquareShowCell.self, id: ImgSquareShowCell.ID)
        
        // card
        vCard = UIView(frame: CGRect(x: NoteFoodCell.ITEM_MARGIN, y: NoteFoodCell.ITEM_MARGIN / 2, width: NoteFoodCell.CARD_WIDTH, height: ivAvatar.frame.origin.y + ivAvatar.frame.size.height + NoteFoodCell.ITEM_MARGIN))
        vCard.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vCard, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vCard, offset: ViewHelper.SHADOW_NORMAL)
        
        vCard.addSubview(vAvatarShadow)
        vCard.addSubview(ivAvatar)
        vCard.addSubview(lTitle)
        vCard.addSubview(btnMore)
        vCard.addSubview(lHappenAt)
        vCard.addSubview(lAddress)
        vCard.addSubview(lContent)
        vCard.addSubview(collectImgList)
        
        // view
        self.contentView.addSubview(vCard)
        
        // hide
        btnMore.isHidden = true
        lAddress.isHidden = true
        lContent.isHidden = true
        collectImgList.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return ImgSquareShowCell.getCellWithData(view: collectionView, indexPath: indexPath, dataList: imgList)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        BrowserHelper.goBrowserImage(view: collectionView, index: indexPath.row, ossKeyList: imgList)
    }
    
    public static func getCellHeight(view: UITableView, indexPath: IndexPath, dataList: [Food]?) -> CGFloat {
        // cache
        let row = indexPath.row
        let height = heightMap[row]
        if height != nil && height! > CGFloat(0) {
            return height!
        }
        // get
        if dataList == nil || dataList!.count <= row {
            return CGFloat(0)
        }
        let food = dataList![row]
        return getHeightByData(food: food)
    }
    
    public static func refreshHeightMap(refresh: Bool, start: Int, dataList: [Food]?) {
        // clear
        var startIndex = start
        if refresh {
            heightMap.removeAll()
            startIndex = 0
        }
        // heightMap
        if dataList == nil || dataList!.count <= 0 {
            return
        }
        for (index, food) in dataList!.enumerated() {
            let height = getHeightByData(food: food)
            heightMap[index + startIndex] = height
        }
    }
    
    public static func getHeightByData(margin: CGFloat = ITEM_MARGIN, food: Food) -> CGFloat {
        // const
        let cell = NoteFoodCell(style: .default, reuseIdentifier: NoteFoodCell.ID)
        if totalHeight == nil || contentFont == nil {
            totalHeight = cell.vCard.frame.origin.y + cell.vCard.frame.size.height + margin / 2
            contentFont = cell.lContent.font
        }
        // content
        var contentHeight = CGFloat(0)
        if !StringUtils.isEmpty(food.contentText) {
            contentHeight = ViewUtils.getFontHeight(font: contentFont, width: CARD_CONTENT_WIDTH, text: food.contentText) + NoteFoodCell.ITEM_MARGIN
        }
        // img
        var imgListHeight = CGFloat(0)
        if food.contentImageList.count > 0 {
            imgListHeight = ImgSquareShowCell.getCollectHeight(collect: cell.collectImgList, dataList: food.contentImageList)
        }
        return totalHeight! + contentHeight + imgListHeight
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Food]?, heightMap: Bool = true, target: Any?, actionAddress: Selector) -> NoteFoodCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? NoteFoodCell
        if cell == nil {
            cell = NoteFoodCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= cell!.tag {
            return cell!
        }
        let food = dataList![cell!.tag]
        let me = UDHelper.getMe()
        let avatar = UserHelper.getAvatar(user: me, uid: food.userId)
        cell?.imgList = food.contentImageList
        
        // view
        KFHelper.setImgAvatarUrl(iv: cell?.ivAvatar, objKey: avatar, uid: food.userId)
        cell?.lTitle.text = food.title
        cell?.lHappenAt.text = TimeHelper.getTimeShowLine_HM_MDHM_YMDHM_ByGo(food.happenAt)
        cell?.lAddress.text = food.address
        cell?.lContent.text = food.contentText
        
        cell?.lAddress.isHidden = StringUtils.isEmpty(food.address)
        cell?.lContent.isHidden = StringUtils.isEmpty(food.contentText)
        cell?.collectImgList.isHidden = food.contentImageList.count <= 0
        
        // size
        AppDelegate.runOnMainAsync {
            let cellHeight = heightMap ? getCellHeight(view: view, indexPath: indexPath, dataList: dataList) : getHeightByData(food: food)
            // card
            let vCardHeight = cellHeight - ITEM_MARGIN
            if (cell?.vCard.frame.size.height ?? 0) != vCardHeight {
                cell?.vCard.frame.size.height = vCardHeight
            }
            ViewUtils.setViewShadow(cell?.vCard, offset: ViewHelper.SHADOW_NORMAL)
            // content
            let collectImgHeight = food.contentImageList.count > 0 ? ImgSquareShowCell.getCollectHeight(collect: cell?.collectImgList, dataList: food.contentImageList) : 0
            let lContentHeight = cellHeight - (totalHeight ?? 0) - NoteFoodCell.ITEM_MARGIN - collectImgHeight
            let lContentY = cell!.ivAvatar.frame.origin.y + cell!.ivAvatar.frame.size.height + ITEM_MARGIN
            if (cell?.lContent.frame.origin.y ?? 0) != lContentY {
                cell?.lContent.frame.origin.y = lContentY
            }
            if (cell?.lContent.frame.size.height ?? 0) != lContentHeight {
                cell?.lContent.frame.size.height = lContentHeight
            }
            // img
            if StringUtils.isEmpty(food.contentText) {
                cell?.collectImgList.frame.origin.y = (cell?.lContent.frame.origin.y ?? 0) + (cell?.imgTop ?? 0)
            } else {
                let why = (cell?.lContent.frame.origin.y ?? 0) + (cell?.lContent.frame.size.height ?? 0)
                cell?.collectImgList.frame.origin.y = why + ITEM_MARGIN - (cell?.imgTop ?? 0)
            }
            if (cell?.collectImgList.frame.size.height ?? 0) != collectImgHeight {
                cell?.collectImgList.frame.size.height = collectImgHeight
            }
            cell?.collectImgList.reloadData()
        }
        // targrt
        ViewUtils.addViewTapTarget(target: target, view: cell?.lAddress, action: actionAddress)
        return cell!
    }
    
    public static func getMuliCellHeight(dataList: [Food]?) -> CGFloat {
        if dataList == nil || dataList!.count <= 0 {
            return CGFloat(0)
        }
        var totalHeight = CGFloat(0)
        for food in dataList! {
            totalHeight += getHeightByData(food: food)
        }
        return totalHeight
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Food]?, heightMap: Bool = true, target: Any?, actionEdit: Selector, actionAddress: Selector) -> NoteFoodCell {
        let cell = getCellWithData(view: view, indexPath: indexPath, dataList: dataList, heightMap: heightMap, target: target, actionAddress: actionAddress)
        cell.btnMore.isHidden = false
        cell.btnMore.addTarget(target, action: actionEdit, for: .touchUpInside)
        return cell
    }
    
    public static func selectFood(view: UITableView, indexPath: IndexPath, dataList: [Food]?) {
        RootVC.get().popBack()
        if dataList == nil || dataList!.count <= indexPath.row {
            return
        }
        let food = dataList![indexPath.row]
        NotifyHelper.post(NotifyHelper.TAG_FOOD_SELECT, obj: food)
    }
    
    public static func goEdit(view: UIView?, dataList: [Food]?) {
        if let indexPath = ViewUtils.findTableIndexPath(view: view) {
            if dataList == nil || dataList!.count <= indexPath.row {
                return
            }
            let food = dataList![indexPath.row]
            NoteFoodEditVC.pushVC(food: food)
        }
    }
    
    public static func goMap(view: UIView?, dataList: [Food]?) {
        if let indexPath = ViewUtils.findTableIndexPath(view: view) {
            if dataList == nil || dataList!.count <= indexPath.row {
                return
            }
            let food = dataList![indexPath.row]
            MapShowVC.pushVC(address: food.address, lon: food.longitude, lat: food.latitude)
        }
    }
    
}
