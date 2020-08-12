//
//  NoteAngryCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/26.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteAngryCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    private static var contentFont: UIFont?
    
    private static let ITEM_MARGIN = ScreenUtils.widthFit(10)
    private static let AVATAR_WIDTH = ScreenUtils.widthFit(30)
    private static let MAX_WIDTH = ScreenUtils.getScreenWidth()
    private static let CARD_WIDTH = MAX_WIDTH - ITEM_MARGIN * 2
    private static let CARD_CONTENT_WIDTH = CARD_WIDTH - ITEM_MARGIN * 2
    
    // view
    private var ivAvatar: UIImageView!
    private var vCard: UIView!
    private var btnMore: UIButton!
    private var lContent: UILabel!
    private var lCreator: UILabel!
    private var lHappenAt: UILabel!
    
    // var
    private static var heightMap: [Int: CGFloat] = [Int: CGFloat]()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // avatar
        ivAvatar = ViewHelper.getImageViewAvatar(width: NoteAngryCell.AVATAR_WIDTH, height: NoteAngryCell.AVATAR_WIDTH)
        ivAvatar.center.x = NoteAngryCell.MAX_WIDTH / 2
        ivAvatar.frame.origin.y = NoteAngryCell.ITEM_MARGIN / 2
        let vAvatarShadow = ViewUtils.getViewShadow(ivAvatar, bgColor: ColorHelper.getWhite(), offset: ViewHelper.SHADOW_NORMAL)
        
        // more
        btnMore = ViewHelper.getBtnImgCenter(paddingH: NoteAngryCell.ITEM_MARGIN, paddingV: NoteAngryCell.ITEM_MARGIN, bgImg: UIImage(named: "ic_more_horiz_grey_18dp"))
        btnMore.frame.origin = CGPoint(x: NoteAngryCell.CARD_WIDTH - btnMore.frame.size.width, y: 0)
        
        // content
        lContent = ViewHelper.getLabelBlackNormal(width: NoteAngryCell.CARD_CONTENT_WIDTH, height: CGFloat(0), text: "-", lines: 0, align: .left, mode: .byTruncatingTail)
        lContent.frame.origin = CGPoint(x: NoteAngryCell.ITEM_MARGIN, y: NoteAngryCell.AVATAR_WIDTH / 2 + NoteAngryCell.ITEM_MARGIN)
        
        // creator
        lCreator = ViewHelper.getLabelGreySmall(width: (NoteAngryCell.CARD_CONTENT_WIDTH - NoteAngryCell.ITEM_MARGIN) / 2,text: "-", lines: 1, align: .left, mode: .byTruncatingMiddle)
        lCreator.frame.origin = CGPoint(x: NoteAngryCell.ITEM_MARGIN, y: lContent.frame.origin.y + lContent.frame.size.height + NoteAngryCell.ITEM_MARGIN)
        
        // happen
        lHappenAt = ViewHelper.getLabelGreySmall(width: (NoteAngryCell.CARD_CONTENT_WIDTH - NoteAngryCell.ITEM_MARGIN) / 2,text: "-", lines: 1, align: .right, mode: .byTruncatingMiddle)
        lHappenAt.frame.origin = CGPoint(x: NoteAngryCell.CARD_WIDTH - NoteAngryCell.ITEM_MARGIN - lHappenAt.frame.size.width, y: lContent.frame.origin.y + lContent.frame.size.height + NoteAngryCell.ITEM_MARGIN)
        
        // card
        vCard = UIView(frame: CGRect(x: NoteAngryCell.ITEM_MARGIN, y: (ivAvatar.frame.size.height / 2) + (NoteAngryCell.ITEM_MARGIN / 2), width: NoteAngryCell.CARD_WIDTH, height: lCreator.frame.origin.y + lCreator.frame.size.height + NoteAngryCell.ITEM_MARGIN))
        vCard.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vCard, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vCard, offset: ViewHelper.SHADOW_NORMAL)
        
        vCard.addSubview(btnMore)
        vCard.addSubview(lContent)
        vCard.addSubview(lCreator)
        vCard.addSubview(lHappenAt)
        
        // view
        self.contentView.addSubview(vCard)
        self.contentView.addSubview(vAvatarShadow)
        self.contentView.addSubview(ivAvatar)
        
        // hide
        btnMore.isHidden = true
    }
    
    public static func getCellHeight(view: UITableView, indexPath: IndexPath, dataList: [Angry]?) -> CGFloat {
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
        let angry = dataList![row]
        return getHeightByData(angry: angry)
    }
    
    public static func refreshHeightMap(refresh: Bool, start: Int, dataList: [Angry]?) {
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
        for (index, angry) in dataList!.enumerated() {
            let height = getHeightByData(angry: angry)
            heightMap[index + startIndex] = height
        }
    }
    
    public static func getHeightByData(margin: CGFloat = ITEM_MARGIN, maxHeight: CGFloat = ViewHelper.FONT_NORMAL_LINE_HEIGHT * 3, angry: Angry) -> CGFloat {
        // const
        if totalHeight == nil || contentFont == nil {
            let cell = NoteAngryCell(style: .default, reuseIdentifier: NoteAngryCell.ID)
            totalHeight = cell.vCard.frame.origin.y + cell.vCard.frame.size.height + margin / 2
            contentFont = cell.lContent.font
        }
        // offset
        let height = ViewUtils.getFontHeight(font: contentFont, width: CARD_CONTENT_WIDTH, text: angry.contentText)
        let realHeight = height > maxHeight ? maxHeight : height
        return totalHeight! + realHeight
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Angry]?, heightMap: Bool = true) -> NoteAngryCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? NoteAngryCell
        if cell == nil {
            cell = NoteAngryCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= cell!.tag {
            return cell!
        }
        let angry = dataList![cell!.tag]
        let me = UDHelper.getMe()
        let avatar = UserHelper.getAvatar(user: me, uid: angry.happenId)
        
        // view
        cell?.btnMore.isHidden = true
        KFHelper.setImgAvatarUrl(iv: cell?.ivAvatar, objKey: avatar, uid: angry.happenId)
        cell?.lContent.text = angry.contentText
        cell?.lCreator.text = UserHelper.getName(user: me, uid: angry.userId)
        cell?.lHappenAt.text = TimeHelper.getTimeShowLine_HM_MD_YMD_ByGo(angry.happenAt)
        
        // size
        AppDelegate.runOnMainAsync {
            let cellHeight = heightMap ? getCellHeight(view: view, indexPath: indexPath, dataList: dataList) : getHeightByData(angry: angry)
            let vCardHeight = cellHeight - ITEM_MARGIN - (AVATAR_WIDTH / 2)
            let lContentHeight = cellHeight - (totalHeight ?? 0)
            if (cell?.vCard.frame.size.height ?? 0) != vCardHeight {
                cell?.vCard.frame.size.height = vCardHeight
            }
            ViewUtils.setViewShadow(cell?.vCard, offset: ViewHelper.SHADOW_NORMAL)
            if (cell?.lContent.frame.size.height ?? 0) != lContentHeight {
                cell?.lContent.frame.size.height = lContentHeight
            }
            cell?.lCreator.frame.origin.y = (cell?.lContent.frame.origin.y ?? 0) + (cell?.lContent.frame.size.height ?? 0) + NoteAngryCell.ITEM_MARGIN
            cell?.lHappenAt.frame.origin.y = (cell?.lContent.frame.origin.y ?? 0) + (cell?.lContent.frame.size.height ?? 0) + NoteAngryCell.ITEM_MARGIN
        }
        return cell!
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Angry]?, heightMap: Bool = true, target: Any?, actionEdit: Selector) -> NoteAngryCell {
        let cell = getCellWithData(view: view, indexPath: indexPath, dataList: dataList, heightMap: heightMap)
        cell.btnMore.isHidden = false
        cell.btnMore.addTarget(target, action: actionEdit, for: .touchUpInside)
        return cell
    }
    
    public static func goAngryDetail(view: UITableView, indexPath: IndexPath, dataList: [Angry]?) {
        if dataList == nil || dataList!.count <= indexPath.row {
            return
        }
        let angry = dataList![indexPath.row]
        NoteAngryDetailVC.pushVC(angry: angry)
    }
    
}
