//
//  TopicPostCommentCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/30.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class TopicPostCommentCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    private static var contentFont: UIFont?
    private static var jabHeight: CGFloat?
    
    private static let ITEM_MARGIN = ScreenUtils.widthFit(10)
    private static let ITEM_MARGIN_SMALL = ITEM_MARGIN / 2
    private static let AVATAR_WIDTH = ScreenUtils.widthFit(35)
    private static let IMG_WIDTH = ScreenUtils.widthFit(15)
    private static let CARD_WIDTH = ScreenUtils.getScreenWidth()
    private static let CARD_CONTENT_WIDTH = CARD_WIDTH - ITEM_MARGIN * 2
    
    // view
    private var vCard: UIView!
    private var vTop: UIView!
    private var ivAvatar: UIImageView!
    private var lName: UILabel!
    private var lFloor: UILabel!
    private var lTime: UILabel!
    private var lContent: UILabel!
    private var ivJabAvatar: UIImageView!
    private var vBottom: UIView!
    private var vReport: UIView!
    private var ivReport: UIImageView!
    private var lReport: UILabel!
    private var vPoint: UIView!
    private var ivPoint: UIImageView!
    private var lPoint: UILabel!
    private var vComment: UIView!
    private var ivComment: UIImageView!
    private var lComment: UILabel!
    
    // var
    private static var heightMap: [Int: CGFloat] = [Int: CGFloat]()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // line
        let lineTop = ViewHelper.getViewLine(width: TopicPostCommentCell.CARD_CONTENT_WIDTH)
        lineTop.frame.origin = CGPoint(x: TopicPostCommentCell.ITEM_MARGIN, y: 0)
        
        // top
        vTop = UIView(frame: CGRect(x: TopicPostCommentCell.ITEM_MARGIN, y: TopicPostCommentCell.ITEM_MARGIN, width: TopicPostCommentCell.CARD_CONTENT_WIDTH, height: TopicPostCommentCell.AVATAR_WIDTH))
        
        // avatar
        ivAvatar = ViewHelper.getImageViewAvatar(width: TopicPostCommentCell.AVATAR_WIDTH, height: TopicPostCommentCell.AVATAR_WIDTH)
        ivAvatar.frame.origin = CGPoint(x: 0, y: 0)
        
        // name
        let nameWidth = vTop.frame.size.width - (ivAvatar.frame.origin.x + ivAvatar.frame.size.width + TopicPostCommentCell.ITEM_MARGIN)
        lName = ViewHelper.getLabelBlackSmall(width: nameWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lName.frame.origin = CGPoint(x: ivAvatar.frame.origin.x + ivAvatar.frame.size.width + TopicPostCommentCell.ITEM_MARGIN, y: 0)
        
        // floor
        lFloor = ViewHelper.getLabelGreySmall(text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lFloor.frame.origin = CGPoint(x: lName.frame.origin.x, y: ivAvatar.frame.origin.y + ivAvatar.frame.size.height - lFloor.frame.size.height)
        
        // time
        let timeWidth = nameWidth - (lFloor.frame.size.width + TopicPostCommentCell.ITEM_MARGIN)
        lTime = ViewHelper.getLabelGreySmall(width: timeWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lTime.frame.origin = CGPoint(x: lFloor.frame.origin.x + lFloor.frame.size.width + TopicPostCommentCell.ITEM_MARGIN, y: lFloor.frame.origin.y)
        
        vTop.addSubview(ivAvatar)
        vTop.addSubview(lName)
        vTop.addSubview(lFloor)
        vTop.addSubview(lTime)
        
        // content
        lContent = ViewHelper.getLabelBlackNormal(text: StringUtils.getString("jab_a_little"), lines: 0, align: .left)
        lContent.frame.origin = CGPoint(x: TopicPostCommentCell.ITEM_MARGIN, y: vTop.frame.origin.y + vTop.frame.size.height + TopicPostCommentCell.ITEM_MARGIN)
        
        // jabAvatar
        ivJabAvatar = ViewHelper.getImageViewAvatar(width: TopicPostCommentCell.IMG_WIDTH, height: TopicPostCommentCell.IMG_WIDTH)
        ivJabAvatar.frame.origin.x = lContent.frame.origin.x + lContent.frame.size.width + TopicPostCommentCell.ITEM_MARGIN_SMALL
        ivJabAvatar.center.y = lContent.center.y
        
        lContent.frame.size.width = TopicPostCommentCell.CARD_CONTENT_WIDTH // 投机取巧!
        
        // report
        ivReport = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_report_grey_18dp"), color: ColorHelper.getFontHint()), width: TopicPostCommentCell.IMG_WIDTH, height: TopicPostCommentCell.IMG_WIDTH, mode: .scaleAspectFit)
        ivReport.frame.origin.x = 0
        lReport = ViewHelper.getLabel(text: StringUtils.getString("report"), size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontHint(), lines: 1, align: .left, mode: .byTruncatingTail)
        lReport.frame.origin.x = ivReport.frame.origin.x + ivReport.frame.size.width + TopicPostCommentCell.ITEM_MARGIN_SMALL
        
        vReport = UIView()
        vReport.frame.size.width = lReport.frame.origin.x + lReport.frame.size.width
        vReport.frame.size.height = CountHelper.getMax(ivReport.frame.size.height, lReport.frame.size.height) + TopicPostCommentCell.ITEM_MARGIN * 2
        vReport.frame.origin.x = 0
        ivReport.center.y = vReport.frame.size.height / 2
        lReport.center.y = vReport.frame.size.height / 2
        vReport.addSubview(ivReport)
        vReport.addSubview(lReport)
        
        // point
        ivPoint = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_thumb_up_grey_18dp"), color: ColorHelper.getFontHint()), width: TopicPostCommentCell.IMG_WIDTH, height: TopicPostCommentCell.IMG_WIDTH, mode: .scaleAspectFit)
        ivPoint.frame.origin.x = TopicPostCommentCell.ITEM_MARGIN * 2
        lPoint = ViewHelper.getLabel(text: "-", size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontHint(), lines: 1, align: .left, mode: .byTruncatingTail)
        lPoint.frame.origin.x = ivPoint.frame.origin.x + ivPoint.frame.size.width + TopicPostCommentCell.ITEM_MARGIN
        
        vPoint = UIView()
        vPoint.frame.size.width = lPoint.frame.origin.x + lPoint.frame.size.width + ivPoint.frame.origin.x
        vPoint.frame.size.height = CountHelper.getMax(ivPoint.frame.size.height, lPoint.frame.size.height) + TopicPostCommentCell.ITEM_MARGIN * 2
        vPoint.frame.origin.x = vReport.frame.origin.x + vReport.frame.size.width + TopicPostCommentCell.ITEM_MARGIN * 2
        ivPoint.center.y = vPoint.frame.size.height / 2
        lPoint.center.y = vPoint.frame.size.height / 2
        vPoint.addSubview(ivPoint)
        vPoint.addSubview(lPoint)
        
        // comment
        ivComment = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_insert_comment_grey_18dp"), color: ColorHelper.getFontHint()), width: TopicPostCommentCell.IMG_WIDTH, height: TopicPostCommentCell.IMG_WIDTH, mode: .scaleAspectFit)
        ivComment.frame.origin.x = TopicPostCommentCell.ITEM_MARGIN * 2
        lComment = ViewHelper.getLabel(text: "-", size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontHint(), lines: 1, align: .left, mode: .byTruncatingTail)
        lComment.frame.origin.x = ivComment.frame.origin.x + ivComment.frame.size.width + TopicPostCommentCell.ITEM_MARGIN
        
        vComment = UIView()
        vComment.frame.size.width = lComment.frame.origin.x + lComment.frame.size.width + ivComment.frame.origin.x
        vComment.frame.size.height = CountHelper.getMax(ivComment.frame.size.height, lComment.frame.size.height) + TopicPostCommentCell.ITEM_MARGIN * 2
        vComment.frame.origin.x = vPoint.frame.origin.x + vPoint.frame.size.width
        ivComment.center.y = vComment.frame.size.height / 2
        lComment.center.y = vComment.frame.size.height / 2
        vComment.addSubview(ivComment)
        vComment.addSubview(lComment)
        
        // bottom
        vBottom = UIView(frame: CGRect(x: TopicPostCommentCell.ITEM_MARGIN, y: lContent.frame.origin.y + lContent.frame.size.height, width: TopicPostCommentCell.CARD_CONTENT_WIDTH, height: CountHelper.getMax(vReport.frame.size.height, vPoint.frame.size.height)))
        
        vReport.center.y = vBottom.frame.size.height / 2
        vPoint.center.y = vBottom.frame.size.height / 2
        vComment.center.y = vBottom.frame.size.height / 2
        vBottom.addSubview(vReport)
        vBottom.addSubview(vPoint)
        vBottom.addSubview(vComment)
        
        // card
        vCard = UIView(frame: CGRect(x: 0, y: 0, width: TopicPostCommentCell.CARD_WIDTH, height: vBottom.frame.origin.y + vBottom.frame.size.height))
        vCard.backgroundColor = ColorHelper.getWhite()
        vCard.addSubview(lineTop)
        vCard.addSubview(vTop)
        vCard.addSubview(lContent)
        vCard.addSubview(ivJabAvatar)
        vCard.addSubview(vBottom)
        
        // view
        self.contentView.addSubview(vCard)
        
        // hide
        vCard.isHidden = true
        vTop.isHidden = true
        ivJabAvatar.isHidden = true
        vComment.isHidden = true
    }
    
    public static func getHeightByData(comment: PostComment) -> CGFloat {
        if comment.isDelete() || comment.screen {
            return 0
        }
        // const
        if totalHeight == nil || contentFont == nil || jabHeight == nil {
            let cell = TopicPostCommentCell(style: .default, reuseIdentifier: TopicPostCommentCell.ID)
            totalHeight = cell.vCard.frame.size.height
            contentFont = cell.lContent.font
            jabHeight = cell.lContent.frame.size.height
        }
        // offset
        var cellHeight: CGFloat = (comment.couple == nil) ? (totalHeight! - ITEM_MARGIN - AVATAR_WIDTH) : totalHeight!
        if comment.kind != PostComment.KIND_JAB {
            let height = ViewUtils.getFontHeight(font: contentFont, width: CARD_CONTENT_WIDTH, text: comment.contentText)
            cellHeight = cellHeight - jabHeight! + height
        }
        return cellHeight
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [PostComment]?, height: CGFloat?, subComment: Bool, target: Any?, actionReport: Selector, actionPoint: Selector) -> TopicPostCommentCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? TopicPostCommentCell
        if cell == nil {
            cell = TopicPostCommentCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= cell!.tag {
            return cell!
        }
        let comment = dataList![cell!.tag]
        // screen
        if comment.isDelete() || comment.screen {
            cell?.vCard.isHidden = true
            return cell!
        }
        // normal
        cell?.vCard.isHidden = false
        // top
        let couple = comment.couple
        var jabAvatar: String!
        if couple == nil {
            cell?.vTop.isHidden = true
            jabAvatar = ""
        } else {
            cell?.vTop.isHidden = false
            let jabId = (couple!.creatorId == comment.userId) ? couple!.inviteeId : couple!.creatorId
            jabAvatar = UserHelper.getAvatar(couple: couple, uid: jabId)
            KFHelper.setImgAvatarUrl(iv: cell?.ivAvatar, objKey: UserHelper.getAvatar(couple: couple, uid: comment.userId))
            cell?.lName.text = comment.official ? StringUtils.getString("administrators") : UserHelper.getName(couple: couple, uid: comment.userId, empty: true)
            cell?.lFloor.text = StringUtils.getString("holder_floor", arguments: [comment.floor])
            cell?.lTime.text = ShowHelper.getBetweenTimeGoneShow(between: DateUtils.getCurrentInt64() - comment.createAt)
        }
        // center
        if comment.kind != PostComment.KIND_JAB {
            cell?.lContent.text = comment.contentText
            cell?.lContent.textColor = ColorHelper.getFontBlack()
            cell?.ivJabAvatar.isHidden = true
        } else {
            cell?.lContent.text = StringUtils.getString("jab_a_little")
            cell?.lContent.textColor = ThemeHelper.getColorPrimary()
            cell?.ivJabAvatar.isHidden = false
            KFHelper.setImgAvatarUrl(iv: cell?.ivJabAvatar, objKey: jabAvatar)
        }
        // bottom
        cell?.lPoint.text = ShowHelper.getShowCount2Thousand(comment.pointCount)
        cell?.lComment.text = ShowHelper.getShowCount2Thousand(comment.subCommentCount)
        cell?.vComment.isHidden = subComment
        cell?.ivReport.image = ViewUtils.getImageWithTintColor(img: cell!.ivReport.image, color: comment.report ? ThemeHelper.getColorPrimary() : ColorHelper.getFontHint())
        cell?.ivPoint.image = ViewUtils.getImageWithTintColor(img: cell!.ivPoint.image, color: comment.point ? ThemeHelper.getColorPrimary() : ColorHelper.getFontHint())
        cell?.ivComment.image = ViewUtils.getImageWithTintColor(img: cell!.ivComment.image, color: comment.subComment ? ThemeHelper.getColorPrimary() : ColorHelper.getFontHint())
        
        // size
        AppDelegate.runOnMainAsync {
            let cellHeight = height ?? getHeightByData(comment: comment)
            // card
            if (cell?.vCard.frame.size.height ?? 0) != cellHeight {
                cell?.vCard.frame.size.height = cellHeight
            }
            // top
            if !cell!.vTop.isHidden {
                let floorWdith = ViewUtils.getFontWidth(font: cell!.lFloor.font, text: cell!.lFloor.text)
                if (cell?.lFloor.frame.size.width ?? 0) != floorWdith {
                    cell?.lFloor.frame.size.width = floorWdith
                }
                let timeWdith = cell!.vTop.frame.size.width - (cell!.lFloor.frame.origin.x + cell!.lFloor.frame.size.width + ITEM_MARGIN)
                if (cell?.lTime.frame.size.width ?? 0) != timeWdith {
                    cell?.lTime.frame.size.width = timeWdith
                }
                let timeX = cell!.lFloor.frame.origin.x + cell!.lFloor.frame.size.width + ITEM_MARGIN
                if (cell?.lTime.frame.origin.x ?? 0) != timeX {
                    cell?.lTime.frame.origin.x = timeX
                }
            }
            // content
            let lContentY = cell!.vTop.isHidden ? cell!.vTop.frame.origin.y : cell!.vTop.frame.origin.y + cell!.vTop.frame.size.height + ITEM_MARGIN
            if (cell?.lContent.frame.origin.y ?? 0) != lContentY {
                cell?.lContent.frame.origin.y = lContentY
                cell?.ivJabAvatar.center.y = cell!.lContent.center.y
            }
            let lContentHeight = (comment.kind == PostComment.KIND_JAB) ? (jabHeight ?? 0) : cellHeight + (jabHeight ?? 0) - ((comment.couple == nil) ? (totalHeight! - ITEM_MARGIN - AVATAR_WIDTH) : totalHeight!)
            if (cell?.lContent.frame.size.height ?? 0) != lContentHeight {
                cell?.lContent.frame.size.height = lContentHeight
            }
            // bottom
            let lBottomY = cell!.lContent.frame.origin.y + cell!.lContent.frame.size.height
            if (cell?.vBottom.frame.origin.y ?? 0) != lBottomY {
                cell?.vBottom.frame.origin.y = lBottomY
            }
            // point
            let lPointWdith = ViewUtils.getFontWidth(font: cell!.lPoint.font, text: cell!.lPoint.text)
            if (cell?.lPoint.frame.size.width ?? 0) != lPointWdith {
                cell?.lPoint.frame.size.width = lPointWdith
            }
            let vPointWdith = cell!.lPoint.frame.origin.x + cell!.lPoint.frame.size.width + cell!.ivPoint.frame.origin.x
            if (cell?.vPoint.frame.size.width ?? 0) != vPointWdith {
                cell?.vPoint.frame.size.width = vPointWdith
            }
            // commnet
            let vCommentX = cell!.vPoint.frame.origin.x + cell!.vPoint.frame.size.width
            if (cell?.vComment.frame.origin.x ?? 0) != vCommentX {
                cell?.vComment.frame.origin.x = vCommentX
            }
            let lCommentWdith = ViewUtils.getFontWidth(font: cell!.lComment.font, text: cell!.lComment.text)
            if (cell?.lComment.frame.size.width ?? 0) != lCommentWdith {
                cell?.lComment.frame.size.width = lCommentWdith
            }
            let vCommentWdith = cell!.lComment.frame.origin.x + cell!.lComment.frame.size.width + cell!.ivComment.frame.origin.x
            if (cell?.vComment.frame.size.width ?? 0) != vCommentWdith {
                cell?.vComment.frame.size.width = vCommentWdith
            }
        }
        // target
        ViewUtils.addViewTapTarget(target: target, view: cell?.vReport, action: actionReport)
        ViewUtils.addViewTapTarget(target: target, view: cell?.vPoint, action: actionPoint)
        return cell!
    }
    
    public static func goCommentDetail(view: UITableView, indexPath: IndexPath, dataList: [PostComment]?) {
        if dataList == nil || dataList!.count <= indexPath.row {
            return
        }
        let comment = dataList![indexPath.row]
        TopicPostCommentDetailVC.pushVC(postComment: comment)
    }
    
}
