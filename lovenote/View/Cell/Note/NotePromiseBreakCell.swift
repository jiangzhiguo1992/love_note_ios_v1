//
//  NotePromiseBreakCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/25.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NotePromiseBreakCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    private static var contentFont: UIFont?
    
    private static let ITEM_MARGIN = ScreenUtils.widthFit(10)
    private static let CARD_WIDTH = ScreenUtils.getScreenWidth() - ITEM_MARGIN * 2
    private static let CARD_CONTENT_WIDTH = CARD_WIDTH - ITEM_MARGIN * 2
    
    // view
    private var vCard: UIView!
    private var btnMore: UIButton!
    private var lHappenAt: UILabel!
    private var lContent: UILabel!
    
    // var
    private static var heightMap: [Int: CGFloat] = [Int: CGFloat]()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // more
        btnMore = ViewHelper.getBtnImgCenter(paddingH: NotePromiseBreakCell.ITEM_MARGIN, paddingV: NotePromiseBreakCell.ITEM_MARGIN, bgImg: UIImage(named: "ic_more_horiz_grey_18dp"))
        btnMore.frame.origin = CGPoint(x: NotePromiseBreakCell.CARD_WIDTH - btnMore.frame.size.width, y: 0)
        
        // happen
        lHappenAt = ViewHelper.getLabelGreySmall(width: NotePromiseBreakCell.CARD_CONTENT_WIDTH, text: "-", lines: 1, align: .left, mode: .byTruncatingMiddle)
        lHappenAt.frame.origin = CGPoint(x: NotePromiseBreakCell.ITEM_MARGIN, y: NotePromiseBreakCell.ITEM_MARGIN)
        
        // content
        lContent = ViewHelper.getLabelBlackNormal(width: NotePromiseBreakCell.CARD_CONTENT_WIDTH, height: CGFloat(0), text: "-", lines: 0, align: .left)
        lContent.frame.origin = CGPoint(x: NotePromiseBreakCell.ITEM_MARGIN, y: lHappenAt.frame.origin.y + lHappenAt.frame.size.height + NotePromiseBreakCell.ITEM_MARGIN)
        
        // card
        vCard = UIView(frame: CGRect(x: NotePromiseBreakCell.ITEM_MARGIN, y: NotePromiseBreakCell.ITEM_MARGIN / 2, width: NotePromiseBreakCell.CARD_WIDTH, height: lContent.frame.origin.y + lContent.frame.size.height + NotePromiseBreakCell.ITEM_MARGIN))
        vCard.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vCard, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vCard, offset: ViewHelper.SHADOW_NORMAL)
        
        vCard.addSubview(btnMore)
        vCard.addSubview(lHappenAt)
        vCard.addSubview(lContent)
        
        // view
        self.contentView.addSubview(vCard)
    }
    
    public static func getCellHeight(view: UITableView, indexPath: IndexPath, dataList: [PromiseBreak]?) -> CGFloat {
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
        let promiseBreak = dataList![row]
        return getHeightByData(promiseBreak: promiseBreak)
    }
    
    public static func refreshHeightMap(refresh: Bool, start: Int, dataList: [PromiseBreak]?) {
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
        for (index, promiseBreak) in dataList!.enumerated() {
            let height = getHeightByData(promiseBreak: promiseBreak)
            heightMap[index + startIndex] = height
        }
    }
    
    public static func getHeightByData(margin: CGFloat = ITEM_MARGIN, promiseBreak: PromiseBreak) -> CGFloat {
        // const
        if totalHeight == nil || contentFont == nil {
            let cell = NotePromiseBreakCell(style: .default, reuseIdentifier: NotePromiseBreakCell.ID)
            totalHeight = cell.vCard.frame.origin.y + cell.vCard.frame.size.height + margin / 2
            contentFont = cell.lContent.font
        }
        // offset
        let height = ViewUtils.getFontHeight(font: contentFont, width: CARD_CONTENT_WIDTH, text: promiseBreak.contentText)
        return totalHeight! + height
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [PromiseBreak]?, target: Any?, actionEdit: Selector) -> NotePromiseBreakCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? NotePromiseBreakCell
        if cell == nil {
            cell = NotePromiseBreakCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= cell!.tag {
            return cell!
        }
        let promiseBreak = dataList![cell!.tag]
        
        // view
        cell?.lHappenAt.text = TimeHelper.getTimeShowLine_HM_MDHM_YMDHM_ByGo(promiseBreak.happenAt)
        cell?.lContent.text = promiseBreak.contentText
        
        // size
        AppDelegate.runOnMainAsync {
            let cellHeight = getCellHeight(view: view, indexPath: indexPath, dataList: dataList)
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
        
        // target
        cell?.btnMore.addTarget(target, action: actionEdit, for: .touchUpInside)
        return cell!
    }
    
}
