//
//  NoteDreamCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/22.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteDreamCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    private static var contentFont: UIFont?
    
    private static let ITEM_MARGIN = ScreenUtils.widthFit(10)
    private static let AVATAR_WIDTH = ScreenUtils.widthFit(30)
    private static let CARD_WIDTH = ScreenUtils.getScreenWidth() - ITEM_MARGIN * 2
    private static let CARD_CONTENT_WIDTH = CARD_WIDTH - ITEM_MARGIN * 2
    
    // view
    private var vCard: UIView!
    private var btnMore: UIButton!
    private var ivAvatar: UIImageView!
    private var lHappenAt: UILabel!
    private var lTextCount: UILabel!
    private var lContent: UILabel!
    
    // var
    private static var heightMap: [Int: CGFloat] = [Int: CGFloat]()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // avatar
        ivAvatar = ViewHelper.getImageViewAvatar(width: NoteDreamCell.AVATAR_WIDTH, height: NoteDreamCell.AVATAR_WIDTH)
        ivAvatar.frame.origin = CGPoint(x: NoteDreamCell.ITEM_MARGIN, y: NoteDreamCell.ITEM_MARGIN)
        let vAvatarShadow = ViewUtils.getViewShadow(ivAvatar, bgColor: ColorHelper.getWhite(), offset: ViewHelper.SHADOW_NORMAL)
        
        // more
        btnMore = ViewHelper.getBtnImgCenter(paddingH: NoteDreamCell.ITEM_MARGIN, paddingV: NoteDreamCell.ITEM_MARGIN, bgImg: UIImage(named: "ic_more_horiz_grey_18dp"))
        btnMore.frame.origin = CGPoint(x: NoteDreamCell.CARD_WIDTH - btnMore.frame.size.width, y: 0)
        
        // count
        lTextCount = ViewHelper.getLabelGreySmall(width: ScreenUtils.widthFit(70), text: "-", lines: 1, align: .right, mode: .byTruncatingMiddle)
        lTextCount.frame.origin = CGPoint(x: NoteDreamCell.CARD_WIDTH - NoteDreamCell.ITEM_MARGIN - lTextCount.frame.size.width, y: ivAvatar.frame.origin.y + ivAvatar.frame.size.height - lTextCount.frame.size.height)
        
        // happen
        lHappenAt = ViewHelper.getLabelBold(width: NoteDreamCell.CARD_WIDTH - ivAvatar.frame.origin.x - ivAvatar.frame.size.width - NoteDreamCell.ITEM_MARGIN * 3 - lTextCount.frame.size.width, text: "-", color: ColorHelper.getFontBlack(), lines: 1, align: .left)
        lHappenAt.frame.origin.x = ivAvatar.frame.origin.x + ivAvatar.frame.size.width + NoteDreamCell.ITEM_MARGIN
        lHappenAt.center.y = ivAvatar.center.y
        
        // line
        let vLine = ViewHelper.getViewLine(width: NoteDreamCell.CARD_CONTENT_WIDTH)
        vLine.frame.origin = CGPoint(x: NoteDreamCell.ITEM_MARGIN, y: ivAvatar.frame.origin.y + ivAvatar.frame.size.height + NoteDreamCell.ITEM_MARGIN)
        
        // content
        lContent = ViewHelper.getLabelGreyNormal(width: NoteDreamCell.CARD_CONTENT_WIDTH, height: CGFloat(0), text: "-", lines: 5, align: .left, mode: .byTruncatingTail)
        lContent.frame.origin = CGPoint(x: NoteDreamCell.ITEM_MARGIN, y: vLine.frame.origin.y + vLine.frame.size.height + NoteDreamCell.ITEM_MARGIN)
        
        // card
        vCard = UIView(frame: CGRect(x: NoteDreamCell.ITEM_MARGIN, y: NoteDreamCell.ITEM_MARGIN / 2, width: NoteDreamCell.CARD_WIDTH, height: lContent.frame.origin.y + lContent.frame.size.height + NoteDreamCell.ITEM_MARGIN))
        vCard.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vCard, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vCard, offset: ViewHelper.SHADOW_NORMAL)
        
        vCard.addSubview(vAvatarShadow)
        vCard.addSubview(ivAvatar)
        vCard.addSubview(btnMore)
        vCard.addSubview(lHappenAt)
        vCard.addSubview(lTextCount)
        vCard.addSubview(vLine)
        vCard.addSubview(lContent)
        
        // view
        self.contentView.addSubview(vCard)
        
        // hide
        btnMore.isHidden = true
    }
    
    public static func getCellHeight(view: UITableView, indexPath: IndexPath, dataList: [Dream]?) -> CGFloat {
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
        let dream = dataList![row]
        return getHeightByData(dream: dream)
    }
    
    public static func refreshHeightMap(refresh: Bool, start: Int, dataList: [Dream]?) {
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
        for (index, dream) in dataList!.enumerated() {
            let height = getHeightByData(dream: dream)
            heightMap[index + startIndex] = height
        }
    }
    
    public static func getHeightByData(margin: CGFloat = ITEM_MARGIN, maxHeight: CGFloat = ViewHelper.FONT_NORMAL_LINE_HEIGHT * 5, dream: Dream) -> CGFloat {
        // const
        if totalHeight == nil || contentFont == nil {
            let cell = NoteDreamCell(style: .default, reuseIdentifier: NoteDreamCell.ID)
            totalHeight = cell.vCard.frame.origin.y + cell.vCard.frame.size.height + margin / 2
            contentFont = cell.lContent.font
        }
        // offset
        let height = ViewUtils.getFontHeight(font: contentFont, width: CARD_CONTENT_WIDTH, text: dream.contentText)
        let realHeight = height > maxHeight ? maxHeight : height
        return totalHeight! + realHeight
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Dream]?, heightMap: Bool = true) -> NoteDreamCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? NoteDreamCell
        if cell == nil {
            cell = NoteDreamCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= cell!.tag {
            return cell!
        }
        let dream = dataList![cell!.tag]
        let me = UDHelper.getMe()
        let avatar = UserHelper.getAvatar(user: me, uid: dream.userId)
        
        // view
        cell?.btnMore.isHidden = true
        KFHelper.setImgAvatarUrl(iv: cell?.ivAvatar, objKey: avatar, uid: dream.userId)
        cell?.lHappenAt.text = TimeHelper.getTimeShowLine_HM_MD_YMD_ByGo(dream.happenAt)
        cell?.lTextCount.text = StringUtils.getString("text_number_space_colon_holder", arguments: [dream.contentText.count])
        cell?.lContent.text = dream.contentText
        
        // size
        AppDelegate.runOnMainAsync {
            let cellHeight = heightMap ? getCellHeight(view: view, indexPath: indexPath, dataList: dataList) : getHeightByData(dream: dream)
            let vCardHeight = cellHeight - ITEM_MARGIN
            let lContentHeight = cellHeight - (totalHeight ?? 0)
            if (cell?.vCard.frame.size.height ?? 0) != vCardHeight {
                cell?.vCard.frame.size.height = vCardHeight
            }
            ViewUtils.setViewShadow(cell?.vCard, offset: ViewHelper.SHADOW_NORMAL)
            if (cell?.lContent.frame.size.height ?? 0) != lContentHeight {
                cell?.lContent.frame.size.height = lContentHeight
            }
        }
        return cell!
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Dream]?, heightMap: Bool = true, target: Any?, actionEdit: Selector) -> NoteDreamCell {
        let cell = getCellWithData(view: view, indexPath: indexPath, dataList: dataList, heightMap: heightMap)
        cell.btnMore.isHidden = false
        cell.btnMore.addTarget(target, action: actionEdit, for: .touchUpInside)
        return cell
    }
    
    public static func goDreamDetail(view: UITableView, indexPath: IndexPath, dataList: [Dream]?) {
        if dataList == nil || dataList!.count <= indexPath.row {
            return
        }
        let dream = dataList![indexPath.row]
        NoteDreamDetailVC.pushVC(dream: dream)
    }
    
}
