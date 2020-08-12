//
//  NoteWhisperCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/3/23.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteWhisperCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    private static var contentFont: UIFont?
    
    private static let ITEM_MARGIN = ScreenUtils.widthFit(10)
    private static let AVATAR_WIDTH = ScreenUtils.widthFit(40)
    private static let MAX_WIDTH = ScreenUtils.getScreenWidth()
    private static let MAX_CARD_WIDTH = MAX_WIDTH - AVATAR_WIDTH * 2 - ITEM_MARGIN * 4
    private static let MAX_CONTENT_WIDTH = MAX_CARD_WIDTH - ITEM_MARGIN * 2
    private static let IMG_WIDTH = ScreenUtils.widthFit(150)
    
    // view
    private var ivAvatarLeft: UIImageView!
    private var lTextLeft: UILabel!
    private var ivImgLeft: UIImageView!
    private var vCardLeft: UIView!
    private var lTimeLeft: UILabel!
    
    private var ivAvatarRight: UIImageView!
    private var lTextRight: UILabel!
    private var ivImgRight: UIImageView!
    private var vCardRight: UIView!
    private var lTimeRight: UILabel!
    
    // var
    private static var heightMap: [Int: CGFloat] = [Int: CGFloat]()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // ---------------------------left---------------------------
        // avatar
        ivAvatarLeft = ViewHelper.getImageViewAvatar(width: NoteWhisperCell.AVATAR_WIDTH, height: NoteWhisperCell.AVATAR_WIDTH)
        ivAvatarLeft.frame.origin = CGPoint(x: NoteWhisperCell.ITEM_MARGIN, y: NoteWhisperCell.ITEM_MARGIN)
        
        // text
        lTextLeft = ViewHelper.getLabelBlackNormal(text: "-", lines: 0, align: .left)
        lTextLeft.frame.size.width = CountHelper.getMin(lTextLeft.frame.size.width, NoteWhisperCell.MAX_CONTENT_WIDTH)
        lTextLeft.frame.origin = CGPoint(x: NoteWhisperCell.ITEM_MARGIN, y: NoteWhisperCell.ITEM_MARGIN)
        
        // img
        ivImgLeft = ViewHelper.getImageViewUrl(width: NoteWhisperCell.IMG_WIDTH, height: NoteWhisperCell.IMG_WIDTH)
        ivImgLeft.frame.origin = CGPoint(x: 0, y: 0)
        
        // card
        vCardLeft = UIView()
        vCardLeft.frame.size = CGSize(width: NoteWhisperCell.MAX_CARD_WIDTH, height: NoteWhisperCell.ITEM_MARGIN * 2)
        vCardLeft.frame.origin = CGPoint(x: ivAvatarLeft.frame.origin.x + ivAvatarLeft.frame.size.width + NoteWhisperCell.ITEM_MARGIN, y: NoteWhisperCell.ITEM_MARGIN)
        vCardLeft.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vCardLeft, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vCardLeft, offset: ViewHelper.SHADOW_NORMAL)
        vCardLeft.addSubview(lTextLeft)
        vCardLeft.addSubview(ivImgLeft)
        
        // time
        lTimeLeft = ViewHelper.getLabelGreySmall(width: NoteWhisperCell.MAX_CARD_WIDTH, text: "-", lines: 1, align: .left)
        lTimeLeft.frame.origin = CGPoint(x: vCardLeft.frame.origin.x , y: vCardLeft.frame.origin.y + vCardLeft.frame.size.height + NoteWhisperCell.ITEM_MARGIN / 2)
        
        // ---------------------------Right---------------------------
        // avatar
        ivAvatarRight = ViewHelper.getImageViewAvatar(width: NoteWhisperCell.AVATAR_WIDTH, height: NoteWhisperCell.AVATAR_WIDTH)
        ivAvatarRight.frame.origin = CGPoint(x: NoteWhisperCell.MAX_WIDTH - NoteWhisperCell.ITEM_MARGIN - NoteWhisperCell.AVATAR_WIDTH, y: NoteWhisperCell.ITEM_MARGIN)
        
        // text
        lTextRight = ViewHelper.getLabelBlackNormal(text: "-", lines: 0, align: .left)
        lTextRight.frame.size.width = CountHelper.getMin(lTextRight.frame.size.width, NoteWhisperCell.MAX_CONTENT_WIDTH)
        lTextRight.frame.origin = CGPoint(x: NoteWhisperCell.ITEM_MARGIN, y: NoteWhisperCell.ITEM_MARGIN)
        
        // img
        ivImgRight = ViewHelper.getImageViewUrl(width: NoteWhisperCell.IMG_WIDTH, height: NoteWhisperCell.IMG_WIDTH)
        ivImgRight.frame.origin = CGPoint(x: 0, y: 0)
        
        // card
        vCardRight = UIView()
        vCardRight.frame.size = CGSize(width: NoteWhisperCell.MAX_CARD_WIDTH, height: NoteWhisperCell.ITEM_MARGIN * 2)
        vCardRight.frame.origin = CGPoint(x: ivAvatarRight.frame.origin.x - NoteWhisperCell.ITEM_MARGIN - vCardRight.frame.size.width, y: NoteWhisperCell.ITEM_MARGIN)
        vCardRight.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vCardRight, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vCardRight, offset: ViewHelper.SHADOW_NORMAL)
        vCardRight.addSubview(lTextRight)
        vCardRight.addSubview(ivImgRight)
        
        // time
        lTimeRight = ViewHelper.getLabelGreySmall(width: NoteWhisperCell.MAX_CARD_WIDTH, text: "-", lines: 1, align: .right)
        lTimeRight.frame.origin = CGPoint(x: NoteWhisperCell.ITEM_MARGIN * 2 + NoteWhisperCell.AVATAR_WIDTH , y: vCardRight.frame.origin.y + vCardRight.frame.size.height + NoteWhisperCell.ITEM_MARGIN / 2)
        
        // view
        self.contentView.addSubview(ivAvatarLeft)
        self.contentView.addSubview(vCardLeft)
        self.contentView.addSubview(lTimeLeft)
        self.contentView.addSubview(ivAvatarRight)
        self.contentView.addSubview(vCardRight)
        self.contentView.addSubview(lTimeRight)
        
        // hiden
        ivAvatarLeft.isHidden = true
        vCardLeft.isHidden = true
        lTextLeft.isHidden = true
        ivImgLeft.isHidden = true
        lTimeLeft.isHidden = true
        ivAvatarRight.isHidden = true
        vCardRight.isHidden = true
        lTextRight.isHidden = true
        ivImgRight.isHidden = true
        lTimeRight.isHidden = true
    }
    
    public static func getCellHeight(view: UITableView, indexPath: IndexPath, dataList: [Whisper]?) -> CGFloat {
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
        let whisper = dataList![row]
        return getHeightByData(whisper: whisper)
    }
    
    public static func refreshHeightMap(refresh: Bool, start: Int, dataList: [Whisper]?) {
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
        for (index, whisper) in dataList!.enumerated() {
            let height = getHeightByData(whisper: whisper)
            heightMap[index + startIndex] = height
        }
    }
    
    private static func getHeightByData(whisper: Whisper) -> CGFloat {
        // const
        if totalHeight == nil || contentFont == nil {
            let cell = NoteWhisperCell(style: .default, reuseIdentifier: NoteWhisperCell.ID)
            totalHeight = cell.lTimeLeft.frame.origin.y + cell.lTimeLeft.frame.size.height + NoteWhisperCell.ITEM_MARGIN
            contentFont = cell.lTextLeft.font
        }
        // offset
        var contentHeight = NoteWhisperCell.IMG_WIDTH - NoteWhisperCell.ITEM_MARGIN * 2
        if !whisper.isImage {
            contentHeight = ViewUtils.getFontHeight(font: contentFont, width: NoteWhisperCell.MAX_CONTENT_WIDTH, text: whisper.content)
        }
        return totalHeight! + contentHeight
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Whisper]?, target: Any?, actionBigImg: Selector) -> NoteWhisperCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? NoteWhisperCell
        if cell == nil {
            cell = NoteWhisperCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        // data
        if dataList == nil || dataList!.count <= cell!.tag {
            return cell!
        }
        let whisper = dataList![cell!.tag]
        let me = UDHelper.getMe()
        let isMe = whisper.userId == me?.id
        let avatar = UserHelper.getAvatar(user: me, uid: whisper.userId)
        
        // view
        if isMe {
            cell?.ivAvatarLeft.isHidden = true
            cell?.vCardLeft.isHidden = true
            cell?.lTimeLeft.isHidden = true
            cell?.ivAvatarRight.isHidden = false
            cell?.vCardRight.isHidden = false
            cell?.lTimeRight.isHidden = false
            
            KFHelper.setImgAvatarUrl(iv: cell?.ivAvatarRight, objKey: avatar, uid: whisper.userId)
            cell?.lTimeRight.text = TimeHelper.getTimeShowLine_HM_MDHM_YMDHM_ByGo(whisper.createAt)
            if whisper.isImage {
                cell?.lTextRight.isHidden = true
                cell?.ivImgRight.isHidden = false
                KFHelper.setImgUrl(iv: cell?.ivImgRight, objKey: whisper.content)
                // size
                AppDelegate.runOnMainAsync {
                    cell!.vCardRight.frame.size.width = NoteWhisperCell.IMG_WIDTH
                    cell!.vCardRight.frame.size.height = NoteWhisperCell.IMG_WIDTH
                    cell!.vCardRight.frame.origin.x = cell!.ivAvatarRight.frame.origin.x - NoteWhisperCell.ITEM_MARGIN - cell!.vCardRight.frame.size.width
                    cell!.lTimeRight.frame.origin.y = cell!.vCardRight.frame.origin.y + cell!.vCardRight.frame.size.height + NoteWhisperCell.ITEM_MARGIN / 2
                }
            } else {
                cell?.lTextRight.isHidden = false
                cell?.ivImgRight.isHidden = true
                cell?.lTextRight.text = whisper.content
                // size
                AppDelegate.runOnMainAsync {
                    // width
                    let textFontWidth = ViewUtils.getFontWidth(font: cell!.lTextRight.font, text: cell!.lTextRight.text)
                    cell!.lTextRight.frame.size.width = CountHelper.getMin(textFontWidth, NoteWhisperCell.MAX_CONTENT_WIDTH)
                    cell!.vCardRight.frame.size.width = cell!.lTextRight.frame.size.width + NoteWhisperCell.ITEM_MARGIN * 2
                    cell!.vCardRight.frame.origin.x = cell!.ivAvatarRight.frame.origin.x - NoteWhisperCell.ITEM_MARGIN - cell!.vCardRight.frame.size.width
                    // height
                    let cellHeight = getCellHeight(view: view, indexPath: indexPath, dataList: dataList)
                    let lContentHeight = cellHeight - (totalHeight ?? 0)
                    cell?.lTextRight.frame.size.height = lContentHeight
                    cell?.vCardRight.frame.size.height = lContentHeight + NoteWhisperCell.ITEM_MARGIN * 2
                    cell?.lTimeRight.frame.origin.y = cell!.vCardRight.frame.origin.y + cell!.vCardRight.frame.size.height + NoteWhisperCell.ITEM_MARGIN / 2
                }
            }
            ViewUtils.setViewShadow(cell?.vCardRight, offset: ViewHelper.SHADOW_NORMAL)
        } else {
            cell?.ivAvatarLeft.isHidden = false
            cell?.vCardLeft.isHidden = false
            cell?.lTimeLeft.isHidden = false
            cell?.ivAvatarRight.isHidden = true
            cell?.vCardRight.isHidden = true
            cell?.lTimeRight.isHidden = true
            
            KFHelper.setImgAvatarUrl(iv: cell?.ivAvatarLeft, objKey: avatar, uid: whisper.userId)
            cell?.lTimeLeft.text = TimeHelper.getTimeShowLine_HM_MDHM_YMDHM_ByGo(whisper.createAt)
            if whisper.isImage {
                cell?.lTextLeft.isHidden = true
                cell?.ivImgLeft.isHidden = false
                KFHelper.setImgUrl(iv: cell?.ivImgLeft, objKey: whisper.content)
                // size
                AppDelegate.runOnMainAsync {
                    // width
                    cell!.vCardLeft.frame.size.width = NoteWhisperCell.IMG_WIDTH
                    cell!.vCardLeft.frame.size.height = NoteWhisperCell.IMG_WIDTH
                    cell!.lTimeLeft.frame.origin.y = cell!.vCardLeft.frame.origin.y + cell!.vCardLeft.frame.size.height + NoteWhisperCell.ITEM_MARGIN / 2
                }
            } else {
                cell?.lTextLeft.isHidden = false
                cell?.ivImgLeft.isHidden = true
                cell?.lTextLeft.text = whisper.content
                // size
                AppDelegate.runOnMainAsync {
                    // width
                    let textFontWidth = ViewUtils.getFontWidth(font: cell!.lTextLeft.font, text: cell!.lTextLeft.text)
                    cell!.lTextLeft.frame.size.width = CountHelper.getMin(textFontWidth, NoteWhisperCell.MAX_CONTENT_WIDTH)
                    cell!.vCardLeft.frame.size.width = cell!.lTextLeft.frame.size.width + NoteWhisperCell.ITEM_MARGIN * 2
                    // height
                    let cellHeight = getCellHeight(view: view, indexPath: indexPath, dataList: dataList)
                    let lContentHeight = cellHeight - (totalHeight ?? 0)
                    cell?.lTextLeft.frame.size.height = lContentHeight
                    cell?.vCardLeft.frame.size.height = lContentHeight + NoteWhisperCell.ITEM_MARGIN * 2
                    cell!.lTimeLeft.frame.origin.y = cell!.vCardLeft.frame.origin.y + cell!.vCardLeft.frame.size.height + NoteWhisperCell.ITEM_MARGIN / 2
                }
            }
            ViewUtils.setViewShadow(cell?.vCardLeft, offset: ViewHelper.SHADOW_NORMAL)
        }
        // target
        ViewUtils.addViewTapTarget(target: target, view: cell?.ivImgLeft, action: actionBigImg)
        ViewUtils.addViewTapTarget(target: target, view: cell?.ivImgRight, action: actionBigImg)
        return cell!
    }
    
    public static func goBigImg(view: UIView?, dataList: [Whisper]?) {
        if let indexPath = ViewUtils.findTableIndexPath(view: view) {
            if dataList == nil || dataList!.count <= indexPath.row {
                return
            }
            let whisper = dataList![indexPath.row]
            BrowserHelper.goBrowserImage(view: view, index: 0, ossKeyList: [whisper.content])
        }
    }
    
}
