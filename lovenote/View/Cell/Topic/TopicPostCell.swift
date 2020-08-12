//
//  TopicPostCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/28.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class TopicPostCell: BaseTableCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // const
    private static var totalHeight: CGFloat?
    private static var contentFont: UIFont?
    
    private static let COVER_HEIGHT = ScreenUtils.heightFit(100)
    private static let ITEM_MARGIN = ScreenUtils.widthFit(10)
    private static let ITEM_MARGIN_SMALL = ITEM_MARGIN / 2
    private static let AVATAR_WIDTH = ScreenUtils.widthFit(15)
    private static let CARD_WIDTH = ScreenUtils.getScreenWidth() - ITEM_MARGIN * 2
    private static let CARD_CONTENT_WIDTH = CARD_WIDTH - ITEM_MARGIN * 2
    
    private static let LIMIT_IMG = 3
    
    // view
    private var vCard: UIView!
    private var lCover: UILabel!
    private var vInfo: UIView!
    
    private var lTitle: UILabel!
    private var lContent: UILabel!
    private var collectImgList: UICollectionView!
    private var vInfoBottom: UIView!
    
    private var lTime: UILabel!
    private var vInfoBottomCouple: UIView!
    private var vInfoBottomUser: UIView!
    
    private var ivAvatarLeft: UIImageView!
    private var ivAvatarRight: UIImageView!
    
    private var ivCollect: UIImageView!
    private var lCollect: UILabel!
    private var ivPoint: UIImageView!
    private var lPoint: UILabel!
    private var ivComment: UIImageView!
    private var lComment: UILabel!
    
    // var
    lazy var imgTop = CGFloat(0)
    lazy var imgBottom = CGFloat(0)
    private var post: Post?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // title
        lTitle = ViewHelper.getLabelBold(width: TopicPostCell.CARD_CONTENT_WIDTH, text: "-", size: ViewHelper.FONT_SIZE_NORMAL, color: ColorHelper.getFontBlack(), lines: 1, align: .left, mode: .byTruncatingTail)
        lTitle.frame.origin = CGPoint(x: TopicPostCell.ITEM_MARGIN, y: TopicPostCell.ITEM_MARGIN)
        
        // content
        lContent = ViewHelper.getLabelGreyNormal(width: TopicPostCell.CARD_CONTENT_WIDTH, height: 0, text: "-", lines: 0, align: .left, mode: .byTruncatingTail)
        lContent.frame.origin = CGPoint(x: TopicPostCell.ITEM_MARGIN, y: lTitle.frame.origin.y + lTitle.frame.size.height + TopicPostCell.ITEM_MARGIN)
        
        // imgList
        let layoutImgList = ImgSquareShowCell.getLayout(maxWidth: TopicPostCell.CARD_CONTENT_WIDTH)
        let marginImgList = layoutImgList.sectionInset
        imgTop = marginImgList.top
        imgBottom = marginImgList.bottom
        let collectImgListWidth = TopicPostCell.CARD_CONTENT_WIDTH + marginImgList.left + marginImgList.right
        let collectImgListX = marginImgList.left
        let collectImgListY = lContent.frame.origin.y + lContent.frame.size.height + TopicPostCell.ITEM_MARGIN - imgTop
        collectImgList = ViewUtils.getCollectionView(target: self, frame: CGRect(x: collectImgListX, y: collectImgListY, width: collectImgListWidth, height: 0), layout: layoutImgList, cellCls: ImgSquareShowCell.self, id: ImgSquareShowCell.ID)
        
        // avatar
        ivAvatarLeft = ViewHelper.getImageViewAvatar(width: TopicPostCell.AVATAR_WIDTH, height: TopicPostCell.AVATAR_WIDTH)
        ivAvatarLeft.frame.origin = CGPoint(x: 0, y: 0)
        let vAvatarLeftShadow = ViewUtils.getViewShadow(ivAvatarLeft, bgColor: ColorHelper.getWhite(), offset: ViewHelper.SHADOW_NORMAL)
        
        ivAvatarRight = ViewHelper.getImageViewAvatar(width: TopicPostCell.AVATAR_WIDTH, height: TopicPostCell.AVATAR_WIDTH)
        ivAvatarRight.frame.origin = CGPoint(x: ivAvatarLeft.frame.origin.x + ivAvatarLeft.frame.size.width + TopicPostCell.ITEM_MARGIN_SMALL, y: 0)
        let vAvatarRightShadow = ViewUtils.getViewShadow(ivAvatarRight, bgColor: ColorHelper.getWhite(), offset: ViewHelper.SHADOW_NORMAL)
        
        let ivHeart = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_favorite_border_grey_18dp"), color: ThemeHelper.getColorPrimary()), width: TopicPostCell.AVATAR_WIDTH, height: TopicPostCell.AVATAR_WIDTH, mode: .scaleAspectFit)
        
        // infoBottomCouple
        vInfoBottomCouple = UIView()
        vInfoBottomCouple.frame.size = CGSize(width: ivAvatarRight.frame.origin.x + ivAvatarRight.frame.size.width, height: TopicPostCell.AVATAR_WIDTH)
        vInfoBottomCouple.frame.origin.x = 0
        ivHeart.center.x = vInfoBottomCouple.frame.size.width / 2
        ivHeart.center.y = vInfoBottomCouple.frame.size.height / 2
        vInfoBottomCouple.addSubview(vAvatarLeftShadow)
        vInfoBottomCouple.addSubview(ivAvatarLeft)
        vInfoBottomCouple.addSubview(vAvatarRightShadow)
        vInfoBottomCouple.addSubview(ivAvatarRight)
        vInfoBottomCouple.addSubview(ivHeart)
        
        // collect
        ivCollect = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_favorite_grey_18dp"), color: ColorHelper.getFontHint()), width: TopicPostCell.AVATAR_WIDTH, height: TopicPostCell.AVATAR_WIDTH, mode: .scaleAspectFit)
        ivCollect.frame.origin.x = 0
        lCollect = ViewHelper.getLabel(text: "-", size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontHint(), lines: 1, align: .center)
        lCollect.frame.origin.x = ivCollect.frame.origin.x + ivCollect.frame.size.width + TopicPostCell.ITEM_MARGIN_SMALL
        
        // point
        ivPoint = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_thumb_up_grey_18dp"), color: ColorHelper.getFontHint()), width: TopicPostCell.AVATAR_WIDTH, height: TopicPostCell.AVATAR_WIDTH, mode: .scaleAspectFit)
        ivPoint.frame.origin.x = lCollect.frame.origin.x + lCollect.frame.size.width + TopicPostCell.ITEM_MARGIN
        lPoint = ViewHelper.getLabel(text: "-", size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontHint(), lines: 1, align: .center)
        lPoint.frame.origin.x = ivPoint.frame.origin.x + ivPoint.frame.size.width + TopicPostCell.ITEM_MARGIN_SMALL
        
        // comment
        ivComment = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_insert_comment_grey_18dp"), color: ColorHelper.getFontHint()), width: TopicPostCell.AVATAR_WIDTH, height: TopicPostCell.AVATAR_WIDTH, mode: .scaleAspectFit)
        ivComment.frame.origin.x = lPoint.frame.origin.x + lPoint.frame.size.width + TopicPostCell.ITEM_MARGIN
        lComment = ViewHelper.getLabel(text: "-", size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontHint(), lines: 1, align: .center)
        lComment.frame.origin.x = ivComment.frame.origin.x + ivComment.frame.size.width + TopicPostCell.ITEM_MARGIN_SMALL
        
        // infoBottomUser
        let bottomUserHeight = CountHelper.getMax(ivCollect.frame.size.height, lCollect.frame.size.height)
        vInfoBottomUser = UIView()
        vInfoBottomUser.frame.size = CGSize(width: lComment.frame.origin.x + lComment.frame.size.width, height: bottomUserHeight)
        vInfoBottomUser.frame.origin.x = TopicPostCell.CARD_CONTENT_WIDTH - vInfoBottomUser.frame.size.width
        ivCollect.center.y = bottomUserHeight / 2
        lCollect.center.y = bottomUserHeight / 2
        ivPoint.center.y = bottomUserHeight / 2
        lPoint.center.y = bottomUserHeight / 2
        ivComment.center.y = bottomUserHeight / 2
        lComment.center.y = bottomUserHeight / 2
        vInfoBottomUser.addSubview(ivCollect)
        vInfoBottomUser.addSubview(lCollect)
        vInfoBottomUser.addSubview(ivPoint)
        vInfoBottomUser.addSubview(lPoint)
        vInfoBottomUser.addSubview(ivComment)
        vInfoBottomUser.addSubview(lComment)
        
        // time
        let timeWidth = vInfoBottomUser.frame.origin.x - (vInfoBottomCouple.frame.origin.x + vInfoBottomCouple.frame.size.width) - TopicPostCell.ITEM_MARGIN * 2
        lTime = ViewHelper.getLabel(width: timeWidth, text: "-", size: ViewHelper.FONT_SIZE_SMALL, color: ColorHelper.getFontHint(), lines: 1, align: .left, mode: .byTruncatingTail)
        lTime.frame.origin.x = vInfoBottomCouple.frame.origin.x + vInfoBottomCouple.frame.size.width + TopicPostCell.ITEM_MARGIN
        
        // infoBottom
        let bottomHeight = CountHelper.getMax(vInfoBottomCouple.frame.size.height, vInfoBottomUser.frame.size.height)
        vInfoBottom = UIView()
        vInfoBottom.frame.size = CGSize(width: TopicPostCell.CARD_CONTENT_WIDTH, height: bottomHeight)
        vInfoBottom.frame.origin = CGPoint(x: TopicPostCell.ITEM_MARGIN, y: collectImgList.frame.origin.y + collectImgList.frame.size.height + TopicPostCell.ITEM_MARGIN)
        vInfoBottomCouple.center.y = bottomHeight / 2
        lTime.center.y = bottomHeight / 2
        vInfoBottomUser.center.y = bottomHeight / 2
        vInfoBottom.addSubview(vInfoBottomCouple)
        vInfoBottom.addSubview(lTime)
        vInfoBottom.addSubview(vInfoBottomUser)
        
        // info
        vInfo = UIView()
        vInfo.frame.size = CGSize(width: TopicPostCell.CARD_WIDTH, height: vInfoBottom.frame.origin.y + vInfoBottom.frame.size.height + TopicPostCell.ITEM_MARGIN)
        vInfo.frame.origin = CGPoint(x: 0, y: 0)
        vInfo.addSubview(lTitle)
        vInfo.addSubview(lContent)
        vInfo.addSubview(collectImgList)
        vInfo.addSubview(vInfoBottom)
        
        // cover
        lCover = ViewHelper.getLabelBlackNormal(width: TopicPostCell.CARD_CONTENT_WIDTH, height: TopicPostCell.COVER_HEIGHT, text: "-", lines: 0, align: .center)
        lCover.frame.origin = CGPoint(x: TopicPostCell.ITEM_MARGIN, y: TopicPostCell.ITEM_MARGIN)
        lCover.backgroundColor = ColorHelper.getWhite90()
        
        // card
        vCard = UIView(frame: CGRect(x: TopicPostCell.ITEM_MARGIN, y: TopicPostCell.ITEM_MARGIN / 2, width: TopicPostCell.CARD_WIDTH, height: vInfo.frame.size.height))
        vCard.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vCard, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vCard, offset: ViewHelper.SHADOW_NORMAL)
        vCard.addSubview(vInfo)
        vCard.addSubview(lCover)
        
        // view
        self.contentView.addSubview(vCard)
        
        // hide
        lCover.isHidden = true
        vInfo.isHidden = true
        lTitle.isHidden = true
        lContent.isHidden = true
        collectImgList.isHidden = true
        vInfoBottomCouple.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CountHelper.getMin(post?.contentImageList.count ?? 0, TopicPostCell.LIMIT_IMG)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return ImgSquareShowCell.getCellWithData(view: collectionView, indexPath: indexPath, dataList: post?.contentImageList, limit: TopicPostCell.LIMIT_IMG)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let tableView = ViewUtils.findSuperTable(view: self) {
            if post != nil {
                let index = IndexPath(row: 0, section: 0)
                let postList = [Post](arrayLiteral: post!)
                TopicPostCell.goPostDetail(view: tableView, indexPath: index, dataList: postList)
            }
        }
    }
    
    public static func getHeightByData(margin: CGFloat = ITEM_MARGIN, post: Post) -> CGFloat {
        if post.isDelete() || post.screen {
            return COVER_HEIGHT + margin * 3
        } else {
            let cell = TopicPostCell(style: .default, reuseIdentifier: TopicPostCell.ID)
            // const
            if totalHeight == nil || contentFont == nil {
                totalHeight = cell.vCard.frame.origin.y + cell.vCard.frame.size.height // + margin / 2
                contentFont = cell.lContent.font
            }
            // content
            var contentHeight = CGFloat(0)
            if !StringUtils.isEmpty(post.contentText) {
                let fontHeight = ViewUtils.getFontHeight(font: contentFont, width: CARD_CONTENT_WIDTH, text: post.contentText)
                contentHeight = CountHelper.getMin(fontHeight, ViewHelper.FONT_NORMAL_LINE_HEIGHT * 3)
            }
            // img
            var imgListHeight = CGFloat(0)
            if post.contentImageList.count > 0 {
                imgListHeight = ImgSquareShowCell.getCollectHeight(collect: cell.collectImgList, dataList: post.contentImageList, limit: LIMIT_IMG)
            }
            return totalHeight! + contentHeight + imgListHeight
        }
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Post]?, height: CGFloat?) -> TopicPostCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? TopicPostCell
        if cell == nil {
            cell = TopicPostCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= cell!.tag {
            return cell!
        }
        let post = dataList![cell!.tag]
        // delete + screen
        if post.isDelete() || post.screen {
            cell?.lCover.isHidden = false
            cell?.vInfo.isHidden = true
            cell?.lCover.text = post.isDelete() ? StringUtils.getString("post_already_be_delete") : StringUtils.getString("post_already_be_screen")
            let cardHeight = getHeightByData(post: post) - TopicPostCell.ITEM_MARGIN
            if (cell?.vCard.frame.size.height ?? 0) != cardHeight {
                cell?.vCard.frame.size.height = cardHeight
            }
            ViewUtils.setViewShadow(cell?.vCard, offset: ViewHelper.SHADOW_NORMAL)
            return cell!
        }
        // normal
        cell?.lCover.isHidden = true
        cell?.vInfo.isHidden = false
        cell?.post = post
        // title
        cell?.lTitle.text = post.title
        cell?.lTitle.isHidden = StringUtils.isEmpty(post.title)
        cell?.lTitle.textColor = post.read ? ColorHelper.getFontGrey() : ColorHelper.getFontBlack()
        // content
        cell?.lContent.text = post.contentText
        cell?.lContent.isHidden = StringUtils.isEmpty(post.contentText)
        // imgList
        cell?.collectImgList.isHidden = post.contentImageList.count <= 0
        // couple
        let couple = post.couple
        if couple == nil {
            cell?.vInfoBottomCouple.isHidden = true
        } else {
            cell?.vInfoBottomCouple.isHidden = false
            KFHelper.setImgAvatarUrl(iv: cell?.ivAvatarLeft, objKey: couple?.creatorAvatar)
            KFHelper.setImgAvatarUrl(iv: cell?.ivAvatarRight, objKey: couple?.inviteeAvatar)
        }
        // time
        cell?.lTime.text = ShowHelper.getBetweenTimeGoneShow(between: DateUtils.getCurrentInt64() - post.updateAt)
        // user
        cell?.lCollect.text = ShowHelper.getShowCount2Thousand(post.collectCount)
        cell?.lPoint.text = ShowHelper.getShowCount2Thousand(post.pointCount)
        cell?.lComment.text = ShowHelper.getShowCount2Thousand(post.commentCount)
        
        // size
        AppDelegate.runOnMainAsync {
            let cellHeight = height ?? getHeightByData(post: post)
            // card
            let vCardHeight = cellHeight - ITEM_MARGIN
            if (cell?.vCard.frame.size.height ?? 0) != vCardHeight {
                cell?.vCard.frame.size.height = vCardHeight
            }
            ViewUtils.setViewShadow(cell?.vCard, offset: ViewHelper.SHADOW_NORMAL)
            if (cell?.vInfo.frame.size.height ?? 0) != vCardHeight {
                cell?.vInfo.frame.size.height = vCardHeight
            }
            // content
            let collectImgHeight = post.contentImageList.count > 0 ? ImgSquareShowCell.getCollectHeight(collect: cell?.collectImgList, dataList: post.contentImageList, limit: LIMIT_IMG) : 0
            let lContentHeight = cellHeight - (totalHeight ?? 0) - collectImgHeight
            let lContentY = cell!.lTitle.isHidden ? cell!.lTitle.frame.origin.y : cell!.lTitle.frame.origin.y + cell!.lTitle.frame.size.height + ITEM_MARGIN
            if (cell?.lContent.frame.origin.y ?? 0) != lContentY {
                cell?.lContent.frame.origin.y = lContentY
            }
            if (cell?.lContent.frame.size.height ?? 0) != lContentHeight {
                cell?.lContent.frame.size.height = lContentHeight
            }
            // img
            let imgListY = cell!.lContent.isHidden ? cell!.lContent.frame.origin.y + cell!.imgTop : cell!.lContent.frame.origin.y + cell!.lContent.frame.size.height + ITEM_MARGIN - cell!.imgTop
            if (cell?.collectImgList.frame.origin.y ?? 0) != imgListY {
                cell?.collectImgList.frame.origin.y = imgListY
            }
            if (cell?.collectImgList.frame.size.height ?? 0) != collectImgHeight {
                cell?.collectImgList.frame.size.height = collectImgHeight
            }
            cell?.collectImgList.reloadData()
            // bottom
            let lBottomY = cell!.collectImgList.isHidden ? cell!.collectImgList.frame.origin.y + cell!.imgBottom : cell!.collectImgList.frame.origin.y + cell!.collectImgList.frame.size.height + ITEM_MARGIN - cell!.imgBottom
            if (cell?.vInfoBottom.frame.origin.y ?? 0) != lBottomY {
                cell?.vInfoBottom.frame.origin.y = lBottomY
            }
            // user
            let collectWdith = ViewUtils.getFontWidth(font: cell!.lCollect.font, text: cell!.lCollect.text)
            if (cell?.lCollect.frame.size.width ?? 0) != collectWdith {
                cell?.lCollect.frame.size.width = collectWdith
            }
            let ivPointX = cell!.lCollect.frame.origin.x + cell!.lCollect.frame.size.width + ITEM_MARGIN
            if (cell?.ivPoint.frame.origin.x ?? 0) != ivPointX {
                cell?.ivPoint.frame.origin.x = ivPointX
            }
            let lPointX = cell!.ivPoint.frame.origin.x + cell!.ivPoint.frame.size.width + ITEM_MARGIN_SMALL
            if (cell?.lPoint.frame.origin.x ?? 0) != lPointX {
                cell?.lPoint.frame.origin.x = lPointX
            }
            let pointWdith = ViewUtils.getFontWidth(font: cell!.lPoint.font, text: cell!.lPoint.text)
            if (cell?.lPoint.frame.size.width ?? 0) != pointWdith {
                cell?.lPoint.frame.size.width = pointWdith
            }
            let ivCommentX = cell!.lPoint.frame.origin.x + cell!.lPoint.frame.size.width + ITEM_MARGIN
            if (cell?.ivComment.frame.origin.x ?? 0) != ivCommentX {
                cell?.ivComment.frame.origin.x = ivCommentX
            }
            let lCommentX = cell!.ivComment.frame.origin.x + cell!.ivComment.frame.size.width + ITEM_MARGIN_SMALL
            if (cell?.lComment.frame.origin.x ?? 0) != lCommentX {
                cell?.lComment.frame.origin.x = lCommentX
            }
            let commentWdith = ViewUtils.getFontWidth(font: cell!.lComment.font, text: cell!.lComment.text)
            if (cell?.lComment.frame.size.width ?? 0) != commentWdith {
                cell?.lComment.frame.size.width = commentWdith
            }
            let bottomUserWidth = cell!.lComment.frame.origin.x + cell!.lComment.frame.size.width
            if (cell?.vInfoBottomUser.frame.size.width ?? 0) != bottomUserWidth {
                cell?.vInfoBottomUser.frame.size.width = bottomUserWidth
            }
            let bottomUserX = CARD_CONTENT_WIDTH - cell!.vInfoBottomUser.frame.size.width
            if (cell?.vInfoBottomUser.frame.origin.x ?? 0) != bottomUserX {
                cell?.vInfoBottomUser.frame.origin.x = bottomUserX
            }
            // time
            let lTimeX = cell!.vInfoBottomCouple.isHidden ? cell!.vInfoBottomCouple.frame.origin.x : cell!.vInfoBottomCouple.frame.origin.x + cell!.vInfoBottomCouple.frame.size.width + ITEM_MARGIN
            if (cell?.lTime.frame.origin.x ?? 0) != lTimeX {
                cell?.lTime.frame.origin.x = lTimeX
            }
            let timeWidth = bottomUserX - lTimeX - ITEM_MARGIN
            if (cell?.lTime.frame.size.width ?? 0) != timeWidth {
                cell?.lTime.frame.size.width = timeWidth
            }
        }
        return cell!
    }
    
    public static func goPostDetail(view: UITableView, indexPath: IndexPath, dataList: [Post]?) {
        if dataList == nil || dataList!.count <= indexPath.row {
            return
        }
        let post = dataList![indexPath.row]
        if post.isDelete() || post.screen {
            return
        }
        TopicPostDetailVC.pushVC(post: post)
    }
    
}
