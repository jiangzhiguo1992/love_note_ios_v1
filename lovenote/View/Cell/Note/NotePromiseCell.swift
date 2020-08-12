//
//  NotePromiseCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/25.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NotePromiseCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    private static var contentFont: UIFont?
    
    private static let ITEM_MARGIN = ScreenUtils.widthFit(10)
    private static let AVATAR_WIDTH = ScreenUtils.widthFit(30)
    private static let CARD_WIDTH = ScreenUtils.getScreenWidth() - ITEM_MARGIN * 2
    private static let CARD_CONTENT_WIDTH = CARD_WIDTH - ITEM_MARGIN * 2
    
    // view
    private var vCard: UIView!
    private var ivAvatar: UIImageView!
    private var btnMore: UIButton!
    private var lHappenAt: UILabel!
    private var lBreakCount: UILabel!
    private var lTime: UILabel!
    private var lContent: UILabel!
    
    // var
    private static var heightMap: [Int: CGFloat] = [Int: CGFloat]()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // more
        btnMore = ViewHelper.getBtnImgCenter(paddingH: NotePromiseCell.ITEM_MARGIN, paddingV: NotePromiseCell.ITEM_MARGIN, bgImg: UIImage(named: "ic_more_horiz_grey_18dp"))
        btnMore.frame.origin = CGPoint(x: NotePromiseCell.CARD_WIDTH - btnMore.frame.size.width, y: 0)
        
        // avatar
        ivAvatar = ViewHelper.getImageViewAvatar(width: NotePromiseCell.AVATAR_WIDTH, height: NotePromiseCell.AVATAR_WIDTH)
        ivAvatar.frame.origin = CGPoint(x: NotePromiseCell.ITEM_MARGIN, y: NotePromiseCell.ITEM_MARGIN)
        let vAvatarShadow = ViewUtils.getViewShadow(ivAvatar, bgColor: ColorHelper.getWhite(), offset: ViewHelper.SHADOW_NORMAL)
        
        // time
        lTime = ViewHelper.getLabelGreySmall(text: StringUtils.getString("ci"), lines: 1)
        lTime.frame.origin = CGPoint(x: NotePromiseCell.CARD_WIDTH - NotePromiseCell.ITEM_MARGIN - lTime.frame.size.width, y: ivAvatar.frame.origin.y + ivAvatar.frame.size.height - lTime.frame.size.height - CGFloat(5))
        
        // count
        lBreakCount = ViewHelper.getLabelBold(width: ScreenUtils.widthFit(70), text: "-", size: ScreenUtils.fontFit(25), color: ColorHelper.getFontGrey(), lines: 1, align: .right, mode: .byTruncatingMiddle)
        lBreakCount.frame.origin = CGPoint(x: lTime.frame.origin.x - lBreakCount.frame.size.width, y: ivAvatar.frame.origin.y + ivAvatar.frame.size.height - lBreakCount.frame.size.height)
        
        // happen
        lHappenAt = ViewHelper.getLabelBold(width: NotePromiseCell.CARD_WIDTH - ivAvatar.frame.origin.x - ivAvatar.frame.size.width - NotePromiseCell.ITEM_MARGIN * 3 - lTime.frame.size.width - lBreakCount.frame.size.width, text: "-", color: ColorHelper.getFontBlack(), lines: 1, align: .left)
        lHappenAt.frame.origin.x = ivAvatar.frame.origin.x + ivAvatar.frame.size.width + NotePromiseCell.ITEM_MARGIN
        lHappenAt.center.y = ivAvatar.center.y
        
        // line
        let vLine = ViewHelper.getViewLine(width: NotePromiseCell.CARD_CONTENT_WIDTH)
        vLine.frame.origin = CGPoint(x: NotePromiseCell.ITEM_MARGIN, y: ivAvatar.frame.origin.y + ivAvatar.frame.size.height + NotePromiseCell.ITEM_MARGIN)
        
        // content
        lContent = ViewHelper.getLabelGreyNormal(width: NotePromiseCell.CARD_CONTENT_WIDTH, height: CGFloat(0), text: "-", lines: 5, align: .left, mode: .byTruncatingTail)
        lContent.frame.origin = CGPoint(x: NotePromiseCell.ITEM_MARGIN, y: vLine.frame.origin.y + vLine.frame.size.height + NotePromiseCell.ITEM_MARGIN)
        
        // card
        vCard = UIView(frame: CGRect(x: NotePromiseCell.ITEM_MARGIN, y: NotePromiseCell.ITEM_MARGIN / 2, width: NotePromiseCell.CARD_WIDTH, height: lContent.frame.origin.y + lContent.frame.size.height + NotePromiseCell.ITEM_MARGIN))
        vCard.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vCard, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vCard, offset: ViewHelper.SHADOW_NORMAL)
        
        vCard.addSubview(vAvatarShadow)
        vCard.addSubview(ivAvatar)
        vCard.addSubview(btnMore)
        vCard.addSubview(lHappenAt)
        vCard.addSubview(lBreakCount)
        vCard.addSubview(lTime)
        vCard.addSubview(vLine)
        vCard.addSubview(lContent)
        
        // view
        self.contentView.addSubview(vCard)
        
        // hide
        btnMore.isHidden = true
    }
    
    public static func getCellHeight(view: UITableView, indexPath: IndexPath, dataList: [Promise]?) -> CGFloat {
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
        let promise = dataList![row]
        return getHeightByData(promise: promise)
    }
    
    public static func refreshHeightMap(refresh: Bool, start: Int, dataList: [Promise]?) {
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
        for (index, promise) in dataList!.enumerated() {
            let height = getHeightByData(promise: promise)
            heightMap[index + startIndex] = height
        }
    }
    
    public static func getHeightByData(margin: CGFloat = ITEM_MARGIN, maxHeight: CGFloat = ViewHelper.FONT_NORMAL_LINE_HEIGHT * 3, promise: Promise) -> CGFloat {
        // const
        if totalHeight == nil || contentFont == nil {
            let cell = NotePromiseCell(style: .default, reuseIdentifier: NotePromiseCell.ID)
            totalHeight = cell.vCard.frame.origin.y + cell.vCard.frame.size.height + margin / 2
            contentFont = cell.lContent.font
        }
        // offset
        let height = ViewUtils.getFontHeight(font: contentFont, width: CARD_CONTENT_WIDTH, text: promise.contentText)
        let realHeight = height > maxHeight ? maxHeight : height
        return totalHeight! + realHeight
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Promise]?, heightMap: Bool = true) -> NotePromiseCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? NotePromiseCell
        if cell == nil {
            cell = NotePromiseCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= cell!.tag {
            return cell!
        }
        let promise = dataList![cell!.tag]
        let me = UDHelper.getMe()
        let avatar = UserHelper.getAvatar(user: me, uid: promise.happenId)
        
        // view
        cell?.btnMore.isHidden = true
        KFHelper.setImgAvatarUrl(iv: cell?.ivAvatar, objKey: avatar, uid: promise.happenId)
        cell?.lHappenAt.text = TimeHelper.getTimeShowLine_HM_MD_YMD_ByGo(promise.happenAt)
        cell?.lBreakCount.text = "\(promise.breakCount)"
        cell?.lContent.text = promise.contentText
        
        // size
        AppDelegate.runOnMainAsync {
            let cellHeight = heightMap ? getCellHeight(view: view, indexPath: indexPath, dataList: dataList) : getHeightByData(promise: promise)
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
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Promise]?, heightMap: Bool = true, target: Any?, actionEdit: Selector) -> NotePromiseCell {
        let cell = getCellWithData(view: view, indexPath: indexPath, dataList: dataList, heightMap: heightMap)
        cell.lTime.frame.origin.x = cell.btnMore.frame.origin.x - NotePromiseCell.ITEM_MARGIN - cell.lTime.frame.size.width
        cell.lBreakCount.frame.origin.x = cell.lTime.frame.origin.x - cell.lBreakCount.frame.size.width
        cell.btnMore.isHidden = false
        cell.btnMore.addTarget(target, action: actionEdit, for: .touchUpInside)
        return cell
    }
    
    public static func goPromiseDetail(view: UITableView, indexPath: IndexPath, dataList: [Promise]?) {
        if dataList == nil || dataList!.count <= indexPath.row {
            return
        }
        let promise = dataList![indexPath.row]
        NotePromiseDetailVC.pushVC(promise: promise)
    }
    
    public static func selectPromise(view: UITableView, indexPath: IndexPath, dataList: [Promise]?) {
        RootVC.get().popBack()
        if dataList == nil || dataList!.count <= indexPath.row {
            return
        }
        let promise = dataList![indexPath.row]
        NotifyHelper.post(NotifyHelper.TAG_PROMISE_SELECT, obj: promise)
    }
    
}
