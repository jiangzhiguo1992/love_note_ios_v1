//
//  VipCell.swift
//  lovenote
//
//  Created by 蒋治国 on 2019/1/23.
//  Copyright © 2019年 蒋治国. All rights reserved.
//

import Foundation
import UIKit

class MoreVipCell: BaseTableCell {
    
    // const
    private static var totalHeight: CGFloat?
    
    private static let MARGIN = ScreenUtils.widthFit(10)
    private static let MAX_WIDTH = ScreenUtils.getScreenWidth() - MARGIN * 2
    private static let AVATAR_WIDTH = ScreenUtils.widthFit(20)
    
    // view
    private var vRoot: UIView!
    private var ivAvatarLeft: UIImageView!
    private var ivAvatarRight: UIImageView!
    private var lTime: UILabel!
    private var lExpireDays: UILabel!
    private var lExpireAt: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // avatar
        ivAvatarLeft = ViewHelper.getImageViewAvatar(width: MoreVipCell.AVATAR_WIDTH, height: MoreVipCell.AVATAR_WIDTH)
        ivAvatarLeft.frame.origin = CGPoint(x: MoreVipCell.MARGIN, y: MoreVipCell.MARGIN)
        
        ivAvatarRight = ViewHelper.getImageViewAvatar(width: MoreVipCell.AVATAR_WIDTH, height: MoreVipCell.AVATAR_WIDTH)
        ivAvatarRight.frame.origin = CGPoint(x: MoreVipCell.MAX_WIDTH - MoreVipCell.MARGIN - MoreVipCell.AVATAR_WIDTH, y: MoreVipCell.MARGIN)
        
        // time
        lTime = ViewHelper.getLabelGreyNormal(text: "-", lines: 1, align: .center)
        lTime.center.x = MoreVipCell.MAX_WIDTH / 2
        lTime.center.y = ivAvatarLeft.center.y
        
        // line
        let vLine = ViewHelper.getViewLine(width: MoreVipCell.MAX_WIDTH - MoreVipCell.MARGIN * 2)
        vLine.frame.origin = CGPoint(x: MoreVipCell.MARGIN, y: ivAvatarLeft.frame.origin.y + ivAvatarLeft.frame.size.height + MoreVipCell.MARGIN)
        
        // expire
        lExpireDays = ViewHelper.getLabelBlackNormal(width: (MoreVipCell.MAX_WIDTH - MoreVipCell.MARGIN * 3) / 2, text: "-", lines: 1, align: .center)
        lExpireDays.frame.origin = CGPoint(x: MoreVipCell.MARGIN, y: vLine.frame.origin.y + vLine.frame.size.height + MoreVipCell.MARGIN)
        
        lExpireAt = ViewHelper.getLabelBlackNormal(width: (MoreVipCell.MAX_WIDTH - MoreVipCell.MARGIN * 3) / 2, text: "-", lines: 1, align: .center)
        lExpireAt.frame.origin = CGPoint(x: MoreVipCell.MAX_WIDTH / 2, y: vLine.frame.origin.y + vLine.frame.size.height + MoreVipCell.MARGIN)
        
        // root
        vRoot = UIView(frame: CGRect(x: MoreVipCell.MARGIN, y: MoreVipCell.MARGIN / 2, width: MoreVipCell.MAX_WIDTH, height: lExpireDays.frame.origin.y + lExpireDays.frame.size.height + MoreVipCell.MARGIN))
        vRoot.backgroundColor = ColorHelper.getWhite()
        ViewUtils.setViewRadius(vRoot, radius: ViewHelper.RADIUS_NORMAL)
        ViewUtils.setViewShadow(vRoot, offset: ViewHelper.SHADOW_NORMAL)
        
        vRoot.addSubview(ivAvatarLeft)
        vRoot.addSubview(ivAvatarRight)
        vRoot.addSubview(lTime)
        vRoot.addSubview(vLine)
        vRoot.addSubview(lExpireDays)
        vRoot.addSubview(lExpireAt)
        
        // view
        self.contentView.addSubview(vRoot)
    }
    
    public static func getCellHeight(view: UITableView, indexPath: IndexPath) -> CGFloat {
        if totalHeight == nil {
            let cell = MoreVipCell(style: .default, reuseIdentifier: MoreVipCell.ID)
            totalHeight = cell.vRoot.frame.origin.y * 2 + cell.vRoot.frame.size.height
        }
        return totalHeight!
    }
    
    public static func getCellWithData(view: UITableView, indexPath: IndexPath, dataList: [Vip]?) -> MoreVipCell {
        var cell = view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as? MoreVipCell
        if cell == nil {
            cell = MoreVipCell(style: .default, reuseIdentifier: ID)
        }
        cell!.tag = indexPath.row
        
        // data
        if dataList == nil || dataList!.count <= indexPath.row {
            return cell!
        }
        let vip = dataList![indexPath.row]
        let me = UDHelper.getMe()
        let isMe = vip.userId == me?.id
        let avatar = UserHelper.getAvatar(couple: me?.couple, uid: vip.userId)
        
        // view
        if isMe {
            cell?.ivAvatarLeft.isHidden = true
            cell?.ivAvatarRight.isHidden = false
            KFHelper.setImgAvatarUrl(iv: cell?.ivAvatarRight, objKey: avatar, user: me)
        } else {
            cell?.ivAvatarLeft.isHidden = false
            cell?.ivAvatarRight.isHidden = true
            KFHelper.setImgAvatarUrl(iv: cell?.ivAvatarLeft, objKey: avatar, uid: vip.userId)
        }
        cell?.lTime.text = TimeHelper.getTimeShowLine_HM_MDHM_YMDHM_ByGo(vip.createAt)
        cell?.lExpireDays.text = StringUtils.getString("continue_colon_space_holder_space_day", arguments: [vip.expireDays])
        cell?.lExpireAt.text = StringUtils.getString("expire_colon_space_holder", arguments: [DateUtils.getStr(vip.expireAt, DateUtils.FORMAT_LINE_Y_M_D)])
        
        // size
        let oldWidth = cell!.lTime.frame.size.width
        cell!.lTime.sizeToFit()
        let widthOffset = cell!.lTime.frame.size.width - oldWidth
        cell!.lTime.center.x -= widthOffset / 2
        
        return cell!
    }
    
}
