//
//  NoteDiaryCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/2/26.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteDiaryCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    private static var contentFont: UIFont?
    
    private static let ITEM_MARGIN = ScreenUtils.widthFit(10)
    private static let AVATAR_WIDTH = ScreenUtils.widthFit(40)
    private static let CARD_WIDTH = ScreenUtils.getScreenWidth() - ITEM_MARGIN * 2
    private static let CARD_CONTENT_WIDTH = CARD_WIDTH - ITEM_MARGIN * 2
    
    // view
    private var ivAvatar: UIImageView!
    private var vCard: UIView!
    private var btnMore: UIButton!
    private var lHappenAt: UILabel!
    private var lTextCount: UILabel!
    private var lReadCount: UILabel!
    private var lContent: UILabel!
    
    // var
    private static var heightMap: [Int: CGFloat] = [Int: CGFloat]()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // avatar
        ivAvatar = ViewHelper.getImageViewAvatar(width: NoteDiaryCell.AVATAR_WIDTH, height: NoteDiaryCell.AVATAR_WIDTH)
        ivAvatar.center.x = NoteDiaryCell.CARD_WIDTH / 2
        ivAvatar.frame.origin.y = NoteDiaryCell.ITEM_MARGIN / 2
        let vAvatarShadow = ViewUtils.getViewShadow(ivAvatar, bgColor: ColorHelper.getWhite(), offset: ViewHelper.SHADOW_NORMAL)
        
        // more
        btnMore = ViewHelper.getBtnImgCenter(paddingH: NoteDiaryCell.ITEM_MARGIN, paddingV: NoteDiaryCell.ITEM_MARGIN, bgImg: UIImage(named: "ic_more_horiz_grey_18dp"))
        btnMore.frame.origin = CGPoint(x: NoteDiaryCell.CARD_WIDTH - btnMore.frame.size.width, y: 0)
        
        // happen
        lHappenAt = ViewHelper.getLabelBold(width: NoteDiaryCell.CARD_CONTENT_WIDTH, text: "-", color: ColorHelper.getFontBlack(), lines: 1, align: .center)
        lHappenAt.frame.origin = CGPoint(x: NoteDiaryCell.ITEM_MARGIN, y: NoteDiaryCell.AVATAR_WIDTH / 2 + ScreenUtils.heightFit(15))
        
        // count
        lTextCount = ViewHelper.getLabelGreySmall(width: NoteDiaryCell.CARD_CONTENT_WIDTH / 2, text: "-", lines: 1, align: .center, mode: .byTruncatingMiddle)
        lTextCount.frame.origin = CGPoint(x: NoteDiaryCell.ITEM_MARGIN, y: lHappenAt.frame.origin.y + lHappenAt.frame.size.height + ScreenUtils.heightFit(15))
        
        lReadCount = ViewHelper.getLabelGreySmall(width: NoteDiaryCell.CARD_CONTENT_WIDTH / 2, text: "-", lines: 1, align: .center, mode: .byTruncatingMiddle)
        lReadCount.frame.origin = CGPoint(x: lTextCount.frame.origin.x + lTextCount.frame.size.width, y: lTextCount.frame.origin.y)
        
        // line
        let vLine = ViewHelper.getViewLine(width: NoteDiaryCell.CARD_CONTENT_WIDTH)
        vLine.frame.origin = CGPoint(x: NoteDiaryCell.ITEM_MARGIN, y: lTextCount.frame.origin.y + lTextCount.frame.size.height + NoteDiaryCell.ITEM_MARGIN)
        
        // content
        lContent = ViewHelper.getLabelGreyNormal(width: NoteDiaryCell.CARD_CONTENT_WIDTH, height: CGFloat(0), text: "-", lines: 5, align: .left, mode: .byTruncatingTail)
        lContent.frame.origin = CGPoint(x: NoteDiaryCell.ITEM_MARGIN, y: vLine.frame.origin.y + vLine.frame.size.height + NoteDiaryCell.ITEM_MARGIN)
        
        // card
        vCard = UIView(frame: CGRect(x: NoteDiaryCell.ITEM_MARGIN, y: (ivAvatar.frame.size.height / 2) + (NoteDiaryCell.ITEM_MARGIN / 2), width: NoteDiaryCell.CARD_WIDTH, height: lContent.frame.origin.y + lContent.frame.size.height + NoteDiaryCell.ITEM_MARGIN))
        vCard.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vCard, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vCard, offset: ViewHelper.SHADOW_NORMAL)
        
        vCard.addSubview(btnMore)
        vCard.addSubview(lHappenAt)
        vCard.addSubview(lTextCount)
        vCard.addSubview(lReadCount)
        vCard.addSubview(vLine)
        vCard.addSubview(lContent)
        
        // view
        self.contentView.addSubview(vCard)
        self.contentView.addSubview(vAvatarShadow)
        self.contentView.addSubview(ivAvatar)
        
        // hide
        btnMore.isHidden = true
    }
    
    public static func getCellHeight(view: UITableView, indexPath: IndexPath, dataList: [Diary]?) -> CGFloat {
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
        let diary = dataList![row]
        return getHeightByData(diary: diary)
    }
    
    public static func refreshHeightMap(refresh: Bool, start: Int, dataList: [Diary]?) {
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
        for (index, diary) in dataList!.enumerated() {
            let height = getHeightByData(diary: diary)
            heightMap[index + startIndex] = height
        }
    }
    
    public static func getHeightByData(margin: CGFloat = ITEM_MARGIN, maxHeight: CGFloat = ViewHelper.FONT_NORMAL_LINE_HEIGHT * 5, diary: Diary) -> CGFloat {
        // const
        if totalHeight == nil || contentFont == nil {
            let cell = NoteDiaryCell(style: .default, reuseIdentifier: NoteDiaryCell.ID)
            totalHeight = cell.vCard.frame.origin.y + cell.vCard.frame.size.height + margin / 2
            contentFont = cell.lContent.font
        }
        // offset
        let height = ViewUtils.getFontHeight(font: contentFont, width: CARD_CONTENT_WIDTH, text: diary.contentText)
        let realHeight = height > maxHeight ? maxHeight : height
        return totalHeight! + realHeight
    }
    
    public static func getMuliCellHeight(dataList: [Diary]?) -> CGFloat {
        if dataList == nil || dataList!.count <= 0 {
            return CGFloat(0)
        }
        var totalHeight = CGFloat(0)
        for diary in dataList! {
            totalHeight += getHeightByData(diary: diary)
        }
        return totalHeight
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Diary]?, heightMap: Bool = true) -> NoteDiaryCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? NoteDiaryCell
        if cell == nil {
            cell = NoteDiaryCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= cell!.tag {
            return cell!
        }
        let diary = dataList![cell!.tag]
        let me = UDHelper.getMe()
        let avatar = UserHelper.getAvatar(user: me, uid: diary.userId)
        
        // view
        cell?.btnMore.isHidden = true
        KFHelper.setImgAvatarUrl(iv: cell?.ivAvatar, objKey: avatar, uid: diary.userId)
        cell?.lHappenAt.text = TimeHelper.getTimeShowLine_HM_MD_YMD_ByGo(diary.happenAt)
        cell?.lTextCount.text = StringUtils.getString("text_number_space_colon_holder", arguments: [diary.contentText.count])
        cell?.lReadCount.text = StringUtils.getString("read_space_colon_holder", arguments: [diary.readCount])
        cell?.lContent.text = diary.contentText
        
        // size
        AppDelegate.runOnMainAsync {
            let cellHeight = heightMap ? getCellHeight(view: view, indexPath: indexPath, dataList: dataList) : getHeightByData(diary: diary)
            let vCardHeight = cellHeight - ITEM_MARGIN - (AVATAR_WIDTH / 2)
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
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Diary]?, heightMap: Bool = true, target: Any?, actionEdit: Selector) -> NoteDiaryCell {
        let cell = getCellWithData(view: view, indexPath: indexPath, dataList: dataList, heightMap: heightMap)
        cell.btnMore.isHidden = false
        cell.btnMore.addTarget(target, action: actionEdit, for: .touchUpInside)
        return cell
    }
    
    public static func goDiaryDetail(view: UITableView, indexPath: IndexPath, dataList: [Diary]?) {
        if dataList == nil || dataList!.count <= indexPath.row {
            return
        }
        let diary = dataList![indexPath.row]
        diary.readCount += 1
        view.reloadRows(at: [indexPath], with: .automatic)
        NoteDiaryDetailVC.pushVC(diary: diary)
    }
    
    public static func selectDiary(view: UITableView, indexPath: IndexPath, dataList: [Diary]?) {
        RootVC.get().popBack()
        if dataList == nil || dataList!.count <= indexPath.row {
            return
        }
        let diary = dataList![indexPath.row]
        NotifyHelper.post(NotifyHelper.TAG_DIARY_SELECT, obj: diary)
    }
    
}
