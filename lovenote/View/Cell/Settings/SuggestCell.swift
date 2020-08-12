//
//  SuggestCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/5/5.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class SuggestCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    private static var contentFont: UIFont?
    
    private static let ITEM_MARGIN = ScreenUtils.widthFit(10)
    private static let CARD_WIDTH = ScreenUtils.getScreenWidth() - ITEM_MARGIN * 2
    private static let CARD_CONTENT_WIDTH = CARD_WIDTH - ITEM_MARGIN * 2
    
    // view
    private var vCard: UIView!
    private var lTitle: UILabel!
    private var lContent: UILabel!
    private var vBottom: UIView!
    private var ivFollow: UIImageView!
    private var lFollow: UILabel!
    private var ivComment: UIImageView!
    private var lComment: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // title
        lTitle = ViewHelper.getLabelBold(width: SuggestCell.CARD_CONTENT_WIDTH, text: "-", size: ViewHelper.FONT_SIZE_NORMAL, color: ColorHelper.getFontBlack(), lines: 1, align: .left, mode: .byTruncatingTail)
        lTitle.frame.origin = CGPoint(x: SuggestCell.ITEM_MARGIN, y: SuggestCell.ITEM_MARGIN)
        
        // content
        lContent = ViewHelper.getLabelGreyNormal(width: SuggestCell.CARD_CONTENT_WIDTH, height: 0, text: "-", lines: 0, align: .left, mode: .byTruncatingTail)
        lContent.frame.origin = CGPoint(x: SuggestCell.ITEM_MARGIN, y: lTitle.frame.origin.y + lTitle.frame.size.height + SuggestCell.ITEM_MARGIN)
        
        // follow
        ivFollow = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_visibility_grey_18dp"), color: ColorHelper.getFontHint()), mode: .center)
        lFollow = ViewHelper.getLabel(text: "-", size: ViewHelper.FONT_SIZE_NORMAL, color: ColorHelper.getFontHint(), lines: 1, align: .center)
        let followWidth = SuggestCell.CARD_WIDTH / 2
        ivFollow.frame.origin.x = (followWidth - (ivFollow.frame.size.width + SuggestCell.ITEM_MARGIN + lFollow.frame.size.width)) / 2
        lFollow.frame.origin.x = ivFollow.frame.origin.x + ivFollow.frame.size.width + SuggestCell.ITEM_MARGIN
        let followHeight = CountHelper.getMax(ivFollow.frame.size.height, lFollow.frame.size.height) + SuggestCell.ITEM_MARGIN * 2
        ivFollow.center.y = followHeight / 2
        lFollow.center.y = followHeight / 2
        
        // comment
        ivComment = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_insert_comment_grey_18dp"), color: ColorHelper.getFontHint()), mode: .center)
        lComment = ViewHelper.getLabel(text: "-", size: ViewHelper.FONT_SIZE_NORMAL, color: ColorHelper.getFontHint(), lines: 1, align: .center)
        let commentWidth = SuggestCell.CARD_WIDTH / 2
        ivComment.frame.origin.x = followWidth + (commentWidth - (ivComment.frame.size.width + SuggestCell.ITEM_MARGIN + lComment.frame.size.width)) / 2
        lComment.frame.origin.x = ivComment.frame.origin.x + ivComment.frame.size.width + SuggestCell.ITEM_MARGIN
        let commentHeight = CountHelper.getMax(ivComment.frame.size.height, lComment.frame.size.height) + SuggestCell.ITEM_MARGIN * 2
        ivComment.center.y = commentHeight / 2
        lComment.center.y = commentHeight / 2
        
        // line
        let vLineTop = ViewHelper.getViewLine(width: SuggestCell.CARD_WIDTH)
        vLineTop.frame.origin = CGPoint(x: 0, y: 0)
        let vLineCenter = ViewHelper.getViewLine(height: followHeight)
        vLineCenter.center.x = SuggestCell.CARD_WIDTH / 2
        vLineCenter.frame.origin.y = 0
        
        // bottom
        vBottom = UIView()
        vBottom.frame.size = CGSize(width: SuggestCell.CARD_WIDTH, height: followHeight)
        vBottom.frame.origin.x = 0
        vBottom.frame.origin.y = lContent.frame.origin.y + lContent.frame.size.height + SuggestCell.ITEM_MARGIN
        vBottom.addSubview(ivFollow)
        vBottom.addSubview(lFollow)
        vBottom.addSubview(ivComment)
        vBottom.addSubview(lComment)
        vBottom.addSubview(vLineTop)
        vBottom.addSubview(vLineCenter)
        
        // card
        vCard = UIView(frame: CGRect(x: SuggestCell.ITEM_MARGIN, y: SuggestCell.ITEM_MARGIN / 2, width: SuggestCell.CARD_WIDTH, height: vBottom.frame.origin.y + vBottom.frame.size.height))
        vCard.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vCard, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vCard, offset: ViewHelper.SHADOW_NORMAL)
        vCard.addSubview(lTitle)
        vCard.addSubview(lContent)
        vCard.addSubview(vBottom)
        
        // view
        self.contentView.addSubview(vCard)
    }
    
    public static func getHeightByData(margin: CGFloat = ITEM_MARGIN, suggest: Suggest) -> CGFloat {
        let cell = SuggestCell(style: .default, reuseIdentifier: SuggestCell.ID)
        // const
        if totalHeight == nil || contentFont == nil {
            totalHeight = cell.vCard.frame.origin.y + cell.vCard.frame.size.height + margin / 2
            contentFont = cell.lContent.font
        }
        // content
        var contentHeight = CGFloat(0)
        if !StringUtils.isEmpty(suggest.contentText) {
            let fontHeight = ViewUtils.getFontHeight(font: contentFont, width: CARD_CONTENT_WIDTH, text: suggest.contentText)
            contentHeight = CountHelper.getMin(fontHeight, ViewHelper.FONT_NORMAL_LINE_HEIGHT * 3)
        }
        return totalHeight! + contentHeight
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Suggest]?, height: CGFloat?) -> SuggestCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? SuggestCell
        if cell == nil {
            cell = SuggestCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= cell!.tag {
            return cell!
        }
        let suggest = dataList![cell!.tag]
        
        // view
        cell?.lTitle.text = suggest.title
        cell?.lContent.text = suggest.contentText
        cell?.lFollow.text = ShowHelper.getShowCount2Thousand(suggest.followCount)
        cell?.lComment.text = ShowHelper.getShowCount2Thousand(suggest.commentCount)
        
        // size
        AppDelegate.runOnMainAsync {
            let cellHeight = height ?? getHeightByData(suggest: suggest)
            // card
            let vCardHeight = cellHeight - ITEM_MARGIN
            if (cell?.vCard.frame.size.height ?? 0) != vCardHeight {
                cell?.vCard.frame.size.height = vCardHeight
            }
            ViewUtils.setViewShadow(cell?.vCard, offset: ViewHelper.SHADOW_NORMAL)
            // content
            let lContentHeight = cellHeight - (totalHeight ?? 0)
            if (cell?.lContent.frame.size.height ?? 0) != lContentHeight {
                cell?.lContent.frame.size.height = lContentHeight
            }
            // bottom
            let bottomY = cell!.lContent.frame.origin.y + cell!.lContent.frame.size.height + ITEM_MARGIN
            if (cell?.vBottom.frame.origin.y ?? 0) != bottomY {
                cell?.vBottom.frame.origin.y = bottomY
            }
            // follow
            let followWdith = ViewUtils.getFontWidth(font: cell!.lFollow.font, text: cell!.lFollow.text)
            if (cell?.lFollow.frame.size.width ?? 0) != followWdith {
                cell?.lFollow.frame.size.width = followWdith
            }
            let ivFollowX2 = cell!.ivFollow.frame.size.width + SuggestCell.ITEM_MARGIN + cell!.ivFollow.frame.size.width
            let ivFollowX = (CARD_WIDTH / 2 - ivFollowX2) / 2
            if (cell?.ivFollow.frame.origin.x ?? 0) != ivFollowX {
                cell?.ivFollow.frame.origin.x = ivFollowX
            }
            let lFollowX = cell!.ivFollow.frame.origin.x + cell!.ivFollow.frame.size.width + SuggestCell.ITEM_MARGIN
            if (cell?.lFollow.frame.origin.x ?? 0) != lFollowX {
                cell?.lFollow.frame.origin.x = lFollowX
            }
            // comment
            let commentWdith = ViewUtils.getFontWidth(font: cell!.lComment.font, text: cell!.lComment.text)
            if (cell?.lComment.frame.size.width ?? 0) != commentWdith {
                cell?.lComment.frame.size.width = commentWdith
            }
            let ivCommentX = CARD_WIDTH / 2 + (CARD_WIDTH / 2 - (cell!.ivComment.frame.size.width + SuggestCell.ITEM_MARGIN + cell!.lComment.frame.size.width)) / 2
            if (cell?.ivComment.frame.origin.x ?? 0) != ivCommentX {
                cell?.ivComment.frame.origin.x = ivCommentX
            }
            let lCommentX = cell!.ivComment.frame.origin.x + cell!.ivComment.frame.size.width + SuggestCell.ITEM_MARGIN
            if (cell?.lComment.frame.origin.x ?? 0) != lCommentX {
                cell?.lComment.frame.origin.x = lCommentX
            }
        }
        return cell!
    }
    
    public static func goSuggestDetail(view: UITableView, indexPath: IndexPath, dataList: [Suggest]?) {
        if dataList == nil || dataList!.count <= indexPath.row {
            return
        }
        let suggest = dataList![indexPath.row]
        SuggestDetailVC.pushVC(suggest: suggest)
    }
    
}
