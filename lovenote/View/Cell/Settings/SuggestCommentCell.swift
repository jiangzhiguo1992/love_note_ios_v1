//
//  SuggestCommentCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/5/5.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class SuggestCommentCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    private static var contentFont: UIFont?
    
    private static let ITEM_MARGIN = ScreenUtils.widthFit(10)
    private static let CARD_WIDTH = ScreenUtils.getScreenWidth()
    private static let CARD_CONTENT_WIDTH = CARD_WIDTH - ITEM_MARGIN * 2
    
    // view
    private var vCard: UIView!
    private var lTop: UILabel!
    private var lContent: UILabel!
    
    // var
    private static var heightMap: [Int: CGFloat] = [Int: CGFloat]()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // line
        let vLine = ViewHelper.getViewLine(width: SuggestCommentCell.CARD_CONTENT_WIDTH)
        vLine.frame.origin = CGPoint(x: SuggestCommentCell.ITEM_MARGIN, y: 0)

        // top
        lTop = ViewHelper.getLabelGreySmall(width: SuggestCommentCell.CARD_CONTENT_WIDTH, text: "-", lines: 1, align: .left)
        lTop.frame.origin = CGPoint(x: SuggestCommentCell.ITEM_MARGIN, y: vLine.frame.origin.y + vLine.frame.size.height + SuggestCommentCell.ITEM_MARGIN)
        
        // content
        lContent = ViewHelper.getLabelBlackNormal(width: SuggestCommentCell.CARD_CONTENT_WIDTH, height: CGFloat(0), text: "-", lines: 0, align: .left)
        lContent.frame.origin = CGPoint(x: SuggestCommentCell.ITEM_MARGIN, y: lTop.frame.origin.y + lTop.frame.size.height + SuggestCommentCell.ITEM_MARGIN)
        
        // card
        vCard = UIView(frame: CGRect(x: 0, y: 0, width: SuggestCommentCell.CARD_WIDTH, height: lContent.frame.origin.y + lContent.frame.size.height + SuggestCommentCell.ITEM_MARGIN))
        
        vCard.addSubview(vLine)
        vCard.addSubview(lTop)
        vCard.addSubview(lContent)
        
        // view
        self.contentView.addSubview(vCard)
    }
    
    public static func getCellHeight(view: UITableView, indexPath: IndexPath, dataList: [SuggestComment]?) -> CGFloat {
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
        let suggestComment = dataList![row]
        return getHeightByData(suggestComment: suggestComment)
    }
    
    public static func refreshHeightMap(refresh: Bool, start: Int, dataList: [SuggestComment]?) {
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
        for (index, suggestComment) in dataList!.enumerated() {
            let height = getHeightByData(suggestComment: suggestComment)
            heightMap[index + startIndex] = height
        }
    }
    
    public static func getHeightByData(margin: CGFloat = ITEM_MARGIN, suggestComment: SuggestComment) -> CGFloat {
        // const
        if totalHeight == nil || contentFont == nil {
            let cell = SuggestCommentCell(style: .default, reuseIdentifier: SuggestCommentCell.ID)
            totalHeight = cell.vCard.frame.size.height
            contentFont = cell.lContent.font
        }
        // offset
        let contentHeight = ViewUtils.getFontHeight(font: contentFont, width: CARD_CONTENT_WIDTH, text: suggestComment.contentText)
        return totalHeight! + contentHeight
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [SuggestComment]?, heightMap: Bool = true) -> SuggestCommentCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? SuggestCommentCell
        if cell == nil {
            cell = SuggestCommentCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= cell!.tag {
            return cell!
        }
        let comment = dataList![cell!.tag]
        let official = comment.official
        let admin = official ? StringUtils.getString("administrators") : ""
        let time = ShowHelper.getBetweenTimeGoneShow(between: DateUtils.getCurrentInt64() - comment.createAt)
        let top = StringUtils.isEmpty(admin) ? time : StringUtils.getString("holder_space_space_holder", arguments: [admin, time])
            
        // view
        cell?.lTop.text = top
        cell?.lTop.textColor = official ? ThemeHelper.getColorPrimary() : ColorHelper.getFontGrey()
        cell?.lContent.text = comment.contentText
        
        // size
        AppDelegate.runOnMainAsync {
            let cellHeight = heightMap ? getCellHeight(view: view, indexPath: indexPath, dataList: dataList) : getHeightByData(suggestComment: comment)
            let lContentHeight = cellHeight - (totalHeight ?? 0)
            if (cell?.vCard.frame.size.height ?? 0) != cellHeight {
                cell?.vCard.frame.size.height = cellHeight
            }
            if (cell?.lContent.frame.size.height ?? 0) != lContentHeight {
                cell?.lContent.frame.size.height = lContentHeight
            }
        }
        return cell!
    }
    
}
