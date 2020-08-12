//
//  NoteTravelCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/2.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteTravelCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    
    private static let ITEM_MARGIN = ScreenUtils.widthFit(10)
    private static let AVATAR_WIDTH = ScreenUtils.widthFit(60)
    private static let AVATAR_END_MARGIN = ScreenUtils.widthFit(30)
    private static let CARD_WIDTH = ScreenUtils.getScreenWidth() - ITEM_MARGIN * 2
    private static let CARD_CONTENT_WIDTH = CARD_WIDTH - ITEM_MARGIN * 2
    
    // view
    private var vCard: UIView!
    private var ivAvatar: UIImageView!
    private var btnMore: UIButton!
    private var lTitle: UILabel!
    private var lHappenAt: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // avatar
        ivAvatar = ViewHelper.getImageViewAvatar(width: NoteTravelCell.AVATAR_WIDTH, height: NoteTravelCell.AVATAR_WIDTH)
        ivAvatar.frame.origin = CGPoint(x: NoteTravelCell.ITEM_MARGIN, y: NoteTravelCell.ITEM_MARGIN)
        
        // more
        btnMore = ViewHelper.getBtnImgCenter(paddingH: NoteTravelCell.ITEM_MARGIN, paddingV: NoteTravelCell.ITEM_MARGIN, bgImg: UIImage(named: "ic_more_horiz_grey_18dp"))
        btnMore.frame.origin = CGPoint(x: NoteTravelCell.CARD_WIDTH - btnMore.frame.size.width, y: 0)
        
        // title
        let titleWidth = NoteTravelCell.CARD_WIDTH - NoteTravelCell.AVATAR_WIDTH - NoteTravelCell.AVATAR_END_MARGIN - NoteTravelCell.ITEM_MARGIN * 2 - btnMore.frame.size.width
        lTitle = ViewHelper.getLabelBold(width: titleWidth, text: "-", size: ViewHelper.FONT_SIZE_HUGE, color: ColorHelper.getFontBlack(), lines: 1, align: .left, mode: .byTruncatingTail)
        lTitle.frame.origin.x = ivAvatar.frame.origin.x + ivAvatar.frame.size.width + NoteTravelCell.AVATAR_END_MARGIN
        lTitle.frame.origin.y = NoteTravelCell.ITEM_MARGIN
        
        // happen
        lHappenAt = ViewHelper.getLabelGreyNormal(width: titleWidth, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lHappenAt.frame.origin.x = ivAvatar.frame.origin.x + ivAvatar.frame.size.width + NoteTravelCell.AVATAR_END_MARGIN
        lHappenAt.frame.origin.y = ivAvatar.frame.origin.y + ivAvatar.frame.size.height - lHappenAt.frame.size.height
        
        // card
        vCard = UIView(frame: CGRect(x: NoteTravelCell.ITEM_MARGIN, y: NoteTravelCell.ITEM_MARGIN / 2, width: NoteTravelCell.CARD_WIDTH, height: ivAvatar.frame.origin.y + ivAvatar.frame.size.height + NoteTravelCell.ITEM_MARGIN))
        vCard.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vCard, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vCard, offset: ViewHelper.SHADOW_NORMAL)
        
        vCard.addSubview(ivAvatar)
        vCard.addSubview(btnMore)
        vCard.addSubview(lTitle)
        vCard.addSubview(lHappenAt)
        
        // view
        self.contentView.addSubview(vCard)
        
        // hide
        btnMore.isHidden = true
    }
    
    public static func getCellHeight() -> CGFloat {
        if totalHeight == nil {
            let cell = NoteTravelCell(style: .default, reuseIdentifier: NoteTravelCell.ID)
            totalHeight = cell.vCard.frame.origin.y * 2 + cell.vCard.frame.size.height
        }
        return totalHeight!
    }
    
    public static func getMuliCellHeight(dataList: [Travel]?) -> CGFloat {
        if dataList == nil || dataList!.count <= 0 {
            return CGFloat(0)
        }
        var totalHeight = CGFloat(0)
        for _ in dataList! {
            if NoteTravelCell.totalHeight == nil || NoteTravelCell.totalHeight! <= 0 {
                _ = getCellHeight()
            }
            totalHeight += NoteTravelCell.totalHeight ?? 0
        }
        return totalHeight
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Travel]?) -> NoteTravelCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? NoteTravelCell
        if cell == nil {
            cell = NoteTravelCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= cell!.tag {
            return cell!
        }
        let travel = dataList![cell!.tag]
        let me = UDHelper.getMe()
        let avatar = UserHelper.getAvatar(user: me, uid: travel.userId)
        
        // view
        cell?.btnMore.isHidden = true
        KFHelper.setImgAvatarUrl(iv: cell?.ivAvatar, objKey: avatar, uid: travel.userId)
        cell?.lTitle.text = travel.title
        cell?.lHappenAt.text = TimeHelper.getTimeShowLine_HM_MD_YMD_ByGo(travel.happenAt)
        
        return cell!
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Travel]?, target: Any?, actionEdit: Selector) -> NoteTravelCell {
        let cell = getCellWithData(view: view, indexPath: indexPath, dataList: dataList)
        cell.btnMore.isHidden = false
        cell.btnMore.addTarget(target, action: actionEdit, for: .touchUpInside)
        return cell
    }
    
    public static func goTravelDetail(view: UITableView, indexPath: IndexPath, dataList: [Travel]?) {
        if dataList == nil || dataList!.count <= indexPath.row {
            return
        }
        let travel = dataList![indexPath.row]
        NoteTravelDetailVC.pushVC(travel: travel)
    }
    
    public static func selectTravel(view: UITableView, indexPath: IndexPath, dataList: [Travel]?) {
        RootVC.get().popBack()
        if dataList == nil || dataList!.count <= indexPath.row {
            return
        }
        let travel = dataList![indexPath.row]
        NotifyHelper.post(NotifyHelper.TAG_TRAVEL_SELECT, obj: travel)
    }
    
}
