//
//  TopicMessageCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/5/3.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class TopicMessageCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    private static var contentFont: UIFont?
    
    private static let ITEM_MARGIN = ScreenUtils.widthFit(10)
    private static let ITEM_MARGIN_SMALL = ITEM_MARGIN / 2
    private static let AVATAR_WIDTH = ScreenUtils.widthFit(15)
    private static let CARD_WIDTH = ScreenUtils.getScreenWidth() - ITEM_MARGIN * 2
    private static let CARD_CONTENT_WIDTH = CARD_WIDTH - ITEM_MARGIN * 2
    
    // view
    private var vCard: UIView!
    private var ivAvatarLeft: UIImageView!
    private var ivAvatarRight: UIImageView!
    private var lTime: UILabel!
    private var lContent: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // avatar
        ivAvatarLeft = ViewHelper.getImageViewAvatar(width: TopicMessageCell.AVATAR_WIDTH, height: TopicMessageCell.AVATAR_WIDTH)
        ivAvatarLeft.frame.origin = CGPoint(x: TopicMessageCell.ITEM_MARGIN, y: TopicMessageCell.ITEM_MARGIN)
        ivAvatarRight = ViewHelper.getImageViewAvatar(width: TopicMessageCell.AVATAR_WIDTH, height: TopicMessageCell.AVATAR_WIDTH)
        ivAvatarRight.frame.origin = CGPoint(x: ivAvatarLeft.frame.origin.x + ivAvatarLeft.frame.size.width + TopicMessageCell.ITEM_MARGIN_SMALL, y: TopicMessageCell.ITEM_MARGIN)
        
        // happen
        let timeX = ivAvatarRight.frame.origin.x + ivAvatarRight.frame.size.width + TopicMessageCell.ITEM_MARGIN
        let timeWidth = TopicMessageCell.CARD_CONTENT_WIDTH - timeX + TopicMessageCell.ITEM_MARGIN
        lTime = ViewHelper.getLabelBlackNormal(width: timeWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lTime.frame.origin.x = timeX
        lTime.center.y = ivAvatarLeft.center.y
        
        // line
        let vLine = ViewHelper.getViewLine(width: TopicMessageCell.CARD_CONTENT_WIDTH)
        vLine.frame.origin = CGPoint(x: TopicMessageCell.ITEM_MARGIN, y: ivAvatarLeft.frame.origin.y + ivAvatarLeft.frame.size.height + TopicMessageCell.ITEM_MARGIN_SMALL)
        
        // content
        lContent = ViewHelper.getLabelGreyNormal(width: TopicMessageCell.CARD_CONTENT_WIDTH, height: CGFloat(0), text: "-", lines: 0, align: .left, mode: .byTruncatingTail)
        lContent.frame.origin = CGPoint(x: TopicMessageCell.ITEM_MARGIN, y: vLine.frame.origin.y + vLine.frame.size.height + TopicMessageCell.ITEM_MARGIN_SMALL)
        
        // card
        vCard = UIView(frame: CGRect(x: TopicMessageCell.ITEM_MARGIN, y: TopicMessageCell.ITEM_MARGIN / 2, width: TopicMessageCell.CARD_WIDTH, height: lContent.frame.origin.y + lContent.frame.size.height + TopicMessageCell.ITEM_MARGIN))
        vCard.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vCard, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vCard, offset: ViewHelper.SHADOW_NORMAL)
        
        vCard.addSubview(ivAvatarLeft)
        vCard.addSubview(ivAvatarRight)
        vCard.addSubview(lTime)
        vCard.addSubview(vLine)
        vCard.addSubview(lContent)
        
        // view
        self.contentView.addSubview(vCard)
    }
    
    public static func getHeightByData(margin: CGFloat = ITEM_MARGIN, maxHeight: CGFloat = ViewHelper.FONT_NORMAL_LINE_HEIGHT * 5, message: TopicMessage) -> CGFloat {
        // const
        if totalHeight == nil || contentFont == nil {
            let cell = TopicMessageCell(style: .default, reuseIdentifier: TopicMessageCell.ID)
            totalHeight = cell.vCard.frame.origin.y + cell.vCard.frame.size.height + margin / 2
            contentFont = cell.lContent.font
        }
        // offset
        let height = ViewUtils.getFontHeight(font: contentFont, width: CARD_CONTENT_WIDTH, text: message.contentText)
        let realHeight = height > maxHeight ? maxHeight : height
        return totalHeight! + realHeight
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [TopicMessage]?, height: CGFloat?) -> TopicMessageCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? TopicMessageCell
        if cell == nil {
            cell = TopicMessageCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= cell!.tag {
            return cell!
        }
        let message = dataList![cell!.tag]
        let couple = message.couple
        // view
        KFHelper.setImgAvatarUrl(iv: cell?.ivAvatarLeft, objKey: couple?.creatorAvatar)
        KFHelper.setImgAvatarUrl(iv: cell?.ivAvatarRight, objKey: couple?.inviteeAvatar)
        cell?.lTime.text = ShowHelper.getBetweenTimeGoneShow(between: DateUtils.getCurrentInt64() - message.updateAt)
        cell?.lContent.text = StringUtils.isEmpty(message.contentText) ? StringUtils.getString("receive_new_message") : message.contentText
        
        // size
        AppDelegate.runOnMainAsync {
            let cellHeight = height ?? getHeightByData(message: message)
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
    
    public static func goSomeDetail(view: UITableView, indexPath: IndexPath, dataList: [TopicMessage]?) {
        if dataList == nil || dataList!.count <= indexPath.row {
            return
        }
        let message = dataList![indexPath.row]
        if message.kind == TopicMessage.KIND_ALL || message.kind == TopicMessage.KIND_OFFICIAL_TEXT {
            return
        }
        switch message.kind {
        case TopicMessage.KIND_JAB_IN_POST: // 被戳
            TopicPostDetailVC.pushVC(pid: message.contentId)
            break
        case TopicMessage.KIND_POST_BE_REPORT: // 举报
            TopicPostDetailVC.pushVC(pid: message.contentId)
            break
        case TopicMessage.KIND_POST_BE_POINT: // 点赞
            TopicPostDetailVC.pushVC(pid: message.contentId)
            break
        case TopicMessage.KIND_POST_BE_COLLECT: // 收藏
            TopicPostDetailVC.pushVC(pid: message.contentId)
            break
        case TopicMessage.KIND_POST_BE_COMMENT: // 评论
            TopicPostDetailVC.pushVC(pid: message.contentId)
            break
        case TopicMessage.KIND_JAB_IN_COMMENT: // 被戳
            TopicPostCommentDetailVC.pushVC(pcid: message.contentId)
            break
        case TopicMessage.KIND_COMMENT_BE_REPLY: // 回复
            TopicPostCommentDetailVC.pushVC(pcid: message.contentId)
            break
        case TopicMessage.KIND_COMMENT_BE_REPORT: // 评论
            TopicPostCommentDetailVC.pushVC(pcid: message.contentId)
            break
        case TopicMessage.KIND_COMMENT_BE_POINT: // 点赞
            TopicPostCommentDetailVC.pushVC(pcid: message.contentId)
            break
        default: break
        }
    }
    
}
