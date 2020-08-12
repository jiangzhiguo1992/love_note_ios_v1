//
//  NoteGiftCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/25.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteGiftCell: BaseTableCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // const
    private static var totalHeight: CGFloat?
    
    private static let ITEM_MARGIN = ScreenUtils.widthFit(10)
    private static let AVATAR_WIDTH = ScreenUtils.widthFit(50)
    private static let AVATAR_END_MARGIN = ScreenUtils.widthFit(20)
    private static let CARD_WIDTH = ScreenUtils.getScreenWidth() - ITEM_MARGIN * 2
    private static let CARD_CONTENT_WIDTH = CARD_WIDTH - ITEM_MARGIN * 2
    
    // view
    private var vCard: UIView!
    private var ivAvatar: UIImageView!
    private var lTitle: UILabel!
    private var btnMore: UIButton!
    private var lHappenAt: UILabel!
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
        ivAvatar = ViewHelper.getImageViewAvatar(width: NoteGiftCell.AVATAR_WIDTH, height: NoteGiftCell.AVATAR_WIDTH)
        ivAvatar.frame.origin = CGPoint(x: NoteGiftCell.ITEM_MARGIN, y: NoteGiftCell.ITEM_MARGIN)
        let vAvatarShadow = ViewUtils.getViewShadow(ivAvatar, bgColor: ColorHelper.getWhite(), offset: ViewHelper.SHADOW_NORMAL)
        
        // more
        btnMore = ViewHelper.getBtnImgCenter(paddingH: NoteGiftCell.ITEM_MARGIN, paddingV: NoteGiftCell.ITEM_MARGIN, bgImg: UIImage(named: "ic_more_horiz_grey_18dp"))
        btnMore.frame.origin = CGPoint(x: NoteGiftCell.CARD_WIDTH - btnMore.frame.size.width, y: 0)
        
        // title
        let titleWidth = NoteGiftCell.CARD_CONTENT_WIDTH - NoteGiftCell.ITEM_MARGIN - NoteGiftCell.AVATAR_WIDTH - NoteGiftCell.AVATAR_END_MARGIN - btnMore.frame.size.width
        lTitle = ViewHelper.getLabelBold(width: titleWidth, text: "-", size: ViewHelper.FONT_SIZE_HUGE, color: ColorHelper.getFontBlack(), lines: 1, align: .left, mode: .byTruncatingTail)
        lTitle.frame.origin = CGPoint(x: ivAvatar.frame.origin.x + ivAvatar.frame.size.width + NoteGiftCell.AVATAR_END_MARGIN, y: NoteGiftCell.ITEM_MARGIN)
        
        // happen
        lHappenAt = ViewHelper.getLabelGreySmall(width: titleWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingMiddle)
        lHappenAt.frame.origin = CGPoint(x: ivAvatar.frame.origin.x + ivAvatar.frame.size.width + NoteGiftCell.AVATAR_END_MARGIN, y: ivAvatar.frame.origin.y + ivAvatar.frame.size.height - lHappenAt.frame.size.height)
        
        // imgList
        let layoutImgList = ImgSquareShowCell.getLayout(maxWidth: NoteGiftCell.CARD_CONTENT_WIDTH)
        let marginImgList = layoutImgList.sectionInset
        let collectImgListWidth = NoteGiftCell.CARD_CONTENT_WIDTH + marginImgList.left + marginImgList.right
        let collectImgListX = marginImgList.left
        let collectImgListY = ivAvatar.frame.origin.y + ivAvatar.frame.size.height + NoteGiftCell.ITEM_MARGIN - marginImgList.top
        imgTop = marginImgList.top
        collectImgList = ViewUtils.getCollectionView(target: self, frame: CGRect(x: collectImgListX, y: collectImgListY, width: collectImgListWidth, height: 0), layout: layoutImgList, cellCls: ImgSquareShowCell.self, id: ImgSquareShowCell.ID)
        
        // card
        vCard = UIView(frame: CGRect(x: NoteGiftCell.ITEM_MARGIN, y: NoteGiftCell.ITEM_MARGIN / 2, width: NoteGiftCell.CARD_WIDTH, height: ivAvatar.frame.origin.y + ivAvatar.frame.size.height + NoteGiftCell.ITEM_MARGIN))
        vCard.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vCard, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vCard, offset: ViewHelper.SHADOW_NORMAL)
        
        vCard.addSubview(vAvatarShadow)
        vCard.addSubview(ivAvatar)
        vCard.addSubview(lTitle)
        vCard.addSubview(btnMore)
        vCard.addSubview(lHappenAt)
        vCard.addSubview(collectImgList)
        
        // view
        self.contentView.addSubview(vCard)
        
        // hide
        btnMore.isHidden = true
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
    
    public static func getCellHeight(view: UITableView, indexPath: IndexPath, dataList: [Gift]?) -> CGFloat {
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
        let gift = dataList![row]
        return getHeightByData(gift: gift)
    }
    
    public static func refreshHeightMap(refresh: Bool, start: Int, dataList: [Gift]?) {
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
        for (index, gift) in dataList!.enumerated() {
            let height = getHeightByData(gift: gift)
            heightMap[index + startIndex] = height
        }
    }
    
    public static func getHeightByData(margin: CGFloat = ITEM_MARGIN, gift: Gift) -> CGFloat {
        // const
        let cell = NoteGiftCell(style: .default, reuseIdentifier: NoteGiftCell.ID)
        if totalHeight == nil {
            totalHeight = cell.vCard.frame.origin.y + cell.vCard.frame.size.height + margin / 2
        }
        // img
        var imgListHeight = CGFloat(0)
        if gift.contentImageList.count > 0 {
            imgListHeight = ImgSquareShowCell.getCollectHeight(collect: cell.collectImgList, dataList: gift.contentImageList)
        }
        return totalHeight! + imgListHeight
    }
    
    public static func getMuliCellHeight(dataList: [Gift]?) -> CGFloat {
        if dataList == nil || dataList!.count <= 0 {
            return CGFloat(0)
        }
        var totalHeight = CGFloat(0)
        for gift in dataList! {
            totalHeight += getHeightByData(gift: gift)
        }
        return totalHeight
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Gift]?, heightMap: Bool = true) -> NoteGiftCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? NoteGiftCell
        if cell == nil {
            cell = NoteGiftCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= cell!.tag {
            return cell!
        }
        let gift = dataList![cell!.tag]
        let me = UDHelper.getMe()
        let avatar = UserHelper.getAvatar(user: me, uid: gift.receiveId)
        cell?.imgList = gift.contentImageList
        
        // view
        cell?.btnMore.isHidden = true
        KFHelper.setImgAvatarUrl(iv: cell?.ivAvatar, objKey: avatar, uid: gift.receiveId)
        cell?.lTitle.text = gift.title
        cell?.lHappenAt.text = TimeHelper.getTimeShowLine_HM_MD_YMD_ByGo(gift.happenAt)
        
        cell?.collectImgList.isHidden = gift.contentImageList.count <= 0
        
        // size
        AppDelegate.runOnMainAsync {
            let cellHeight = heightMap ? getCellHeight(view: view, indexPath: indexPath, dataList: dataList) : getHeightByData(gift: gift)
            // card
            let vCardHeight = cellHeight - ITEM_MARGIN
            if (cell?.vCard.frame.size.height ?? 0) != vCardHeight {
                cell?.vCard.frame.size.height = vCardHeight
            }
            ViewUtils.setViewShadow(cell?.vCard, offset: ViewHelper.SHADOW_NORMAL)
            // img
            let collectImgHeight = gift.contentImageList.count > 0 ? ImgSquareShowCell.getCollectHeight(collect: cell?.collectImgList, dataList: gift.contentImageList) : 0
            if (cell?.collectImgList.frame.size.height ?? 0) != collectImgHeight {
                cell?.collectImgList.frame.size.height = collectImgHeight
            }
            cell?.collectImgList.reloadData()
        }
        return cell!
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Gift]?, heightMap: Bool = true, target: Any?, actionEdit: Selector) -> NoteGiftCell {
        let cell = getCellWithData(view: view, indexPath: indexPath, dataList: dataList, heightMap: heightMap)
        cell.btnMore.isHidden = false
        cell.btnMore.addTarget(target, action: actionEdit, for: .touchUpInside)
        return cell
    }
    
    public static func selectGift(view: UITableView, indexPath: IndexPath, dataList: [Gift]?) {
        RootVC.get().popBack()
        if dataList == nil || dataList!.count <= indexPath.row {
            return
        }
        let gift = dataList![indexPath.row]
        NotifyHelper.post(NotifyHelper.TAG_GIFT_SELECT, obj: gift)
    }
    
    public static func goEdit(view: UIView?, dataList: [Gift]?) {
        if let indexPath = ViewUtils.findTableIndexPath(view: view) {
            if dataList == nil || dataList!.count <= indexPath.row {
                return
            }
            let gift = dataList![indexPath.row]
            NoteGiftEditVC.pushVC(gift: gift)
        }
    }
    
}
