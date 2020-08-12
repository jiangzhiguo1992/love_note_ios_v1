//
//  NoteAudioCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/4/1.
//  Copyright © 2019 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class NoteAudioCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    
    private static let ITEM_MARGIN = ScreenUtils.widthFit(10)
    private static let AVATAR_WIDTH = ScreenUtils.widthFit(40)
    private static let SCREEN_WIDTH = ScreenUtils.getScreenWidth()
    private static let CARD_WIDTH = SCREEN_WIDTH / 2
    private static let CARD_HEIGHT = ScreenUtils.widthFit(50)
    private static let CARD_PLAY_WIDTH = CARD_HEIGHT - ITEM_MARGIN
    private static let CARD_CONTENT_WIDTH = CARD_WIDTH - CARD_PLAY_WIDTH - ITEM_MARGIN
    
    // view
    private var vCardRight: UIView!
    private var ivAvatarRight: UIImageView!
    private var vContentRight: UIView!
    private var ivPlayRight: UIImageView!
    private var lTitleRight: UILabel!
    private var lDurationRight: UILabel!
    private var lHappenAtRight: UILabel!
    private var vCardLeft: UIView!
    private var ivAvatarLeft: UIImageView!
    private var vContentLeft: UIView!
    private var ivPlayLeft: UIImageView!
    private var lTitleLeft: UILabel!
    private var lDurationLeft: UILabel!
    private var lHappenAtLeft: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // ----------------------------right----------------------------
        // avatar
        ivAvatarRight = ViewHelper.getImageViewAvatar(width: NoteAudioCell.AVATAR_WIDTH, height: NoteAudioCell.AVATAR_WIDTH)
        ivAvatarRight.frame.origin.x = NoteAudioCell.SCREEN_WIDTH - NoteAudioCell.ITEM_MARGIN - ivAvatarRight.frame.size.width
        ivAvatarRight.frame.origin.y = NoteAudioCell.ITEM_MARGIN / 2
        
        // play
        ivPlayRight = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_play_circle_outline_white_48dp"), color: ThemeHelper.getColorPrimary()), width: NoteAudioCell.CARD_PLAY_WIDTH, height: NoteAudioCell.CARD_PLAY_WIDTH, mode: .scaleAspectFit)
        ivPlayRight.frame.origin.x = NoteAudioCell.ITEM_MARGIN / 2
        ivPlayRight.frame.origin.y = NoteAudioCell.ITEM_MARGIN / 2
        
        // title
        lTitleRight = ViewHelper.getLabelBlackNormal(width: NoteAudioCell.CARD_CONTENT_WIDTH, text: "-", lines: 1, align: .right, mode: .byTruncatingTail)
        lTitleRight.frame.origin.x = ivPlayRight.frame.origin.x + ivPlayRight.frame.size.width
        lTitleRight.frame.origin.y = NoteAudioCell.ITEM_MARGIN / 2
        
        // duration
        lDurationRight = ViewHelper.getLabelGreySmall(width: NoteAudioCell.CARD_CONTENT_WIDTH, text: "--:--", lines: 1, align: .right, mode: .byTruncatingMiddle)
        lDurationRight.frame.origin.x = ivPlayRight.frame.origin.x + ivPlayRight.frame.size.width
        lDurationRight.frame.origin.y = NoteAudioCell.CARD_HEIGHT - NoteAudioCell.ITEM_MARGIN / 2 - lDurationRight.frame.size.height
        
        // content
        vContentRight = UIView(frame: CGRect(x: 0, y: 0, width: NoteAudioCell.CARD_WIDTH, height: NoteAudioCell.CARD_HEIGHT))
        vContentRight.frame.origin.x = NoteAudioCell.SCREEN_WIDTH - NoteAudioCell.ITEM_MARGIN * 2 - NoteAudioCell.AVATAR_WIDTH - vContentRight.frame.size.width
        vContentRight.frame.origin.y = NoteAudioCell.ITEM_MARGIN / 2
        vContentRight.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewCorner(vContentRight, corner: vContentRight.frame.size.height / 2, round: [UIRectCorner.bottomLeft, UIRectCorner.topLeft])
        vContentRight.addSubview(ivPlayRight)
        vContentRight.addSubview(lTitleRight)
        vContentRight.addSubview(lDurationRight)
        
        let vShadowRight = ViewUtils.getViewShadow(vContentRight, radius: NoteAudioCell.CARD_HEIGHT / 2, bgColor: ColorHelper.getWhite(), offset: ViewHelper.SHADOW_NORMAL)
        
        // happen
        lHappenAtRight = ViewHelper.getLabelGreySmall(width: NoteAudioCell.CARD_WIDTH, text: "-", lines: 1, align: .right, mode: .byTruncatingMiddle)
        lHappenAtRight.frame.origin.x = NoteAudioCell.SCREEN_WIDTH - NoteAudioCell.ITEM_MARGIN * 2 - NoteAudioCell.AVATAR_WIDTH - lHappenAtRight.frame.size.width
        lHappenAtRight.frame.origin.y = vContentRight.frame.origin.y + vContentRight.frame.size.height + NoteAudioCell.ITEM_MARGIN / 2
        
        // card
        vCardRight = UIView(frame: CGRect(x: 0, y: 0, width: NoteAudioCell.SCREEN_WIDTH, height: lHappenAtRight.frame.origin.y + lHappenAtRight.frame.size.height + NoteAudioCell.ITEM_MARGIN / 2))
        vCardRight.addSubview(ivAvatarRight)
        vCardRight.addSubview(vShadowRight)
        vCardRight.addSubview(vContentRight)
        vCardRight.addSubview(lHappenAtRight)
        
        // ----------------------------left----------------------------
        // avatar
        ivAvatarLeft = ViewHelper.getImageViewAvatar(width: NoteAudioCell.AVATAR_WIDTH, height: NoteAudioCell.AVATAR_WIDTH)
        ivAvatarLeft.frame.origin.x = NoteAudioCell.ITEM_MARGIN
        ivAvatarLeft.frame.origin.y = NoteAudioCell.ITEM_MARGIN / 2
        
        // title
        lTitleLeft = ViewHelper.getLabelBlackNormal(width: NoteAudioCell.CARD_CONTENT_WIDTH, text: "-", lines: 1, align: .left, mode: .byTruncatingTail)
        lTitleLeft.frame.origin.x = NoteAudioCell.ITEM_MARGIN / 2
        lTitleLeft.frame.origin.y = NoteAudioCell.ITEM_MARGIN / 2
        
        // duration
        lDurationLeft = ViewHelper.getLabelGreySmall(width: NoteAudioCell.CARD_CONTENT_WIDTH, text: "--:--", lines: 1, align: .left, mode: .byTruncatingMiddle)
        lDurationLeft.frame.origin.x = NoteAudioCell.ITEM_MARGIN / 2
        lDurationLeft.frame.origin.y = NoteAudioCell.CARD_HEIGHT - NoteAudioCell.ITEM_MARGIN / 2 - lDurationLeft.frame.size.height
        
        // play
        ivPlayLeft = ViewHelper.getImageView(img: ViewUtils.getImageWithTintColor(img: UIImage(named: "ic_play_circle_outline_white_48dp"), color: ThemeHelper.getColorPrimary()), width: NoteAudioCell.CARD_PLAY_WIDTH, height: NoteAudioCell.CARD_PLAY_WIDTH, mode: .scaleAspectFit)
        ivPlayLeft.frame.origin.x = lTitleLeft.frame.origin.x + lTitleLeft.frame.size.width
        ivPlayLeft.frame.origin.y = NoteAudioCell.ITEM_MARGIN / 2
        
        // content
        vContentLeft = UIView(frame: CGRect(x: 0, y: 0, width: NoteAudioCell.CARD_WIDTH, height: NoteAudioCell.CARD_HEIGHT))
        vContentLeft.frame.origin.x = ivAvatarLeft.frame.origin.x + ivAvatarLeft.frame.size.width + NoteAudioCell.ITEM_MARGIN
        vContentLeft.frame.origin.y = NoteAudioCell.ITEM_MARGIN / 2
        vContentLeft.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewCorner(vContentLeft, corner: vContentLeft.frame.size.height / 2, round: [UIRectCorner.bottomRight, UIRectCorner.topRight])
        vContentLeft.addSubview(ivPlayLeft)
        vContentLeft.addSubview(lTitleLeft)
        vContentLeft.addSubview(lDurationLeft)
        
        let vShadowLeft = ViewUtils.getViewShadow(vContentLeft, radius: NoteAudioCell.CARD_HEIGHT / 2, bgColor: ColorHelper.getWhite(), offset: ViewHelper.SHADOW_NORMAL)
        
        // happen
        lHappenAtLeft = ViewHelper.getLabelGreySmall(width: NoteAudioCell.CARD_WIDTH, text: "-", lines: 1, align: .left, mode: .byTruncatingMiddle)
        lHappenAtLeft.frame.origin.x = ivAvatarLeft.frame.origin.x + ivAvatarLeft.frame.size.width + NoteAudioCell.ITEM_MARGIN
        lHappenAtLeft.frame.origin.y = vContentLeft.frame.origin.y + vContentLeft.frame.size.height + NoteAudioCell.ITEM_MARGIN / 2
        
        // card
        vCardLeft = UIView(frame: CGRect(x: 0, y: 0, width: NoteAudioCell.SCREEN_WIDTH, height: lHappenAtLeft.frame.origin.y + lHappenAtLeft.frame.size.height + NoteAudioCell.ITEM_MARGIN / 2))
        vCardLeft.addSubview(ivAvatarLeft)
        vCardLeft.addSubview(vShadowLeft)
        vCardLeft.addSubview(vContentLeft)
        vCardLeft.addSubview(lHappenAtLeft)
        
        // view
        self.contentView.addSubview(vCardRight)
        self.contentView.addSubview(vCardLeft)
        
        // hide
        vCardRight.isHidden = true
        vCardLeft.isHidden = true
    }
    
    public static func getCellHeight(view: UITableView, indexPath: IndexPath) -> CGFloat {
        if totalHeight == nil {
            let cell = NoteAudioCell(style: .default, reuseIdentifier: NoteAudioCell.ID)
            totalHeight = cell.vCardRight.frame.origin.y * 2 + cell.vCardRight.frame.size.height
        }
        return totalHeight!
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Audio]?, playIndex: Int = -1, target: Any?, actionPlay: Selector, actionEdit: Selector) -> NoteAudioCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? NoteAudioCell
        if cell == nil {
            cell = NoteAudioCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= cell!.tag {
            return cell!
        }
        let audio = dataList![cell!.tag]
        let me = UDHelper.getMe()
        let avatar = UserHelper.getAvatar(user: me, uid: audio.userId)
        
        if audio.isMine() {
            // right
            cell?.vCardRight.isHidden = false
            cell?.vCardLeft.isHidden = true
            
            KFHelper.setImgAvatarUrl(iv: cell?.ivAvatarRight, objKey: avatar, uid: audio.userId)
            cell?.lTitleRight.text = audio.title
            cell?.lDurationRight.text = ShowHelper.getDurationShow(audio.duration)
            cell?.lHappenAtRight.text = TimeHelper.getTimeShowLine_HM_MDHM_YMDHM_ByGo(audio.happenAt)
            cell?.ivPlayRight.image = ViewUtils.getImageWithTintColor(img: playIndex == cell!.tag ? UIImage(named: "ic_pause_circle_outline_white_48dp") : UIImage(named: "ic_play_circle_outline_white_48dp"), color: ThemeHelper.getColorPrimary())
        } else {
            // left
            cell?.vCardRight.isHidden = true
            cell?.vCardLeft.isHidden = false
            
            KFHelper.setImgAvatarUrl(iv: cell?.ivAvatarLeft, objKey: avatar, uid: audio.userId)
            cell?.lTitleLeft.text = audio.title
            cell?.lDurationLeft.text = ShowHelper.getDurationShow(audio.duration)
            cell?.lHappenAtLeft.text = TimeHelper.getTimeShowLine_HM_MDHM_YMDHM_ByGo(audio.happenAt)
            cell?.ivPlayLeft.image = ViewUtils.getImageWithTintColor(img: playIndex == cell!.tag ? UIImage(named: "ic_pause_circle_outline_white_48dp") : UIImage(named: "ic_play_circle_outline_white_48dp"), color: ThemeHelper.getColorPrimary())
        }
        
        // target
        ViewUtils.addViewTapTarget(target: target, view: cell?.vContentRight, action: actionPlay)
        ViewUtils.addViewTapTarget(target: target, view: cell?.vContentLeft, action: actionPlay)
        return cell!
    }
    
}
