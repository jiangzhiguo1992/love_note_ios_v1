//
//  NoteAwardCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/23.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteAwardCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    private static var contentFont: UIFont?
    
    private static let ITEM_MARGIN = ScreenUtils.widthFit(10)
    private static let AVATAR_WIDTH = ScreenUtils.widthFit(40)
    private static let MAX_WIDTH = ScreenUtils.getScreenWidth()
    private static let CARD_WIDTH = MAX_WIDTH - ITEM_MARGIN * 2
    private static let CARD_CONTENT_WIDTH = CARD_WIDTH - ITEM_MARGIN * 2
    
    // view
    private var ivAvatar: UIImageView!
    private var lScoreTa: UILabel!
    private var vScoreTaShadow: UIView!
    private var lScoreMe: UILabel!
    private var vScoreMeShadow: UIView!
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
        ivAvatar = ViewHelper.getImageViewAvatar(width: NoteAwardCell.AVATAR_WIDTH, height: NoteAwardCell.AVATAR_WIDTH)
        ivAvatar.center.x = NoteAwardCell.MAX_WIDTH / 2
        ivAvatar.frame.origin.y = NoteAwardCell.ITEM_MARGIN / 2
        let vAvatarShadow = ViewUtils.getViewShadow(ivAvatar, bgColor: ColorHelper.getWhite(), offset: ViewHelper.SHADOW_NORMAL)
        
        // scoreTa
        lScoreTa = ViewHelper.getLabelBlackNormal(width: NoteAwardCell.AVATAR_WIDTH, height: NoteAwardCell.AVATAR_WIDTH, text: "-", lines: 1, align: .center)
        lScoreTa.center.x = NoteAwardCell.MAX_WIDTH / 4
        lScoreTa.frame.origin.y = NoteAwardCell.ITEM_MARGIN / 2
        ViewUtils.setViewRadiusCircle(lScoreTa, bounds: true)
        vScoreTaShadow = ViewUtils.getViewShadow(lScoreTa, radius: lScoreTa.frame.size.height / 2, bgColor: ColorHelper.getWhite(), offset: ViewHelper.SHADOW_NORMAL)
        lScoreTa.backgroundColor = ColorHelper.getWhite()
        
        // scoreMe
        lScoreMe = ViewHelper.getLabelBlackNormal(width: NoteAwardCell.AVATAR_WIDTH, height: NoteAwardCell.AVATAR_WIDTH, text: "-", lines: 1, align: .center)
        lScoreMe.center.x = NoteAwardCell.MAX_WIDTH / 4 * 3
        lScoreMe.frame.origin.y = NoteAwardCell.ITEM_MARGIN / 2
        ViewUtils.setViewRadiusCircle(lScoreMe, bounds: true)
        vScoreMeShadow = ViewUtils.getViewShadow(lScoreMe, radius: lScoreMe.frame.size.height / 2, bgColor: ColorHelper.getWhite(), offset: ViewHelper.SHADOW_NORMAL)
        lScoreMe.backgroundColor = ColorHelper.getWhite()
        
        // more
        btnMore = ViewHelper.getBtnImgCenter(paddingH: NoteAwardCell.ITEM_MARGIN, paddingV: NoteAwardCell.ITEM_MARGIN, bgImg: UIImage(named: "ic_more_horiz_grey_18dp"))
        btnMore.frame.origin = CGPoint(x: NoteAwardCell.CARD_WIDTH - btnMore.frame.size.width, y: 0)
        
        // content
        lContent = ViewHelper.getLabelBlackNormal(width: NoteAwardCell.CARD_CONTENT_WIDTH, height: CGFloat(0), text: "-", lines: 0, align: .left)
        lContent.frame.origin = CGPoint(x: NoteAwardCell.ITEM_MARGIN, y: NoteAwardCell.AVATAR_WIDTH / 2 + ScreenUtils.heightFit(15))
        
        // creator
        lCreator = ViewHelper.getLabelGreySmall(width: (NoteAwardCell.CARD_CONTENT_WIDTH - NoteAwardCell.ITEM_MARGIN) / 2,text: "-", lines: 1, align: .left, mode: .byTruncatingMiddle)
        lCreator.frame.origin = CGPoint(x: NoteAwardCell.ITEM_MARGIN, y: lContent.frame.origin.y + lContent.frame.size.height + NoteAwardCell.ITEM_MARGIN)
        
        // happen
        lHappenAt = ViewHelper.getLabelGreySmall(width: (NoteAwardCell.CARD_CONTENT_WIDTH - NoteAwardCell.ITEM_MARGIN) / 2,text: "-", lines: 1, align: .right, mode: .byTruncatingMiddle)
        lHappenAt.frame.origin = CGPoint(x: NoteAwardCell.CARD_WIDTH - NoteAwardCell.ITEM_MARGIN - lHappenAt.frame.size.width, y: lContent.frame.origin.y + lContent.frame.size.height + NoteAwardCell.ITEM_MARGIN)
        
        // card
        vCard = UIView(frame: CGRect(x: NoteAwardCell.ITEM_MARGIN, y: (ivAvatar.frame.size.height / 2) + (NoteAwardCell.ITEM_MARGIN / 2), width: NoteAwardCell.CARD_WIDTH, height: lCreator.frame.origin.y + lCreator.frame.size.height + NoteAwardCell.ITEM_MARGIN))
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
        self.contentView.addSubview(vScoreTaShadow)
        self.contentView.addSubview(lScoreTa)
        self.contentView.addSubview(vScoreMeShadow)
        self.contentView.addSubview(lScoreMe)
        
        // hide
        vScoreTaShadow.isHidden = true
        lScoreTa.isHidden = true
        vScoreMeShadow.isHidden = true
        lScoreMe.isHidden = true
    }
    
    public static func getCellHeight(view: UITableView, indexPath: IndexPath, dataList: [Award]?) -> CGFloat {
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
        let award = dataList![row]
        return getHeightByData(award: award)
    }
    
    public static func refreshHeightMap(refresh: Bool, start: Int, dataList: [Award]?) {
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
        for (index, award) in dataList!.enumerated() {
            let height = getHeightByData(award: award)
            heightMap[index + startIndex] = height
        }
    }
    
    public static func getHeightByData(margin: CGFloat = ITEM_MARGIN, award: Award) -> CGFloat {
        // const
        if totalHeight == nil || contentFont == nil {
            let cell = NoteAwardCell(style: .default, reuseIdentifier: NoteAwardCell.ID)
            totalHeight = cell.vCard.frame.origin.y + cell.vCard.frame.size.height + margin / 2
            contentFont = cell.lContent.font
        }
        // offset
        let height = ViewUtils.getFontHeight(font: contentFont, width: CARD_CONTENT_WIDTH, text: award.contentText)
        return totalHeight! + height
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Award]?, heightMap: Bool = true, target: Any?, actionEdit: Selector) -> NoteAwardCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? NoteAwardCell
        if cell == nil {
            cell = NoteAwardCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= cell!.tag {
            return cell!
        }
        let award = dataList![cell!.tag]
        let me = UDHelper.getMe()
        let avatar = UserHelper.getAvatar(user: me, uid: award.happenId)
        let scoreChange = award.scoreChange > 0 ? "+\(award.scoreChange)" : "\(award.scoreChange)"
        
        // view
        KFHelper.setImgAvatarUrl(iv: cell?.ivAvatar, objKey: avatar, uid: award.happenId)
        cell?.lScoreTa.text = scoreChange
        cell?.lScoreMe.text = scoreChange
        cell?.vScoreTaShadow.isHidden = (me?.id == award.happenId)
        cell?.lScoreTa.isHidden = (me?.id == award.happenId)
        cell?.vScoreMeShadow.isHidden = (me?.id != award.happenId)
        cell?.lScoreMe.isHidden = (me?.id != award.happenId)
        cell?.lContent.text = award.contentText
        cell?.lCreator.text = UserHelper.getName(user: me, uid: award.userId)
        cell?.lHappenAt.text = TimeHelper.getTimeShowLine_HM_MDHM_YMDHM_ByGo(award.happenAt)
        
        // size
        AppDelegate.runOnMainAsync {
            let cellHeight = heightMap ? getCellHeight(view: view, indexPath: indexPath, dataList: dataList) : getHeightByData(award: award)
            let vCardHeight = cellHeight - ITEM_MARGIN - (AVATAR_WIDTH / 2)
            let lContentHeight = cellHeight - (totalHeight ?? 0)
            if (cell?.vCard.frame.size.height ?? 0) != vCardHeight {
                cell?.vCard.frame.size.height = vCardHeight
            }
            ViewUtils.setViewShadow(cell?.vCard, offset: ViewHelper.SHADOW_NORMAL)
            if (cell?.lContent.frame.size.height ?? 0) != lContentHeight {
                cell?.lContent.frame.size.height = lContentHeight
            }
            cell?.lCreator.frame.origin.y = (cell?.lContent.frame.origin.y ?? 0) + (cell?.lContent.frame.size.height ?? 0) + NoteAwardCell.ITEM_MARGIN
            cell?.lHappenAt.frame.origin.y = (cell?.lContent.frame.origin.y ?? 0) + (cell?.lContent.frame.size.height ?? 0) + NoteAwardCell.ITEM_MARGIN
        }
        // target
        cell?.btnMore.addTarget(target, action: actionEdit, for: .touchUpInside)
        return cell!
    }
    
}
