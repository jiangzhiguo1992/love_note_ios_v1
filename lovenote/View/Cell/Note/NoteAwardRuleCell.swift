//
//  NoteAwardRuleCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/23.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteAwardRuleCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    private static var titleFont: UIFont?
    
    private static let ITEM_MARGIN = ScreenUtils.widthFit(10)
    private static let MAX_WIDTH = ScreenUtils.getScreenWidth()
    private static let CARD_WIDTH = MAX_WIDTH - ITEM_MARGIN * 2
    private static let CARD_CONTENT_WIDTH = CARD_WIDTH - ITEM_MARGIN * 2
    
    // view
    private var vCard: UIView!
    private var lScore: UILabel!
    private var lCount: UILabel!
    private var btnMore: UIButton!
    private var lTitle: UILabel!
    private var lCreator: UILabel!
    private var lCreateAt: UILabel!
    
    // var
    private static var heightMap: [Int: CGFloat] = [Int: CGFloat]()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // score
        lScore = ViewHelper.getLabelBold(width: NoteAwardRuleCell.CARD_CONTENT_WIDTH / 2, text: "-", size: ScreenUtils.fontFit(30), color: ColorHelper.getFontBlack(), lines: 1, align: .center, mode: .byTruncatingMiddle)
        lScore.frame.origin = CGPoint(x: NoteAwardRuleCell.ITEM_MARGIN, y: NoteAwardRuleCell.ITEM_MARGIN)
        
        // count
        lCount = ViewHelper.getLabelBold(width: NoteAwardRuleCell.CARD_CONTENT_WIDTH / 2, text: "-", size: ScreenUtils.fontFit(30), color: ColorHelper.getFontBlack(), lines: 1, align: .center, mode: .byTruncatingMiddle)
        lCount.frame.origin = CGPoint(x: NoteAwardRuleCell.CARD_WIDTH / 2, y: NoteAwardRuleCell.ITEM_MARGIN)
        
        // line
        let lineCenter = ViewHelper.getViewLine(height: lScore.frame.size.height + NoteAwardRuleCell.ITEM_MARGIN)
        lineCenter.frame.origin = CGPoint(x: NoteAwardRuleCell.CARD_WIDTH / 2, y: NoteAwardRuleCell.ITEM_MARGIN)
        let lineBottom = ViewHelper.getViewLine(width: NoteAwardRuleCell.CARD_CONTENT_WIDTH)
        lineBottom.frame.origin = CGPoint(x: NoteAwardRuleCell.ITEM_MARGIN, y: lineCenter.frame.origin.y + lineCenter.frame.size.height)
        
        // more
        btnMore = ViewHelper.getBtnImgCenter(paddingH: NoteAwardRuleCell.ITEM_MARGIN, paddingV: NoteAwardRuleCell.ITEM_MARGIN, bgImg: UIImage(named: "ic_more_horiz_grey_18dp"))
        btnMore.frame.origin = CGPoint(x: NoteAwardRuleCell.CARD_WIDTH - btnMore.frame.size.width, y: 0)
        
        // title
        lTitle = ViewHelper.getLabelBlackNormal(width: NoteAwardRuleCell.CARD_CONTENT_WIDTH, height: CGFloat(0), text: "-", lines: 0, align: .center)
        lTitle.frame.origin = CGPoint(x: NoteAwardRuleCell.ITEM_MARGIN, y: lineBottom.frame.origin.y + lineBottom.frame.size.height + NoteAwardRuleCell.ITEM_MARGIN)
        
        // creator
        lCreator = ViewHelper.getLabelGreySmall(width: (NoteAwardRuleCell.CARD_CONTENT_WIDTH - NoteAwardRuleCell.ITEM_MARGIN) / 2,text: "-", lines: 1, align: .left, mode: .byTruncatingMiddle)
        lCreator.frame.origin = CGPoint(x: NoteAwardRuleCell.ITEM_MARGIN, y: lTitle.frame.origin.y + lTitle.frame.size.height + NoteAwardRuleCell.ITEM_MARGIN)
        
        // create
        lCreateAt = ViewHelper.getLabelGreySmall(width: (NoteAwardRuleCell.CARD_CONTENT_WIDTH - NoteAwardRuleCell.ITEM_MARGIN) / 2,text: "-", lines: 1, align: .right, mode: .byTruncatingMiddle)
        lCreateAt.frame.origin = CGPoint(x: NoteAwardRuleCell.CARD_WIDTH - NoteAwardRuleCell.ITEM_MARGIN - lCreateAt.frame.size.width, y: lTitle.frame.origin.y + lTitle.frame.size.height + NoteAwardRuleCell.ITEM_MARGIN)
        
        // card
        vCard = UIView(frame: CGRect(x: NoteAwardRuleCell.ITEM_MARGIN, y: NoteAwardRuleCell.ITEM_MARGIN / 2, width: NoteAwardRuleCell.CARD_WIDTH, height: lCreator.frame.origin.y + lCreator.frame.size.height + NoteAwardRuleCell.ITEM_MARGIN))
        vCard.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vCard, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vCard, offset: ViewHelper.SHADOW_NORMAL)
        
        vCard.addSubview(lScore)
        vCard.addSubview(lCount)
        vCard.addSubview(lineCenter)
        vCard.addSubview(lineBottom)
        vCard.addSubview(btnMore)
        vCard.addSubview(lTitle)
        vCard.addSubview(lCreator)
        vCard.addSubview(lCreateAt)
        
        // view
        self.contentView.addSubview(vCard)
    }
    
    public static func getCellHeight(view: UITableView, indexPath: IndexPath, dataList: [AwardRule]?) -> CGFloat {
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
        let awardRule = dataList![row]
        return getHeightByData(awardRule: awardRule)
    }
    
    public static func refreshHeightMap(refresh: Bool, start: Int, dataList: [AwardRule]?) {
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
        for (index, awardRule) in dataList!.enumerated() {
            let height = getHeightByData(awardRule: awardRule)
            heightMap[index + startIndex] = height
        }
    }
    
    private static func getHeightByData(margin: CGFloat = ITEM_MARGIN, awardRule: AwardRule) -> CGFloat {
        // const
        if totalHeight == nil || titleFont == nil {
            let cell = NoteAwardRuleCell(style: .default, reuseIdentifier: NoteAwardRuleCell.ID)
            totalHeight = cell.vCard.frame.origin.y + cell.vCard.frame.size.height + margin / 2
            titleFont = cell.lTitle.font
        }
        // offset
        let height = ViewUtils.getFontHeight(font: titleFont, width: CARD_CONTENT_WIDTH, text: awardRule.title)
        return totalHeight! + height
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [AwardRule]?, target: Any?, actionEdit: Selector) -> NoteAwardRuleCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? NoteAwardRuleCell
        if cell == nil {
            cell = NoteAwardRuleCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= cell!.tag {
            return cell!
        }
        let awardRule = dataList![cell!.tag]
        let me = UDHelper.getMe()
        
        // view
        cell?.lScore.text = awardRule.score > 0 ? "+\(awardRule.score)" : "\(awardRule.score)"
        cell?.lCount.text = "\(awardRule.useCount)"
        cell?.lTitle.text = awardRule.title
        cell?.lCreator.text = UserHelper.getName(user: me, uid: awardRule.userId)
        cell?.lCreateAt.text = TimeHelper.getTimeShowLine_HM_MDHM_YMDHM_ByGo(awardRule.createAt)
        
        // size
        AppDelegate.runOnMainAsync {
            let cellHeight = getCellHeight(view: view, indexPath: indexPath, dataList: dataList)
            let vCardHeight = cellHeight - ITEM_MARGIN
            let lTitleHeight = cellHeight - (totalHeight ?? 0)
            if (cell?.vCard.frame.size.height ?? 0) != vCardHeight {
                cell?.vCard.frame.size.height = vCardHeight
            }
            ViewUtils.setViewShadow(cell?.vCard, offset: ViewHelper.SHADOW_NORMAL)
            if (cell?.lTitle.frame.size.height ?? 0) != lTitleHeight {
                cell?.lTitle.frame.size.height = lTitleHeight
            }
            cell?.lCreator.frame.origin.y = (cell?.lTitle.frame.origin.y ?? 0) + (cell?.lTitle.frame.size.height ?? 0) + NoteAwardRuleCell.ITEM_MARGIN
            cell?.lCreateAt.frame.origin.y = (cell?.lTitle.frame.origin.y ?? 0) + (cell?.lTitle.frame.size.height ?? 0) + NoteAwardRuleCell.ITEM_MARGIN
        }
        // target
        cell?.btnMore.addTarget(target, action: actionEdit, for: .touchUpInside)
        return cell!
    }
    
    public static func selectAwardRule(view: UITableView, indexPath: IndexPath, dataList: [AwardRule]?) {
        RootVC.get().popBack()
        if dataList == nil || dataList!.count <= indexPath.row {
            return
        }
        let awardRule = dataList![indexPath.row]
        NotifyHelper.post(NotifyHelper.TAG_AWARD_RULE_SELECT, obj: awardRule)
    }
    
}
